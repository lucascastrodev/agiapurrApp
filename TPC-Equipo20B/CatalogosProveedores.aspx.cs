using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using Dominio;
using Negocio;

namespace TPC_Equipo20B
{
    public partial class CatalogosProveedores : System.Web.UI.Page
    {
        private ProductoProveedorNegocio _negocio = new ProductoProveedorNegocio();

        protected void Page_Load(object sender, EventArgs e)
        {
            Permisos.RequiereAdmin(this);

            if (!IsPostBack)
            {
                CargarDropdownProveedores();

                // Si venimos de un guardado exitoso (PRG), recuperamos el proveedor
                if (Session["ProvSeleccionado_Cat"] != null)
                {
                    ddlProveedor.SelectedValue = Session["ProvSeleccionado_Cat"].ToString();
                    ddlProveedor_SelectedIndexChanged(null, null); // Forzamos la carga de la grilla
                    Session.Remove("ProvSeleccionado_Cat"); // Limpiamos la sesión
                }
                else
                {
                    lblMensajeVacio.Visible = true;
                }
            }
        }

        private void CargarDropdownProveedores()
        {
            ProveedorNegocio provNeg = new ProveedorNegocio();
            ddlProveedor.DataSource = provNeg.Listar();
            ddlProveedor.DataTextField = "Nombre";
            ddlProveedor.DataValueField = "Id";
            ddlProveedor.DataBind();

            ddlProveedor.Items.Insert(0, new ListItem("--- Seleccione un Proveedor ---", "0"));
        }

        protected void ddlProveedor_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlProveedor.SelectedValue != "0")
            {
                CargarGrilla();
                btnNuevo.Visible = true;
                lblMensajeVacio.Visible = false;
                divGrilla.Visible = true;
            }
            else
            {
                btnNuevo.Visible = false;
                lblMensajeVacio.Visible = true;
                divGrilla.Visible = false;
            }
        }

        private void CargarGrilla()
        {
            int idProv = int.Parse(ddlProveedor.SelectedValue);
            gvCatalogo.DataSource = _negocio.ListarPorProveedor(idProv);
            gvCatalogo.DataBind();
        }

        protected void btnNuevo_Click(object sender, EventArgs e)
        {
            lblModalTitulo.Text = "Nuevo Producto para " + ddlProveedor.SelectedItem.Text;
            hdfIdProducto.Value = "0";
            txtCodigo.Text = "";
            txtDescripcion.Text = "";
            txtPrecio.Text = "";
            txtPack.Text = "1";
            txtDescuento.Text = "0,00";

            ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "var myModal = new bootstrap.Modal(document.getElementById('modalABM')); myModal.show();", true);
        }

        protected void gvCatalogo_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int idProd = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "Editar")
            {
                ProductoProveedor p = _negocio.ObtenerPorId(idProd);
                if (p != null)
                {
                    lblModalTitulo.Text = "Editar Producto";
                    hdfIdProducto.Value = p.Id.ToString();
                    txtCodigo.Text = p.Codigo;
                    txtDescripcion.Text = p.Descripcion;
                    txtPrecio.Text = p.PrecioUnitario.ToString("0.00");
                    txtPack.Text = p.UnidadesPorPack.ToString();
                    txtDescuento.Text = p.PorcentajeDescuento.ToString("0.00");

                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Pop", "var myModal = new bootstrap.Modal(document.getElementById('modalABM')); myModal.show();", true);
                }
            }
            else if (e.CommandName == "Eliminar")
            {
                _negocio.Eliminar(idProd);

                Session["ProvSeleccionado_Cat"] = ddlProveedor.SelectedValue;
                Response.Redirect("CatalogosProveedores.aspx", false);
            }
        }
        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            try
            {
                ProductoProveedor p = new ProductoProveedor();
                p.Id = int.Parse(hdfIdProducto.Value);
                p.Proveedor.Id = int.Parse(ddlProveedor.SelectedValue);
                p.Codigo = txtCodigo.Text.Trim();
                p.Descripcion = txtDescripcion.Text.Trim();

                p.PrecioUnitario = decimal.Parse(txtPrecio.Text.Replace(".", ","));
                p.PorcentajeDescuento = decimal.Parse(txtDescuento.Text.Replace(".", ","));
                p.UnidadesPorPack = int.Parse(txtPack.Text);

                if (p.Id == 0)
                    _negocio.Agregar(p);
                else
                    _negocio.Modificar(p);

                // Novedad: Guardamos el proveedor en sesión y forzamos una recarga limpia (GET)
                Session["ProvSeleccionado_Cat"] = ddlProveedor.SelectedValue;
                Response.Redirect("CatalogosProveedores.aspx", false);
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Alert", $"alert('Error: {ex.Message}');", true);
            }
        }
    }
}