using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using Dominio;
using Negocio;

namespace TPC_Equipo20B
{
    public partial class AgregarProducto : Page
    {
        private int IdProducto
        {
            get { return ViewState["IdProducto"] != null ? (int)ViewState["IdProducto"] : 0; }
            set { ViewState["IdProducto"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            Permisos.RequiereAdmin(this);

            if (!IsPostBack)
            {
                try
                {
                    CargarCombos();
                    ConfigurarPermisosStock();

                    if (!string.IsNullOrEmpty(Request.QueryString["id"]))
                    {
                        if (int.TryParse(Request.QueryString["id"], out int id))
                        {
                            IdProducto = id;
                            CargarDatosProducto(id);
                            CargarProveedores(id);

                            lblTitulo.InnerText = "Editar Producto";
                            btnProcesarUI.InnerHtml = "<span class=\"material-symbols-outlined fs-5\">save_as</span> Guardar Cambios";
                        }
                    }
                    else
                    {
                        txtStockActual.Text = "0";
                        txtPrecioNeto.Text = "0.00";
                        CargarProveedores(null);
                        lblTitulo.InnerText = "Agregar Nuevo Producto";
                        // Por defecto mostramos ganancia
                        ConfigurarVisibilidadGanancia(true);
                    }
                }
                catch (Exception ex)
                {
                    MostrarMensaje("Error al iniciar la página: " + ex.Message, false);
                }
            }
        }

        // --- NUEVO: EVENTO AL CLICKEAR EL CHECKBOX ---
        protected void chkSel_CheckedChanged(object sender, EventArgs e)
        {
            bool hayProveedorConIva = false;

            // Recorremos la grilla para ver qué se seleccionó
            foreach (GridViewRow row in gvProveedores.Rows)
            {
                CheckBox chk = (CheckBox)row.FindControl("chkSel");
                HiddenField hdnIva = (HiddenField)row.FindControl("hdnVendeConIVA");

                if (chk != null && chk.Checked && hdnIva != null)
                {
                    // Si encontramos UNO con IVA, la regla de ocultar se activa
                    if (bool.TryParse(hdnIva.Value, out bool vendeConIva) && vendeConIva)
                    {
                        hayProveedorConIva = true;
                        break;
                    }
                }
            }

            // Si hay proveedor con IVA, OCULTAMOS (false). Si no, MOSTRAMOS (true).
            ConfigurarVisibilidadGanancia(!hayProveedorConIva);
        }

        // --- MÉTODO HELPER PARA OCULTAR/MOSTRAR Y APAGAR VALIDADORES ---
        private void ConfigurarVisibilidadGanancia(bool visible)
        {
            divGanancia.Visible = visible;

            // Importante: Apagamos los validadores para que deje guardar si está oculto
            rfvGanancia.Enabled = visible;
            revGanancia.Enabled = visible;

            if (!visible)
            {
                txtGanancia.Text = "0"; // Valor por defecto para que no falle la lógica matemática
            }
        }

        private void ConfigurarPermisosStock()
        {
            bool esAdmin = Session["EsAdmin"] != null && (bool)Session["EsAdmin"];
            txtStockActual.ReadOnly = !esAdmin;
            txtStockActual.Enabled = esAdmin;
        }

        private void CargarCombos()
        {
            MarcaNegocio marcaNegocio = new MarcaNegocio();
            CategoriaNegocio categoriaNegocio = new CategoriaNegocio();

            ddlMarca.DataSource = marcaNegocio.Listar();
            ddlMarca.DataTextField = "Nombre";
            ddlMarca.DataValueField = "Id";
            ddlMarca.DataBind();
            ddlMarca.Items.Insert(0, new ListItem("Seleccione una marca...", "0"));

            ddlCategoria.DataSource = categoriaNegocio.Listar();
            ddlCategoria.DataTextField = "Nombre";
            ddlCategoria.DataValueField = "Id";
            ddlCategoria.DataBind();
            ddlCategoria.Items.Insert(0, new ListItem("Seleccione una categoría...", "0"));
        }

        private void CargarDatosProducto(int id)
        {
            ProductoNegocio negocio = new ProductoNegocio();
            Producto producto = negocio.ObtenerPorId(id);

            if (producto != null)
            {
                txtDescripcion.Text = producto.Descripcion;
                txtStockMinimo.Text = producto.StockMinimo.ToString("0.00");
                txtStockActual.Text = producto.StockActual.ToString("0.00");
                txtPrecioNeto.Text = producto.PrecioNeto.ToString("0.00");
                txtGanancia.Text = producto.PorcentajeGanancia.ToString("0.00");
                chkHabilitado.Checked = producto.Habilitado;
                txtSKU.Text = producto.CodigoSKU;

                if (producto.Marca != null && ddlMarca.Items.FindByValue(producto.Marca.Id.ToString()) != null)
                    ddlMarca.SelectedValue = producto.Marca.Id.ToString();

                if (producto.Categoria != null && ddlCategoria.Items.FindByValue(producto.Categoria.Id.ToString()) != null)
                    ddlCategoria.SelectedValue = producto.Categoria.Id.ToString();

                // Lógica inicial: Si el producto ya tiene un proveedor con IVA, ocultamos el campo
                bool tieneIva = producto.Proveedor != null && producto.Proveedor.VendeConIVA;
                ConfigurarVisibilidadGanancia(!tieneIva);
            }
        }

        private decimal ParsearDecimalSeguro(string valor)
        {
            if (string.IsNullOrWhiteSpace(valor)) return 0;
            string normalizado = valor.Replace(",", ".");
            decimal.TryParse(normalizado, NumberStyles.Any, CultureInfo.InvariantCulture, out decimal resultado);
            return resultado;
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "PopCerrar", "cerrarModalSeguridad();", true);

            pnlMensaje.Visible = false;
            Page.Validate();
            if (!Page.IsValid) return;

            try
            {
                ProductoNegocio negocio = new ProductoNegocio();

                decimal stockMin = ParsearDecimalSeguro(txtStockMinimo.Text);
                decimal ganancia = ParsearDecimalSeguro(txtGanancia.Text);
                decimal precioNeto = ParsearDecimalSeguro(txtPrecioNeto.Text);
                decimal stockFinal = 0;

                if (IdProducto > 0)
                {
                    Producto actual = negocio.ObtenerPorId(IdProducto);
                    bool esAdmin = Session["EsAdmin"] != null && (bool)Session["EsAdmin"];
                    if (esAdmin) stockFinal = ParsearDecimalSeguro(txtStockActual.Text);
                    else stockFinal = actual != null ? actual.StockActual : 0;
                }
                else
                {
                    stockFinal = ParsearDecimalSeguro(txtStockActual.Text);
                }

                Producto p = new Producto
                {
                    Id = IdProducto,
                    Descripcion = txtDescripcion.Text.Trim(),
                    CodigoSKU = string.IsNullOrWhiteSpace(txtSKU.Text) ? null : txtSKU.Text.Trim(),
                    StockMinimo = stockMin,
                    StockActual = stockFinal,
                    PrecioNeto = precioNeto,
                    PorcentajeGanancia = ganancia,
                    Habilitado = chkHabilitado.Checked,
                    Marca = new Marca { Id = int.Parse(ddlMarca.SelectedValue) },
                    Categoria = new Categoria { Id = int.Parse(ddlCategoria.SelectedValue) }
                };

                negocio.Guardar(p);
                ActualizarProveedores(p.Id);

                lblMensajeExitoModal.Text = IdProducto > 0
                    ? "El producto ha sido actualizado correctamente."
                    : "El producto ha sido registrado en el catálogo con éxito.";

                ScriptManager.RegisterStartupScript(this, this.GetType(), "PopExito", "mostrarModalExito();", true);
            }
            catch (Exception ex)
            {
                if (ex.Message.Contains("mismo código SKU"))
                {
                    MostrarMensaje("⚠️ El código SKU ya pertenece a otro producto.", false);
                    txtSKU.Focus();
                }
                else
                {
                    MostrarMensaje("Ocurrió un error al guardar: " + ex.Message, false);
                }
            }
        }

        private void ActualizarProveedores(int idProd)
        {
            List<int> seleccionados = new List<int>();
            foreach (GridViewRow row in gvProveedores.Rows)
            {
                CheckBox chk = (CheckBox)row.FindControl("chkSel");
                if (chk != null && chk.Checked)
                {
                    seleccionados.Add(Convert.ToInt32(gvProveedores.DataKeys[row.RowIndex].Value));
                }
            }
            new ProductoNegocio().ActualizarProveedoresProducto(idProd, seleccionados);
        }

        private void CargarProveedores(int? idProd = null)
        {
            ProveedorNegocio provNeg = new ProveedorNegocio();
            gvProveedores.DataSource = provNeg.Listar();
            gvProveedores.DataBind();

            if (idProd.HasValue)
            {
                var asociados = new ProductoNegocio().ObtenerProveedoresPorProducto(idProd.Value);
                // También verificamos si alguno tiene IVA al cargar
                bool tieneIva = false;
                ProveedorNegocio pNeg = new ProveedorNegocio();
                // Nota: ObtenerProveedoresPorProducto solo trae IDs. 
                // La verificación real de IVA se hizo en CargarDatosProducto usando el objeto completo.

                foreach (GridViewRow row in gvProveedores.Rows)
                {
                    int idProv = Convert.ToInt32(gvProveedores.DataKeys[row.RowIndex].Value);
                    ((CheckBox)row.FindControl("chkSel")).Checked = asociados.Contains(idProv);
                }
            }
        }

        protected void btnBuscarProveedor_Click(object sender, EventArgs e)
        {
            string q = txtBuscarProveedor.Text.Trim();
            gvProveedores.DataSource = new ProveedorNegocio().Listar(q);
            gvProveedores.DataBind();

            if (IdProducto > 0) CargarProveedores(IdProducto);
        }

        protected void btnCancelar_Click(object sender, EventArgs e)
        {
            Response.Redirect("Productos.aspx", false);
        }

        private void MostrarMensaje(string mensaje, bool esExito)
        {
            pnlMensaje.Visible = true;
            lblMensaje.Text = mensaje;
            pnlMensaje.CssClass = esExito ? "alert alert-success alert-dismissible fade show mb-3"
                                          : "alert alert-danger alert-dismissible fade show mb-3";
        }
    }
}