using Dominio;
using Negocio;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TPC_Equipo20B
{
    public partial class AgregarCompra : System.Web.UI.Page
    {
        private List<CompraLinea> Lineas
        {
            get
            {
                if (Session["LineasCompra"] == null)
                    Session["LineasCompra"] = new List<CompraLinea>();
                return (List<CompraLinea>)Session["LineasCompra"];
            }
            set { Session["LineasCompra"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            Permisos.RequiereAdmin(this);
            if (!IsPostBack)
            {
                CargarCombos();

                var hoy = DateTime.Today;
                txtFecha.Text = hoy.ToString("yyyy-MM-dd");
                txtFecha.Attributes["max"] = hoy.ToString("yyyy-MM-dd");

                Lineas = new List<CompraLinea>();
                ActualizarGrid();
            }
        }

        private void CargarCombos()
        {
            ProveedorNegocio provNeg = new ProveedorNegocio();
            ddlProveedor.DataSource = provNeg.Listar();
            ddlProveedor.DataTextField = "Nombre";
            ddlProveedor.DataValueField = "Id";
            ddlProveedor.DataBind();
            ddlProveedor.Items.Insert(0, new ListItem("-- Seleccione una empresa --", "0"));

            ddlProducto.Items.Clear();
            ddlProducto.Items.Insert(0, new ListItem("-- Seleccione proveedor primero --", "0"));
        }

        private void CargarProductosPorProveedor(int idProveedor)
        {
            ProductoNegocio prodNeg = new ProductoNegocio();
            ddlProducto.DataSource = prodNeg.listarPorProveedor(idProveedor);
            ddlProducto.DataTextField = "Descripcion";
            ddlProducto.DataValueField = "Id";
            ddlProducto.DataBind();

            ddlProducto.Items.Insert(0, new ListItem("-- Seleccione un producto --", "0"));
        }

        protected void ddlProveedor_SelectedIndexChanged(object sender, EventArgs e)
        {
            int idProveedor = int.Parse(ddlProveedor.SelectedValue);

            if (idProveedor == 0)
            {
                ddlProducto.Items.Clear();
                ddlProducto.Items.Insert(0, new ListItem("-- Seleccione proveedor primero --", "0"));
                return;
            }

            CargarProductosPorProveedor(idProveedor);
        }

        // --- BOTÓN PARA ACTUALIZAR LA LISTA DESDE EL MODAL ---
        protected void btnActualizarLista_Click(object sender, EventArgs e)
        {
            try
            {
                if (ddlProveedor.SelectedValue != "0")
                {
                    int idProveedor = int.Parse(ddlProveedor.SelectedValue);
                    string productoSeleccionado = ddlProducto.SelectedValue;

                    // Recargamos los productos del proveedor
                    CargarProductosPorProveedor(idProveedor);

                    // Intentamos mantener seleccionado el que estaba antes, por comodidad
                    if (ddlProducto.Items.FindByValue(productoSeleccionado) != null)
                    {
                        ddlProducto.SelectedValue = productoSeleccionado;
                    }

                    lblError.Visible = false;
                }
            }
            catch (Exception ex)
            {
                lblError.Text = "Error al actualizar la lista: " + ex.Message;
                lblError.Visible = true;
            }
        }

        protected void btnAgregarLinea_Click(object sender, EventArgs e)
        {
            if (ddlProducto.SelectedValue == "0" ||
                string.IsNullOrWhiteSpace(txtCantidad.Text) ||
                string.IsNullOrWhiteSpace(txtPrecio.Text))
                return;

            int idProveedorCompra = int.Parse(ddlProveedor.SelectedValue);
            int idProducto = int.Parse(ddlProducto.SelectedValue);

            ProductoNegocio prodNeg = new ProductoNegocio();
            bool pertenece = prodNeg.ProductoPerteneceAProveedor(idProducto, idProveedorCompra);

            if (!pertenece)
            {
                lblError.Text = "El producto seleccionado no pertenece a este proveedor.";
                lblError.Visible = true;
                return;
            }

            // --- LÓGICA DE NORMALIZACIÓN DE DECIMALES ---
            string precioRaw = txtPrecio.Text.Trim();
            decimal precioFinal;

            if (precioRaw.Contains(".") && !precioRaw.Contains(","))
            {
                precioFinal = decimal.Parse(precioRaw, System.Globalization.CultureInfo.InvariantCulture);
            }
            else
            {
                precioFinal = decimal.Parse(precioRaw, new System.Globalization.CultureInfo("es-AR"));
            }

            int cantidadFinal = int.Parse(txtCantidad.Text);

            if (precioFinal <= 0 || cantidadFinal <= 0)
            {
                lblError.Text = "La cantidad y el precio deben ser mayores a 0.";
                lblError.Visible = true;
                return;
            }

            lblError.Visible = false;
            Producto prod = prodNeg.ObtenerPorId(idProducto);

            CompraLinea nueva = new CompraLinea
            {
                Producto = prod,
                Cantidad = cantidadFinal,
                PrecioUnitario = precioFinal
            };

            Lineas.Add(nueva);
            ActualizarGrid();

            // Deshabilitar proveedor para no mezclar en el mismo remito
            if (Lineas.Count == 1)
            {
                ddlProveedor.Enabled = false;
                txtFecha.Enabled = false;
            }

            // Limpiamos los errores del Footer al agregar con éxito
            lblMensajeFooter.Visible = false;

            ddlProducto.SelectedIndex = 0;
            txtCantidad.Text = "";
            txtPrecio.Text = "";
        }

        protected void gvLineas_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Eliminar")
            {
                int index;
                if (!int.TryParse(e.CommandArgument.ToString(), out index)) return;
                if (index < 0 || index >= Lineas.Count) return;

                Lineas.RemoveAt(index);
                ActualizarGrid();

                // Limpiamos el cartel de error al quitar productos
                lblMensajeFooter.Visible = false;

                if (Lineas.Count == 0)
                {
                    ddlProveedor.Enabled = true;
                    txtFecha.Enabled = true;
                }
            }
        }

        private void ActualizarGrid()
        {
            gvLineas.DataSource = Lineas;
            gvLineas.DataBind();

            decimal total = 0;
            foreach (var l in Lineas)
                total += l.Subtotal;

            lblTotal.Text = total.ToString("C");
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            try
            {
                // Aseguramos cerrar el modal de seguridad antes de continuar
                ScriptManager.RegisterStartupScript(this, this.GetType(), "PopCerrar", "cerrarModalSeguridad();", true);

                lblMensajeFooter.Visible = false;
                lblMensajeFooter.Text = "";

                bool proveedorVacio = ddlProveedor.SelectedValue == "0";
                bool sinProductos = (Lineas == null || Lineas.Count == 0);

                if (proveedorVacio || sinProductos)
                {
                    lblMensajeFooter.Text = "Es necesario seleccionar un proveedor y agregar al menos un producto al detalle.";
                    lblMensajeFooter.Visible = true;
                    return;
                }

                if (string.IsNullOrWhiteSpace(txtFecha.Text))
                {
                    lblMensajeFooter.Text = "Debe ingresar la fecha de la compra.";
                    lblMensajeFooter.Visible = true;
                    return;
                }

                DateTime fechaCompra;
                if (!DateTime.TryParse(txtFecha.Text, out fechaCompra))
                {
                    lblMensajeFooter.Text = "La fecha de la compra no tiene un formato válido.";
                    lblMensajeFooter.Visible = true;
                    return;
                }

                if (fechaCompra.Date > DateTime.Today)
                {
                    lblMensajeFooter.Text = "La fecha de la compra no puede ser futura.";
                    lblMensajeFooter.Visible = true;
                    return;
                }

                CompraNegocio negocio = new CompraNegocio();

                if (Session["Usuario"] == null)
                {
                    // Fallback de seguridad si se perdió la sesión
                    Session["Usuario"] = new Usuario
                    {
                        Id = 1,
                        Nombre = "Admin Temporal"
                    };
                }

                Compra compra = new Compra
                {
                    Proveedor = new Proveedor { Id = int.Parse(ddlProveedor.SelectedValue) },
                    Fecha = fechaCompra,
                    Usuario = (Usuario)Session["Usuario"],
                    Observaciones = txtObservaciones.Text,
                    Lineas = Lineas
                };

                negocio.Registrar(compra);
                Session.Remove("LineasCompra");

                // Abrimos el Modal de Éxito
                ScriptManager.RegisterStartupScript(this, this.GetType(), "PopExito", "mostrarModalExito();", true);
            }
            catch (Exception ex)
            {
                lblMensajeFooter.Text = "Error al procesar la compra: " + ex.Message;
                lblMensajeFooter.Visible = true;
            }
        }

        protected void btnConfirmarCancelar_Click(object sender, EventArgs e)
        {
            Session.Remove("LineasCompra");
            Response.Redirect("Compras.aspx", false);
        }

        protected void btnCancelar_Click(object sender, EventArgs e)
        {
            Session.Remove("LineasCompra");
            Response.Redirect("Compras.aspx", false);
        }
    }
}