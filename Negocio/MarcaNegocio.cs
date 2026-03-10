using System;
using System.Collections.Generic;
using Dominio;

namespace Negocio
{
    public class MarcaNegocio
    {
        public List<Marca> Listar(string q = null)
        {
            var lista = new List<Marca>();
            var datos = new AccesoDatos();

            try
            {
                string consulta = @"
                    SELECT Id, Nombre
                    FROM MARCAS WHERE Activo = 1";


                if (!string.IsNullOrWhiteSpace(q))
                {

                    consulta += " AND Nombre LIKE @q";
                }

                consulta += " ORDER BY Nombre";

                datos.setearConsulta(consulta);

                if (!string.IsNullOrWhiteSpace(q))
                    datos.setearParametro("@q", "%" + q + "%");

                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    lista.Add(new Marca
                    {
                        Id = (int)datos.Lector["Id"],
                        Nombre = datos.Lector["Nombre"]?.ToString() ?? ""
                    });
                }

                return lista;
            }
            finally
            {
                datos.CerrarConexion();
            }
        }

        public Marca ObtenerPorId(int id)
        {
            var datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("SELECT Id, Nombre FROM MARCAS WHERE Id = @id");
                datos.setearParametro("@id", id);
                datos.ejecutarLectura();

                if (datos.Lector.Read())
                {
                    return new Marca
                    {
                        Id = (int)datos.Lector["Id"],
                        Nombre = datos.Lector["Nombre"]?.ToString() ?? ""
                    };
                }

                return null;
            }
            finally
            {
                datos.CerrarConexion();
            }
        }

        public void Guardar(Marca marca)
        {
            var datos = new AccesoDatos();
            try
            {
                if (marca.Id == 0)
                {
                    datos.setearConsulta(@"
                        INSERT INTO MARCAS (Nombre)
                        VALUES (@nombre)");
                }
                else
                {
                    datos.setearConsulta(@"
                        UPDATE MARCAS SET Nombre = @nombre
                        WHERE Id = @id");
                    datos.setearParametro("@id", marca.Id);
                }

                datos.setearParametro("@nombre", marca.Nombre);
                datos.ejecutarAccion();
            }
            finally
            {
                datos.CerrarConexion();
            }
        }


        public void Agregar(Marca marca)
        {
            Guardar(marca);
        }

        public void Modificar(Marca marca)
        {
            Guardar(marca);
        }

        public void Eliminar(int id)
        {
            var datos = new AccesoDatos();
            try
            {
               
                datos.setearConsulta("UPDATE MARCAS SET Activo = 0 WHERE Id = @id");

                datos.setearParametro("@id", id);
                datos.ejecutarAccion();
            }
            finally
            {
                datos.CerrarConexion();
            }
        }
    }
}
