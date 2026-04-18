using Dominio;
using System;
using System.Collections.Generic;

namespace Negocio
{
    public class ProductoProveedorNegocio
    {
        public List<ProductoProveedor> ListarPorProveedor(int idProveedor)
        {
            List<ProductoProveedor> lista = new List<ProductoProveedor>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("SELECT Id, IdProveedor, Codigo, Descripcion, IdMarca, PrecioUnitario, Estado, UnidadesPorPack, PorcentajeDescuento FROM PRODUCTOS_PROVEEDOR WHERE IdProveedor = @idProv AND Estado = 1");
                datos.setearParametro("@idProv", idProveedor);
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    ProductoProveedor aux = new ProductoProveedor();
                    aux.Id = (int)datos.Lector["Id"];
                    aux.Codigo = (string)datos.Lector["Codigo"];
                    aux.Descripcion = (string)datos.Lector["Descripcion"];
                    aux.PrecioUnitario = (decimal)datos.Lector["PrecioUnitario"];
                    aux.Estado = (bool)datos.Lector["Estado"];
                    aux.UnidadesPorPack = datos.Lector["UnidadesPorPack"] != DBNull.Value ? (int)datos.Lector["UnidadesPorPack"] : 1;
                    aux.PorcentajeDescuento = datos.Lector["PorcentajeDescuento"] != DBNull.Value ? (decimal)datos.Lector["PorcentajeDescuento"] : 0;

                    aux.Proveedor = new Proveedor();
                    aux.Proveedor.Id = (int)datos.Lector["IdProveedor"];

                    aux.Marca = new Marca();
                    if (!(datos.Lector["IdMarca"] is DBNull))
                    {
                        aux.Marca.Id = (int)datos.Lector["IdMarca"];
                    }

                    lista.Add(aux);
                }
                return lista;
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

        public ProductoProveedor ObtenerPorId(int id)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {

                datos.setearConsulta("SELECT Id, IdProveedor, Codigo, Descripcion, IdMarca, PrecioUnitario, Estado, UnidadesPorPack, PorcentajeDescuento FROM PRODUCTOS_PROVEEDOR WHERE Id = @id");
                datos.setearParametro("@id", id);
                datos.ejecutarLectura();

                if (datos.Lector.Read())
                {
                    ProductoProveedor aux = new ProductoProveedor();
                    aux.Id = (int)datos.Lector["Id"];
                    aux.Codigo = (string)datos.Lector["Codigo"];
                    aux.Descripcion = (string)datos.Lector["Descripcion"];
                    aux.PrecioUnitario = (decimal)datos.Lector["PrecioUnitario"];
                    aux.Estado = (bool)datos.Lector["Estado"];
                    aux.UnidadesPorPack = datos.Lector["UnidadesPorPack"] != DBNull.Value ? (int)datos.Lector["UnidadesPorPack"] : 1;

                    // Nueva lectura: Mapeo del Descuento
                    aux.PorcentajeDescuento = datos.Lector["PorcentajeDescuento"] != DBNull.Value ? (decimal)datos.Lector["PorcentajeDescuento"] : 0;

                    aux.Proveedor = new Proveedor();
                    aux.Proveedor.Id = (int)datos.Lector["IdProveedor"];

                    aux.Marca = new Marca();
                    if (!(datos.Lector["IdMarca"] is DBNull))
                    {
                        aux.Marca.Id = (int)datos.Lector["IdMarca"];
                    }

                    return aux;
                }
                return null;
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
        // --- MÓDULO DE ACTUALIZACIÓN MASIVA ---
        public void ActualizarDescuentoMasivo(int idProveedor, string palabraClave, bool contienePalabra, decimal nuevoDescuento)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                // Armamos el condicional (LIKE o NOT LIKE) según lo que eligió el usuario
                string operador = contienePalabra ? "LIKE" : "NOT LIKE";
                
                // Aplicamos el descuento solo a los productos de ESTE proveedor que cumplan la regla
                string consulta = $"UPDATE PRODUCTOS_PROVEEDOR SET PorcentajeDescuento = @desc WHERE IdProveedor = @idProv AND Descripcion {operador} @palabra";

                datos.setearConsulta(consulta);
                datos.setearParametro("@desc", nuevoDescuento);
                datos.setearParametro("@idProv", idProveedor);
                datos.setearParametro("@palabra", "%" + palabraClave.Trim() + "%");

                datos.ejecutarAccion();
            }
            finally
            {
                datos.CerrarConexion();
            }
        }
    }
}