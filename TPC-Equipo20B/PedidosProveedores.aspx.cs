using Dominio;
using System;
using System.Web.UI;
using System.Web.UI.WebControls;
// using Dominio;
// using Negocio;

namespace TPC_Equipo20B
{
    public partial class PedidosProveedores : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Permisos.RequiereAdmin(this);
            if (!IsPostBack)
            {
                // CargarPedidos(); // Lo implementaremos luego
            }
        }

        protected void btnNuevoPedido_Click(object sender, EventArgs e)
        {
            Response.Redirect("AgregarPedidoProveedor.aspx", false);
        }

        protected void btnBuscarPedido_Click(object sender, EventArgs e)
        {
            // string filtro = txtBuscarPedido.Text.Trim();
            // CargarPedidos(filtro); // Lo implementaremos luego
        }

        protected void gvPedidos_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int idPedido = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "Detalle")
            {
                Response.Redirect("PedidoProveedorDetalle.aspx?id=" + idPedido, false);
            }
            else if (e.CommandName == "Editar")
            {
                Response.Redirect("AgregarPedidoProveedor.aspx?id=" + idPedido, false);
            }
            else if (e.CommandName == "Cancelar")
            {
                // Lógica para cancelar el pedido
                // CargarPedidos();
            }
        }

        protected void gvPedidos_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                // Aquí ocultaremos los botones de Editar o Recibir si el pedido ya está Cancelado o Recibido
                // string estado = DataBinder.Eval(e.Row.DataItem, "Estado").ToString();
                // LinkButton cmdEditar = (LinkButton)e.Row.FindControl("cmdEditar");
                // LinkButton cmdRecibir = (LinkButton)e.Row.FindControl("cmdRecibir");
                // LinkButton cmdCancelar = (LinkButton)e.Row.FindControl("cmdCancelar");
            }
        }

        protected void gvPedidos_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvPedidos.PageIndex = e.NewPageIndex;
            // CargarPedidos(txtBuscarPedido.Text);
        }

        protected void btnConfirmarRecepcion_Click(object sender, EventArgs e)
        {
            int idPedido = int.Parse(hfPedidoId.Value);

            // 1. Cambiar estado del pedido a "Recibido" en la BD

            // 2. Redirigir a AgregarCompra para que haga el ingreso real de stock
            // Response.Redirect("AgregarCompra.aspx?idPedido=" + idPedido, false);
        }

        // Métodos auxiliares para la interfaz visual
        protected string FormatearEstadoTexto(object estadoObj)
        {
            if (estadoObj == null) return "Pendiente";
            return estadoObj.ToString();
        }

        protected string ObtenerCssPorEstado(object estadoObj)
        {
            if (estadoObj == null) return "bg-warning bg-opacity-10"; // Naranja para Pendiente

            string estado = estadoObj.ToString().ToUpper();
            switch (estado)
            {
                case "PENDIENTE":
                case "ENVIADO":
                    return "bg-warning bg-opacity-10"; // Naranja
                case "RECIBIDO":
                    return "bg-success bg-opacity-10"; // Verde
                case "CANCELADO":
                    return "bg-danger bg-opacity-10";  // Rojo
                default:
                    return "bg-info bg-opacity-10";    // Celeste por defecto
            }
        }
    }
}