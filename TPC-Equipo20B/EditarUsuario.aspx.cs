using System;
using System.Web.UI;
using Dominio;
using Negocio;

namespace TPC_Equipo20B
{
    public partial class EditarUsuario : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Permisos.RequiereAdmin(this); // Candado puesto 🔒

            if (!IsPostBack)
            {
                if (Request.QueryString["id"] == null)
                {
                    Response.Redirect("Usuarios.aspx", false);
                    return;
                }

                int idUsuario;
                if (!int.TryParse(Request.QueryString["id"], out idUsuario))
                {
                    Response.Redirect("Usuarios.aspx", false);
                    return;
                }

                ViewState["IdUsuario"] = idUsuario;
                CargarUsuario(idUsuario);
            }
        }

        private void CargarUsuario(int idUsuario)
        {
            UsuarioNegocio neg = new UsuarioNegocio();
            Usuario u = neg.ObtenerUsuarioPorId(idUsuario);

            if (u == null)
            {
                Response.Redirect("Usuarios.aspx", false);
                return;
            }

            txtNombre.Text = u.Nombre;
            txtEmail.Text = u.Email;
            txtDocumento.Text = u.Documento;
            txtTelefono.Text = u.Telefono;
            txtDireccion.Text = u.Direccion;
            txtLocalidad.Text = u.Localidad;
            txtUsername.Text = u.Username;
            txtObservaciones.Text = u.Observaciones;

            lblEstado.Text = u.Activo ? "ACTIVO" : "DESHABILITADO";
            lblEstado.CssClass = u.Activo ? "badge bg-success-subtle text-success border border-success fw-bold px-3 py-2 fs-6 rounded-pill"
                                          : "badge bg-secondary-subtle text-secondary border border-secondary fw-bold px-3 py-2 fs-6 rounded-pill";
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            // Cerramos modal de seguridad para que no tape el flujo
            ScriptManager.RegisterStartupScript(this, this.GetType(), "PopCerrar", "cerrarModalSeguridad();", true);

            lblError.Text = "";

            // Forzamos validación manual (Evita el error Page.IsValid)
            Page.Validate();

            if (!Page.IsValid)
                return;

            if (ViewState["IdUsuario"] == null)
            {
                Response.Redirect("Usuarios.aspx", false);
                return;
            }

            try
            {
                int idUsuario = (int)ViewState["IdUsuario"];

                Usuario u = new Usuario
                {
                    Id = idUsuario,
                    Nombre = txtNombre.Text.Trim(),
                    Email = txtEmail.Text.Trim(),
                    Documento = string.IsNullOrWhiteSpace(txtDocumento.Text) ? null : txtDocumento.Text.Trim(),
                    Telefono = string.IsNullOrWhiteSpace(txtTelefono.Text) ? null : txtTelefono.Text.Trim(),
                    Direccion = string.IsNullOrWhiteSpace(txtDireccion.Text) ? null : txtDireccion.Text.Trim(),
                    Localidad = string.IsNullOrWhiteSpace(txtLocalidad.Text) ? null : txtLocalidad.Text.Trim(),
                    Observaciones = string.IsNullOrWhiteSpace(txtObservaciones.Text) ? null : txtObservaciones.Text.Trim()
                };

                UsuarioNegocio neg = new UsuarioNegocio();
                neg.ActualizarUsuario(u);

                // Mostramos el modal de éxito
                ScriptManager.RegisterStartupScript(this, this.GetType(), "PopExito", "mostrarModalExito();", true);
            }
            catch (Exception ex)
            {
                lblError.Text = "Ocurrió un error al actualizar: " + ex.Message;
            }
        }

        protected void btnCancelar_Click(object sender, EventArgs e)
        {
            Response.Redirect("Usuarios.aspx", false);
        }
    }
}