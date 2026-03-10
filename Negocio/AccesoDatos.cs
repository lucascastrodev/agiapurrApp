using System;
using System.Data.SqlClient;

namespace Negocio
{
    public class AccesoDatos
    {
        public SqlConnection conexion;
        public SqlCommand comando;
        public SqlDataReader lector;

        public SqlDataReader Lector => lector;

        public AccesoDatos()
        {
            conexion = new SqlConnection(@"Server=(LocalDB)\MSSQLLocalDB; database=COMERCIO_DB; integrated security=true");
            comando = new SqlCommand();
        }

        public void LimpiarParametros()
        {
            comando.Parameters.Clear();
        }
        public void setearConsulta(string consulta)
        {
            comando.Parameters.Clear();
            comando.CommandType = System.Data.CommandType.Text;
            comando.CommandText = consulta;
        }

        public void setearParametro(string nombre, object valor)
        {
            comando.Parameters.AddWithValue(nombre, valor ?? DBNull.Value);
        }

        public void ejecutarLectura()
        {
            comando.Connection = conexion;
            try
            {
                conexion.Open();
                lector = comando.ExecuteReader();
            }
            catch (Exception)
            {
                throw;
            }
        }

        public void ejecutarAccion()
        {
            comando.Connection = conexion;
            try
            {
                conexion.Open();
                comando.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                conexion.Close();
            }
        }

        public object EjecutarScalar()
        {
            comando.Connection = conexion;
            object resultado = null;
            try
            {
                conexion.Open();
                resultado = comando.ExecuteScalar();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                conexion.Close();
            }
            return resultado;
        }

        public void CerrarConexion()
        {
            if (lector != null) lector.Close();
            conexion.Close();
        }
    }
}
