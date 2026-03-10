using Dominio;
using Negocio;
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace TPC_Equipo20B
{
    public partial class Clientes : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Candado de seguridad: Solo el Admin pasa de acá
            Permisos.RequiereAdmin(this);

            if (!IsPostBack)
                BindGrid("");
        }

        protected void btnBuscar_Click(object sender, EventArgs e)
        {
            BindGrid(txtBuscar.Text.Trim());
        }

        protected void gvClientes_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvClientes.PageIndex = e.NewPageIndex;
            BindGrid(txtBuscar.Text.Trim());
        }

        private void BindGrid(string q)
        {
            ClienteNegocio negocio = new ClienteNegocio();
            var lista = negocio.Listar(q);

            bool esAdmin = Session["EsAdmin"] != null && (bool)Session["EsAdmin"];
            int idUsuarioLogueado = Session["UsuarioId"] != null
                ? (int)Session["UsuarioId"]
                : -1;

            if (!esAdmin)
            {
                lista = lista
                    .FindAll(c => c.IdUsuarioAlta == idUsuarioLogueado);
            }


            gvClientes.DataSource = lista;
            gvClientes.DataBind();
        }
        protected void gvClientes_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType != DataControlRowType.DataRow)
                return;

            Cliente cli = (Cliente)e.Row.DataItem;

            HyperLink lnkEditar = (HyperLink)e.Row.FindControl("lnkEditar");
            HyperLink lnkEliminar = (HyperLink)e.Row.FindControl("lnkEliminar");

            bool esAdmin = Session["EsAdmin"] != null && (bool)Session["EsAdmin"];
            int idUsuarioLogueado = Session["UsuarioId"] != null ? (int)Session["UsuarioId"] : -1;

            // Si es admin dejar todo visible
            if (esAdmin)
                return;

            // Si no es admin permitir solo si el cliente fue creado por él
            if (cli.IdUsuarioAlta != idUsuarioLogueado)
            {
                lnkEditar.Visible = false;
                lnkEliminar.Visible = false;
            }
        }

    }

}
