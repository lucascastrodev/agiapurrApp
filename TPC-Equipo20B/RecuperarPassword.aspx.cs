using System;
using Dominio;
using Negocio;

namespace TPC_Equipo20B
{
    public partial class RecuperarPassword : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["Usuario"] != null)
                {
                    Response.Redirect("Dashboard.aspx");
                }
            }
        }

        protected void btnRestablecer_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            string email = txtEmail.Text.Trim();
            UsuarioNegocio negocio = new UsuarioNegocio();

            try
            {
                Usuario usuario = negocio.ObtenerPorEmail(email);

                if (usuario == null)
                {
                    lblError.Text = "No existe un usuario activo con ese correo electrónico.";
                    lblSuccess.Text = "";
                    return;
                }

                string nuevaPassword = GenerarPasswordTemporal();

                bool ok = negocio.RestablecerPasswordPorEmail(email, nuevaPassword);

                if (ok)
                {
                
                    EmailService.EnviarRecuperacionPassword(usuario, nuevaPassword);

                    lblError.Text = "";
                    lblSuccess.Text = "Hemos enviado una contraseña temporal a tu correo electrónico. Revisa tu bandeja de entrada o la carpeta de spam.";
                }
                else
                {
                    lblError.Text = "No fue posible actualizar la contraseña. Intente nuevamente.";
                    lblSuccess.Text = "";
                }
            }
            catch (Exception ex)
            {
                lblError.Text = "Error al restablecer la contraseña: " + ex.Message;
                lblSuccess.Text = "";
            }
        }

        private string GenerarPasswordTemporal()
        {
            string guid = Guid.NewGuid().ToString("N");
            return guid.Substring(0, 8);
        }
    }
}
