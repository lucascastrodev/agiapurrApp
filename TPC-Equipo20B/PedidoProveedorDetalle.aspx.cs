using System;
using System.Web.UI;
using Dominio;
using Negocio;

namespace TPC_Equipo20B
{
    public partial class PedidoProveedorDetalle : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Permisos.RequiereAdmin(this);

            if (!IsPostBack)
            {
                if (Request.QueryString["id"] != null)
                {
                    int idPedido = int.Parse(Request.QueryString["id"]);
                    CargarComprobante(idPedido);
                }
                else
                {
                    Response.Redirect("PedidosProveedores.aspx", false);
                }
            }
        }

        private void CargarComprobante(int idPedido)
        {
            try
            {
                // Ahora usamos el método oficial de Negocio, que ya trae todo el JOIN y la cascada
                PedidoProveedorNegocio negocio = new PedidoProveedorNegocio();
                PedidoProveedor pedido = negocio.ObtenerPorId(idPedido);

                if (pedido != null)
                {
                    // 1. Cargar Cabecera
                    lblNumeroPedido.Text = pedido.Id.ToString("D5");
                    lblFecha.Text = pedido.FechaEmision.ToString("dd/MM/yyyy");
                    lblEstado.Text = pedido.Estado.ToUpper();

                    if (pedido.Estado == "Recibido") lblEstado.CssClass = "badge bg-success bg-opacity-10 text-success border border-success";
                    else if (pedido.Estado == "Cancelado") lblEstado.CssClass = "badge bg-danger bg-opacity-10 text-danger border border-danger";

                    // 2. Cargar Proveedor y Usuario
                    lblProveedorNombre.Text = pedido.Proveedor.Nombre;
                    lblUsuario.Text = pedido.Usuario.Nombre;

                    // 3. Cargar Tabla de Productos (Detalle)
                    repDetalles.DataSource = pedido.Lineas;
                    repDetalles.DataBind();

                    // 4. Cargar Cascada Matemática (Oculta los div si son 0)
                    lblSubtotalBruto.Text = pedido.SubtotalBruto.ToString("C");

                    if (pedido.DescuentoPorcentaje > 0 || pedido.DescuentoMonto > 0)
                    {
                        divDescuento.Visible = true;
                        lblPorcDescuento.Text = pedido.DescuentoPorcentaje.ToString("0.##");
                        lblDescuento.Text = "- " + pedido.DescuentoMonto.ToString("C");
                    }
                    else divDescuento.Visible = false;

                    lblSubtotalNeto.Text = pedido.SubtotalNeto.ToString("C");

                    if (pedido.MontoIVA > 0)
                    {
                        divIva.Visible = true;
                        lblIva.Text = pedido.MontoIVA.ToString("C");
                    }
                    else divIva.Visible = false;

                    if (pedido.MontoIIBB > 0)
                    {
                        divIibb.Visible = true;
                        lblIibb.Text = pedido.MontoIIBB.ToString("C");
                    }
                    else divIibb.Visible = false;

                    if (pedido.MontoPercepcion > 0)
                    {
                        divPercepcion.Visible = true;
                        lblPercepcion.Text = pedido.MontoPercepcion.ToString("C");
                    }
                    else divPercepcion.Visible = false;

                    // 5. Total Final
                    lblTotal.Text = pedido.TotalEstimado.ToString("C");
                }
                else
                {
                    lblError.Text = "No se encontró el pedido.";
                    lblError.Visible = true;
                    pnlComprobante.Visible = false;
                }
            }
            catch (Exception ex)
            {
                lblError.Text = "Error al cargar el detalle: " + ex.Message;
                lblError.Visible = true;
                pnlComprobante.Visible = false;
            }

        }
        protected int CalcularPacks(object cantidad, object unidadesPorPack)
        {
            int cant = Convert.ToInt32(cantidad);
            int un = Convert.ToInt32(unidadesPorPack);
            return un > 0 ? cant / un : cant;
        }
    }
}