using Dominio;
using Negocio;
using System;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TPC_Equipo20B
{
    public partial class AgregarProveedor : System.Web.UI.Page
    {
        private readonly ProveedorNegocio _negocio = new ProveedorNegocio();
        private int Id => int.TryParse(Request.QueryString["id"], out var x) ? x : 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            Permisos.RequiereAdmin(this);

            if (!IsPostBack)
            {
                txtNombre.Focus();

                if (Id != 0)
                {
                    lblTitulo.InnerText = "Editar Proveedor";
                    btnProcesarUI.InnerHtml = "<span class=\"material-symbols-outlined fs-5\">save_as</span> Guardar Cambios";

                    var p = _negocio.BuscarPorId(Id);
                    if (p != null)
                    {
                        txtNombre.Text = p.Nombre;
                        txtRazonSocial.Text = p.RazonSocial;
                        txtDocumento.Text = p.Documento;
                        txtEmail.Text = p.Email;
                        txtTelefono.Text = p.Telefono;
                        txtDireccion.Text = p.Direccion;
                        txtLocalidad.Text = p.Localidad;
                        ddlFacturaIVA.SelectedValue = p.VendeConIVA ? "true" : "false";

                        // CARGAMOS LOS IMPUESTOS AL EDITAR
                        txtDescuento.Text = p.DescuentoHabitual.ToString("0.00");
                        txtIVA.Text = p.PorcentajeIVA.ToString("0.00");
                        txtIIBB.Text = p.PorcentajeIIBB.ToString("0.00");
                        txtPercepcion.Text = p.PorcentajePercepcion.ToString("0.00");
                    }
                }
            }
        }

        protected void cvNombreRazon_ServerValidate(object source, ServerValidateEventArgs args)
        {
            args.IsValid = !string.IsNullOrEmpty(txtNombre.Text) || !string.IsNullOrEmpty(txtRazonSocial.Text);
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            // Cerramos el modal de pregunta para que no tape el de éxito
            ScriptManager.RegisterStartupScript(this, this.GetType(), "PopCerrar", "cerrarModalSeguridad();", true);

            lblError.Text = "";
            Page.Validate("GuardarProveedor");

            if (!Page.IsValid) return;

            try
            {
                Proveedor p = new Proveedor
                {
                    Id = Id,
                    Nombre = txtNombre.Text.Trim(),
                    RazonSocial = txtRazonSocial.Text.Trim(),
                    Documento = txtDocumento.Text.Trim(),
                    Email = txtEmail.Text.Trim(),
                    Telefono = txtTelefono.Text.Trim(),
                    Direccion = txtDireccion.Text.Trim(),
                    Localidad = txtLocalidad.Text.Trim(),
                    CondicionIVA = ddlFacturaIVA.SelectedItem.Text,
                    VendeConIVA = bool.Parse(ddlFacturaIVA.SelectedValue),

                    // Normalizamos puntos por comas para evitar errores de parseo regional
                    DescuentoHabitual = decimal.Parse(txtDescuento.Text.Replace(".", ",")),
                    PorcentajeIVA = decimal.Parse(txtIVA.Text.Replace(".", ",")),
                    PorcentajeIIBB = decimal.Parse(txtIIBB.Text.Replace(".", ",")),
                    PorcentajePercepcion = decimal.Parse(txtPercepcion.Text.Replace(".", ","))
                };

                _negocio.Guardar(p);

                lblMensajeExitoModal.Text = Id > 0
                    ? "Los datos de la empresa proveedora han sido actualizados correctamente."
                    : "La nueva empresa proveedora ha sido registrada en el sistema con éxito.";

                ScriptManager.RegisterStartupScript(this, this.GetType(), "PopExito", "mostrarModalExito();", true);
            }
            catch (Exception ex)
            {
                lblError.Text = "Ocurrió un error al guardar: " + ex.Message;
            }
        }

        protected void btnCancelar_Click(object sender, EventArgs e)
        {
            Response.Redirect("Proveedores.aspx", false);
        }
    }
}