using System;
using System.Collections.Generic;
using Dominio;

namespace Negocio
{
    public class CategoriaNegocio
    {
        public List<Categoria> Listar(string q = null)
        {
            var lista = new List<Categoria>();
            var datos = new AccesoDatos();

            try
            {
                string consulta = @"
                    SELECT Id, Nombre
                    FROM CATEGORIAS WHERE Activo = 1";

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
                    lista.Add(new Categoria
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

        public Categoria ObtenerPorId(int id)
        {
            var datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("SELECT Id, Nombre FROM CATEGORIAS WHERE Id = @id");
                datos.setearParametro("@id", id);
                datos.ejecutarLectura();

                if (datos.Lector.Read())
                {
                    return new Categoria
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

        public void Guardar(Categoria categoria)
        {
            var datos = new AccesoDatos();
            try
            {
                if (categoria.Id == 0)
                {
                    datos.setearConsulta(@"
                        INSERT INTO CATEGORIAS (Nombre)
                        VALUES (@nombre)");
                }
                else
                {
                    datos.setearConsulta(@"
                        UPDATE CATEGORIAS SET Nombre = @nombre
                        WHERE Id = @id");
                    datos.setearParametro("@id", categoria.Id);
                }

                datos.setearParametro("@nombre", categoria.Nombre);
                datos.ejecutarAccion();
            }
            finally
            {
                datos.CerrarConexion();
            }
        }

       
        public void Agregar(Categoria categoria)
        {
            Guardar(categoria);
        }

        public void Modificar(Categoria categoria)
        {
            Guardar(categoria);
        }

        public void Eliminar(int id)
        {
            var datos = new AccesoDatos();
            try
            {

                datos.setearConsulta("UPDATE CATEGORIAS SET Activo = 0 WHERE Id = @id");

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
