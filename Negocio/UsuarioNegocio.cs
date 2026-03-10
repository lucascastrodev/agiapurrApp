using Dominio;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;

namespace Negocio
{
    public class UsuarioNegocio
    {
        public bool RegistrarUsuario(Usuario nuevoUsuario)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                if (string.IsNullOrWhiteSpace(nuevoUsuario.Documento))
                    throw new Exception("El documento es obligatorio.");

                if (ExisteDocumento(nuevoUsuario.Documento))
                    throw new Exception("El documento ya está registrado.");

                if (ExisteUsername(nuevoUsuario.Username))
                    throw new Exception("El nombre de usuario ya está en uso.");

                if (ExisteEmail(nuevoUsuario.Email))
                    throw new Exception("El correo electrónico ya está registrado.");

                // --- INYECTADO OBSERVACIONES ---
                datos.setearConsulta(@"
            INSERT INTO USUARIOS (Nombre, Documento, Email, Telefono, Direccion, Localidad, Username, Password, Activo, Observaciones) 
            VALUES (@Nombre, @Documento, @Email, @Telefono, @Direccion, @Localidad, @Username, @Password, @Activo, @Observaciones);
            SELECT SCOPE_IDENTITY();
        ");

                datos.setearParametro("@Nombre", nuevoUsuario.Nombre);
                datos.setearParametro("@Documento", nuevoUsuario.Documento);
                datos.setearParametro("@Email", nuevoUsuario.Email);
                datos.setearParametro("@Telefono", nuevoUsuario.Telefono);
                datos.setearParametro("@Direccion", nuevoUsuario.Direccion);
                datos.setearParametro("@Localidad", nuevoUsuario.Localidad);
                datos.setearParametro("@Username", nuevoUsuario.Username);
                datos.setearParametro("@Password", nuevoUsuario.Password);
                datos.setearParametro("@Activo", nuevoUsuario.Activo);
                datos.setearParametro("@Observaciones", nuevoUsuario.Observaciones); // NUEVO

                int idUsuario = Convert.ToInt32(datos.EjecutarScalar());

                AsignarRol(idUsuario, 2);

                if (!string.IsNullOrWhiteSpace(nuevoUsuario.Email))
                    EmailService.EnviarBienvenidaUsuario(nuevoUsuario);

                return true;
            }
            catch (SqlException ex)
            {
                if (ex.Number == 2601 || ex.Number == 2627)
                    throw new Exception("El documento ingresado ya está asociado a otro usuario.");

                throw;
            }
            finally
            {
                datos.CerrarConexion();
            }
        }

        public bool ExisteUsername(string username)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("SELECT COUNT(*) FROM USUARIOS WHERE Username = @Username");
                datos.setearParametro("@Username", username);

                int count = Convert.ToInt32(datos.EjecutarScalar());
                return count > 0;
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

        public bool ExisteEmail(string email)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("SELECT COUNT(*) FROM USUARIOS WHERE Email = @Email");
                datos.setearParametro("@Email", email);

                int count = Convert.ToInt32(datos.EjecutarScalar());
                return count > 0;
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

        private void AsignarRol(int idUsuario, int idRol)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("INSERT INTO USUARIO_ROLES (IdUsuario, IdRol) VALUES (@IdUsuario, @IdRol)");
                datos.setearParametro("@IdUsuario", idUsuario);
                datos.setearParametro("@IdRol", idRol);
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

        public Usuario ValidarLogin(string username, string password)
        {
            AccesoDatos datos = new AccesoDatos();
            Usuario usuario = null;

            try
            {
                // --- INYECTADO OBSERVACIONES ---
                datos.setearConsulta(@"
                    SELECT U.Id, U.Nombre, U.Documento, U.Email, U.Telefono, 
                           U.Direccion, U.Localidad, U.Username, U.Activo, U.Observaciones
                    FROM USUARIOS U
                    WHERE U.Username = @Username AND U.Password = @Password");

                datos.setearParametro("@Username", username);
                datos.setearParametro("@Password", password);

                datos.ejecutarLectura();

                if (datos.Lector.Read())
                {
                    usuario = new Usuario
                    {
                        Id = (int)datos.Lector["Id"],
                        Nombre = datos.Lector["Nombre"].ToString(),
                        Documento = datos.Lector["Documento"] != DBNull.Value ? datos.Lector["Documento"].ToString() : null,
                        Email = datos.Lector["Email"].ToString(),
                        Telefono = datos.Lector["Telefono"] != DBNull.Value ? datos.Lector["Telefono"].ToString() : null,
                        Direccion = datos.Lector["Direccion"] != DBNull.Value ? datos.Lector["Direccion"].ToString() : null,
                        Localidad = datos.Lector["Localidad"] != DBNull.Value ? datos.Lector["Localidad"].ToString() : null,
                        Username = datos.Lector["Username"].ToString(),
                        Activo = (bool)datos.Lector["Activo"],
                        Observaciones = datos.Lector["Observaciones"] != DBNull.Value ? datos.Lector["Observaciones"].ToString() : null // NUEVO
                    };

                    usuario.Roles = ObtenerRolesUsuario(usuario.Id);
                }

                return usuario;
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

        public Usuario ObtenerPorEmail(string email)
        {
            AccesoDatos datos = new AccesoDatos();
            Usuario usuario = null;

            try
            {
                // --- INYECTADO OBSERVACIONES ---
                datos.setearConsulta(@"
                    SELECT Id, Nombre, Documento, Email, Telefono, 
                           Direccion, Localidad, Username, Password, Activo, Observaciones
                    FROM USUARIOS
                    WHERE Email = @Email AND Activo = 1");

                datos.setearParametro("@Email", email);
                datos.ejecutarLectura();

                if (datos.Lector.Read())
                {
                    usuario = new Usuario
                    {
                        Id = (int)datos.Lector["Id"],
                        Nombre = datos.Lector["Nombre"] as string,
                        Documento = datos.Lector["Documento"] as string,
                        Email = datos.Lector["Email"] as string,
                        Telefono = datos.Lector["Telefono"] as string,
                        Direccion = datos.Lector["Direccion"] as string,
                        Localidad = datos.Lector["Localidad"] as string,
                        Username = datos.Lector["Username"] as string,
                        Password = datos.Lector["Password"] as string,
                        Activo = (bool)datos.Lector["Activo"],
                        Observaciones = datos.Lector["Observaciones"] as string // NUEVO
                    };

                    usuario.Roles = ObtenerRolesUsuario(usuario.Id);
                }

                return usuario;
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

        public bool RestablecerPasswordPorEmail(string email, string nuevaPassword)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("UPDATE USUARIOS SET Password = @Password WHERE Email = @Email AND Activo = 1");
                datos.setearParametro("@Password", nuevaPassword);
                datos.setearParametro("@Email", email);

                datos.ejecutarAccion();

                return true;
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

        private List<UsuarioRol> ObtenerRolesUsuario(int idUsuario)
        {
            AccesoDatos datos = new AccesoDatos();
            List<UsuarioRol> roles = new List<UsuarioRol>();

            try
            {
                datos.setearConsulta(@"
            SELECT R.Id, R.Descripcion 
            FROM ROLES R
            INNER JOIN USUARIO_ROLES UR ON R.Id = UR.IdRol
            WHERE UR.IdUsuario = @IdUsuario");

                datos.setearParametro("@IdUsuario", idUsuario);
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    UsuarioRol rol = new UsuarioRol
                    {
                        Id = (int)datos.Lector["Id"],
                        Nombre = datos.Lector["Descripcion"].ToString()
                    };
                    roles.Add(rol);
                }

                return roles;
            }
            finally
            {
                datos.CerrarConexion();
            }
        }

        public bool ActualizarUsuario(Usuario usuario)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                // Usamos un solo bloque de consulta para actualizar AMBAS tablas al mismo tiempo.
                // Si el usuario también existe como cliente (coinciden por Documento), se sincronizan sus datos de envío.
                datos.setearConsulta(@"
            UPDATE USUARIOS 
            SET Nombre = @Nombre, 
                Documento = @Documento, 
                Email = @Email, 
                Telefono = @Telefono, 
                Direccion = @Direccion, 
                Localidad = @Localidad,
                Observaciones = @Observaciones
            WHERE Id = @Id;

            UPDATE CLIENTES 
            SET Nombre = @Nombre, 
                Email = @Email, 
                Telefono = @Telefono, 
                Direccion = @Direccion, 
                Localidad = @Localidad,
                Observaciones = @Observaciones
            WHERE Documento = @Documento 
              AND Documento IS NOT NULL 
              AND LTRIM(RTRIM(Documento)) <> '';
        ");

                // Pasamos los parámetros una sola vez y sirven para los dos UPDATE
                datos.setearParametro("@Nombre", usuario.Nombre);
                datos.setearParametro("@Documento", usuario.Documento);
                datos.setearParametro("@Email", usuario.Email);
                datos.setearParametro("@Telefono", usuario.Telefono);
                datos.setearParametro("@Direccion", usuario.Direccion);
                datos.setearParametro("@Localidad", usuario.Localidad);
                datos.setearParametro("@Observaciones", usuario.Observaciones);
                datos.setearParametro("@Id", usuario.Id);

                datos.ejecutarAccion();

                return true;
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

        public bool CambiarPassword(int idUsuario, string nuevaPassword)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("UPDATE USUARIOS SET Password = @Password WHERE Id = @Id");
                datos.setearParametro("@Password", nuevaPassword);
                datos.setearParametro("@Id", idUsuario);

                datos.ejecutarAccion();

                return true;
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

        public List<Usuario> ListarUsuarios(string q = null)
        {
            var lista = new List<Usuario>();
            var datos = new AccesoDatos();

            try
            {
                // --- INYECTADO OBSERVACIONES ---
                string query = @"
                    SELECT 
                        U.Id, U.Nombre, U.Documento, U.Email, U.Telefono,
                        U.Direccion, U.Localidad, U.Username, U.Password, U.Activo, U.Observaciones,
                        R.Id AS IdRol,
                        R.Descripcion AS RolDescripcion
                    FROM USUARIOS U
                    INNER JOIN USUARIO_ROLES UR ON UR.IdUsuario = U.Id
                    INNER JOIN ROLES R ON R.Id = UR.IdRol
                    WHERE 1 = 1";

                if (!string.IsNullOrWhiteSpace(q))
                {
                    query += @"
                        AND (
                            U.Nombre LIKE @q OR 
                            U.Email LIKE @q OR
                            U.Username LIKE @q
                        )";
                }

                datos.setearConsulta(query);

                if (!string.IsNullOrWhiteSpace(q))
                    datos.setearParametro("@q", "%" + q + "%");

                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Usuario u = new Usuario
                    {
                        Id = (int)datos.Lector["Id"],
                        Nombre = datos.Lector["Nombre"] as string,
                        Documento = datos.Lector["Documento"] as string,
                        Email = (string)datos.Lector["Email"],
                        Telefono = datos.Lector["Telefono"] as string,
                        Direccion = datos.Lector["Direccion"] as string,
                        Localidad = datos.Lector["Localidad"] as string,
                        Username = (string)datos.Lector["Username"],
                        Password = (string)datos.Lector["Password"],
                        Activo = (bool)datos.Lector["Activo"],
                        Observaciones = datos.Lector["Observaciones"] as string // NUEVO
                    };

                    var rol = new UsuarioRol
                    {
                        Id = (int)datos.Lector["IdRol"],
                        Nombre = (string)datos.Lector["RolDescripcion"]
                    };

                    u.Roles.Add(rol);

                    lista.Add(u);
                }

                return lista;
            }
            finally
            {
                datos.CerrarConexion();
            }
        }

        public void HacerAdmin(int idUsuario)
        {
            var datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("UPDATE USUARIO_ROLES SET IdRol = 1 WHERE IdUsuario = @id");
                datos.setearParametro("@id", idUsuario);
                datos.ejecutarAccion();
            }
            finally
            {
                datos.CerrarConexion();
            }
        }

        public void HacerVendedor(int idUsuario)
        {
            var datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("UPDATE USUARIO_ROLES SET IdRol = 2 WHERE IdUsuario = @id");
                datos.setearParametro("@id", idUsuario);
                datos.ejecutarAccion();
            }
            finally
            {
                datos.CerrarConexion();
            }
        }

        public Usuario ObtenerUsuarioPorId(int idUsuario)
        {
            var datos = new AccesoDatos();
            Usuario usuario = null;

            try
            {
                datos.setearConsulta("SELECT * FROM USUARIOS WHERE Id = @id");
                datos.setearParametro("@id", idUsuario);
                datos.ejecutarLectura();

                if (datos.Lector.Read())
                {
                    usuario = new Usuario
                    {
                        Id = (int)datos.Lector["Id"],
                        Nombre = datos.Lector["Nombre"] as string,
                        Documento = datos.Lector["Documento"] as string,
                        Email = datos.Lector["Email"] as string,
                        Telefono = datos.Lector["Telefono"] as string,
                        Direccion = datos.Lector["Direccion"] as string,
                        Localidad = datos.Lector["Localidad"] as string,
                        Username = datos.Lector["Username"] as string,
                        Password = datos.Lector["Password"] as string,
                        Activo = (bool)datos.Lector["Activo"],
                        Observaciones = datos.Lector["Observaciones"] as string // NUEVO
                    };
                }

                if (usuario != null)
                    usuario.Roles = ObtenerRolesUsuario(usuario.Id);

                return usuario;
            }
            finally
            {
                datos.CerrarConexion();
            }
        }

        public void DeshabilitarUsuario(int idUsuario)
        {
            var datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("UPDATE USUARIOS SET Activo = 0 WHERE Id = @id");
                datos.setearParametro("@id", idUsuario);
                datos.ejecutarAccion();
            }
            finally
            {
                datos.CerrarConexion();
            }
        }

        public void HabilitarUsuario(int idUsuario)
        {
            var datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("UPDATE USUARIOS SET Activo = 1 WHERE Id = @id");
                datos.setearParametro("@id", idUsuario);
                datos.ejecutarAccion();
            }
            finally
            {
                datos.CerrarConexion();
            }
        }

        public bool ExisteDocumento(string documento)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("SELECT COUNT(*) FROM USUARIOS WHERE Documento = @doc");
                datos.setearParametro("@doc", documento);

                int count = (int)datos.EjecutarScalar();
                return count > 0;
            }
            finally
            {
                datos.CerrarConexion();
            }
        }

    }
}