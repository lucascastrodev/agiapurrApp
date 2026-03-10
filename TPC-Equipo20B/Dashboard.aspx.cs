using System;
using System.Linq;
using System.Globalization;
using Negocio;
using System.Collections.Generic;

namespace TPC_Equipo20B
{
    public partial class Dashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                CargarDatos();
        }

        private void CargarDatos()
        {
            bool esAdmin = Session["EsAdmin"] != null && (bool)Session["EsAdmin"];

            // Traemos siempre el ID del usuario logueado para comparar
            int idUsuarioLogueado = Session["UsuarioId"] != null ? (int)Session["UsuarioId"] : -1;
            int? idUsuarioFiltro = null;

            if (!esAdmin && Session["UsuarioId"] != null)
                idUsuarioFiltro = (int)Session["UsuarioId"];

            var ventaNegocio = new VentaNegocio();
            var productoNegocio = new ProductoNegocio();
            TextInfo textInfo = new CultureInfo("es-AR", false).TextInfo;

            var stockBajo = productoNegocio.ListarStockBajo()
                .Select(p => new
                {
                    Codigo = string.IsNullOrWhiteSpace(p.CodigoSKU) ? "Sin SKU" : p.CodigoSKU,
                    Producto = textInfo.ToTitleCase((p.Descripcion ?? "").ToLower()),
                    StockVisual = esAdmin
                                  ? p.StockActual.ToString()
                                  : (p.StockActual <= 0 ? "🔴 Agotado" : "🟡 Últimas unidades"),
                    StockMinimo = p.StockMinimo.ToString()
                })
                .ToList();

            gvStockBajo.DataSource = stockBajo;
            gvStockBajo.DataBind();

            List<Dominio.Venta> listaVentas = ventaNegocio.Listar(null);
            IEnumerable<Dominio.Venta> ventasFiltradas = listaVentas;

            if (idUsuarioFiltro.HasValue)
            {
                ventasFiltradas = listaVentas.Where(v => v.Usuario != null && v.Usuario.Id == idUsuarioFiltro.Value);
            }

            if (esAdmin)
            {
                lblTituloCard1.InnerText = "Ventas del Mes";
                lblDescCard1.InnerText = "Ventas confirmadas del mes actual";
                lblMetrica1.Text = ventaNegocio.ObtenerTotalVentasMes(null).ToString("C");

                lblTituloCard2.InnerText = "Pedidos Completados";
                lblDescCard2.InnerText = "Ventas no canceladas en el mes";
                lblMetrica2.Text = ventaNegocio.ObtenerPedidosCompletadosMes(null).ToString();

                lblTituloCard3.InnerText = "Clientes Nuevos";
                lblDescCard3.InnerText = "Cuentas creadas este mes";
                lblMetrica3.Text = ventaNegocio.ObtenerClientesNuevosMes(null).ToString();

                gvStockBajo.Columns[2].HeaderText = "Stock Actual";
                gvStockBajo.Columns[3].Visible = true;

                lblTituloVentas.InnerText = "Últimas Ventas";
                gvUltimasVentas.Columns[1].Visible = true;
                gvUltimasVentas.Columns[4].Visible = true; // Hace visible "Tipo de Venta"
            }
            else
            {
                var mesActual = DateTime.Now.Month;
                var anioActual = DateTime.Now.Year;
                var ventasMesVendedor = ventasFiltradas.Where(v => v.Fecha.Month == mesActual && v.Fecha.Year == anioActual).ToList();

                decimal totalInvertido = ventasMesVendedor.Where(v => v.Estado != "Cancelada").Sum(v => v.TotalBD);
                int pedidosConfirmados = ventasMesVendedor.Count(v => v.Estado != "Cancelada");
                int pedidosCancelados = ventasMesVendedor.Count(v => v.Estado == "Cancelada");

                lblTituloCard1.InnerText = "Total Pedido (Mes)";
                lblDescCard1.InnerText = "Dinero invertido en pedidos confirmados";
                lblMetrica1.Text = totalInvertido.ToString("C");

                lblTituloCard2.InnerText = "Pedidos Confirmados";
                lblDescCard2.InnerText = "Órdenes procesadas este mes";
                lblMetrica2.Text = pedidosConfirmados.ToString();

                lblTituloCard3.InnerText = "Pedidos Cancelados";
                lblDescCard3.InnerText = "Órdenes anuladas este mes";
                lblDescCard3.Attributes["class"] = "small text-danger mb-0";
                card3.Attributes["class"] = "card h-100 card-custom shadow-sm border-start border-danger border-4";
                lblMetrica3.Text = pedidosCancelados.ToString();

                gvStockBajo.Columns[2].HeaderText = "Disponibilidad";
                gvStockBajo.Columns[3].Visible = false;

                lblTituloVentas.InnerText = "Últimos Pedidos";
                gvUltimasVentas.Columns[1].Visible = false;
                gvUltimasVentas.Columns[4].Visible = false; // Oculta "Tipo de Venta" para el vendedor
            }

            var ultimas = ventasFiltradas
                .OrderByDescending(v => v.Fecha)
                .Take(10)
                .Select(v => new
                {
                    IdVenta = v.Id,
                    Cliente = (v.Cliente != null && !string.IsNullOrEmpty(v.Cliente.Nombre))
                               ? textInfo.ToTitleCase(v.Cliente.Nombre.ToLower())
                               : "Consumidor Final",
                    Fecha = v.Fecha.ToString("dd/MM/yyyy"),
                    Total = v.TotalBD,

                    // LÓGICA INTELIGENTE: Misma lógica que en Ventas.aspx
                    TipoVentaBadge = (v.Usuario != null && v.Usuario.Id != idUsuarioLogueado)
                                 ? "<span class='text-primary border border-primary rounded px-2 py-1 bg-primary bg-opacity-10 fw-bold' style='font-size: 0.75rem;'>Mayorista</span>"
                                 : "<span class='border rounded px-2 py-1 fw-bold' style='color: #fd7e14; background-color: rgba(253, 126, 20, 0.1); border-color: #fd7e14; font-size: 0.75rem;'>C. Final</span>",

                    EstadoText = FormatearEstadoTexto(v.Estado, textInfo),
                    CssEstado = ObtenerCssPorEstado(v.Estado)
                })
                .ToList();

            gvUltimasVentas.DataSource = ultimas;
            gvUltimasVentas.DataBind();
        }

        private string FormatearEstadoTexto(string estado, TextInfo textInfo)
        {
            if (string.IsNullOrEmpty(estado)) return "Pendiente";
            string est = estado.ToLower().Trim();
            if (est == "activa" || est == "activo") return "Pendiente";
            return textInfo.ToTitleCase(est);
        }

        private string ObtenerCssPorEstado(string estado)
        {
            if (string.IsNullOrEmpty(estado)) return "bg-warning bg-opacity-10 text-warning border-warning fw-bold";
            string est = estado.ToLower().Trim();
            if (est.Contains("entregada") || est.Contains("entregado") || est.Contains("completada"))
                return "bg-success bg-opacity-10 text-success border-success fw-bold";
            if (est.Contains("cancelada") || est.Contains("cancelado") || est.Contains("rechazada"))
                return "bg-danger bg-opacity-10 text-danger border-danger fw-bold";
            if (est.Contains("pendiente") || est.Contains("proceso") || est.Contains("preparacion") || est.Contains("activa") || est.Contains("activo"))
                return "bg-warning bg-opacity-10 text-warning border-warning fw-bold";
            return "bg-primary bg-opacity-10 text-primary border-primary fw-bold";
        }
    }
}