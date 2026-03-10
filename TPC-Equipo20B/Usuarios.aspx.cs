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

        protected void gvUsuarios_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (string.IsNullOrEmpty(e.CommandArgument.ToString()))
                return;

            int idActual = Convert.ToInt32(Session["UsuarioId"]);
            int idUsuario = Convert.ToInt32(e.CommandArgument);

            // No permitir auto-modificarse
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

                    // por seguridad: no permitir deshabilitar admins desde acá
                    if (usuario.Roles.Any(r => r.Id == 1))
                        return;

                    if (usuario.Activo)
                        neg.DeshabilitarUsuario(idUsuario);
                    else
                        neg.HabilitarUsuario(idUsuario);
                    break;
            }

            // Volvemos a bindear respetando el filtro actual
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

            // Si es el usuario logueado → ocultamos todas las acciones
            if (usuario.Id == idActual)
            {
                btnCambiarRol.Visible = false;
                btnEditar.Visible = false;
                btnToggleActivo.Visible = false;
                return;
            }

            // ---- Botón Cambiar Rol ----
            // Agregamos íconos para identificar visualmente la acción
            if (esAdmin)
            {
                btnCambiarRol.Text = "<i class='bi bi-person-badge'></i> Hacer Vendedor";
                btnCambiarRol.CssClass = "btn btn-secondary btn-grilla me-1 shadow-sm";
            }
            else
            {
                btnCambiarRol.Text = "<i class='bi bi-key-fill'></i> Hacer Admin";
                btnCambiarRol.CssClass = "btn btn-warning text-dark btn-grilla me-1 shadow-sm";
            }

            // ---- Botón Activar / Desactivar ----
            if (usuario.Activo)
            {
                btnToggleActivo.Text = "<i class='bi bi-person-x-fill'></i> Deshabilitar";
                // Clase btn-danger de Bootstrap + clase global btn-grilla
                btnToggleActivo.CssClass = "btn btn-danger btn-grilla shadow-sm";
            }
            else
            {
                btnToggleActivo.Text = "<i class='bi bi-person-check-fill'></i> Habilitar";
                // Clase btn-success para habilitar
                btnToggleActivo.CssClass = "btn btn-success btn-grilla shadow-sm";

                // Efecto visual: si está deshabilitado, la fila se ve más "apagada"
                e.Row.CssClass = "text-muted";
            }

            // Efecto visual: resaltamos la fila si es Admin
            if (esAdmin)
            {
                e.Row.CssClass = "fila-admin fw-bold";
            }
        }
    }
}