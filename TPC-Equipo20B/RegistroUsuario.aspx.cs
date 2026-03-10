using System;
using System.Web.UI;
using Dominio;
using Negocio;

namespace TPC_Equipo20B
{
    public partial class RegistroUsuario : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                txtNombre.Focus();
            }

            if (Session["Usuario"] != null)
            {
                Response.Redirect("~/Default.aspx");
            }
        }

        protected void btnRegistrar_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            UsuarioNegocio negocio = new UsuarioNegocio();

            try
            {
                Usuario nuevoUsuario = new Usuario
                {
                    Nombre = txtNombre.Text.Trim(),
                    Documento = string.IsNullOrWhiteSpace(txtDocumento.Text) ? null : txtDocumento.Text.Trim(),
                    Email = txtEmail.Text.Trim(),
                    Telefono = string.IsNullOrWhiteSpace(txtTelefono.Text) ? null : txtTelefono.Text.Trim(),
                    Direccion = string.IsNullOrWhiteSpace(txtDireccion.Text) ? null : txtDireccion.Text.Trim(),
                    Localidad = string.IsNullOrWhiteSpace(txtLocalidad.Text) ? null : txtLocalidad.Text.Trim(),

                    // Se captura la observación obligatoria
                    Observaciones = txtObservaciones.Text.Trim(),

                    Username = txtUsername.Text.Trim(),
                    Password = txtPassword.Text,
                    Activo = true
                };

                bool registrado = negocio.RegistrarUsuario(nuevoUsuario);

                if (registrado)
                {
                    lblSuccess.Text = "¡Registro exitoso! Redirigiendo al inicio de sesión...";
                    lblError.Text = "";
                    Response.AddHeader("REFRESH", "1;URL=Default.aspx");
                }
            }
            catch (Exception ex)
            {
                lblError.Text = ex.Message;
                lblSuccess.Text = "";
            }
        }
    }
}