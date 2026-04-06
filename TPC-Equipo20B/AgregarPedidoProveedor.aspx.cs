using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using Dominio;
using Negocio;

namespace TPC_Equipo20B
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

                // VERIFICAMOS SI ESTAMOS EN MODO EDICIÓN
                if (Request.QueryString["id"] != null)
                {
                    int idPedido = int.Parse(Request.QueryString["id"]);
                    CargarPedidoParaEdicion(idPedido);
                }
                else
                {
                    // MODO ALTA NUEVA
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
                // 1. Cambiamos títulos visuales
                lblTituloPagina.InnerText = "Editar Pedido #" + pedido.Id;
                lblSubtituloPagina.InnerText = "Modifique las cantidades o productos de la orden.";
                btnGuardarDefinitivo.Text = "Guardar Cambios";

                // 2. Cargamos controles
                txtFecha.Text = pedido.FechaEmision.ToString("yyyy-MM-dd");

                ddlProveedor.SelectedValue = pedido.Proveedor.Id.ToString();
                ddlProveedor.Enabled = false; // Bloqueamos el proveedor para no romper los SKUs

                // Cargamos los productos de ese proveedor en el segundo combo
                CargarProductosDelProveedor(pedido.Proveedor.Id);

                // 3. Cargamos el carrito en memoria
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
                return;
            }

            CargarProductosDelProveedor(idProveedor);
        }

        private void CargarProductosDelProveedor(int idProveedor)
        {
            ProductoProveedorNegocio prodProvNeg = new ProductoProveedorNegocio();

            // Suponiendo que tenés un método ListarPorProveedor en ProductoProveedorNegocio
            var productos = prodProvNeg.ListarPorProveedor(idProveedor);

            ddlProducto.DataSource = productos;
            // Mostramos Código y Descripción juntos para que sea más fácil elegir
            ddlProducto.DataTextField = "Descripcion";
            ddlProducto.DataValueField = "Id";
            ddlProducto.DataBind();

            ddlProducto.Items.Insert(0, new ListItem("-- Seleccione el producto --", "0"));

            // Si hay productos, los formateamos un poco (Opcional, depende de cómo los traigas)
            foreach (ListItem item in ddlProducto.Items)
            {
                if (item.Value != "0")
                {
                    var prod = productos.FirstOrDefault(p => p.Id.ToString() == item.Value);
                    if (prod != null) item.Text = $"{prod.Codigo} - {prod.Descripcion}";
                }
            }

            txtPrecio.Text = "";
        }

        protected void ddlProducto_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlProducto.SelectedValue == "0")
            {
                txtPrecio.Text = "";
                return;
            }

            int idProductoProv = int.Parse(ddlProducto.SelectedValue);

            ProductoProveedorNegocio negocio = new ProductoProveedorNegocio();
            ProductoProveedor prod = negocio.ObtenerPorId(idProductoProv);

            if (prod != null)
            {
                // Mostramos el precio unitario del catálogo del proveedor
                txtPrecio.Text = prod.PrecioUnitario.ToString("0.00");
            }
        }

        protected void btnAgregarLinea_Click(object sender, EventArgs e)
        {
            if (ddlProducto.SelectedValue == "0" || string.IsNullOrEmpty(txtCantidad.Text)) return;

            // Bloquear el combo de Proveedor para que no lo cambien a mitad del pedido
            ddlProveedor.Enabled = false;

            int idProductoProv = int.Parse(ddlProducto.SelectedValue);
            int cantidad = int.Parse(txtCantidad.Text);

            ProductoProveedorNegocio prodNeg = new ProductoProveedorNegocio();
            ProductoProveedor producto = prodNeg.ObtenerPorId(idProductoProv);

            if (producto != null)
            {
                // Crear nueva línea
                PedidoProveedorLinea nuevaLinea = new PedidoProveedorLinea
                {
                    Producto = producto,
                    Cantidad = cantidad,
                    PrecioUnitario = producto.PrecioUnitario
                    // El Subtotal se calcula solo gracias a la propiedad en la clase de Dominio
                };

                // Verificar si ya existe el producto en el carrito y sumar cantidad (opcional)
                var lineaExistente = Lineas.FirstOrDefault(l => l.Producto.Id == producto.Id);
                if (lineaExistente != null)
                {
                    lineaExistente.Cantidad += cantidad;
                }
                else
                {
                    Lineas.Add(nuevaLinea);
                }

                ActualizarGrid();
            }

            // Resetear campos para cargar el siguiente más rápido
            ddlProducto.SelectedIndex = 0;
            txtCantidad.Text = "";
            txtPrecio.Text = "";
            lblMensajeFooter.Visible = false;
        }

        protected void gvLineas_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Eliminar")
            {
                int index = Convert.ToInt32(e.CommandArgument);

                Lineas.RemoveAt(index);
                ActualizarGrid();

                // Liberar proveedor si se vacía la lista por completo
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

            if (Lineas.Count > 0)
            {
                decimal total = Lineas.Sum(l => l.Subtotal);
                lblTotal.Text = total.ToString("C");
            }
            else
            {
                lblTotal.Text = "$ 0,00";
            }
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            try
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "PopCerrar", "var modal = bootstrap.Modal.getInstance(document.getElementById('modalSeguridadGuardar')); if(modal) modal.hide();", true);

                if (ddlProveedor.SelectedValue == "0") return;
                if (Lineas.Count == 0) return;

                PedidoProveedor pedido = new PedidoProveedor
                {
                    Proveedor = new Proveedor { Id = int.Parse(ddlProveedor.SelectedValue) },
                    FechaEmision = DateTime.Parse(txtFecha.Text),
                    Usuario = (Usuario)Session["Usuario"],
                    Lineas = Lineas,
                    TotalEstimado = Lineas.Sum(l => l.Subtotal)
                };

                PedidoProveedorNegocio negocio = new PedidoProveedorNegocio();

                // SI HAY UN ID EN LA URL, ACTUALIZAMOS. SINO, CREAMOS UNO NUEVO.
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
            // Limpiar carrito y salir
            Session["PedidoProvLineas"] = null;
            Response.Redirect("PedidosProveedores.aspx", false);
        }
    }
}