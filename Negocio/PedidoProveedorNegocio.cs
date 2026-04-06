using Dominio;
using System;
using System.Collections.Generic;

namespace Negocio
{
    public class PedidoProveedorNegocio
    {
        public void Generar(PedidoProveedor pedido)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta(
                    "INSERT INTO PEDIDOS_PROVEEDOR (IdProveedor, IdUsuario, FechaEmision, TotalEstimado, Estado, SubtotalBruto, DescuentoPorcentaje, DescuentoMonto, SubtotalNeto, MontoIVA, MontoIIBB, MontoPercepcion) " +
                    "OUTPUT INSERTED.Id VALUES (@idProv, @idUsu, @fecha, @total, @est, @subBruto, @descPorc, @descMonto, @subNeto, @montoIva, @montoIibb, @montoPerc)");

                datos.setearParametro("@idProv", pedido.Proveedor.Id);
                datos.setearParametro("@idUsu", pedido.Usuario.Id);
                datos.setearParametro("@fecha", pedido.FechaEmision);
                datos.setearParametro("@total", pedido.TotalEstimado);
                datos.setearParametro("@est", pedido.Estado);

                // Nuevos parámetros matemáticos
                datos.setearParametro("@subBruto", pedido.SubtotalBruto);
                datos.setearParametro("@descPorc", pedido.DescuentoPorcentaje);
                datos.setearParametro("@descMonto", pedido.DescuentoMonto);
                datos.setearParametro("@subNeto", pedido.SubtotalNeto);
                datos.setearParametro("@montoIva", pedido.MontoIVA);
                datos.setearParametro("@montoIibb", pedido.MontoIIBB);
                datos.setearParametro("@montoPerc", pedido.MontoPercepcion);

                int idPedido = Convert.ToInt32(datos.EjecutarScalar());
                datos.LimpiarParametros();

                foreach (var linea in pedido.Lineas)
                {
                    datos.setearConsulta(@"
                INSERT INTO PEDIDOS_PROVEEDOR_DETALLE (IdPedido, IdProductoProveedor, Cantidad, PrecioUnitario, Subtotal)
                VALUES (@idPed, @idProdProv, @cant, @precio, @subt)");

                    datos.setearParametro("@idPed", idPedido);
                    datos.setearParametro("@idProdProv", linea.Producto.Id);
                    datos.setearParametro("@cant", linea.Cantidad);
                    datos.setearParametro("@precio", linea.PrecioUnitario);
                    datos.setearParametro("@subt", linea.Subtotal);

                    datos.ejecutarAccion();
                    datos.LimpiarParametros();
                }
            }
            finally { datos.CerrarConexion(); }
        }

        public List<PedidoProveedor> Listar(string q = null)
        {
            List<PedidoProveedor> lista = new List<PedidoProveedor>();
            AccesoDatos datos = new AccesoDatos();
            try
            {
                string consulta = @"
            SELECT P.Id, P.FechaEmision, P.TotalEstimado, P.Estado, 
                   P.SubtotalBruto, P.DescuentoPorcentaje, P.DescuentoMonto, P.SubtotalNeto, P.MontoIVA, P.MontoIIBB, P.MontoPercepcion,
                   P.IdProveedor, PR.Nombre AS NombreProveedor, 
                   P.IdUsuario, U.Nombre AS NombreUsuario
            FROM PEDIDOS_PROVEEDOR P
            INNER JOIN PROVEEDORES PR ON P.IdProveedor = PR.Id
            INNER JOIN USUARIOS U ON P.IdUsuario = U.Id
        ";

                if (!string.IsNullOrWhiteSpace(q))
                {
                    consulta += " WHERE PR.Nombre LIKE @q OR U.Nombre LIKE @q OR P.Estado LIKE @q";
                }

                consulta += " ORDER BY P.FechaEmision DESC;";

                datos.setearConsulta(consulta);

                if (!string.IsNullOrWhiteSpace(q))
                    datos.setearParametro("@q", "%" + q + "%");

                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    PedidoProveedor pedido = new PedidoProveedor
                    {
                        Id = (int)datos.Lector["Id"],
                        FechaEmision = (DateTime)datos.Lector["FechaEmision"],
                        TotalEstimado = (decimal)datos.Lector["TotalEstimado"],
                        Estado = datos.Lector["Estado"].ToString(),

                        SubtotalBruto = datos.Lector["SubtotalBruto"] != DBNull.Value ? (decimal)datos.Lector["SubtotalBruto"] : 0,
                        DescuentoPorcentaje = datos.Lector["DescuentoPorcentaje"] != DBNull.Value ? (decimal)datos.Lector["DescuentoPorcentaje"] : 0,
                        DescuentoMonto = datos.Lector["DescuentoMonto"] != DBNull.Value ? (decimal)datos.Lector["DescuentoMonto"] : 0,
                        SubtotalNeto = datos.Lector["SubtotalNeto"] != DBNull.Value ? (decimal)datos.Lector["SubtotalNeto"] : 0,
                        MontoIVA = datos.Lector["MontoIVA"] != DBNull.Value ? (decimal)datos.Lector["MontoIVA"] : 0,
                        MontoIIBB = datos.Lector["MontoIIBB"] != DBNull.Value ? (decimal)datos.Lector["MontoIIBB"] : 0,
                        MontoPercepcion = datos.Lector["MontoPercepcion"] != DBNull.Value ? (decimal)datos.Lector["MontoPercepcion"] : 0,

                        Proveedor = new Proveedor
                        {
                            Id = (int)datos.Lector["IdProveedor"],
                            Nombre = datos.Lector["NombreProveedor"].ToString()
                        },
                        Usuario = new Usuario
                        {
                            Id = (int)datos.Lector["IdUsuario"],
                            Nombre = datos.Lector["NombreUsuario"].ToString()
                        }
                    };
                    lista.Add(pedido);
                }
                return lista;
            }
            finally { datos.CerrarConexion(); }
        }

        public PedidoProveedor ObtenerPorId(int idPedido)
        {
            PedidoProveedor pedido = new PedidoProveedor();
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta(@"
                    SELECT P.Id, P.IdProveedor, PR.Nombre AS NombreProveedor, 
                           P.IdUsuario, U.Nombre AS NombreUsuario, 
                           P.FechaEmision, P.TotalEstimado, P.Estado,
                           P.SubtotalBruto, P.DescuentoPorcentaje, P.DescuentoMonto, P.SubtotalNeto, P.MontoIVA, P.MontoIIBB, P.MontoPercepcion
                    FROM PEDIDOS_PROVEEDOR P
                    INNER JOIN PROVEEDORES PR ON P.IdProveedor = PR.Id
                    INNER JOIN USUARIOS U ON P.IdUsuario = U.Id
                    WHERE P.Id = @id");

                datos.setearParametro("@id", idPedido);
                datos.ejecutarLectura();

                if (datos.Lector.Read())
                {
                    pedido.Id = (int)datos.Lector["Id"];

                    pedido.Proveedor.Id = (int)datos.Lector["IdProveedor"];
                    pedido.Proveedor.Nombre = (string)datos.Lector["NombreProveedor"];

                    pedido.Usuario.Id = (int)datos.Lector["IdUsuario"];
                    pedido.Usuario.Nombre = (string)datos.Lector["NombreUsuario"];

                    pedido.FechaEmision = (DateTime)datos.Lector["FechaEmision"];
                    pedido.TotalEstimado = (decimal)datos.Lector["TotalEstimado"];
                    pedido.Estado = (string)datos.Lector["Estado"];

                    pedido.SubtotalBruto = datos.Lector["SubtotalBruto"] != DBNull.Value ? (decimal)datos.Lector["SubtotalBruto"] : 0;
                    pedido.DescuentoPorcentaje = datos.Lector["DescuentoPorcentaje"] != DBNull.Value ? (decimal)datos.Lector["DescuentoPorcentaje"] : 0;
                    pedido.DescuentoMonto = datos.Lector["DescuentoMonto"] != DBNull.Value ? (decimal)datos.Lector["DescuentoMonto"] : 0;
                    pedido.SubtotalNeto = datos.Lector["SubtotalNeto"] != DBNull.Value ? (decimal)datos.Lector["SubtotalNeto"] : 0;
                    pedido.MontoIVA = datos.Lector["MontoIVA"] != DBNull.Value ? (decimal)datos.Lector["MontoIVA"] : 0;
                    pedido.MontoIIBB = datos.Lector["MontoIIBB"] != DBNull.Value ? (decimal)datos.Lector["MontoIIBB"] : 0;
                    pedido.MontoPercepcion = datos.Lector["MontoPercepcion"] != DBNull.Value ? (decimal)datos.Lector["MontoPercepcion"] : 0;
                }
                datos.CerrarConexion();

                datos = new AccesoDatos();
                datos.setearConsulta(@"
            SELECT D.Id, D.IdProductoProveedor, D.Cantidad, D.PrecioUnitario, D.Subtotal, 
                   P.Codigo, P.Descripcion, P.UnidadesPorPack 
            FROM PEDIDOS_PROVEEDOR_DETALLE D
            INNER JOIN PRODUCTOS_PROVEEDOR P ON D.IdProductoProveedor = P.Id
            WHERE D.IdPedido = @idPed");

                datos.setearParametro("@idPed", idPedido);
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    PedidoProveedorLinea linea = new PedidoProveedorLinea();
                    linea.Id = (int)datos.Lector["Id"];
                    linea.Cantidad = (int)datos.Lector["Cantidad"];
                    linea.PrecioUnitario = (decimal)datos.Lector["PrecioUnitario"];
                    linea.Producto.Id = (int)datos.Lector["IdProductoProveedor"];
                    linea.Producto.Codigo = (string)datos.Lector["Codigo"];
                    linea.Producto.Descripcion = (string)datos.Lector["Descripcion"];
                    linea.Producto.UnidadesPorPack = datos.Lector["UnidadesPorPack"] != DBNull.Value ? (int)datos.Lector["UnidadesPorPack"] : 1;

                    pedido.Lineas.Add(linea);
                }
                return pedido;
            }
            finally { datos.CerrarConexion(); }
        }

        public void Modificar(PedidoProveedor pedido)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta(
                    @"UPDATE PEDIDOS_PROVEEDOR SET 
                        IdProveedor = @idProv, FechaEmision = @fecha, TotalEstimado = @total,
                        SubtotalBruto = @subBruto, DescuentoPorcentaje = @descPorc, DescuentoMonto = @descMonto,
                        SubtotalNeto = @subNeto, MontoIVA = @montoIva, MontoIIBB = @montoIibb, MontoPercepcion = @montoPerc
                      WHERE Id = @id");

                datos.setearParametro("@idProv", pedido.Proveedor.Id);
                datos.setearParametro("@fecha", pedido.FechaEmision);
                datos.setearParametro("@total", pedido.TotalEstimado);
                datos.setearParametro("@subBruto", pedido.SubtotalBruto);
                datos.setearParametro("@descPorc", pedido.DescuentoPorcentaje);
                datos.setearParametro("@descMonto", pedido.DescuentoMonto);
                datos.setearParametro("@subNeto", pedido.SubtotalNeto);
                datos.setearParametro("@montoIva", pedido.MontoIVA);
                datos.setearParametro("@montoIibb", pedido.MontoIIBB);
                datos.setearParametro("@montoPerc", pedido.MontoPercepcion);
                datos.setearParametro("@id", pedido.Id);

                datos.ejecutarAccion();
                datos.LimpiarParametros();

                datos.setearConsulta("DELETE FROM PEDIDOS_PROVEEDOR_DETALLE WHERE IdPedido = @id");
                datos.setearParametro("@id", pedido.Id);
                datos.ejecutarAccion();
                datos.LimpiarParametros();

                foreach (var linea in pedido.Lineas)
                {
                    datos.setearConsulta(@"
                INSERT INTO PEDIDOS_PROVEEDOR_DETALLE (IdPedido, IdProductoProveedor, Cantidad, PrecioUnitario, Subtotal)
                VALUES (@idPed, @idProdProv, @cant, @precio, @subt)");

                    datos.setearParametro("@idPed", pedido.Id);
                    datos.setearParametro("@idProdProv", linea.Producto.Id);
                    datos.setearParametro("@cant", linea.Cantidad);
                    datos.setearParametro("@precio", linea.PrecioUnitario);
                    datos.setearParametro("@subt", linea.Subtotal);

                    datos.ejecutarAccion();
                    datos.LimpiarParametros();
                }
            }
            finally { datos.CerrarConexion(); }
        }

        public void Cancelar(int idPedido, string motivo)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("UPDATE PEDIDOS_PROVEEDOR SET Estado = 'Cancelado' WHERE Id = @id");
                datos.setearParametro("@id", idPedido);
                datos.ejecutarAccion();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                datos.CerrarConexion();
            }
        }
    }
}