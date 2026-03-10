using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.WebControls;
using Dominio;
using Negocio;

namespace TPC_Equipo20B
{
    public partial class Compras : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Permisos.RequiereAdmin(this);

            if (!IsPostBack)
                CargarGrid();

            // Para que ENTER dispare la búsqueda y no “Nueva Compra”
            if (Form != null)
                Form.DefaultButton = btnBuscarCompra.UniqueID;
        }

        // Carga el grid, con o sin filtro
        private void CargarGrid(string q = null)
        {
            var negocio = new CompraNegocio();
            List<Compra> lista = negocio.Listar(q);
            gvCompras.DataSource = lista;
            gvCompras.DataBind();
        }

        protected void btnNuevaCompra_Click(object sender, EventArgs e)
        {
            Response.Redirect("AgregarCompra.aspx");
        }

        // 🔎 EVENTO DE BÚSQUEDA (el que falta)
        protected void btnBuscarCompra_Click(object sender, EventArgs e)
        {
            var q = (txtBuscarCompra.Text ?? string.Empty).Trim();

            if (string.IsNullOrEmpty(q))
                CargarGrid(null);   // sin filtro
            else
                CargarGrid(q);      // con filtro
        }

        protected void gvCompras_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandArgument == null)
                return;

            int id = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "Detalle")
            {
                Response.Redirect("CompraDetalle.aspx?id=" + id);
            }
            else if (e.CommandName == "Eliminar")
            {
                string msg = Server.UrlEncode(
                    $"¿Desea eliminar la compra N° {id}? Esta acción no se puede deshacer.");
                Response.Redirect($"ConfirmarEliminar.aspx?tipo=compra&id={id}&msg={msg}");
            }
        }
        protected void gvCompras_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                // Obtenemos la compra como el DataItem
                Compra compra = (Compra)e.Row.DataItem;


                LinkButton btnEliminar = (LinkButton)e.Row.FindControl("cmdEliminar");

                if (compra.Cancelada)
                {
                    btnEliminar.Visible = false;

                }
                else
                {
                    btnEliminar.Visible = true;
                }
            }
        }
        protected void gvCompras_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvCompras.PageIndex = e.NewPageIndex;
            btnBuscarCompra_Click(null, null); // Vuelve a cargar la lista
        }

    }
}
