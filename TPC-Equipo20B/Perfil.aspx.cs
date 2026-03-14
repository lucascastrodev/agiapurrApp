using System;
using System.Linq;
using System.Web.UI;
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

                // Cargar la nueva propiedad Observaciones
                txtObservaciones.Text = usuario.Observaciones;

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
            // Cerramos forzosamente el modal de pregunta para que no quede tildado en pantalla
            ScriptManager.RegisterStartupScript(this, this.GetType(), "PopCerrar", "cerrarModalSeguridad();", true);

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

                // Guardar las observaciones
                usuario.Observaciones = txtObservaciones.Text.Trim();

                // Guardar en la base de datos
                UsuarioNegocio negocio = new UsuarioNegocio();
                bool actualizado = negocio.ActualizarUsuario(usuario);

                if (actualizado)
                {
                    // Actualizar sesión
                    Session["Usuario"] = usuario;
                    Session["UsuarioNombre"] = usuario.Nombre;

                    // Configuramos el mensaje y disparamos el modal de éxito
                    lblMensajeExitoModal.Text = "Tus datos personales y observaciones han sido actualizados con éxito.";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "PopExito", "mostrarModalExito();", true);
                }
                else
                {
                    lblMensaje.Text = "<div class='alert alert-danger mt-3'>Error al actualizar el perfil en la base de datos.</div>";
                    lblMensaje.CssClass = "d-block";
                }
            }
            catch (Exception ex)
            {
                lblMensaje.Text = $"<div class='alert alert-danger mt-3'>Ocurrió un error: {ex.Message}</div>";
                lblMensaje.CssClass = "d-block";
            }
        }

        protected void btnCancelar_Click(object sender, EventArgs e)
        {
            // Al cancelar, lo sacamos del formulario y lo llevamos al inicio/dashboard
            Response.Redirect("Default.aspx", false);
        }

        protected void btnCambiarPassword_Click(object sender, EventArgs e)
        {
            // Cerramos forzosamente el modal de contraseña para que no quede tildado
            ScriptManager.RegisterStartupScript(this, this.GetType(), "PopCerrarPass", "cerrarModalPassword();", true);

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
                    lblMensajePassword.Text = "<div class='alert alert-danger'>La contraseña actual es incorrecta. Verificá y volvé a intentarlo.</div>";
                    return;
                }

                // Actualizar la contraseña
                bool actualizado = negocio.CambiarPassword(usuario.Id, txtPasswordNueva.Text);

                if (actualizado)
                {
                    // Limpiar campos por seguridad
                    txtPasswordActual.Text = "";
                    txtPasswordNueva.Text = "";
                    txtPasswordConfirmar.Text = "";
                    lblMensajePassword.Text = "";

                    // Disparamos el modal de éxito
                    lblMensajeExitoModal.Text = "Tu contraseña ha sido actualizada correctamente.";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "PopExitoPass", "mostrarModalExito();", true);
                }
                else
                {
                    lblMensajePassword.Text = "<div class='alert alert-danger'>Ocurrió un error en el servidor al intentar actualizar la contraseña.</div>";
                }
            }
            catch (Exception ex)
            {
                lblMensajePassword.Text = $"<div class='alert alert-danger'>Error: {ex.Message}</div>";
            }
        }
    }
}