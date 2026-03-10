using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Dominio;

namespace Negocio
{
    public class CompraLineaNegocio
    {
        public List<CompraLinea> ListarPorCompra(int idCompra)
        {
            List<CompraLinea> lista = new List<CompraLinea>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta(@"
                    SELECT CL.Id, CL.IdCompra, CL.IdProducto, CL.Cantidad, CL.PrecioUnitario,
                           P.Descripcion
                    FROM COMPRA_LINEAS CL
                    INNER JOIN PRODUCTOS P ON P.Id = CL.IdProducto
                    WHERE CL.IdCompra = @idCompra");
                datos.setearParametro("@idCompra", idCompra);
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    CompraLinea linea = new CompraLinea();
                    linea.Id = (int)datos.Lector["Id"];
                    linea.Producto = new Producto
                    {
                        Id = (int)datos.Lector["IdProducto"],
                        Descripcion = (string)datos.Lector["Descripcion"]
                    };
                    linea.Cantidad = Convert.ToInt32(datos.Lector["Cantidad"]);
                    linea.PrecioUnitario = Convert.ToDecimal(datos.Lector["PrecioUnitario"]);
                    lista.Add(linea);
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
    }
}

