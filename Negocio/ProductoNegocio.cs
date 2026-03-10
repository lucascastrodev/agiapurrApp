using System;
using System.Collections.Generic;
using System.Linq;
using Dominio;
using System.Data;

namespace Negocio
{
    public class ProductoNegocio
    {
        // --- DASHBOARD ---
        public DataTable ObtenerReporteInflacionAnual()
        {
            var datos = new AccesoDatos();
            try
            {
                datos.setearConsulta(@"
            WITH PreciosExtremos AS (
                SELECT 
                    IdProducto, Precio,
                    ROW_NUMBER() OVER(PARTITION BY IdProducto ORDER BY Fecha ASC) as Primero,
                    ROW_NUMBER() OVER(PARTITION BY IdProducto ORDER BY Fecha DESC) as Ultimo
                FROM PRECIOS_COMPRA
                WHERE YEAR(Fecha) = YEAR(GETDATE())
            )
            SELECT 
                P.Descripcion AS Producto, 
                C.Nombre as Categoria,
                P_Inicio.Precio as PrecioInicial, 
                P_Fin.Precio as PrecioActual,
                ((P_Fin.Precio - P_Inicio.Precio) / NULLIF(P_Inicio.Precio, 0)) * 100 as Porcentaje
            FROM PRODUCTOS P
            INNER JOIN CATEGORIAS C ON P.IdCategoria = C.Id
            INNER JOIN PreciosExtremos P_Inicio ON P.Id = P_Inicio.IdProducto AND P_Inicio.Primero = 1
            INNER JOIN PreciosExtremos P_Fin ON P.Id = P_Fin.IdProducto AND P_Fin.Ultimo = 1
            WHERE P.Activo = 1
            ORDER BY Porcentaje DESC");

                datos.ejecutarLectura();
                DataTable dt = new DataTable();
                dt.Load(datos.Lector);
                return dt;
            }
            finally { datos.CerrarConexion(); }
        }

        // --- LISTAR ---
        public List<Producto> Listar(string q = null, int? idProveedor = null)
        {
            var lista = new List<Producto>();
            var datos = new AccesoDatos();

            try
            {
                string query = @"
                SELECT 
                    P.Id, P.CodigoSKU, P.Descripcion, P.StockMinimo, P.StockActual,
                    P.PorcentajeGanancia, P.PrecioNeto, P.Activo, P.Habilitado,
                    C.Id AS IdCategoria, C.Nombre AS NombreCategoria,
                    M.Id AS IdMarca, M.Nombre AS NombreMarca,
                    Prov.IdProv, Prov.NombreProv, Prov.VendeConIVA,
                    UP.PrecioActual, UP.FechaActual, UP.PrecioAnterior
                FROM PRODUCTOS P
                INNER JOIN CATEGORIAS C ON P.IdCategoria = C.Id
                LEFT JOIN MARCAS M ON P.IdMarca = M.Id
                OUTER APPLY (
                    SELECT TOP 1 
                        p1.Precio AS PrecioActual, 
                        p1.Fecha AS FechaActual,
                        (SELECT TOP 1 p2.Precio FROM PRECIOS_COMPRA p2 WHERE p2.IdProducto = p1.IdProducto AND p2.Fecha < p1.Fecha ORDER BY p2.Fecha DESC) AS PrecioAnterior
                    FROM PRECIOS_COMPRA p1
                    WHERE p1.IdProducto = P.Id
                    ORDER BY p1.Fecha DESC
                ) AS UP
                OUTER APPLY (
                    SELECT TOP 1 PR.Id AS IdProv, PR.Nombre AS NombreProv, PR.VendeConIVA
                    FROM PRODUCTO_PROVEEDOR PP
                    INNER JOIN PROVEEDORES PR ON PR.Id = PP.IdProveedor
                    WHERE PP.IdProducto = P.Id
                ) AS Prov
                WHERE P.Activo = 1";

                if (idProveedor.HasValue && idProveedor.Value > 0)
                {
                    query += " AND EXISTS (SELECT 1 FROM PRODUCTO_PROVEEDOR PPF WHERE PPF.IdProducto = P.Id AND PPF.IdProveedor = @idProv)";
                }

                if (!string.IsNullOrWhiteSpace(q))
                {
                    query += @" AND (
                        P.Descripcion LIKE @q 
                        OR P.CodigoSKU LIKE @q 
                        OR C.Nombre LIKE @q 
                        OR M.Nombre LIKE @q
                        OR EXISTS (
                            SELECT 1 FROM PRODUCTO_PROVEEDOR PPQ 
                            INNER JOIN PROVEEDORES PRQ ON PPQ.IdProveedor = PRQ.Id 
                            WHERE PPQ.IdProducto = P.Id AND PRQ.Nombre LIKE @q
                        )
                    )";
                }

                query += " ORDER BY P.Descripcion";
                datos.setearConsulta(query);

                if (idProveedor.HasValue && idProveedor.Value > 0)
                    datos.setearParametro("@idProv", idProveedor.Value);

                if (!string.IsNullOrWhiteSpace(q))
                    datos.setearParametro("@q", "%" + q + "%");

                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    var p = new Producto
                    {
                        Id = (int)datos.Lector["Id"],
                        CodigoSKU = datos.Lector["CodigoSKU"] as string ?? "",
                        Descripcion = datos.Lector["Descripcion"].ToString(),
                        StockMinimo = datos.Lector["StockMinimo"] is DBNull ? 0 : (decimal)datos.Lector["StockMinimo"],
                        StockActual = datos.Lector["StockActual"] is DBNull ? 0 : (decimal)datos.Lector["StockActual"],
                        PorcentajeGanancia = datos.Lector["PorcentajeGanancia"] is DBNull ? 0 : (decimal)datos.Lector["PorcentajeGanancia"],
                        PrecioNeto = datos.Lector["PrecioNeto"] is DBNull ? 0 : (decimal)datos.Lector["PrecioNeto"],
                        Activo = (bool)datos.Lector["Activo"],
                        Habilitado = (bool)datos.Lector["Habilitado"],
                        Categoria = new Categoria { Id = (int)datos.Lector["IdCategoria"], Nombre = (string)datos.Lector["NombreCategoria"] },
                        Marca = datos.Lector["IdMarca"] is DBNull ? null : new Marca { Id = (int)datos.Lector["IdMarca"], Nombre = (string)datos.Lector["NombreMarca"] },
                        Proveedor = datos.Lector["IdProv"] is DBNull ? null : new Proveedor
                        {
                            Id = (int)datos.Lector["IdProv"],
                            Nombre = (string)datos.Lector["NombreProv"],
                            VendeConIVA = (bool)datos.Lector["VendeConIVA"]
                        }
                    };

                    if (!(datos.Lector["PrecioActual"] is DBNull))
                    {
                        p.PreciosCompra.Add(new PrecioCompra
                        {
                            ProductoId = p.Id,
                            PrecioUnitario = (decimal)datos.Lector["PrecioActual"],
                            Fecha = (DateTime)datos.Lector["FechaActual"]
                        });

                        if (!(datos.Lector["PrecioAnterior"] is DBNull))
                        {
                            p.PreciosCompra.Add(new PrecioCompra
                            {
                                ProductoId = p.Id,
                                PrecioUnitario = (decimal)datos.Lector["PrecioAnterior"],
                                Fecha = DateTime.MinValue
                            });
                        }
                    }
                    lista.Add(p);
                }
                return lista;
            }
            finally { datos.CerrarConexion(); }
        }

        public List<Producto> ListarHabilitados()
        {
            return Listar().Where(x => x.Habilitado).ToList();
        }

        public Producto ObtenerPorId(int id)
        {
            var datos = new AccesoDatos();
            try
            {
                datos.setearConsulta(@"
                SELECT 
                    P.Id, P.CodigoSKU, P.Descripcion, P.StockMinimo, P.StockActual, P.PorcentajeGanancia, 
                    P.PrecioNeto, P.Activo, P.Habilitado,
                    C.Id AS IdCategoria, C.Nombre AS NombreCategoria,
                    M.Id AS IdMarca, M.Nombre AS NombreMarca,
                    Prov.IdProv, Prov.NombreProv, Prov.VendeConIVA,
                    UP.Precio AS PrecioUnitario, UP.Fecha AS FechaPrecio
                FROM PRODUCTOS P
                INNER JOIN CATEGORIAS C ON P.IdCategoria = C.Id
                LEFT JOIN MARCAS M ON P.IdMarca = M.Id
                OUTER APPLY (
                    SELECT TOP 1 Precio, Fecha FROM PRECIOS_COMPRA PC WHERE PC.IdProducto = P.Id ORDER BY PC.Fecha DESC
                ) AS UP
                OUTER APPLY (
                    SELECT TOP 1 PR.Id AS IdProv, PR.Nombre AS NombreProv, PR.VendeConIVA
                    FROM PRODUCTO_PROVEEDOR PP
                    INNER JOIN PROVEEDORES PR ON PR.Id = PP.IdProveedor
                    WHERE PP.IdProducto = P.Id
                ) AS Prov
                WHERE P.Id = @id");

                datos.setearParametro("@id", id);
                datos.ejecutarLectura();

                if (datos.Lector.Read())
                {
                    var p = new Producto
                    {
                        Id = (int)datos.Lector["Id"],
                        CodigoSKU = datos.Lector["CodigoSKU"] is DBNull ? "" : (string)datos.Lector["CodigoSKU"],
                        Descripcion = (string)datos.Lector["Descripcion"],
                        StockMinimo = datos.Lector["StockMinimo"] is DBNull ? 0 : (decimal)datos.Lector["StockMinimo"],
                        StockActual = datos.Lector["StockActual"] is DBNull ? 0 : (decimal)datos.Lector["StockActual"],
                        PorcentajeGanancia = datos.Lector["PorcentajeGanancia"] is DBNull ? 0 : (decimal)datos.Lector["PorcentajeGanancia"],
                        PrecioNeto = datos.Lector["PrecioNeto"] is DBNull ? 0 : (decimal)datos.Lector["PrecioNeto"],
                        Activo = (bool)datos.Lector["Activo"],
                        Habilitado = (bool)datos.Lector["Habilitado"],
                        Categoria = new Categoria { Id = (int)datos.Lector["IdCategoria"], Nombre = (string)datos.Lector["NombreCategoria"] },
                        Marca = datos.Lector["IdMarca"] is DBNull ? null : new Marca { Id = (int)datos.Lector["IdMarca"], Nombre = (string)datos.Lector["NombreMarca"] },
                        Proveedor = datos.Lector["IdProv"] is DBNull ? null : new Proveedor
                        {
                            Id = (int)datos.Lector["IdProv"],
                            Nombre = (string)datos.Lector["NombreProv"],
                            VendeConIVA = (bool)datos.Lector["VendeConIVA"]
                        }
                    };

                    if (!(datos.Lector["PrecioUnitario"] is DBNull))
                    {
                        p.PreciosCompra.Add(new PrecioCompra
                        {
                            ProductoId = p.Id,
                            PrecioUnitario = (decimal)datos.Lector["PrecioUnitario"],
                            Fecha = (DateTime)datos.Lector["FechaPrecio"]
                        });
                    }
                    return p;
                }
                return null;
            }
            finally { datos.CerrarConexion(); }
        }

        // --- AUMENTO POR PROVEEDOR (BLINDADO) ---
        public int AumentarPreciosPorProveedor(int idProveedor, decimal porcentajeAumento)
        {
            var datos = new AccesoDatos();
            try
            {
                // Si PrecioNeto > 0 usa eso. Si es 0 o NULL, busca el último precio en historial.
                datos.setearConsulta(@"
                    INSERT INTO PRECIOS_COMPRA (IdProducto, Precio, Fecha)
                    SELECT 
                        P.Id,
                        CAST(
                            (CASE WHEN P.PrecioNeto > 0 THEN P.PrecioNeto ELSE ISNULL(UP.Precio, 0) END) 
                            * (1.0 + (@porc / 100.0)) 
                        AS DECIMAL(18,2)),
                        GETDATE()
                    FROM PRODUCTOS P
                    INNER JOIN PRODUCTO_PROVEEDOR PP ON P.Id = PP.IdProducto
                    OUTER APPLY (SELECT TOP 1 Precio FROM PRECIOS_COMPRA WHERE IdProducto = P.Id ORDER BY Fecha DESC) AS UP
                    WHERE PP.IdProveedor = @idProv AND P.Activo = 1;
                    
                    UPDATE P
                    SET P.PrecioNeto = CAST(
                        (CASE WHEN P.PrecioNeto > 0 THEN P.PrecioNeto ELSE ISNULL(UP.Precio, 0) END) 
                        * (1.0 + (@porc / 100.0)) 
                    AS DECIMAL(18,2))
                    FROM PRODUCTOS P
                    INNER JOIN PRODUCTO_PROVEEDOR PP ON P.Id = PP.IdProducto
                    OUTER APPLY (SELECT TOP 1 Precio FROM PRECIOS_COMPRA WHERE IdProducto = P.Id ORDER BY Fecha DESC) AS UP
                    WHERE PP.IdProveedor = @idProv AND P.Activo = 1;

                    SELECT @@ROWCOUNT; 
                ");
                datos.setearParametro("@idProv", idProveedor);
                datos.setearParametro("@porc", porcentajeAumento);
                return Convert.ToInt32(datos.EjecutarScalar());
            }
            finally { datos.CerrarConexion(); }
        }

        // --- AUMENTO POR MARCA (BLINDADO) ---
        public int AumentarPreciosPorMarca(int idMarca, decimal porcentajeAumento)
        {
            var datos = new AccesoDatos();
            try
            {
                datos.setearConsulta(@"
                    INSERT INTO PRECIOS_COMPRA (IdProducto, Precio, Fecha)
                    SELECT 
                        P.Id,
                        CAST(
                            (CASE WHEN P.PrecioNeto > 0 THEN P.PrecioNeto ELSE ISNULL(UP.Precio, 0) END) 
                            * (1.0 + (@porc / 100.0)) 
                        AS DECIMAL(18,2)),
                        GETDATE()
                    FROM PRODUCTOS P
                    OUTER APPLY (SELECT TOP 1 Precio FROM PRECIOS_COMPRA WHERE IdProducto = P.Id ORDER BY Fecha DESC) AS UP
                    WHERE P.IdMarca = @idMarca AND P.Activo = 1;
                    
                    UPDATE P
                    SET P.PrecioNeto = CAST(
                        (CASE WHEN P.PrecioNeto > 0 THEN P.PrecioNeto ELSE ISNULL(UP.Precio, 0) END) 
                        * (1.0 + (@porc / 100.0)) 
                    AS DECIMAL(18,2))
                    FROM PRODUCTOS P
                    OUTER APPLY (SELECT TOP 1 Precio FROM PRECIOS_COMPRA WHERE IdProducto = P.Id ORDER BY Fecha DESC) AS UP
                    WHERE P.IdMarca = @idMarca AND P.Activo = 1;

                    SELECT @@ROWCOUNT; 
                ");
                datos.setearParametro("@idMarca", idMarca);
                datos.setearParametro("@porc", porcentajeAumento);
                return Convert.ToInt32(datos.EjecutarScalar());
            }
            finally { datos.CerrarConexion(); }
        }

        // --- AUMENTO INDIVIDUAL (BLINDADO) ---
        public void AumentarPrecioProducto(int idProducto, decimal porcentajeAumento)
        {
            var datos = new AccesoDatos();
            try
            {
                datos.setearConsulta(@"
                    DECLARE @NewPrice DECIMAL(18,2);
                    
                    SELECT @NewPrice = CAST(
                        (CASE WHEN P.PrecioNeto > 0 THEN P.PrecioNeto ELSE ISNULL(UP.Precio, 0) END) 
                        * (1.0 + (@porc / 100.0)) 
                    AS DECIMAL(18,2))
                    FROM PRODUCTOS P
                    OUTER APPLY (SELECT TOP 1 Precio FROM PRECIOS_COMPRA WHERE IdProducto = P.Id ORDER BY Fecha DESC) AS UP
                    WHERE P.Id = @idProd;

                    INSERT INTO PRECIOS_COMPRA (IdProducto, Precio, Fecha)
                    VALUES (@idProd, @NewPrice, GETDATE());

                    UPDATE PRODUCTOS SET PrecioNeto = @NewPrice WHERE Id = @idProd;
                ");
                datos.setearParametro("@idProd", idProducto);
                datos.setearParametro("@porc", porcentajeAumento);
                datos.ejecutarAccion();
            }
            finally { datos.CerrarConexion(); }
        }

        // --- GUARDAR (Sin cambios, ya estaba correcto) ---
        public void Guardar(Producto p)
        {
            var datos = new AccesoDatos();
            try
            {
                int? idExcluir = p.Id == 0 ? (int?)null : p.Id;
                if (!string.IsNullOrWhiteSpace(p.CodigoSKU))
                {
                    if (ExisteSku(p.CodigoSKU, idExcluir)) throw new Exception("Ya existe un producto con el mismo código SKU.");
                }

                if (p.Id == 0)
                {
                    datos.setearConsulta(@"
                        INSERT INTO PRODUCTOS (CodigoSKU, Descripcion, StockMinimo, StockActual, PorcentajeGanancia, PrecioNeto, Activo, Habilitado, IdCategoria, IdMarca)
                        VALUES (@sku, @desc, @min, @act, @gan, @neto, 1, @hab, @idCat, @idMar);
                        SELECT SCOPE_IDENTITY();");
                }
                else
                {
                    datos.setearConsulta(@"
                        UPDATE PRODUCTOS SET CodigoSKU = @sku, Descripcion = @desc, StockMinimo = @min, StockActual = @act, 
                        PorcentajeGanancia = @gan, PrecioNeto = @neto, Habilitado = @hab, IdCategoria = @idCat, IdMarca = @idMar
                        WHERE Id = @id;

                        INSERT INTO PRECIOS_COMPRA (IdProducto, IdProveedor, Precio, Fecha)
                        SELECT @id, (SELECT TOP 1 IdProveedor FROM PRODUCTO_PROVEEDOR WHERE IdProducto = @id), @neto, GETDATE()
                        WHERE @neto > 0;
                    ");
                    datos.setearParametro("@id", p.Id);
                }

                datos.setearParametro("@sku", p.CodigoSKU);
                datos.setearParametro("@desc", p.Descripcion);
                datos.setearParametro("@min", p.StockMinimo);
                datos.setearParametro("@act", p.StockActual);
                datos.setearParametro("@gan", p.PorcentajeGanancia);
                datos.setearParametro("@neto", p.PrecioNeto);
                datos.setearParametro("@hab", p.Habilitado);
                datos.setearParametro("@idCat", p.Categoria.Id);
                datos.setearParametro("@idMar", (p.Marca != null && p.Marca.Id > 0) ? (object)p.Marca.Id : DBNull.Value);

                if (p.Id == 0)
                {
                    p.Id = Convert.ToInt32(datos.EjecutarScalar());
                    if (p.Proveedor != null && p.Proveedor.Id > 0) vincularProveedorNuevo(p.Id, p.Proveedor.Id);
                }
                else { datos.ejecutarAccion(); }
            }
            finally { datos.CerrarConexion(); }
        }

        private void vincularProveedorNuevo(int idProd, int idProv)
        {
            var datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("INSERT INTO PRODUCTO_PROVEEDOR (IdProducto, IdProveedor) VALUES (@p, @prov)");
                datos.setearParametro("@p", idProd);
                datos.setearParametro("@prov", idProv);
                datos.ejecutarAccion();
            }
            finally { datos.CerrarConexion(); }
        }

        public void Eliminar(int id)
        {
            var datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("UPDATE PRODUCTOS SET Activo = 0 WHERE Id = @id");
                datos.setearParametro("@id", id);
                datos.ejecutarAccion();
            }
            finally { datos.CerrarConexion(); }
        }

        private bool ExisteSku(string sku, int? idProductoExcluir = null)
        {
            var datos = new AccesoDatos();
            try
            {
                string consulta = "SELECT COUNT(*) FROM PRODUCTOS WHERE CodigoSKU = @sku";
                if (idProductoExcluir.HasValue) consulta += " AND Id <> @id";
                datos.setearConsulta(consulta);
                datos.setearParametro("@sku", sku);
                if (idProductoExcluir.HasValue) datos.setearParametro("@id", idProductoExcluir.Value);
                return Convert.ToInt32(datos.EjecutarScalar()) > 0;
            }
            finally { datos.CerrarConexion(); }
        }

        public List<int> ObtenerProveedoresPorProducto(int idProducto)
        {
            var lista = new List<int>();
            var datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("SELECT IdProveedor FROM PRODUCTO_PROVEEDOR WHERE IdProducto = @id");
                datos.setearParametro("@id", idProducto);
                datos.ejecutarLectura();
                while (datos.Lector.Read()) lista.Add((int)datos.Lector["IdProveedor"]);
                return lista;
            }
            finally { datos.CerrarConexion(); }
        }

        public void ActualizarProveedoresProducto(int idProducto, List<int> proveedores)
        {
            var datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("DELETE FROM PRODUCTO_PROVEEDOR WHERE IdProducto = @id");
                datos.setearParametro("@id", idProducto);
                datos.ejecutarAccion();
                foreach (int idProv in proveedores)
                {
                    datos.setearConsulta("INSERT INTO PRODUCTO_PROVEEDOR (IdProducto, IdProveedor) VALUES (@p, @prov)");
                    datos.setearParametro("@p", idProducto);
                    datos.setearParametro("@prov", idProv);
                    datos.ejecutarAccion();
                }
            }
            finally { datos.CerrarConexion(); }
        }

        public List<Producto> ListarStockBajo()
        {
            var lista = new List<Producto>();
            var datos = new AccesoDatos();
            try
            {
                datos.setearConsulta(@"
                    SELECT P.Id, P.CodigoSKU, P.Descripcion, P.StockMinimo, P.StockActual, C.Id AS IdCategoria, C.Nombre AS NombreCategoria
                    FROM PRODUCTOS P INNER JOIN CATEGORIAS C ON P.IdCategoria = C.Id
                    WHERE P.Activo = 1 AND P.StockMinimo IS NOT NULL AND P.StockActual IS NOT NULL AND P.StockActual < P.StockMinimo");
                datos.ejecutarLectura();
                while (datos.Lector.Read())
                {
                    lista.Add(new Producto
                    {
                        Id = (int)datos.Lector["Id"],
                        Descripcion = datos.Lector["Descripcion"].ToString(),
                        StockActual = (decimal)datos.Lector["StockActual"],
                        StockMinimo = (decimal)datos.Lector["StockMinimo"]
                    });
                }
                return lista;
            }
            finally { datos.CerrarConexion(); }
        }

        public List<Producto> listarPorProveedor(int idProveedor)
        {
            var lista = new List<Producto>();
            var datos = new AccesoDatos();
            try
            {
                datos.setearConsulta(
                    "SELECT P.Id, P.Descripcion " +
                    "FROM PRODUCTOS P " +
                    "INNER JOIN PRODUCTO_PROVEEDOR PP ON PP.IdProducto = P.Id " +
                    "WHERE PP.IdProveedor = @id AND P.Activo = 1 AND P.Habilitado = 1 " +
                    "ORDER BY P.Descripcion"
                );
                datos.setearParametro("@id", idProveedor);
                datos.ejecutarLectura();
                while (datos.Lector.Read())
                {
                    lista.Add(new Producto
                    {
                        Id = (int)datos.Lector["Id"],
                        Descripcion = (string)datos.Lector["Descripcion"]
                    });
                }
                return lista;
            }
            finally { datos.CerrarConexion(); }
        }

        public bool ProductoPerteneceAProveedor(int idProducto, int idProveedor)
        {
            var datos = new AccesoDatos();
            try
            {
                datos.setearConsulta(
                    "SELECT COUNT(*) FROM PRODUCTO_PROVEEDOR " +
                    "WHERE IdProducto = @prod AND IdProveedor = @prov");
                datos.setearParametro("@prod", idProducto);
                datos.setearParametro("@prov", idProveedor);
                return Convert.ToInt32(datos.EjecutarScalar()) > 0;
            }
            finally { datos.CerrarConexion(); }
        }
    }
}