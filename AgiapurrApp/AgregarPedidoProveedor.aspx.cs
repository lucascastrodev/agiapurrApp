using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using Dominio;
using Negocio;

namespace AgiapurrApp
{
    public partial class AgregarPedidoProveedor : System.Web.UI.Page
    {
        // Lista temporal en memoria para armar el pedido antes de guardarlo
        private List<PedidoProveedorLinea> Lineas
        {
            get { return (List<PedidoProveedorLinea>)(Session["PedidoProvLineas"] ?? (Session["PedidoProvLineas"] = new List<PedidoProveedorLinea>())); }
            set { Session["PedidoProvLineas"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            Permisos.RequiereAdmin(this);

            if (!IsPostBack)
            {
                CargarProveedores();

                if (Request.QueryString["id"] != null)
                {
                    int idPedido = int.Parse(Request.QueryString["id"]);
                    CargarPedidoParaEdicion(idPedido);
                }
                else
                {
                    txtFecha.Text = DateTime.Now.ToString("yyyy-MM-dd");
                    Session["PedidoProvLineas"] = null;
                    ActualizarGrid();
                }
            }
        }

        private void CargarPedidoParaEdicion(int idPedido)
        {
            PedidoProveedorNegocio negocio = new PedidoProveedorNegocio();
            PedidoProveedor pedido = negocio.ObtenerPorId(idPedido);

            if (pedido != null)
            {
                lblTituloPagina.InnerText = "Editar Pedido #" + pedido.Id;
                lblSubtituloPagina.InnerText = "Modifique las cantidades o productos de la orden.";
                btnGuardarDefinitivo.Text = "Guardar Cambios";

                txtFecha.Text = pedido.FechaEmision.ToString("yyyy-MM-dd");

                ddlProveedor.SelectedValue = pedido.Proveedor.Id.ToString();
                ddlProveedor.Enabled = false;
                btnAbrirModalNuevoProd.Disabled = false; // Habilitar el botón '+' aunque se bloquee el proveedor

                CargarProductosDelProveedor(pedido.Proveedor.Id);

                Lineas = pedido.Lineas;
                ActualizarGrid();
            }
        }

        private void CargarProveedores()
        {
            ProveedorNegocio provNeg = new ProveedorNegocio();
            ddlProveedor.DataSource = provNeg.Listar();
            ddlProveedor.DataTextField = "Nombre";
            ddlProveedor.DataValueField = "Id";
            ddlProveedor.DataBind();

            ddlProveedor.Items.Insert(0, new ListItem("-- Seleccione un proveedor --", "0"));
        }

        protected void ddlProveedor_SelectedIndexChanged(object sender, EventArgs e)
        {
            int idProveedor = int.Parse(ddlProveedor.SelectedValue);

            if (idProveedor == 0)
            {
                ddlProducto.Items.Clear();
                ddlProducto.Items.Insert(0, new ListItem("-- Seleccione un proveedor primero --", "0"));
                txtPrecio.Text = "";
                lblLabelCantidad.Text = "Cantidad";
                btnAbrirModalNuevoProd.Disabled = true; // Deshabilita el '+'
                return;
            }

            btnAbrirModalNuevoProd.Disabled = false; // Habilita el '+'
            CargarProductosDelProveedor(idProveedor);
            ActualizarGrid();
        }

        private void CargarProductosDelProveedor(int idProveedor)
        {
            ProductoProveedorNegocio prodProvNeg = new ProductoProveedorNegocio();
            var productos = prodProvNeg.ListarPorProveedor(idProveedor);

            ddlProducto.DataSource = productos;
            ddlProducto.DataTextField = "Descripcion";
            ddlProducto.DataValueField = "Id";
            ddlProducto.DataBind();

            ddlProducto.Items.Insert(0, new ListItem("-- Seleccione el producto --", "0"));

            foreach (ListItem item in ddlProducto.Items)
            {
                if (item.Value != "0")
                {
                    var prod = productos.FirstOrDefault(p => p.Id.ToString() == item.Value);
                    if (prod != null) item.Text = $"{prod.Codigo} - {prod.Descripcion}";
                }
            }

            txtPrecio.Text = "";
            lblLabelCantidad.Text = "Cantidad";
        }

        protected void ddlProducto_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlProducto.SelectedValue == "0")
            {
                txtPrecio.Text = "";
                lblLabelCantidad.Text = "Cantidad";
                return;
            }

            int idProductoProv = int.Parse(ddlProducto.SelectedValue);
            ProductoProveedorNegocio negocio = new ProductoProveedorNegocio();
            ProductoProveedor prod = negocio.ObtenerPorId(idProductoProv);

            if (prod != null)
            {
                txtPrecio.Text = prod.PrecioUnitario.ToString("0.00");

                if (prod.UnidadesPorPack > 1)
                {
                    lblLabelCantidad.Text = $"Cant. de Packs ({prod.UnidadesPorPack} un. c/u)";
                }
                else
                {
                    lblLabelCantidad.Text = "Cantidad (Unidades)";
                }
            }
        }

        // --- MAGIA: GUARDAR EL NUEVO PRODUCTO Y AUTO-SELECCIONARLO ---
        protected void btnGuardarNuevoProducto_Click(object sender, EventArgs e)
        {
            // Validacion C# para evitar que modifiquen el HTML y hagan un Bypass
            Page.Validate("NuevoProd");
            if (!Page.IsValid) return;

            try
            {
                if (ddlProveedor.SelectedValue == "0") return;

                ProductoProveedor p = new ProductoProveedor();
                p.Proveedor.Id = int.Parse(ddlProveedor.SelectedValue);
                p.Codigo = string.IsNullOrWhiteSpace(txtNuevoCodigo.Text) ? "-" : txtNuevoCodigo.Text.Trim();
                p.Descripcion = txtNuevoDescripcion.Text.Trim();

                p.PrecioUnitario = decimal.Parse(txtNuevoPrecio.Text.Replace(".", ","));
                p.PorcentajeDescuento = decimal.Parse(txtNuevoDescuento.Text.Replace(".", ","));
                p.UnidadesPorPack = int.Parse(txtNuevoPack.Text);

                ProductoProveedorNegocio negocio = new ProductoProveedorNegocio();
                negocio.Agregar(p); // Se inserta en la BD

                // 1. Recargamos la lista para que aparezca el nuevo
                CargarProductosDelProveedor(p.Proveedor.Id);

                // 2. Lo buscamos por su texto (ya que Agregar no devuelve el Id)
                string textoGenerado = $"{p.Codigo} - {p.Descripcion}";
                ListItem itemRecienAgregado = ddlProducto.Items.FindByText(textoGenerado);

                if (itemRecienAgregado != null)
                {
                    ddlProducto.ClearSelection();
                    itemRecienAgregado.Selected = true;
                    ddlProducto_SelectedIndexChanged(null, null); // Forzar que se cargue el "Costo Unitario" en pantalla
                }

                // 3. Limpiamos el modal para la próxima vez
                txtNuevoCodigo.Text = "";
                txtNuevoDescripcion.Text = "";
                txtNuevoPrecio.Text = "";
                txtNuevoPack.Text = "1";
                txtNuevoDescuento.Text = "0,00";

                // 4. Cerramos el modal suavemente
                ScriptManager.RegisterStartupScript(this, this.GetType(), "PopCloseNuevoProd", "var modal = bootstrap.Modal.getInstance(document.getElementById('modalNuevoProducto')); if(modal) modal.hide();", true);
            }
            catch (Exception ex)
            {
                lblMensajeFooter.Text = "Error al guardar el producto nuevo: " + ex.Message;
                lblMensajeFooter.Visible = true;
            }
        }

        protected void btnAgregarLinea_Click(object sender, EventArgs e)
        {
            Page.Validate("AgregarLinea");
            if (!Page.IsValid) return;

            if (ddlProducto.SelectedValue == "0" || string.IsNullOrEmpty(txtCantidad.Text)) return;

            ddlProveedor.Enabled = false;

            int idProductoProv = int.Parse(ddlProducto.SelectedValue);
            int cantidadIngresada = int.Parse(txtCantidad.Text);

            ProductoProveedorNegocio prodNeg = new ProductoProveedorNegocio();
            ProductoProveedor producto = prodNeg.ObtenerPorId(idProductoProv);

            if (producto != null)
            {
                bool esModoEdicion = Request.QueryString["id"] != null;

                if (Lineas.Count > 0)
                {
                    decimal descuentoActualDelCarrito = Lineas.First().Producto.PorcentajeDescuento;

                    if (!esModoEdicion && producto.PorcentajeDescuento != descuentoActualDelCarrito)
                    {
                        lblMensajeFooter.Text = "No se pueden mezclar productos de distintas familias (Ej: Yerbas con resto del catálogo) en el mismo pedido.";
                        lblMensajeFooter.Visible = true;
                        return;
                    }

                    if (esModoEdicion)
                    {
                        producto.PorcentajeDescuento = descuentoActualDelCarrito;
                    }
                }

                int cantidadRealUnidades = cantidadIngresada * (producto.UnidadesPorPack > 0 ? producto.UnidadesPorPack : 1);

                PedidoProveedorLinea nuevaLinea = new PedidoProveedorLinea
                {
                    Producto = producto,
                    Cantidad = cantidadRealUnidades,
                    PrecioUnitario = producto.PrecioUnitario
                };

                var lineaExistente = Lineas.FirstOrDefault(l => l.Producto.Id == producto.Id);
                if (lineaExistente != null)
                {
                    lineaExistente.Cantidad += cantidadRealUnidades;
                }
                else
                {
                    Lineas.Add(nuevaLinea);
                }

                ActualizarGrid();
            }

            ddlProducto.SelectedIndex = 0;
            txtCantidad.Text = "";
            txtPrecio.Text = "";
            lblLabelCantidad.Text = "Cantidad";
            lblMensajeFooter.Visible = false;
        }

        protected void gvLineas_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Eliminar")
            {
                int index = Convert.ToInt32(e.CommandArgument);

                Lineas.RemoveAt(index);
                ActualizarGrid();

                if (Lineas.Count == 0)
                {
                    ddlProveedor.Enabled = true;
                }
            }
        }

        private void ActualizarGrid()
        {
            gvLineas.DataSource = Lineas;
            gvLineas.DataBind();

            if (Lineas.Count > 0 && ddlProveedor.SelectedValue != "0")
            {
                int idProv = int.Parse(ddlProveedor.SelectedValue);
                ProveedorNegocio provNeg = new ProveedorNegocio();
                Proveedor prov = provNeg.ObtenerPorId(idProv);

                decimal subBruto = Lineas.Sum(l => l.Subtotal);
                lblSubtotalBruto.Text = subBruto.ToString("C");

                decimal descPorc = Lineas.First().Producto.PorcentajeDescuento;
                decimal descMonto = subBruto * (descPorc / 100);

                lblPorcDescuento.Text = descPorc.ToString("0.##");
                lblDescuento.Text = "- " + descMonto.ToString("C");
                divDescuento.Visible = descPorc > 0;

                decimal subNeto = subBruto - descMonto;
                lblSubtotalNeto.Text = subNeto.ToString("C");

                decimal ivaPorc = prov != null ? prov.PorcentajeIVA : 0;
                decimal montoIva = subNeto * (ivaPorc / 100);
                lblPorcIva.Text = ivaPorc.ToString("0.##");
                lblIva.Text = montoIva.ToString("C");
                divIva.Visible = ivaPorc > 0;

                decimal iibbPorc = prov != null ? prov.PorcentajeIIBB : 0;
                decimal montoIibb = subNeto * (iibbPorc / 100);
                lblPorcIibb.Text = iibbPorc.ToString("0.##");
                lblIibb.Text = montoIibb.ToString("C");
                divIibb.Visible = iibbPorc > 0;

                decimal percPorc = prov != null ? prov.PorcentajePercepcion : 0;
                decimal montoPerc = subNeto * (percPorc / 100);
                lblPorcPercepcion.Text = percPorc.ToString("0.##");
                lblPercepcion.Text = montoPerc.ToString("C");
                divPercepcion.Visible = percPorc > 0;

                decimal total = subNeto + montoIva + montoIibb + montoPerc;
                lblTotal.Text = total.ToString("C");
            }
            else
            {
                lblSubtotalBruto.Text = "$ 0,00";
                lblDescuento.Text = "- $ 0,00";
                divDescuento.Visible = false;
                lblSubtotalNeto.Text = "$ 0,00";
                lblIva.Text = "$ 0,00";
                divIva.Visible = false;
                lblIibb.Text = "$ 0,00";
                divIibb.Visible = false;
                lblPercepcion.Text = "$ 0,00";
                divPercepcion.Visible = false;
                lblTotal.Text = "$ 0,00";
            }
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            Page.Validate("GuardarPedido");
            if (!Page.IsValid) return;

            try
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "PopCerrar", "var modal = bootstrap.Modal.getInstance(document.getElementById('modalSeguridadGuardar')); if(modal) modal.hide();", true);

                if (ddlProveedor.SelectedValue == "0") return;
                if (Lineas.Count == 0) return;

                ProveedorNegocio provNeg = new ProveedorNegocio();
                Proveedor prov = provNeg.ObtenerPorId(int.Parse(ddlProveedor.SelectedValue));

                decimal subBruto = Lineas.Sum(l => l.Subtotal);

                decimal descPorc = Lineas.First().Producto.PorcentajeDescuento;

                decimal descMonto = subBruto * (descPorc / 100);
                decimal subNeto = subBruto - descMonto;
                decimal montoIva = subNeto * (prov.PorcentajeIVA / 100);
                decimal montoIibb = subNeto * (prov.PorcentajeIIBB / 100);
                decimal montoPerc = subNeto * (prov.PorcentajePercepcion / 100);
                decimal total = subNeto + montoIva + montoIibb + montoPerc;

                PedidoProveedor pedido = new PedidoProveedor
                {
                    Proveedor = prov,
                    FechaEmision = DateTime.Parse(txtFecha.Text),
                    Usuario = (Usuario)Session["Usuario"],
                    Lineas = Lineas,

                    SubtotalBruto = subBruto,
                    DescuentoPorcentaje = descPorc,
                    DescuentoMonto = descMonto,
                    SubtotalNeto = subNeto,
                    MontoIVA = montoIva,
                    MontoIIBB = montoIibb,
                    MontoPercepcion = montoPerc,
                    TotalEstimado = total
                };

                PedidoProveedorNegocio negocio = new PedidoProveedorNegocio();

                if (Request.QueryString["id"] != null)
                {
                    pedido.Id = int.Parse(Request.QueryString["id"]);
                    negocio.Modificar(pedido);
                }
                else
                {
                    negocio.Generar(pedido);
                }

                Session["PedidoProvLineas"] = null;
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
            Session["PedidoProvLineas"] = null;
            Response.Redirect("PedidosProveedores.aspx", false);
        }
    }
}