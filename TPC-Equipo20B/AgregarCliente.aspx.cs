using Dominio;
using Negocio;
using System;
using System.Web.UI;

namespace TPC_Equipo20B
{
    public partial class AgregarCliente : System.Web.UI.Page
    {
        private int idCliente = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            Permisos.RequiereAdmin(this);

            if (!IsPostBack)
            {
                txtNombre.Focus();

                if (Request.QueryString["id"] != null)
                {
                    idCliente = int.Parse(Request.QueryString["id"]);
                    CargarCliente(idCliente);

                    lblTitulo.InnerText = "Editar Cliente";
                    btnProcesarUI.InnerHtml = "<span class=\"material-symbols-outlined fs-5\">save_as</span> Guardar Cambios";
                }
            }
        }

        private void CargarCliente(int id)
        {
            ClienteNegocio negocio = new ClienteNegocio();
            Cliente c = negocio.BuscarPorId(id);

            if (c != null)
            {
                txtNombre.Text = c.Nombre;
                txtDocumento.Text = c.Documento;
                txtEmail.Text = c.Email;
                txtTelefono.Text = c.Telefono;
                txtDireccion.Text = c.Direccion;
                txtLocalidad.Text = c.Localidad;
                txtObservaciones.Text = c.Observaciones;

                if (!string.IsNullOrEmpty(c.CondicionIVA))
                    ddlCondicionIVA.SelectedValue = c.CondicionIVA;

                ViewState["idCliente"] = id;
            }
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "PopCerrar", "cerrarModalSeguridad();", true);
            lblError.Text = "";
            Page.Validate();

            if (!Page.IsValid)
            {
                return;
            }

            ClienteNegocio negocio = new ClienteNegocio();
            Cliente c = new Cliente
            {
                Nombre = txtNombre.Text.Trim(),

                // Si están vacíos, los mandamos como nulos para la BD
                Documento = string.IsNullOrWhiteSpace(txtDocumento.Text) ? null : txtDocumento.Text.Trim(),
                Email = string.IsNullOrWhiteSpace(txtEmail.Text) ? null : txtEmail.Text.Trim(),
                Direccion = string.IsNullOrWhiteSpace(txtDireccion.Text) ? null : txtDireccion.Text.Trim(),
                Localidad = string.IsNullOrWhiteSpace(txtLocalidad.Text) ? null : txtLocalidad.Text.Trim(),
                CondicionIVA = ddlCondicionIVA.SelectedValue == "Seleccione..." ? null : ddlCondicionIVA.SelectedValue,

                Telefono = txtTelefono.Text.Trim(), // Obligatorio

                // Excepción a la regla: La BD no acepta nulos acá, mandamos cadena vacía ""
                Observaciones = string.IsNullOrWhiteSpace(txtObservaciones.Text) ? "" : txtObservaciones.Text.Trim(),

                IdUsuarioAlta = (int)Session["UsuarioId"]
            };

            if (ViewState["idCliente"] != null)
                c.Id = (int)ViewState["idCliente"];

            try
            {
                negocio.Guardar(c);

                lblMensajeExitoModal.Text = c.Id > 0
                    ? "Los datos del cliente han sido actualizados correctamente."
                    : "El nuevo cliente ha sido registrado en el sistema con éxito.";

                ScriptManager.RegisterStartupScript(this, this.GetType(), "PopExito", "mostrarModalExito();", true);
            }
            catch (Exception ex)
            {
                lblError.Text = "Ocurrió un error al guardar: " + ex.Message;
            }
        }

        protected void btnCancelar_Click(object sender, EventArgs e)
        {
            Response.Redirect("Clientes.aspx", false);
        }
    }
}