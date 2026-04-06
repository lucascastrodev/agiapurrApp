using System;
using System.Collections.Generic;
using Dominio;

namespace Negocio
{
    public class ProveedorNegocio
    {
        public List<Proveedor> Listar(string q = null)
        {
            var lista = new List<Proveedor>();
            var datos = new AccesoDatos();

            try
            {
                string consulta = @"
                    SELECT Id, Nombre, RazonSocial, Documento, Email, Telefono, 
                           Direccion, Localidad, CondicionIVA, Activo, VendeConIVA,
                           DescuentoHabitual, PorcentajeIVA, PorcentajeIIBB, PorcentajePercepcion
                    FROM PROVEEDORES
                    WHERE Activo = 1";

                if (!string.IsNullOrWhiteSpace(q))
                    consulta += " AND (Nombre LIKE @q OR RazonSocial LIKE @q OR Documento LIKE @q OR Email LIKE @q OR Telefono LIKE @q OR Localidad LIKE @q)";

                consulta += " ORDER BY Nombre";

                datos.setearConsulta(consulta);

                if (!string.IsNullOrWhiteSpace(q))
                    datos.setearParametro("@q", "%" + q + "%");

                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    var p = new Proveedor
                    {
                        Id = (int)datos.Lector["Id"],
                        Nombre = datos.Lector["Nombre"] as string ?? "",
                        RazonSocial = datos.Lector["RazonSocial"] as string ?? "",
                        Documento = datos.Lector["Documento"] as string ?? "",
                        Email = datos.Lector["Email"] as string ?? "",
                        Telefono = datos.Lector["Telefono"] as string ?? "",
                        Direccion = datos.Lector["Direccion"] as string ?? "",
                        Localidad = datos.Lector["Localidad"] as string ?? "",
                        CondicionIVA = datos.Lector["CondicionIVA"] as string ?? "",
                        Activo = datos.Lector["Activo"] != DBNull.Value && (bool)datos.Lector["Activo"],
                        VendeConIVA = datos.Lector["VendeConIVA"] != DBNull.Value && (bool)datos.Lector["VendeConIVA"],

                        // Nuevos campos impositivos
                        DescuentoHabitual = datos.Lector["DescuentoHabitual"] != DBNull.Value ? (decimal)datos.Lector["DescuentoHabitual"] : 0,
                        PorcentajeIVA = datos.Lector["PorcentajeIVA"] != DBNull.Value ? (decimal)datos.Lector["PorcentajeIVA"] : 0,
                        PorcentajeIIBB = datos.Lector["PorcentajeIIBB"] != DBNull.Value ? (decimal)datos.Lector["PorcentajeIIBB"] : 0,
                        PorcentajePercepcion = datos.Lector["PorcentajePercepcion"] != DBNull.Value ? (decimal)datos.Lector["PorcentajePercepcion"] : 0
                    };

                    lista.Add(p);
                }

                return lista;
            }
            finally
            {
                datos.CerrarConexion();
            }
        }

        public Proveedor ObtenerPorId(int id)
        {
            var datos = new AccesoDatos();

            try
            {
                datos.setearConsulta(@"
                    SELECT Id, Nombre, RazonSocial, Documento, Email, Telefono, 
                           Direccion, Localidad, CondicionIVA, Activo, VendeConIVA,
                           DescuentoHabitual, PorcentajeIVA, PorcentajeIIBB, PorcentajePercepcion
                    FROM PROVEEDORES
                    WHERE Id = @id");

                datos.setearParametro("@id", id);
                datos.ejecutarLectura();

                Proveedor p = null;

                if (datos.Lector.Read())
                {
                    p = new Proveedor
                    {
                        Id = (int)datos.Lector["Id"],
                        Nombre = datos.Lector["Nombre"] as string ?? "",
                        RazonSocial = datos.Lector["RazonSocial"] as string ?? "",
                        Documento = datos.Lector["Documento"] as string ?? "",
                        Email = datos.Lector["Email"] as string ?? "",
                        Telefono = datos.Lector["Telefono"] as string ?? "",
                        Direccion = datos.Lector["Direccion"] as string ?? "",
                        Localidad = datos.Lector["Localidad"] as string ?? "",
                        CondicionIVA = datos.Lector["CondicionIVA"] as string ?? "",
                        Activo = datos.Lector["Activo"] != DBNull.Value && (bool)datos.Lector["Activo"],
                        VendeConIVA = datos.Lector["VendeConIVA"] != DBNull.Value && (bool)datos.Lector["VendeConIVA"],

                        DescuentoHabitual = datos.Lector["DescuentoHabitual"] != DBNull.Value ? (decimal)datos.Lector["DescuentoHabitual"] : 0,
                        PorcentajeIVA = datos.Lector["PorcentajeIVA"] != DBNull.Value ? (decimal)datos.Lector["PorcentajeIVA"] : 0,
                        PorcentajeIIBB = datos.Lector["PorcentajeIIBB"] != DBNull.Value ? (decimal)datos.Lector["PorcentajeIIBB"] : 0,
                        PorcentajePercepcion = datos.Lector["PorcentajePercepcion"] != DBNull.Value ? (decimal)datos.Lector["PorcentajePercepcion"] : 0
                    };
                }

                return p;
            }
            finally
            {
                datos.CerrarConexion();
            }
        }

        public Proveedor BuscarPorId(int id)
        {
            return ObtenerPorId(id);
        }

        public void Guardar(Proveedor p)
        {
            var datos = new AccesoDatos();

            try
            {
                var existente = BuscarPorCuit(p.Documento);

                if (existente != null && existente.Id != p.Id)
                {
                    if (existente.Activo)
                    {
                        throw new Exception("Ya existe un proveedor activo con este CUIT.");
                    }
                }

                if (p.Id == 0)
                {
                    datos.setearConsulta(@"
                INSERT INTO PROVEEDORES
                    (Nombre, RazonSocial, Documento, Email, Telefono, Direccion, Localidad, CondicionIVA, Activo, VendeConIVA,
                     DescuentoHabitual, PorcentajeIVA, PorcentajeIIBB, PorcentajePercepcion)
                VALUES
                    (@nom, @razon, @doc, @mail, @tel, @dir, @loc, @iva, 1, @vendeIva,
                     @descHab, @porcIva, @porcIibb, @porcPerc)");
                }
                else
                {
                    datos.setearConsulta(@"
                UPDATE PROVEEDORES SET
                    Nombre = @nom,
                    RazonSocial = @razon,
                    Documento = @doc,
                    Email = @mail,
                    Telefono = @tel,
                    Direccion = @dir,
                    Localidad = @loc,
                    CondicionIVA = @iva,
                    VendeConIVA = @vendeIva,
                    DescuentoHabitual = @descHab,
                    PorcentajeIVA = @porcIva,
                    PorcentajeIIBB = @porcIibb,
                    PorcentajePercepcion = @porcPerc
                WHERE Id = @id");

                    datos.setearParametro("@id", p.Id);
                }

                datos.setearParametro("@nom", p.Nombre);
                datos.setearParametro("@razon", p.RazonSocial);
                datos.setearParametro("@doc", (object)p.Documento ?? DBNull.Value);
                datos.setearParametro("@mail", (object)p.Email ?? DBNull.Value);
                datos.setearParametro("@tel", (object)p.Telefono ?? DBNull.Value);
                datos.setearParametro("@dir", (object)p.Direccion ?? DBNull.Value);
                datos.setearParametro("@loc", (object)p.Localidad ?? DBNull.Value);
                datos.setearParametro("@iva", (object)p.CondicionIVA ?? DBNull.Value);
                datos.setearParametro("@vendeIva", p.VendeConIVA);

                // Parámetros impositivos
                datos.setearParametro("@descHab", p.DescuentoHabitual);
                datos.setearParametro("@porcIva", p.PorcentajeIVA);
                datos.setearParametro("@porcIibb", p.PorcentajeIIBB);
                datos.setearParametro("@porcPerc", p.PorcentajePercepcion);

                datos.ejecutarAccion();
            }
            finally
            {
                datos.CerrarConexion();
            }
        }

        public List<dynamic> ObtenerReporteInflacionAnual()
        {
            var lista = new List<dynamic>();
            var datos = new AccesoDatos();
            try
            {
                datos.setearConsulta(@"
            WITH PreciosExtremos AS (
                SELECT 
                    IdProducto, 
                    Precio,
                    ROW_NUMBER() OVER(PARTITION BY IdProducto ORDER BY Fecha ASC) as Primero,
                    ROW_NUMBER() OVER(PARTITION BY IdProducto ORDER BY Fecha DESC) as Ultimo
                FROM PRECIOS_COMPRA
                WHERE YEAR(Fecha) = YEAR(GETDATE())
            )
            SELECT 
                P.Descripcion,
                C.Nombre as Categoria,
                P_Inicio.Precio as PrecioEne,
                P_Fin.Precio as PrecioHoy,
                ((P_Fin.Precio - P_Inicio.Precio) / NULLIF(P_Inicio.Precio, 0)) * 100 as Porcentaje
            FROM PRODUCTOS P
            INNER JOIN CATEGORIAS C ON P.IdCategoria = C.Id
            INNER JOIN PreciosExtremos P_Inicio ON P.Id = P_Inicio.IdProducto AND P_Inicio.Primero = 1
            INNER JOIN PreciosExtremos P_Fin ON P.Id = P_Fin.IdProducto AND P_Fin.Ultimo = 1
            WHERE P.Activo = 1
            ORDER BY Porcentaje DESC");

                datos.ejecutarLectura();
                while (datos.Lector.Read())
                {
                    lista.Add(new
                    {
                        Producto = datos.Lector["Descripcion"].ToString(),
                        Categoria = datos.Lector["Categoria"].ToString(),
                        PrecioInicial = (decimal)datos.Lector["PrecioEne"],
                        PrecioActual = (decimal)datos.Lector["PrecioHoy"],
                        Porcentaje = (decimal)datos.Lector["Porcentaje"]
                    });
                }
                return lista;
            }
            finally { datos.CerrarConexion(); }
        }

        public void Eliminar(int id)
        {
            var datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("UPDATE PROVEEDORES SET Activo = 0 WHERE Id = @id");
                datos.setearParametro("@id", id);
                datos.ejecutarAccion();
            }
            finally
            {
                datos.CerrarConexion();
            }
        }

        public Proveedor BuscarPorCuit(string cuit)
        {
            var datos = new AccesoDatos();
            try
            {
                datos.setearConsulta(@"
                    SELECT *, VendeConIVA, DescuentoHabitual, PorcentajeIVA, PorcentajeIIBB, PorcentajePercepcion 
                    FROM PROVEEDORES 
                    WHERE Documento = @cuit");
                datos.setearParametro("@cuit", cuit);
                datos.ejecutarLectura();

                if (datos.Lector.Read())
                {
                    return new Proveedor
                    {
                        Id = (int)datos.Lector["Id"],
                        Nombre = datos.Lector["Nombre"].ToString(),
                        RazonSocial = datos.Lector["RazonSocial"].ToString(),
                        Documento = datos.Lector["Documento"].ToString(),
                        Email = datos.Lector["Email"].ToString(),
                        Telefono = datos.Lector["Telefono"].ToString(),
                        Direccion = datos.Lector["Direccion"].ToString(),
                        Localidad = datos.Lector["Localidad"].ToString(),
                        CondicionIVA = datos.Lector["CondicionIVA"].ToString(),
                        Activo = (bool)datos.Lector["Activo"],
                        VendeConIVA = (bool)datos.Lector["VendeConIVA"],

                        DescuentoHabitual = datos.Lector["DescuentoHabitual"] != DBNull.Value ? (decimal)datos.Lector["DescuentoHabitual"] : 0,
                        PorcentajeIVA = datos.Lector["PorcentajeIVA"] != DBNull.Value ? (decimal)datos.Lector["PorcentajeIVA"] : 0,
                        PorcentajeIIBB = datos.Lector["PorcentajeIIBB"] != DBNull.Value ? (decimal)datos.Lector["PorcentajeIIBB"] : 0,
                        PorcentajePercepcion = datos.Lector["PorcentajePercepcion"] != DBNull.Value ? (decimal)datos.Lector["PorcentajePercepcion"] : 0
                    };
                }
                return null;
            }
            finally
            {
                datos.CerrarConexion();
            }
        }
    }
}