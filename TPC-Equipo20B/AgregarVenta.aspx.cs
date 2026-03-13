using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using Dominio;
using Negocio;

namespace TPC_Equipo20B
{
    public partial class AgregarVenta : System.Web.UI.Page
    {
        private List<VentaLinea> Lineas
        {
            get { return (List<VentaLinea>)(Session["VentaLineas"] ?? (Session["VentaLineas"] = new List<VentaLinea>())); }
            set { Session["VentaLineas"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session["VentaLineasOriginales"] = null;
                txtFecha.Text = DateTime.Now.ToString("yyyy-MM-dd");
                ConfigurarPantallaPorRol();
                CargarCombos();

                if (Request.QueryString["id"] != null)
                {
                    int idVenta = int.Parse(Request.QueryString["id"]);
                    CargarVenta(idVenta);
                }
            }
        }

        private void ConfigurarPantallaPorRol()
        {
            bool esAdmin = Session["EsAdmin"] != null && (bool)Session["EsAdmin"];

            if (!esAdmin)
            {
                lblTituloPagina.InnerText = "Generar Pedido";
                lblSubtituloPagina.InnerText = "Complete los datos para enviar su pedido a la distribuidora";

                divClienteBox.Visible = false;
                rfvCliente.Enabled = false;
                divMetodoPago.Visible = false;
                rfvMetodoPago.Enabled = false;
                divTipoVenta.Visible = false;
                divFilaMetodos.Visible = false;

                divDescuentoAdmin.Visible = false; // <-- EL VENDEDOR NO VE EL DESCUENTO

                txtFecha.Attributes.Add("readonly", "readonly");
                txtFecha.Style.Add("pointer-events", "none");
                txtFecha.CssClass = "form-control form-control-sm bg-transparent text-center border-0 fw-bold p-0 text-dark fs-6";

                tituloFacturacion.Visible = false;
                lblTxtPrecio.InnerText = "Precio";
                lblTxtTotalRemito.InnerText = "Total Pedido";

                btnProcesarUI.InnerHtml = "<span class=\"material-symbols-outlined fs-5\">check_circle</span> Confirmar Pedido";
                lblMensajeExitoModal.Text = "Su pedido ha sido generado y enviado a la distribuidora correctamente.";
            }
            else
            {
                lblTituloPagina.InnerText = "Registrar Venta";
                lblSubtituloPagina.InnerText = "Complete los datos para generar un nuevo remito";

                divClienteBox.Visible = true;
                divMetodoPago.Visible = true;
                divTipoVenta.Visible = true;

                divDescuentoAdmin.Visible = true; // <-- EL ADMIN SÍ VE EL DESCUENTO

                txtFecha.Attributes.Remove("readonly");
                txtFecha.Style.Remove("pointer-events");
                txtFecha.CssClass = "form-control form-control-sm bg-white text-center border-0 border-bottom border-success fw-bold px-2 py-1 text-dark fs-6";

                tituloFacturacion.Visible = true;
                lblTxtPrecio.InnerText = "Precio Unitario";
                lblTxtTotalRemito.InnerText = "Total Remito";

                btnProcesarUI.InnerHtml = "<span class=\"material-symbols-outlined fs-5\">check_circle</span> Confirmar Venta";
                lblMensajeExitoModal.Text = "El remito ha sido registrado en el sistema correctamente.";
            }
        }

        protected void txtDescuento_TextChanged(object sender, EventArgs e)
        {
            // Evento que se dispara cuando el admin tipea un descuento y sale del campo
            ActualizarTotal();
        }

        protected void ddlProducto_SelectedIndexChanged(object sender, EventArgs e)
        {
            ActualizarPrecioProducto();
        }

        protected void rblTipoVenta_SelectedIndexChanged(object sender, EventArgs e)
        {
            ActualizarPrecioProducto();
        }

        private void ActualizarPrecioProducto()
        {
            if (ddlProducto.SelectedValue == "0")
            {
                txtPrecio.Text = "";
                return;
            }

            int idProd = int.Parse(ddlProducto.SelectedValue);
            ProductoNegocio negocio = new ProductoNegocio();
            Producto prod = negocio.ObtenerPorId(idProd);

            bool esAdmin = Session["EsAdmin"] != null && (bool)Session["EsAdmin"];

            if (!esAdmin || rblTipoVenta.SelectedValue == "Mayorista")
            {
                txtPrecio.Text = prod.PrecioMayorista.ToString("0.00");
            }
            else
            {
                txtPrecio.Text = prod.PrecioVenta.ToString("0.00");
            }
        }

        private void CargarCombos()
        {
            ClienteNegocio clienteNeg = new ClienteNegocio();
            ProductoNegocio productoNeg = new ProductoNegocio();
            System.Globalization.TextInfo textInfo = new System.Globalization.CultureInfo("es-AR", false).TextInfo;

            bool esAdmin = Session["EsAdmin"] != null && (bool)Session["EsAdmin"];

            if (esAdmin)
            {
                var listaClientes = clienteNeg.Listar();
                var clientesFormateados = listaClientes.Select(c => new
                {
                    Id = c.Id,
                    Nombre = textInfo.ToTitleCase(c.Nombre.ToLower())
                }).ToList();

                ddlCliente.DataSource = clientesFormateados;
                ddlCliente.DataTextField = "Nombre";
                ddlCliente.DataValueField = "Id";
                ddlCliente.DataBind();
                ddlCliente.Items.Insert(0, new ListItem("-- Seleccione un cliente --", "0"));
            }

            var listaProductos = productoNeg.ListarHabilitados();
            var productosFormateados = listaProductos.Select(p => new
            {
                Id = p.Id,
                Display = textInfo.ToTitleCase((p.Descripcion ?? "").ToLower()) +
                          " (" + textInfo.ToTitleCase((p.Marca != null && !string.IsNullOrEmpty(p.Marca.Nombre) ? p.Marca.Nombre : "Sin marca").ToLower()) + ")"
            }).ToList();

            ddlProducto.DataSource = productosFormateados;
            ddlProducto.DataTextField = "Display";
            ddlProducto.DataValueField = "Id";
            ddlProducto.DataBind();
            ddlProducto.Items.Insert(0, new ListItem("-- Seleccione un producto --", "0"));
        }

        protected void ValidarCantidad_ServerValidate(object source, ServerValidateEventArgs args)
        {
            int cantidad;
            if (int.TryParse(args.Value, out cantidad) && cantidad > 0)
                args.IsValid = true;
            else
                args.IsValid = false;
        }

        protected void btnAgregarLinea_Click(object sender, EventArgs e)
        {
            lblErrorStock.Text = "";

            bool esAdminLoc = Session["EsAdmin"] != null && (bool)Session["EsAdmin"];
            bool esMayorista = !esAdminLoc || rblTipoVenta.SelectedValue == "Mayorista";
            int limiteProductos = esMayorista ? 40 : 15;

            if (Lineas.Count >= limiteProductos)
            {
                lblErrorStock.Text = $"Límite alcanzado: Máximo {limiteProductos} productos para esta lista.";
                return;
            }

            if (ddlProducto.SelectedValue == "0" || string.IsNullOrEmpty(txtCantidad.Text) || string.IsNullOrEmpty(txtPrecio.Text))
                return;

            Page.Validate("AgregarLinea");
            if (!Page.IsValid) return;

            ProductoNegocio productoNeg = new ProductoNegocio();
            int idProducto = int.Parse(ddlProducto.SelectedValue);

            Producto prod = productoNeg.ObtenerPorId(idProducto);
            if (prod == null) return;

            int cantidadSolicitada = int.Parse(txtCantidad.Text);
            decimal cantidadYaAgregada = Lineas.Where(l => l.Producto.Id == idProducto).Sum(l => l.Cantidad);

            decimal cantidadOriginalEnVenta = 0;
            if (Session["VentaLineasOriginales"] != null)
            {
                var originales = (List<VentaLinea>)Session["VentaLineasOriginales"];
                cantidadOriginalEnVenta = originales.Where(l => l.Producto.Id == idProducto).Sum(l => l.Cantidad);
            }

            int stockDisponible = (int)prod.StockActual + (int)cantidadOriginalEnVenta - (int)cantidadYaAgregada;

            if (cantidadSolicitada > stockDisponible)
            {
                lblErrorStock.Text = $"Stock insuficiente. Disponible: {stockDisponible} unidad(es).";
                return;
            }

            VentaLinea nueva = new VentaLinea
            {
                Producto = prod,
                Cantidad = cantidadSolicitada,
                PrecioUnitario = decimal.Parse(txtPrecio.Text)
            };

            Lineas.Add(nueva);

            gvLineas.DataSource = Lineas;
            gvLineas.DataBind();
            ActualizarTotal();

            lblMensajeFooter.Visible = false;

            txtCantidad.Text = "";
            ddlProducto.SelectedIndex = 0;
            txtPrecio.Text = "";
        }

        protected void gvLineas_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Eliminar")
            {
                int index = Convert.ToInt32(e.CommandArgument);
                Lineas.RemoveAt(index);
                gvLineas.DataSource = Lineas;
                gvLineas.DataBind();
                ActualizarTotal();

                lblMensajeFooter.Visible = false;
            }
        }

        private void ActualizarTotal()
        {
            decimal subtotal = Lineas.Sum(l => l.PrecioUnitario * l.Cantidad);
            decimal porcentajeDescuento = 0;

            if (divDescuentoAdmin.Visible && !string.IsNullOrEmpty(txtDescuento.Text))
            {
                decimal.TryParse(txtDescuento.Text, out porcentajeDescuento);
                // Evitamos que ponga más del 100% de descuento
                if (porcentajeDescuento > 100) porcentajeDescuento = 100;
            }

            // Calculamos cuánta plata hay que descontar
            decimal descuentoAplicado = subtotal * (porcentajeDescuento / 100m);

            decimal total = subtotal - descuentoAplicado;
            if (total < 0) total = 0;

            lblTotal.Text = total.ToString("C");
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            try
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "PopCerrar", "cerrarModalSeguridad();", true);

                bool esAdmin = Session["EsAdmin"] != null && (bool)Session["EsAdmin"];

                if (esAdmin && (ddlCliente.SelectedValue == "0" || ddlMetodoPago.SelectedValue == "0"))
                {
                    lblMensajeFooter.Text = "Complete Cliente y Método de Pago.";
                    lblMensajeFooter.Visible = true;
                    return;
                }

                if (Lineas.Count == 0)
                {
                    lblMensajeFooter.Text = "Agregue productos al pedido antes de confirmar.";
                    lblMensajeFooter.Visible = true;
                    return;
                }

                int idUsuario = (int)Session["UsuarioId"];
                UsuarioNegocio usuNegocio = new UsuarioNegocio();
                Usuario usuarioCompleto = usuNegocio.ObtenerUsuarioPorId(idUsuario);

                ClienteNegocio cliNegocio = new ClienteNegocio();
                Cliente clienteCompleto = esAdmin
                    ? cliNegocio.BuscarPorId(int.Parse(ddlCliente.SelectedValue))
                    : cliNegocio.BuscarPorDocumento(usuarioCompleto.Documento);

                if (clienteCompleto == null) return;

                string metodoPagoFinal = esAdmin ? ddlMetodoPago.SelectedValue : "Transferencia";
                DateTime fechaVenta = DateTime.TryParse(txtFecha.Text, out DateTime parsedDate) ? parsedDate : DateTime.Now;

                // Capturamos el descuento final para guardarlo en la Base de Datos
                decimal descuentoFinal = 0;
                if (esAdmin && !string.IsNullOrEmpty(txtDescuento.Text))
                {
                    decimal.TryParse(txtDescuento.Text, out descuentoFinal);
                }

                Venta venta = new Venta
                {
                    Cliente = clienteCompleto,
                    Usuario = usuarioCompleto,
                    Fecha = fechaVenta,
                    MetodoPago = metodoPagoFinal,
                    TipoVenta = esAdmin ? rblTipoVenta.SelectedValue : "Mayorista",
                    Descuento = descuentoFinal, // <-- AQUÍ SE GUARDA EL DESCUENTO
                    Lineas = Lineas
                };

                VentaNegocio negocio = new VentaNegocio();

                if (Request.QueryString["id"] != null)
                {
                    venta.Id = int.Parse(Request.QueryString["id"]);
                    negocio.Modificar(venta);
                    lblMensajeExitoModal.Text = "La venta ha sido actualizada y el stock recalculado correctamente.";
                }
                else
                {
                    negocio.Registrar(venta);
                }

                Session["VentaLineas"] = null;
                Session["VentaLineasOriginales"] = null;

                ScriptManager.RegisterStartupScript(this, this.GetType(), "PopExito", "mostrarModalExito();", true);
            }
            catch (Exception ex)
            {
                lblMensajeFooter.Text = "Error al procesar: " + ex.Message;
                lblMensajeFooter.Visible = true;
            }
        }

        protected void btnConfirmarCancelar_Click(object sender, EventArgs e)
        {
            Session["VentaLineas"] = null;
            Session["VentaLineasOriginales"] = null;
            Response.Redirect("Ventas.aspx", false);
        }

        protected void btnCancelar_Click(object sender, EventArgs e)
        {
            Session["VentaLineas"] = null;
            Session["VentaLineasOriginales"] = null;
            Response.Redirect("Ventas.aspx", false);
        }

        private void CargarVenta(int idVenta)
        {
            VentaNegocio negocio = new VentaNegocio();
            Venta venta = negocio.ObtenerPorId(idVenta);
            if (venta == null) return;

            if (Session["EsAdmin"] != null && (bool)Session["EsAdmin"])
            {
                ddlCliente.SelectedValue = venta.Cliente.Id.ToString();

                lblTituloPagina.InnerText = "Editar Venta / Pedido";
                lblSubtituloPagina.InnerText = $"Modificando el remito {venta.NumeroFactura}";

                if (!string.IsNullOrEmpty(venta.TipoVenta))
                {
                    rblTipoVenta.SelectedValue = venta.TipoVenta;
                }

                // Cargar el descuento previo si existía
                if (venta.Descuento > 0)
                {
                    txtDescuento.Text = Math.Round(venta.Descuento, 0).ToString();
                }

                btnProcesarUI.InnerHtml = "<span class=\"material-symbols-outlined fs-5\">save_as</span> Guardar Cambios";
            }

            ddlMetodoPago.SelectedValue = venta.MetodoPago;
            txtFecha.Text = venta.Fecha.ToString("yyyy-MM-dd");

            Lineas = venta.Lineas;

            Session["VentaLineasOriginales"] = venta.Lineas.Select(l => new VentaLinea
            {
                Producto = l.Producto,
                Cantidad = l.Cantidad,
                PrecioUnitario = l.PrecioUnitario
            }).ToList();

            gvLineas.DataSource = Lineas;
            gvLineas.DataBind();
            ActualizarTotal();
        }
    }
}