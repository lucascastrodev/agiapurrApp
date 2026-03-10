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
                    // Cambiamos el texto del botón que abre el modal
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
                ddlCondicionIVA.SelectedValue = c.CondicionIVA;
                ViewState["idCliente"] = id;
            }
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            // Cerramos forzosamente el modal de pregunta para que no quede tildado en pantalla
            ScriptManager.RegisterStartupScript(this, this.GetType(), "PopCerrar", "cerrarModalSeguridad();", true);

            lblError.Text = ""; // Limpiamos mensaje de error previo

            // Forzamos la validación (Soluciona el error Page.IsValid)
            Page.Validate();

            if (!Page.IsValid)
            {
                return;
            }

            ClienteNegocio negocio = new ClienteNegocio();
            Cliente c = new Cliente
            {
                Nombre = txtNombre.Text.Trim(),
                Documento = txtDocumento.Text.Trim(),
                Email = txtEmail.Text.Trim(),
                Telefono = txtTelefono.Text.Trim(),
                Direccion = txtDireccion.Text.Trim(),
                Localidad = txtLocalidad.Text.Trim(),
                Observaciones = txtObservaciones.Text.Trim(),
                CondicionIVA = ddlCondicionIVA.SelectedValue,
                IdUsuarioAlta = (int)Session["UsuarioId"]
            };

            if (ViewState["idCliente"] != null)
                c.Id = (int)ViewState["idCliente"];

            try
            {
                negocio.Guardar(c);

                // Configuramos el mensaje del modal según si es alta o edición
                lblMensajeExitoModal.Text = c.Id > 0
                    ? "Los datos del cliente han sido actualizados correctamente."
                    : "El nuevo cliente ha sido registrado en el sistema con éxito.";

                // Abrimos el modal de éxito final
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