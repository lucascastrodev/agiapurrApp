using System;
using System.Linq;
using Dominio;
using Negocio;

namespace TPC_Equipo20B
{
    public partial class Perfil : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarDatosUsuario();
            }
        }

        private void CargarDatosUsuario()
        {
            if (Session["Usuario"] != null)
            {
                Usuario usuario = (Usuario)Session["Usuario"];

                // Cargar datos en los controles
                txtNombre.Text = usuario.Nombre;
                txtDocumento.Text = usuario.Documento;
                txtEmail.Text = usuario.Email;
                txtTelefono.Text = usuario.Telefono;
                txtDireccion.Text = usuario.Direccion;
                txtLocalidad.Text = usuario.Localidad;
                txtUsername.Text = usuario.Username;

                // Mostrar rol(es)
                if (usuario.Roles != null && usuario.Roles.Count > 0)
                {
                    txtRol.Text = string.Join(", ", usuario.Roles.Select(r => r.Nombre));
                }

                // Información de la cuenta
                lblUsuarioId.Text = usuario.Id.ToString();
            }
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            try
            {
                Usuario usuario = (Usuario)Session["Usuario"];

                // Actualizar datos del usuario
                usuario.Nombre = txtNombre.Text.Trim();
                usuario.Documento = string.IsNullOrWhiteSpace(txtDocumento.Text) ? null : txtDocumento.Text.Trim();
                usuario.Email = txtEmail.Text.Trim();
                usuario.Telefono = string.IsNullOrWhiteSpace(txtTelefono.Text) ? null : txtTelefono.Text.Trim();
                usuario.Direccion = string.IsNullOrWhiteSpace(txtDireccion.Text) ? null : txtDireccion.Text.Trim();
                usuario.Localidad = string.IsNullOrWhiteSpace(txtLocalidad.Text) ? null : txtLocalidad.Text.Trim();

                // Guardar en la base de datos
                UsuarioNegocio negocio = new UsuarioNegocio();
                bool actualizado = negocio.ActualizarUsuario(usuario);

                if (actualizado)
                {
                    // Actualizar sesión
                    Session["Usuario"] = usuario;
                    Session["UsuarioNombre"] = usuario.Nombre;

                    lblMensaje.Text = "<div class='alert alert-success'>Perfil actualizado correctamente</div>";
                }
                else
                {
                    lblMensaje.Text = "<div class='alert alert-danger'>Error al actualizar el perfil</div>";
                }
            }
            catch (Exception ex)
            {
                lblMensaje.Text = $"<div class='alert alert-danger'>Error: {ex.Message}</div>";
            }
        }

        protected void btnCancelar_Click(object sender, EventArgs e)
        {
            // Recargar los datos originales
            CargarDatosUsuario();
            lblMensaje.Text = "<div class='alert alert-info'>Cambios cancelados</div>";
        }

        protected void btnCambiarPassword_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            try
            {
                Usuario usuario = (Usuario)Session["Usuario"];
                UsuarioNegocio negocio = new UsuarioNegocio();

                // Validar que la contraseña actual sea correcta
                Usuario validacion = negocio.ValidarLogin(usuario.Username, txtPasswordActual.Text);

                if (validacion == null)
                {
                    lblMensajePassword.Text = "<div class='alert alert-danger'>La contraseña actual es incorrecta</div>";
                    return;
                }

                // Actualizar la contraseña
                bool actualizado = negocio.CambiarPassword(usuario.Id, txtPasswordNueva.Text);

                if (actualizado)
                {
                    lblMensajePassword.Text = "<div class='alert alert-success'>Contraseña actualizada correctamente</div>";

                    // Limpiar campos
                    txtPasswordActual.Text = "";
                    txtPasswordNueva.Text = "";
                    txtPasswordConfirmar.Text = "";
                }
                else
                {
                    lblMensajePassword.Text = "<div class='alert alert-danger'>Error al actualizar la contraseña</div>";
                }
            }
            catch (Exception ex)
            {
                lblMensajePassword.Text = $"<div class='alert alert-danger'>Error: {ex.Message}</div>";
            }
        }
    }
}