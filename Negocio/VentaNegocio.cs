using Dominio;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;

namespace Negocio
{
    public class VentaNegocio
    {
        public List<Venta> Listar(string q = null)
        {
            List<Venta> lista = new List<Venta>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                string consulta = @"
SELECT 
    V.Id,
    V.Fecha,
    V.NumeroFactura,
    V.MetodoPago,
    V.Total,
    V.Descuento, -- LEYENDO LA COLUMNA DESCUENTO
    V.Estado, 
    V.MotivoCancelacion,
    V.FechaCancelacion,
    V.IdUsuarioCancelacion,
    V.IdUsuario,
    V.TipoVenta,
    U.Nombre AS NombreUsuario,
    C.Id AS IdCliente,  
    C.Nombre AS NombreCliente
FROM Ventas V
INNER JOIN Clientes C ON V.IdCliente = C.Id
INNER JOIN Usuarios U ON V.IdUsuario = U.Id
WHERE 1 = 1
";

                if (!string.IsNullOrWhiteSpace(q))
                {
                    consulta += @"
 AND (
        C.Nombre LIKE @q
        OR V.NumeroFactura LIKE @q
        OR V.MetodoPago LIKE @q
        OR CONVERT(VARCHAR(10), V.Id) LIKE @q
     )
";
                }

                consulta += " ORDER BY V.Fecha DESC";

                datos.setearConsulta(consulta);

                if (!string.IsNullOrWhiteSpace(q))
                    datos.setearParametro("@q", "%" + q + "%");

                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Venta v = new Venta
                    {
                        Id = (int)datos.Lector["Id"],
                        Fecha = (DateTime)datos.Lector["Fecha"],
                        NumeroFactura = datos.Lector["NumeroFactura"]?.ToString(),
                        MetodoPago = datos.Lector["MetodoPago"]?.ToString(),
                        Cliente = new Cliente
                        {
                            Id = (int)datos.Lector["IdCliente"],
                            Nombre = datos.Lector["NombreCliente"].ToString()
                        },
                        Usuario = new Usuario
                        {
                            Id = (int)datos.Lector["IdUsuario"],
                            Nombre = datos.Lector["NombreUsuario"].ToString()
                        },
                        TotalBD = datos.Lector["Total"] != DBNull.Value ? Convert.ToDecimal(datos.Lector["Total"]) : 0,
                        Descuento = datos.Lector["Descuento"] != DBNull.Value ? Convert.ToDecimal(datos.Lector["Descuento"]) : 0, // MAPEO DEL DESCUENTO
                        Estado = datos.Lector["Estado"].ToString()
                    };

                    if (!(datos.Lector["TipoVenta"] is DBNull))
                        v.TipoVenta = datos.Lector["TipoVenta"].ToString();

                    lista.Add(v);
                }

                return lista;
            }
            finally
            {
                datos.CerrarConexion();
            }
        }

        public Venta ObtenerPorId(int id)
        {
            Venta venta = null;
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta(@"
            SELECT 
                V.Id,
                V.Fecha,
                V.NumeroFactura,
                V.NumeroNC,
                V.MetodoPago,
                V.TipoVenta, 
                V.Total AS TotalBD,
                V.Descuento, -- LEYENDO LA COLUMNA DESCUENTO
                V.Estado, 
                V.MotivoCancelacion,
                V.FechaCancelacion,
                V.IdUsuarioCancelacion,
                C.Id AS IdCliente,
                C.Nombre AS NombreCliente,
                C.Email AS EmailCliente,
                C.Telefono AS TelefonoCliente,     
                C.Direccion AS DireccionCliente,   
                C.Localidad AS LocalidadCliente,   
                C.Observaciones AS ObservacionesCliente,
                U.Nombre AS NombreUsuarioCancelacion,
                V.IdUsuario AS IdVendedor,
                U2.Nombre AS NombreVendedor
            FROM VENTAS V
            INNER JOIN CLIENTES C ON V.IdCliente = C.Id
            LEFT JOIN USUARIOS U ON V.IdUsuarioCancelacion = U.Id
            LEFT JOIN USUARIOS U2 ON V.IdUsuario = U2.Id 
            WHERE V.Id = @id
        ");

                datos.setearParametro("@id", id);
                datos.ejecutarLectura();

                if (datos.Lector.Read())
                {
                    venta = new Venta
                    {
                        Id = (int)datos.Lector["Id"],
                        Fecha = (DateTime)datos.Lector["Fecha"],
                        NumeroFactura = datos.Lector["NumeroFactura"]?.ToString(),
                        NumeroNC = datos.Lector["NumeroNC"]?.ToString(),
                        MetodoPago = datos.Lector["MetodoPago"]?.ToString(),
                        TotalBD = datos.Lector["TotalBD"] != DBNull.Value ? Convert.ToDecimal(datos.Lector["TotalBD"]) : 0,
                        Descuento = datos.Lector["Descuento"] != DBNull.Value ? Convert.ToDecimal(datos.Lector["Descuento"]) : 0, // MAPEO DEL DESCUENTO
                        Cliente = new Cliente
                        {
                            Id = (int)datos.Lector["IdCliente"],
                            Nombre = datos.Lector["NombreCliente"].ToString(),
                            Email = datos.Lector["EmailCliente"] == DBNull.Value ? null : datos.Lector["EmailCliente"].ToString(),
                            Telefono = datos.Lector["TelefonoCliente"] == DBNull.Value ? null : datos.Lector["TelefonoCliente"].ToString(),
                            Direccion = datos.Lector["DireccionCliente"] == DBNull.Value ? null : datos.Lector["DireccionCliente"].ToString(),
                            Localidad = datos.Lector["LocalidadCliente"] == DBNull.Value ? null : datos.Lector["LocalidadCliente"].ToString(),
                            Observaciones = datos.Lector["ObservacionesCliente"] == DBNull.Value ? null : datos.Lector["ObservacionesCliente"].ToString()
                        },
                        Usuario = datos.Lector["IdVendedor"] == DBNull.Value ? null : new Usuario
                        {
                            Id = Convert.ToInt32(datos.Lector["IdVendedor"]),
                            Nombre = datos.Lector["NombreVendedor"]?.ToString()
                        },
                        Estado = datos.Lector["Estado"].ToString(),
                        MotivoCancelacion = datos.Lector["MotivoCancelacion"]?.ToString(),
                        FechaCancelacion = datos.Lector["FechaCancelacion"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(datos.Lector["FechaCancelacion"]),
                        UsuarioCancelacion = datos.Lector["IdUsuarioCancelacion"] == DBNull.Value ? null : new Usuario
                        {
                            Id = Convert.ToInt32(datos.Lector["IdUsuarioCancelacion"]),
                            Nombre = datos.Lector["NombreUsuarioCancelacion"]?.ToString()
                        },
                        Lineas = new List<VentaLinea>()
                    };

                    if (!(datos.Lector["TipoVenta"] is DBNull))
                        venta.TipoVenta = datos.Lector["TipoVenta"].ToString();
                }
            }
            finally
            {
                datos.CerrarConexion();
            }

            if (venta != null)
                venta.Lineas = ListarLineasPorVenta(id);

            return venta;
        }

        private List<VentaLinea> ListarLineasPorVenta(int idVenta)
        {
            List<VentaLinea> lineas = new List<VentaLinea>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta(@"
                    SELECT VL.Id, VL.Cantidad, VL.PrecioUnitario,
                           P.Id AS IdProducto, P.Descripcion AS NombreProducto
                    FROM DETALLE_VENTA VL
                    INNER JOIN Productos P ON VL.IdProducto = P.Id
                    WHERE VL.IdVenta = @idVenta
                ");
                datos.setearParametro("@idVenta", idVenta);
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    VentaLinea l = new VentaLinea
                    {
                        Id = (int)datos.Lector["Id"],
                        Cantidad = Convert.ToDecimal(datos.Lector["Cantidad"]),
                        PrecioUnitario = Convert.ToDecimal(datos.Lector["PrecioUnitario"]),
                        Producto = new Producto
                        {
                            Id = (int)datos.Lector["IdProducto"],
                            Descripcion = datos.Lector["NombreProducto"].ToString()
                        }
                    };
                    lineas.Add(l);
                }
                return lineas;
            }
            finally
            {
                datos.CerrarConexion();
            }
        }

        private string GenerarNumeroFactura()
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta(@"
            SELECT TOP 1 NumeroFactura
            FROM VENTAS
            WHERE NumeroFactura LIKE 'R-%'
                  AND NumeroFactura IS NOT NULL
                  AND NumeroFactura <> ''
            ORDER BY Id DESC;
        ");

                object resultado = datos.EjecutarScalar();

                if (resultado == null || resultado == DBNull.Value)
                    return "R-0001-00000001";

                string ultimo = resultado.ToString().Trim();

                int posGuion = ultimo.LastIndexOf('-');
                int correlativoActual;

                if (posGuion >= 0 &&
                    int.TryParse(ultimo.Substring(posGuion + 1), out correlativoActual))
                {
                    correlativoActual++;
                    return $"R-0001-{correlativoActual:00000000}";
                }

                return "R-0001-00000001";
            }
            finally
            {
                datos.CerrarConexion();
            }
        }

        private string GenerarNumeroNC()
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta(@"
                    SELECT TOP 1 NumeroNC
                    FROM VENTAS
                    WHERE NumeroNC IS NOT NULL AND NumeroNC <> ''
                    ORDER BY Id DESC;
                ");

                object resultado = datos.EjecutarScalar();

                if (resultado == null || resultado == DBNull.Value)
                    return "NC-0001-00000001";

                string ultimo = resultado.ToString().Trim();

                int posGuion = ultimo.LastIndexOf('-');
                int correlativoActual;

                if (posGuion >= 0 &&
                    int.TryParse(ultimo.Substring(posGuion + 1), out correlativoActual))
                {
                    correlativoActual++;
                    string prefijo = ultimo.Substring(0, posGuion + 1);
                    return $"{prefijo}{correlativoActual:00000000}";
                }

                return "NC-0001-00000001";
            }
            finally
            {
                datos.CerrarConexion();
            }
        }

        public void Registrar(Venta venta)
        {
            AccesoDatos datos = new AccesoDatos();
            int idVenta = 0;

            try
            {
                decimal totalFinal = venta.TotalFinal;

                string numeroFactura = GenerarNumeroFactura();
                venta.NumeroFactura = numeroFactura;

                datos.setearConsulta(@"
                    INSERT INTO Ventas (IdUsuario, IdCliente, Fecha, NumeroFactura, MetodoPago, TipoVenta, Descuento, Total, Estado)
                    OUTPUT INSERTED.Id
                    VALUES (@usuario, @cliente, @fecha, @factura, @metodo, @tipoVenta, @descuento, @total, 'Activa')");

                datos.setearParametro("@usuario", venta.Usuario.Id);
                datos.setearParametro("@cliente", venta.Cliente.Id);
                datos.setearParametro("@fecha", venta.Fecha);
                datos.setearParametro("@factura", numeroFactura);
                datos.setearParametro("@metodo", venta.MetodoPago ?? "");
                datos.setearParametro("@tipoVenta", venta.TipoVenta ?? "Final");
                datos.setearParametro("@descuento", venta.Descuento); // GUARDANDO EL DESCUENTO
                datos.setearParametro("@total", totalFinal); // GUARDANDO EL TOTAL YA RESTADO

                idVenta = Convert.ToInt32(datos.EjecutarScalar());

                foreach (var linea in venta.Lineas)
                {
                    datos.setearConsulta(@"
                        INSERT INTO Detalle_Venta (IdVenta, IdProducto, Cantidad, PrecioUnitario)
                        VALUES (@idVenta, @idProd, @cant, @precio)");
                    datos.setearParametro("@idVenta", idVenta);
                    datos.setearParametro("@idProd", linea.Producto.Id);
                    datos.setearParametro("@cant", linea.Cantidad);
                    datos.setearParametro("@precio", linea.PrecioUnitario);
                    datos.ejecutarAccion();

                    datos.setearConsulta("UPDATE Productos SET StockActual = StockActual - @cant WHERE Id = @idProd");
                    datos.setearParametro("@cant", linea.Cantidad);
                    datos.setearParametro("@idProd", linea.Producto.Id);
                    datos.ejecutarAccion();
                }
            }
            finally
            {
                datos.CerrarConexion();
            }

            try
            {
                Venta ventaCompleta = ObtenerPorId(idVenta);

                if (ventaCompleta != null &&
                    ventaCompleta.Cliente != null &&
                    !string.IsNullOrEmpty(ventaCompleta.Cliente.Email))
                {
                    EnviarFacturaPorMail(ventaCompleta);
                }
            }
            catch
            {
            }
        }

        public void Cancelar(int idVenta, string motivo, int idUsuario)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("SELECT IdProducto, Cantidad FROM DETALLE_VENTA WHERE IdVenta = @id");
                datos.setearParametro("@id", idVenta);
                datos.ejecutarLectura();

                List<Tuple<int, decimal>> lineas = new List<Tuple<int, decimal>>();

                while (datos.Lector.Read())
                {
                    lineas.Add(new Tuple<int, decimal>(
                        (int)datos.Lector["IdProducto"],
                        (decimal)datos.Lector["Cantidad"]
                    ));
                }

                datos.CerrarConexion();

                foreach (var item in lineas)
                {
                    AccesoDatos upd = new AccesoDatos();
                    upd.setearConsulta("UPDATE PRODUCTOS SET StockActual = StockActual + @cant WHERE Id = @idProd");
                    int idProd = item.Item1;
                    decimal cant = item.Item2;
                    upd.setearParametro("@cant", cant);
                    upd.setearParametro("@idProd", idProd);
                    upd.ejecutarAccion();
                    upd.CerrarConexion();
                }

                string numeroNC = GenerarNumeroNC();

                AccesoDatos updVenta = new AccesoDatos();
                updVenta.setearConsulta(@"
            UPDATE VENTAS
            SET Estado = 'Cancelada', 
                MotivoCancelacion = @motivo,
                FechaCancelacion = GETDATE(),
                IdUsuarioCancelacion = @idUsuario,
                NumeroNC = @numeroNC
            WHERE Id = @idVenta
        ");

                updVenta.setearParametro("@motivo", motivo);
                updVenta.setearParametro("@idUsuario", idUsuario);
                updVenta.setearParametro("@numeroNC", numeroNC);
                updVenta.setearParametro("@idVenta", idVenta);
                updVenta.ejecutarAccion();
                updVenta.CerrarConexion();
            }
            finally
            {
                datos.CerrarConexion();
            }

            try
            {
                Venta ventaCancelada = ObtenerPorId(idVenta);

                if (ventaCancelada != null &&
                    ventaCancelada.Cliente != null &&
                    !string.IsNullOrEmpty(ventaCancelada.Cliente.Email))
                {
                    EnviarFacturaPorMail(ventaCancelada);
                }
            }
            catch
            {
            }
        }

        public void EntregarVenta(int idVenta)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("UPDATE VENTAS SET Estado = 'Entregada' WHERE Id = @idVenta");
                datos.setearParametro("@idVenta", idVenta);
                datos.ejecutarAccion();
            }
            finally
            {
                datos.CerrarConexion();
            }
        }

        public decimal ObtenerTotalVentasMes(int? idUsuario)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                string consulta = @"
                    SELECT ISNULL(SUM(V.Total), 0)
                    FROM VENTAS V
                    WHERE V.Estado != 'Cancelada' 
                      AND V.Fecha >= @inicio
                      AND V.Fecha < @fin";

                if (idUsuario.HasValue)
                    consulta += " AND V.IdUsuario = @idUsuario";

                DateTime inicio = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
                DateTime fin = inicio.AddMonths(1);

                datos.setearConsulta(consulta);
                datos.setearParametro("@inicio", inicio);
                datos.setearParametro("@fin", fin);

                if (idUsuario.HasValue)
                    datos.setearParametro("@idUsuario", idUsuario.Value);

                object r = datos.EjecutarScalar();
                if (r == null || r == DBNull.Value)
                    return 0;

                return Convert.ToDecimal(r);
            }
            finally
            {
                datos.CerrarConexion();
            }
        }

        public int ObtenerPedidosCompletadosMes(int? idUsuario)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                string consulta = @"
                    SELECT COUNT(*)
                    FROM VENTAS V
                    WHERE V.Estado != 'Cancelada' 
                      AND V.Fecha >= @inicio
                      AND V.Fecha < @fin";

                if (idUsuario.HasValue)
                    consulta += " AND V.IdUsuario = @idUsuario";

                DateTime inicio = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
                DateTime fin = inicio.AddMonths(1);

                datos.setearConsulta(consulta);
                datos.setearParametro("@inicio", inicio);
                datos.setearParametro("@fin", fin);

                if (idUsuario.HasValue)
                    datos.setearParametro("@idUsuario", idUsuario.Value);

                object r = datos.EjecutarScalar();
                if (r == null || r == DBNull.Value)
                    return 0;

                return Convert.ToInt32(r);
            }
            finally
            {
                datos.CerrarConexion();
            }
        }

        public int ObtenerClientesNuevosMes(int? idUsuario)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                string consulta = @"
            SELECT COUNT(*)
            FROM CLIENTES C
            WHERE EXISTS (
                SELECT 1 
                FROM VENTAS V
                WHERE V.IdCliente = C.Id
                  AND V.Estado != 'Cancelada' 
                  AND V.Fecha >= @inicio
                  AND V.Fecha < @fin";

                if (idUsuario.HasValue)
                    consulta += " AND V.IdUsuario = @idUsuario";

                consulta += @"
            )
            AND NOT EXISTS (
                SELECT 1
                FROM VENTAS V2
                WHERE V2.IdCliente = C.Id
                  AND V2.Estado != 'Cancelada' 
                  AND V2.Fecha < @inicio";

                if (idUsuario.HasValue)
                    consulta += " AND V2.IdUsuario = @idUsuario";

                consulta += @"
            );";

                DateTime inicio = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
                DateTime fin = inicio.AddMonths(1);

                datos.setearConsulta(consulta);
                datos.setearParametro("@inicio", inicio);
                datos.setearParametro("@fin", fin);

                if (idUsuario.HasValue)
                    datos.setearParametro("@idUsuario", idUsuario.Value);

                object r = datos.EjecutarScalar();
                if (r == null || r == DBNull.Value)
                    return 0;

                return Convert.ToInt32(r);
            }
            finally
            {
                datos.CerrarConexion();
            }
        }


        public decimal ObtenerTicketPromedioMes(int? idUsuario)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                string consulta = @"
                    SELECT ISNULL(
                        SUM(V.Total) / NULLIF(COUNT(*), 0),
                        0
                    )
                    FROM VENTAS V
                    WHERE V.Estado != 'Cancelada' 
                      AND V.Fecha >= @inicio
                      AND V.Fecha < @fin";

                if (idUsuario.HasValue)
                    consulta += " AND V.IdUsuario = @idUsuario";

                DateTime inicio = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
                DateTime fin = inicio.AddMonths(1);

                datos.setearConsulta(consulta);
                datos.setearParametro("@inicio", inicio);
                datos.setearParametro("@fin", fin);

                if (idUsuario.HasValue)
                    datos.setearParametro("@idUsuario", idUsuario.Value);

                object r = datos.EjecutarScalar();
                if (r == null || r == DBNull.Value)
                    return 0;

                return Convert.ToDecimal(r);
            }
            finally
            {
                datos.CerrarConexion();
            }
        }

        public List<TopProductoVendido> TopProductosVendidosMes(int? idUsuario)
        {
            List<TopProductoVendido> lista = new List<TopProductoVendido>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                string consulta = @"
            SELECT TOP 6
                P.Descripcion AS Producto,
                C.Nombre AS Categoria,
                SUM(DV.Cantidad) AS Unidades,
                SUM(DV.Cantidad * DV.PrecioUnitario) AS Ingresos
            FROM DETALLE_VENTA DV
            INNER JOIN VENTAS V ON DV.IdVenta = V.Id
            INNER JOIN PRODUCTOS P ON DV.IdProducto = P.Id
            INNER JOIN CATEGORIAS C ON P.IdCategoria = C.Id
            WHERE V.Estado != 'Cancelada' 
              AND V.Fecha >= @inicio
              AND V.Fecha < @fin";

                if (idUsuario.HasValue)
                    consulta += " AND V.IdUsuario = @idUsuario";

                consulta += @"
            GROUP BY P.Descripcion, C.Nombre
            ORDER BY Unidades DESC";

                DateTime inicio = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
                DateTime fin = inicio.AddMonths(1);

                datos.setearConsulta(consulta);
                datos.setearParametro("@inicio", inicio);
                datos.setearParametro("@fin", fin);

                if (idUsuario.HasValue)
                    datos.setearParametro("@idUsuario", idUsuario.Value);

                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    var item = new TopProductoVendido
                    {
                        Producto = datos.Lector["Producto"].ToString(),
                        Categoria = datos.Lector["Categoria"].ToString(),
                        Unidades = Convert.ToDecimal(datos.Lector["Unidades"]),
                        Ingresos = Convert.ToDecimal(datos.Lector["Ingresos"]),
                        Vendedor = ""
                    };

                    lista.Add(item);
                }

                return lista;
            }
            finally
            {
                datos.CerrarConexion();
            }
        }

        public void Modificar(Venta venta)
        {
            try
            {
                AccesoDatos datos = new AccesoDatos();
                datos.setearConsulta("SELECT IdProducto, Cantidad FROM Detalle_Venta WHERE IdVenta = @idVenta");
                datos.setearParametro("@idVenta", venta.Id);
                datos.ejecutarLectura();

                List<Tuple<int, decimal>> lineasOriginales = new List<Tuple<int, decimal>>();
                while (datos.Lector.Read())
                {
                    lineasOriginales.Add(new Tuple<int, decimal>((int)datos.Lector["IdProducto"], (decimal)datos.Lector["Cantidad"]));
                }
                datos.CerrarConexion();

                foreach (var item in lineasOriginales)
                {
                    AccesoDatos upd = new AccesoDatos();
                    upd.setearConsulta("UPDATE Productos SET StockActual = StockActual + @cant WHERE Id = @idProd");
                    upd.setearParametro("@cant", item.Item2);
                    upd.setearParametro("@idProd", item.Item1);
                    upd.ejecutarAccion();
                    upd.CerrarConexion();
                }

                AccesoDatos del = new AccesoDatos();
                del.setearConsulta("DELETE FROM Detalle_Venta WHERE IdVenta = @idVenta");
                del.setearParametro("@idVenta", venta.Id);
                del.ejecutarAccion();
                del.CerrarConexion();

                decimal totalFinal = venta.TotalFinal;

                AccesoDatos updCab = new AccesoDatos();
                updCab.setearConsulta("UPDATE Ventas SET IdCliente = @cliente, Fecha = @fecha, MetodoPago = @metodo, TipoVenta = @tipoVenta, Descuento = @descuento, Total = @total WHERE Id = @idVenta");
                updCab.setearParametro("@cliente", venta.Cliente.Id);
                updCab.setearParametro("@fecha", venta.Fecha);
                updCab.setearParametro("@metodo", venta.MetodoPago ?? "");
                updCab.setearParametro("@tipoVenta", venta.TipoVenta ?? "Final");
                updCab.setearParametro("@descuento", venta.Descuento); // GUARDANDO EL DESCUENTO
                updCab.setearParametro("@total", totalFinal); // GUARDANDO EL TOTAL FINAL
                updCab.setearParametro("@idVenta", venta.Id);
                updCab.ejecutarAccion();
                updCab.CerrarConexion();

                foreach (var linea in venta.Lineas)
                {
                    AccesoDatos ins = new AccesoDatos();
                    ins.setearConsulta(@"
                        INSERT INTO Detalle_Venta (IdVenta, IdProducto, Cantidad, PrecioUnitario)
                        VALUES (@idVenta, @idProd, @cant, @precio)");
                    ins.setearParametro("@idVenta", venta.Id);
                    ins.setearParametro("@idProd", linea.Producto.Id);
                    ins.setearParametro("@cant", linea.Cantidad);
                    ins.setearParametro("@precio", linea.PrecioUnitario);
                    ins.ejecutarAccion();
                    ins.CerrarConexion();

                    AccesoDatos updStock = new AccesoDatos();
                    updStock.setearConsulta("UPDATE Productos SET StockActual = StockActual - @cant WHERE Id = @idProd");
                    updStock.setearParametro("@cant", linea.Cantidad);
                    updStock.setearParametro("@idProd", linea.Producto.Id);
                    updStock.ejecutarAccion();
                    updStock.CerrarConexion();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void EnviarFacturaPorMail(Venta venta)
        {
            EmailService.EnviarFactura(venta);
        }

        public void EnviarMailFactura(Venta venta)
        {
            EnviarFacturaPorMail(venta);
        }
    }
}