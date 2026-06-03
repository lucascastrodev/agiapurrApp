using Dominio;
using Negocio;
using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TPC_Equipo20B
{
    public partial class Usuarios : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Permisos.RequiereAdmin(this);

            if (!IsPostBack)
            {
                Bind();
            }
        }

        private void Bind(string q = null)
        {
            UsuarioNegocio neg = new UsuarioNegocio();
            gvUsuarios.DataSource = neg.ListarUsuarios(q);
            gvUsuarios.DataBind();
        }

        protected void btnBuscarUsuario_Click(object sender, EventArgs e)
        {
            Bind(txtBuscarUsuario.Text.Trim());
        }

        // --- LÓGICA DEL NUEVO MODAL DE REGISTRO ---
        protected void btnGuardarUsuarioModal_Click(object sender, EventArgs e)
        {
            Page.Validate("NuevoUser");
            if (!Page.IsValid) return;

            UsuarioNegocio negocio = new UsuarioNegocio();

            try
            {
                Usuario nuevoUsuario = new Usuario
                {
                    Nombre = txtNuevoNombre.Text.Trim(),
                    Email = txtNuevoEmail.Text.Trim(),
                    Username = txtNuevoUsername.Text.Trim(),
                    Password = txtNuevoPassword.Text,
                    Activo = true
                };

                // Guardamos usando la lógica que ya tiene BCrypt adentro
                negocio.RegistrarUsuario(nuevoUsuario);

                // Refrescamos la grilla
                Bind();

                // Limpiamos los campos
                txtNuevoNombre.Text = "";
                txtNuevoEmail.Text = "";
                txtNuevoUsername.Text = "";

                // Cerramos el modal de alta y abrimos el de éxito
                ScriptManager.RegisterStartupScript(this, this.GetType(), "PopModal",
                    "var m = bootstrap.Modal.getInstance(document.getElementById('modalNuevoUsuario')); if(m) m.hide(); " +
                    "new bootstrap.Modal(document.getElementById('modalExitoUsuario')).show();", true);
            }
            catch (Exception ex)
            {
                lblErrorModal.Text = ex.Message;
                // Dejamos el modal abierto para que vea el error
                ScriptManager.RegisterStartupScript(this, this.GetType(), "MantenerAbierto",
                    "new bootstrap.Modal(document.getElementById('modalNuevoUsuario')).show();", true);
            }
        }

        protected void gvUsuarios_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (string.IsNullOrEmpty(e.CommandArgument.ToString()))
                return;

            int idActual = Convert.ToInt32(Session["UsuarioId"]);
            int idUsuario = Convert.ToInt32(e.CommandArgument);

            if (idUsuario == idActual)
                return;

            UsuarioNegocio neg = new UsuarioNegocio();

            switch (e.CommandName)
            {
                case "CambiarRol":
                    Usuario u = neg.ObtenerUsuarioPorId(idUsuario);
                    bool esAdmin = u.Roles.Any(r => r.Id == 1);

                    if (esAdmin)
                        neg.HacerVendedor(idUsuario);
                    else
                        neg.HacerAdmin(idUsuario);
                    break;

                case "EditarUsuario":
                    Response.Redirect("EditarUsuario.aspx?id=" + idUsuario, false);
                    return;

                case "ToggleActivo":
                    Usuario usuario = neg.ObtenerUsuarioPorId(idUsuario);

                    if (usuario.Roles.Any(r => r.Id == 1))
                        return;

                    if (usuario.Activo)
                        neg.DeshabilitarUsuario(idUsuario);
                    else
                        neg.HabilitarUsuario(idUsuario);
                    break;
            }

            Bind(txtBuscarUsuario.Text.Trim());
        }

        protected void gvUsuarios_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType != DataControlRowType.DataRow)
                return;

            Usuario usuario = (Usuario)e.Row.DataItem;
            int idActual = Convert.ToInt32(Session["UsuarioId"]);

            LinkButton btnCambiarRol = (LinkButton)e.Row.FindControl("btnCambiarRol");
            LinkButton btnEditar = (LinkButton)e.Row.FindControl("btnEditar");
            LinkButton btnToggleActivo = (LinkButton)e.Row.FindControl("btnToggleActivo");

            bool esAdmin = usuario.Roles.Any(r => r.Id == 1);

            if (usuario.Id == idActual)
            {
                btnCambiarRol.Visible = false;
                btnEditar.Visible = false;
                btnToggleActivo.Visible = false;
                return;
            }

            // --- CONFIRMACIONES DE SEGURIDAD JS ---
            btnCambiarRol.OnClientClick = "return confirm('¿Está seguro de modificar los permisos de este usuario?');";
            btnToggleActivo.OnClientClick = "return confirm('¿Está seguro de cambiar el estado de acceso de este usuario?');";

            if (esAdmin)
            {
                btnCambiarRol.Text = "<i class='bi bi-person-badge'></i> Hacer Vendedor";
                btnCambiarRol.CssClass = "btn btn-secondary btn-grilla me-1 shadow-sm";
                e.Row.CssClass = "fila-admin fw-bold";
            }
            else
            {
                btnCambiarRol.Text = "<i class='bi bi-key-fill'></i> Hacer Admin";
                btnCambiarRol.CssClass = "btn btn-warning text-dark btn-grilla me-1 shadow-sm";
            }

            if (usuario.Activo)
            {
                btnToggleActivo.Text = "<i class='bi bi-person-x-fill'></i> Deshabilitar";
                btnToggleActivo.CssClass = "btn btn-danger btn-grilla shadow-sm";
            }
            else
            {
                btnToggleActivo.Text = "<i class='bi bi-person-check-fill'></i> Habilitar";
                btnToggleActivo.CssClass = "btn btn-success btn-grilla shadow-sm";
                e.Row.CssClass = "text-muted";
            }
        }
    }
}