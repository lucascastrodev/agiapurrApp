using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
// using Dominio;
// using Negocio;

namespace TPC_Equipo20B
{
    public partial class AgregarPedidoProveedor : System.Web.UI.Page
    {
        // En un futuro, esto será List<PedidoProveedorLinea>
        // private List<PedidoProveedorLinea> Lineas
        // {
        //     get { return (List<PedidoProveedorLinea>)(Session["PedidoProvLineas"] ?? (Session["PedidoProvLineas"] = new List<PedidoProveedorLinea>())); }
        //     set { Session["PedidoProvLineas"] = value; }
        // }

        protected void Page_Load(object sender, EventArgs e)
        {
            // Permisos.RequiereAdmin(this);

            if (!IsPostBack)
            {
                txtFecha.Text = DateTime.Now.ToString("yyyy-MM-dd");
                CargarProveedores();

                // Session["PedidoProvLineas"] = null; // Limpiar lista temporal al entrar
            }
        }

        private void CargarProveedores()
        {
            // ProveedorNegocio provNeg = new ProveedorNegocio();
            // ddlProveedor.DataSource = provNeg.Listar();
            // ddlProveedor.DataTextField = "Nombre";
            // ddlProveedor.DataValueField = "Id";
            // ddlProveedor.DataBind();

            // Dato falso temporal para maquetación
            ddlProveedor.Items.Insert(0, new ListItem("-- Seleccione un proveedor --", "0"));
            ddlProveedor.Items.Insert(1, new ListItem("Distribuidora Mayorista S.A.", "1"));
        }

        protected void ddlProveedor_SelectedIndexChanged(object sender, EventArgs e)
        {
            int idProveedor = int.Parse(ddlProveedor.SelectedValue);

            if (idProveedor == 0)
            {
                ddlProducto.Items.Clear();
                ddlProducto.Items.Insert(0, new ListItem("-- Seleccione un proveedor primero --", "0"));
                return;
            }

            CargarProductosDelProveedor(idProveedor);
        }

        private void CargarProductosDelProveedor(int idProveedor)
        {
            // ProductoProveedorNegocio prodProvNeg = new ProductoProveedorNegocio();
            // ddlProducto.DataSource = prodProvNeg.ListarPorProveedor(idProveedor);
            // ddlProducto.DataTextField = "DisplayCombo"; // Ej: "SKU123 - Bolson Yerba"
            // ddlProducto.DataValueField = "Id";
            // ddlProducto.DataBind();

            // Datos falsos temporales para maquetación
            ddlProducto.Items.Clear();
            ddlProducto.Items.Insert(0, new ListItem("-- Seleccione el producto --", "0"));
            ddlProducto.Items.Insert(1, new ListItem("BOL001 - Bolson Yerba Mate 4x2", "1"));
        }

        protected void ddlProducto_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlProducto.SelectedValue == "0")
            {
                txtPrecio.Text = "";
                return;
            }

            int idProductoProv = int.Parse(ddlProducto.SelectedValue);

            // ProductoProveedorNegocio negocio = new ProductoProveedorNegocio();
            // ProductoProveedor prod = negocio.ObtenerPorId(idProductoProv);
            // txtPrecio.Text = prod.PrecioUnitario.ToString("0.00");

            txtPrecio.Text = "5500.00"; // Falso para maquetar
        }

        protected void btnAgregarLinea_Click(object sender, EventArgs e)
        {
            if (ddlProducto.SelectedValue == "0" || string.IsNullOrEmpty(txtCantidad.Text)) return;

            // Bloquear el combo de Proveedor para que no lo cambien a mitad del pedido
            ddlProveedor.Enabled = false;

            // 1. Obtener el producto de la DB
            // 2. Crear nueva línea
            // 3. Agregarlo a la lista "Lineas"
            // 4. ActualizarGrid()

            // Resetear campos
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

                // Lineas.RemoveAt(index);
                // ActualizarGrid();

                // if (Lineas.Count == 0) ddlProveedor.Enabled = true; // Liberar proveedor si se vacía la lista
            }
        }

        private void ActualizarGrid()
        {
            // gvLineas.DataSource = Lineas;
            // gvLineas.DataBind();

            // decimal total = Lineas.Sum(l => l.PrecioUnitario * l.Cantidad);
            // lblTotal.Text = total.ToString("C");
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            try
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "PopCerrar", "var modal = bootstrap.Modal.getInstance(document.getElementById('modalSeguridadGuardar')); if(modal) modal.hide();", true);

                // Validaciones
                if (ddlProveedor.SelectedValue == "0")
                {
                    lblMensajeFooter.Text = "Debe seleccionar un proveedor.";
                    lblMensajeFooter.Visible = true;
                    return;
                }

                /*
                if (Lineas.Count == 0)
                {
                    lblMensajeFooter.Text = "Debe añadir al menos un producto al pedido.";
                    lblMensajeFooter.Visible = true;
                    return;
                }
                
                // Armar el objeto PedidoProveedor
                PedidoProveedor pedido = new PedidoProveedor
                {
                    Proveedor = new Proveedor { Id = int.Parse(ddlProveedor.SelectedValue) },
                    FechaEmision = DateTime.Parse(txtFecha.Text),
                    Observaciones = txtObservaciones.Text,
                    Usuario = (Usuario)Session["Usuario"],
                    Lineas = Lineas
                };
                
                PedidoProveedorNegocio negocio = new PedidoProveedorNegocio();
                negocio.Generar(pedido);
                */

                // ScriptManager.RegisterStartupScript(this, this.GetType(), "PopExito", "mostrarModalExito();", true);
            }
            catch (Exception ex)
            {
                lblMensajeFooter.Text = "Error: " + ex.Message;
                lblMensajeFooter.Visible = true;
            }
        }

        protected void btnConfirmarCancelar_Click(object sender, EventArgs e)
        {
            // Session["PedidoProvLineas"] = null;
            Response.Redirect("PedidosProveedores.aspx", false);
        }
    }
}