using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using Dominio;
using Negocio;

namespace TPC_Equipo20B
{
    public partial class PedidosProveedores : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Permisos.RequiereAdmin(this);

            if (!IsPostBack)
            {
                CargarPedidos();
            }
        }

        private void CargarPedidos(string filtro = "")
        {
            PedidoProveedorNegocio negocio = new PedidoProveedorNegocio();
            gvPedidos.DataSource = negocio.Listar(filtro);
            gvPedidos.DataBind();
        }

        protected void btnNuevoPedido_Click(object sender, EventArgs e)
        {
            Response.Redirect("AgregarPedidoProveedor.aspx", false);
        }

        protected void btnBuscarPedido_Click(object sender, EventArgs e)
        {
            CargarPedidos(txtBuscarPedido.Text.Trim());
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
                // Mandamos el ID por la URL para que el formulario sepa que tiene que cargar datos
                Response.Redirect("AgregarPedidoProveedor.aspx?id=" + idPedido, false);
            }
            else if (e.CommandName == "Cancelar")
            {
                PedidoProveedorNegocio negocio = new PedidoProveedorNegocio();
                negocio.Cancelar(idPedido, "Cancelado por el administrador.");
                CargarPedidos(txtBuscarPedido.Text.Trim());
            }
        }

        protected void gvPedidos_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                string estado = DataBinder.Eval(e.Row.DataItem, "Estado").ToString().ToUpper();

                LinkButton cmdEditar = (LinkButton)e.Row.FindControl("cmdEditar");
                LinkButton cmdRecibir = (LinkButton)e.Row.FindControl("cmdRecibir");
                LinkButton cmdCancelar = (LinkButton)e.Row.FindControl("cmdCancelar");

                // Regla de Negocio: Solo los pedidos "Pendientes" se pueden modificar, recibir o cancelar
                if (estado != "PENDIENTE")
                {
                    if (cmdEditar != null) cmdEditar.Visible = false;
                    if (cmdRecibir != null) cmdRecibir.Visible = false;
                    if (cmdCancelar != null) cmdCancelar.Visible = false;
                }
            }
        }

        protected void gvPedidos_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvPedidos.PageIndex = e.NewPageIndex;
            CargarPedidos(txtBuscarPedido.Text.Trim());
        }

        protected void btnConfirmarRecepcion_Click(object sender, EventArgs e)
        {
            int idPedido = int.Parse(hfPedidoId.Value);

            // Cambiamos el estado en la base de datos ---
            PedidoProveedorNegocio negocio = new PedidoProveedorNegocio();
            negocio.CambiarEstado(idPedido, "Recibido");

            // Redirigimos a la pantalla de Compras
            Response.Redirect("AgregarCompra.aspx?idPedido=" + idPedido, false);
        }

        // --- MÉTODOS VISUALES ---
        protected string FormatearEstadoTexto(object estadoObj)
        {
            if (estadoObj == null) return "Pendiente";
            return estadoObj.ToString();
        }

        protected string ObtenerCssPorEstado(object estadoObj)
        {
            if (estadoObj == null) return "bg-warning bg-opacity-10 text-warning";

            string estado = estadoObj.ToString().ToUpper();
            switch (estado)
            {
                case "PENDIENTE":
                    return "bg-warning bg-opacity-10 text-warning"; // Naranja
                case "RECIBIDO":
                    return "bg-success bg-opacity-10 text-success"; // Verde
                case "CANCELADO":
                    return "bg-danger bg-opacity-10 text-danger";  // Rojo
                default:
                    return "bg-info bg-opacity-10 text-info";    // Celeste
            }
        }
    }
}