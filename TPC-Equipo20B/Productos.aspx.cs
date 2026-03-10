using Negocio;
using Dominio;
using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Globalization;

namespace TPC_Equipo20B
{
    public partial class Productos : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarCombos();
                ConfigurarPantallaPorRol();
                Bind();
            }
        }

        private void ConfigurarPantallaPorRol()
        {
            bool esAdmin = Session["EsAdmin"] != null && (bool)Session["EsAdmin"];
            ddlProveedor.Visible = esAdmin;
        }

        private void CargarCombos()
        {
            var provNegocio = new ProveedorNegocio();
            var listaProv = provNegocio.Listar();

            ddlProveedor.DataSource = listaProv;
            ddlProveedor.DataTextField = "Nombre";
            ddlProveedor.DataValueField = "Id";
            ddlProveedor.DataBind();
            ddlProveedor.Items.Insert(0, new ListItem("Todos los proveedores", "0"));

            ddlProveedorModal.DataSource = listaProv;
            ddlProveedorModal.DataTextField = "Nombre";
            ddlProveedorModal.DataValueField = "Id";
            ddlProveedorModal.DataBind();
            ddlProveedorModal.Items.Insert(0, new ListItem("-- Seleccione un proveedor --", "0"));

            // Eliminé ddlProductoModal porque ya no se usa (la selección es por checkbox)

            var marcaNegocio = new MarcaNegocio();
            ddlMarcaModal.DataSource = marcaNegocio.Listar().OrderBy(m => m.Nombre).ToList();
            ddlMarcaModal.DataTextField = "Nombre";
            ddlMarcaModal.DataValueField = "Id";
            ddlMarcaModal.DataBind();
            ddlMarcaModal.Items.Insert(0, new ListItem("-- Seleccione una marca --", "0"));
        }

        private void Bind(string q = null, int? idProveedor = null)
        {
            var negocio = new ProductoNegocio();
            var lista = negocio.Listar(q, idProveedor);

            if (chkSoloHabilitados.Checked)
                lista = lista.Where(x => x.Habilitado).ToList();

            TextInfo textInfo = new CultureInfo("es-AR", false).TextInfo;
            foreach (var item in lista)
            {
                if (!string.IsNullOrEmpty(item.Descripcion)) item.Descripcion = textInfo.ToTitleCase(item.Descripcion.ToLower());
                if (item.Categoria != null && !string.IsNullOrEmpty(item.Categoria.Nombre)) item.Categoria.Nombre = textInfo.ToTitleCase(item.Categoria.Nombre.ToLower());
                if (item.Marca != null && !string.IsNullOrEmpty(item.Marca.Nombre)) item.Marca.Nombre = textInfo.ToTitleCase(item.Marca.Nombre.ToLower());
                if (item.Proveedor != null && !string.IsNullOrEmpty(item.Proveedor.Nombre)) item.Proveedor.Nombre = textInfo.ToTitleCase(item.Proveedor.Nombre.ToLower());
            }

            gvProductos.DataSource = lista;
            gvProductos.DataBind();
        }

        protected void btnAgregarProducto_Click(object sender, EventArgs e)
        {
            Response.Redirect("AgregarProducto.aspx");
        }

        protected void btnBuscarProducto_Click(object sender, EventArgs e)
        {
            pnlNotificacion.Visible = false;
            var q = txtBuscarProducto.Text.Trim();
            int idProv;

            if (ddlProveedor.Visible && int.TryParse(ddlProveedor.SelectedValue, out idProv) && idProv > 0)
                Bind(q, idProv);
            else
                Bind(q, null);
        }

        protected void ddlProveedor_SelectedIndexChanged(object sender, EventArgs e)
        {
            btnBuscarProducto_Click(sender, e);
        }

        protected void gvProductos_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Editar") Response.Redirect("AgregarProducto.aspx?id=" + e.CommandArgument);
            if (e.CommandName == "Eliminar") Response.Redirect("ConfirmarEliminar.aspx?tipo=producto&id=" + e.CommandArgument);
        }

        protected void gvProductos_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            bool esAdmin = (bool)(Session["EsAdmin"] ?? false);

            if (e.Row.RowType == DataControlRowType.Header || e.Row.RowType == DataControlRowType.DataRow)
            {
                // DEFINICIÓN DE ÍNDICES
                int indexCheck = 0;      // La columna de selección (NUEVA)
                int indexProveedor = 4;  // Proveedor
                int indexPrecioCF = 6;   // Precio Final
                int indexAcciones = gvProductos.Columns.Count - 1; // Botones de acción

                // REGLAS DE VISIBILIDAD
                // Si no es admin, ocultamos todas estas columnas
                e.Row.Cells[indexCheck].Visible = esAdmin;     // <-- ESTA ES LA LÍNEA NUEVA
                e.Row.Cells[indexProveedor].Visible = esAdmin;
                e.Row.Cells[indexPrecioCF].Visible = esAdmin;
                e.Row.Cells[indexAcciones].Visible = esAdmin;
            }

            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                Producto prod = (Producto)e.Row.DataItem;

                // 1. SI ESTÁ DESHABILITADO: GRIS
                if (!prod.Habilitado)
                {
                    e.Row.CssClass = "fila-deshabilitada";
                }
                else
                {
                    // 2. SI AUMENTÓ EN LA ÚLTIMA SEMANA: VERDE
                    if (prod.PreciosCompra != null && prod.PreciosCompra.Any())
                    {
                        var ultimoPrecio = prod.PreciosCompra.First();

                        if ((DateTime.Now - ultimoPrecio.Fecha).TotalDays <= 7)
                        {
                            bool huboAumento = false;
                            if (prod.PreciosCompra.Count > 1)
                            {
                                var precioAnterior = prod.PreciosCompra[1];
                                if (ultimoPrecio.PrecioUnitario > precioAnterior.PrecioUnitario) huboAumento = true;
                            }
                            else
                            {
                                if (ultimoPrecio.PrecioUnitario > 0) huboAumento = true;
                            }

                            if (huboAumento) e.Row.CssClass += " fila-precio-nuevo";
                        }
                    }
                }

                Label lblStock = (Label)e.Row.FindControl("lblStock");
                if (lblStock != null)
                {
                    decimal stock = prod.StockActual;
                    if (!esAdmin)
                    {
                        if (stock <= 0) lblStock.Text = "<span class='badge bg-danger'>Agotado</span>";
                        else if (stock < 20) lblStock.Text = "<span class='badge bg-warning text-dark'>Últimas unidades</span>";
                        else lblStock.Text = "<span class='badge bg-success'>Disponible</span>";
                    }
                    else
                    {
                        lblStock.Text = stock.ToString("N2");
                    }
                }
            }
        }

        protected void chkSoloHabilitados_CheckedChanged(object sender, EventArgs e) { btnBuscarProducto_Click(sender, e); }

        protected void gvProductos_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvProductos.PageIndex = e.NewPageIndex;
            btnBuscarProducto_Click(sender, e);
        }

        protected void gvProductos_Sorting(object sender, GridViewSortEventArgs e)
        {
            gvProductos.PageIndex = 0;
            var negocio = new ProductoNegocio();

            int? idProv = null;
            if (ddlProveedor.Visible && int.TryParse(ddlProveedor.SelectedValue, out int temp) && temp > 0) idProv = temp;

            var lista = negocio.Listar(txtBuscarProducto.Text.Trim(), idProv);
            if (chkSoloHabilitados.Checked) lista = lista.Where(x => x.Habilitado).ToList();

            if (ViewState["SortExpression"] as string == e.SortExpression)
                ViewState["SortDirection"] = (string)ViewState["SortDirection"] == "ASC" ? "DESC" : "ASC";
            else
            {
                ViewState["SortExpression"] = e.SortExpression;
                ViewState["SortDirection"] = "ASC";
            }

            string direction = ViewState["SortDirection"].ToString();
            string expr = e.SortExpression;

            if (direction == "ASC") lista = lista.OrderBy(p => DataBinder.Eval(p, expr)).ToList();
            else lista = lista.OrderByDescending(p => DataBinder.Eval(p, expr)).ToList();

            TextInfo textInfo = new CultureInfo("es-AR", false).TextInfo;
            foreach (var item in lista)
            {
                if (!string.IsNullOrEmpty(item.Descripcion)) item.Descripcion = textInfo.ToTitleCase(item.Descripcion.ToLower());
                if (item.Categoria != null && !string.IsNullOrEmpty(item.Categoria.Nombre)) item.Categoria.Nombre = textInfo.ToTitleCase(item.Categoria.Nombre.ToLower());
                if (item.Marca != null && !string.IsNullOrEmpty(item.Marca.Nombre)) item.Marca.Nombre = textInfo.ToTitleCase(item.Marca.Nombre.ToLower());
                if (item.Proveedor != null && !string.IsNullOrEmpty(item.Proveedor.Nombre)) item.Proveedor.Nombre = textInfo.ToTitleCase(item.Proveedor.Nombre.ToLower());
            }

            gvProductos.DataSource = lista;
            gvProductos.DataBind();
        }

        protected void btnAplicarAumento_Click(object sender, EventArgs e)
        {
            try
            {
                int idProv;
                if (!int.TryParse(ddlProveedorModal.SelectedValue, out idProv) || idProv == 0) return;

                string textoPorc = txtPorcentajeModal.Text.Trim();
                decimal porcentaje;

                if (textoPorc.Contains(".") && !textoPorc.Contains(",")) porcentaje = decimal.Parse(textoPorc, CultureInfo.InvariantCulture);
                else porcentaje = decimal.Parse(textoPorc, new CultureInfo("es-AR"));

                if (porcentaje > 0)
                {
                    ProductoNegocio negocio = new ProductoNegocio();
                    int productosAfectados = negocio.AumentarPreciosPorProveedor(idProv, porcentaje);
                    txtPorcentajeModal.Text = "";

                    btnBuscarProducto_Click(null, null);

                    pnlNotificacion.Visible = true;
                    pnlNotificacion.CssClass = "alert alert-success alert-dismissible fade show mb-3 shadow-sm";
                    lblNotificacion.Text = $"<i class='bi bi-check-circle-fill me-2'></i><strong>¡Éxito!</strong> Se aumentó el costo de {productosAfectados} productos del proveedor.";
                }
            }
            catch (Exception)
            {
                pnlNotificacion.Visible = true;
                pnlNotificacion.CssClass = "alert alert-danger alert-dismissible fade show mb-3 shadow-sm";
                lblNotificacion.Text = "<i class='bi bi-exclamation-triangle-fill me-2'></i><strong>¡Error!</strong> Verifique el formato numérico.";
            }
        }

        // --- MODIFICADO: Aumento para múltiples productos seleccionados ---
        protected void btnAplicarAumentoIndividual_Click(object sender, EventArgs e)
        {
            try
            {
                string textoPorc = txtPorcentajeIndividual.Text.Trim();
                decimal porcentaje;

                if (textoPorc.Contains(".") && !textoPorc.Contains(",")) porcentaje = decimal.Parse(textoPorc, CultureInfo.InvariantCulture);
                else porcentaje = decimal.Parse(textoPorc, new CultureInfo("es-AR"));

                if (porcentaje <= 0) return;

                int contadores = 0;
                ProductoNegocio negocio = new ProductoNegocio();

                // Recorremos la grilla buscando los tildados
                foreach (GridViewRow row in gvProductos.Rows)
                {
                    CheckBox chk = (CheckBox)row.FindControl("chkSeleccion");
                    if (chk != null && chk.Checked)
                    {
                        int idProd = Convert.ToInt32(gvProductos.DataKeys[row.RowIndex].Value);
                        negocio.AumentarPrecioProducto(idProd, porcentaje);
                        contadores++;
                    }
                }

                if (contadores > 0)
                {
                    txtPorcentajeIndividual.Text = "";
                    btnBuscarProducto_Click(null, null); // Recargar grilla

                    pnlNotificacion.Visible = true;
                    pnlNotificacion.CssClass = "alert alert-success alert-dismissible fade show mb-3 shadow-sm";
                    lblNotificacion.Text = $"<i class='bi bi-check-circle-fill me-2'></i><strong>¡Éxito!</strong> Se actualizaron {contadores} productos seleccionados.";
                }
                else
                {
                    pnlNotificacion.Visible = true;
                    pnlNotificacion.CssClass = "alert alert-warning alert-dismissible fade show mb-3 shadow-sm";
                    lblNotificacion.Text = "<i class='bi bi-exclamation-circle-fill me-2'></i><strong>Atención:</strong> No seleccionó ningún producto de la lista.";
                }
            }
            catch (Exception)
            {
                pnlNotificacion.Visible = true;
                pnlNotificacion.CssClass = "alert alert-danger alert-dismissible fade show mb-3 shadow-sm";
                lblNotificacion.Text = "<i class='bi bi-exclamation-triangle-fill me-2'></i><strong>¡Error!</strong> Verifique el formato numérico.";
            }
        }

        protected void btnAplicarAumentoMarca_Click(object sender, EventArgs e)
        {
            try
            {
                int idMarca;
                if (!int.TryParse(ddlMarcaModal.SelectedValue, out idMarca) || idMarca == 0) return;

                string textoPorc = txtPorcentajeMarca.Text.Trim();
                decimal porcentaje;

                if (textoPorc.Contains(".") && !textoPorc.Contains(",")) porcentaje = decimal.Parse(textoPorc, CultureInfo.InvariantCulture);
                else porcentaje = decimal.Parse(textoPorc, new CultureInfo("es-AR"));

                if (porcentaje > 0)
                {
                    ProductoNegocio negocio = new ProductoNegocio();
                    int productosAfectados = negocio.AumentarPreciosPorMarca(idMarca, porcentaje);
                    txtPorcentajeMarca.Text = "";

                    btnBuscarProducto_Click(null, null);

                    pnlNotificacion.Visible = true;
                    pnlNotificacion.CssClass = "alert alert-success alert-dismissible fade show mb-3 shadow-sm";
                    lblNotificacion.Text = $"<i class='bi bi-check-circle-fill me-2'></i><strong>¡Éxito!</strong> Se aumentó el costo de {productosAfectados} productos de la marca seleccionada.";
                }
            }
            catch (Exception)
            {
                pnlNotificacion.Visible = true;
                pnlNotificacion.CssClass = "alert alert-danger alert-dismissible fade show mb-3 shadow-sm";
                lblNotificacion.Text = "<i class='bi bi-exclamation-triangle-fill me-2'></i><strong>¡Error!</strong> Verifique el formato numérico.";
            }
        }
    }
}