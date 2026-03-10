using Dominio;
using Negocio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Globalization;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TPC_Equipo20B
{
    public partial class Ventas : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ConfigurarPantallaPorRol();
                CargarGrid();
            }
        }

        private void ConfigurarPantallaPorRol()
        {
            bool esAdmin = Session["EsAdmin"] != null && (bool)Session["EsAdmin"];

            if (!esAdmin)
            {
                lblTituloPagina.InnerText = "Mis Pedidos";
                btnNuevaVenta.Text = "<i class=\"bi bi-plus-lg\"></i> Nuevo Pedido";
                txtBuscarVenta.Attributes["placeholder"] = "Buscar por número de remito o método de pago...";
            }
            else
            {
                lblTituloPagina.InnerText = "Gestión de Ventas";
                btnNuevaVenta.Text = "<i class=\"bi bi-plus-lg\"></i> Nueva Venta";
                txtBuscarVenta.Attributes["placeholder"] = "Buscar por cliente o n° de remito...";
            }
        }

        private void CargarGrid(string q = null)
        {
            var negocio = new VentaNegocio();
            List<Venta> lista = negocio.Listar(q);

            bool esAdmin = Session["EsAdmin"] != null && (bool)Session["EsAdmin"];
            int idUsuarioLogueado = Session["UsuarioId"] != null ? (int)Session["UsuarioId"] : -1;

            if (!esAdmin)
            {
                lista = lista.Where(v => v.Usuario != null && v.Usuario.Id == idUsuarioLogueado).ToList();
            }

            TextInfo textInfo = new CultureInfo("es-AR", false).TextInfo;

            var listaTransformada = lista.Select(v =>
            {

                // --- LECTURA DIRECTA DESDE LA BASE DE DATOS ---
                // Usamos Trim() y ToLower() para limpiar cualquier espacio invisible que venga de SQL
                bool esMayorista = !string.IsNullOrEmpty(v.TipoVenta) && v.TipoVenta.Trim().ToLower() == "mayorista";

                string badgeMayorista = "<span class='text-primary border border-primary rounded px-2 py-1 bg-primary bg-opacity-10 fw-bold' style='font-size: 0.75rem;'>Mayorista</span>";
                string badgeFinal = "<span class='border rounded px-2 py-1 fw-bold' style='color: #fd7e14; background-color: rgba(253, 126, 20, 0.1); border-color: #fd7e14; font-size: 0.75rem;'>C. Final</span>";

                return new
                {
                    Id = v.Id,
                    Fecha = v.Fecha,
                    Cliente = new { Nombre = (v.Cliente != null && !string.IsNullOrEmpty(v.Cliente.Nombre)) ? textInfo.ToTitleCase(v.Cliente.Nombre.ToLower()) : "S/D" },
                    Usuario = v.Usuario,
                    NumeroFactura = v.NumeroFactura,
                    MetodoPago = v.MetodoPago,
                    TotalBD = v.TotalBD,
                    Estado = v.Estado,
                    TipoVentaBadge = esMayorista ? badgeMayorista : badgeFinal
                };
            })
            .OrderByDescending(v => v.Id)
            .ToList();

            // La columna 3 (Tipo Venta) solo la ve el Admin
            if (gvVentas.Columns.Count > 3)
            {
                gvVentas.Columns[3].Visible = esAdmin;
            }

            gvVentas.DataSource = listaTransformada;
            gvVentas.DataBind();
        }

        protected void gvVentas_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvVentas.PageIndex = e.NewPageIndex;
            CargarGrid(txtBuscarVenta.Text.Trim());
        }

        protected void gvVentas_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandArgument == null)
                return;

            int id = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "Detalle")
            {
                Response.Redirect("VentaDetalle.aspx?id=" + id);
            }
            else if (e.CommandName == "Editar")
            {
                Response.Redirect("AgregarVenta.aspx?id=" + id);
            }
            else if (e.CommandName == "Cancelar")
            {
                string msg = Server.UrlEncode($"¿Cancelar la venta #{id}? Se reintegrará el stock.");
                Response.Redirect($"ConfirmarEliminar.aspx?tipo=venta&id={id}&msg={msg}");
            }
        }

        protected void gvVentas_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType != DataControlRowType.DataRow)
                return;

            string estadoVenta = DataBinder.Eval(e.Row.DataItem, "Estado")?.ToString();
            int idUsuarioVenta = -1;

            var usuarioObj = DataBinder.Eval(e.Row.DataItem, "Usuario") as Usuario;
            if (usuarioObj != null) idUsuarioVenta = usuarioObj.Id;

            LinkButton btnCancelar = (LinkButton)e.Row.FindControl("cmdCancelar");
            LinkButton btnEntregar = (LinkButton)e.Row.FindControl("cmdEntregar");
            LinkButton btnEditar = (LinkButton)e.Row.FindControl("cmdEditar");

            if (btnCancelar == null || btnEntregar == null || btnEditar == null) return;

            if (estadoVenta != "Activa")
            {
                btnCancelar.Visible = false;
                btnEntregar.Visible = false;
                btnEditar.Visible = false;
                return;
            }

            bool esAdmin = Session["EsAdmin"] != null && (bool)Session["EsAdmin"];
            int idUsuarioLogueado = Session["UsuarioId"] != null ? (int)Session["UsuarioId"] : -1;

            if (!esAdmin)
            {
                btnEntregar.Visible = false;
                btnEditar.Visible = false;

                if (idUsuarioVenta != idUsuarioLogueado)
                {
                    btnCancelar.Visible = false;
                }
            }
        }

        protected void btnNuevaVenta_Click(object sender, EventArgs e)
        {
            Response.Redirect("AgregarVenta.aspx");
        }

        protected void btnBuscarVenta_Click(object sender, EventArgs e)
        {
            var q = txtBuscarVenta.Text ?? string.Empty;
            CargarGrid(q.Trim());
        }

        protected void btnConfirmarEntrega_Click(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(hfVentaId.Value))
            {
                int idVenta = Convert.ToInt32(hfVentaId.Value);
                VentaNegocio neg = new VentaNegocio();
                neg.EntregarVenta(idVenta);

                hfVentaId.Value = "";
                CargarGrid(txtBuscarVenta.Text.Trim());
            }
        }

        protected string FormatearEstadoTexto(object estadoObj)
        {
            string estado = estadoObj?.ToString() ?? "Pendiente";
            string est = estado.ToLower().Trim();
            if (est == "activa" || est == "activo") return "Pendiente";
            return new CultureInfo("es-AR", false).TextInfo.ToTitleCase(est);
        }

        protected string ObtenerCssPorEstado(object estadoObj)
        {
            string estado = estadoObj?.ToString() ?? "";
            string est = estado.ToLower().Trim();

            if (est.Contains("entregada") || est.Contains("entregado") || est.Contains("completada"))
                return "badge bg-success bg-opacity-10 text-success border border-success rounded-pill px-3 py-2 w-100 fw-bold";
            if (est.Contains("cancelada") || est.Contains("cancelado") || est.Contains("rechazada"))
                return "badge bg-danger bg-opacity-10 text-danger border border-danger rounded-pill px-3 py-2 w-100 fw-bold";
            if (est.Contains("pendiente") || est.Contains("proceso") || est.Contains("preparacion") || est.Contains("activa") || est.Contains("activo"))
                return "badge bg-warning bg-opacity-10 text-warning border border-warning rounded-pill px-3 py-2 w-100 fw-bold";

            return "badge bg-primary bg-opacity-10 text-primary border border-primary rounded-pill px-3 py-2 w-100 fw-bold";
        }
    }
}