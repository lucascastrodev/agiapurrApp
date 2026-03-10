using System;
using System.Web.UI;
using Negocio;
using Dominio;

namespace TPC_Equipo20B
{
    public partial class AgregarMarca : System.Web.UI.Page
    {
        private readonly MarcaNegocio _negocio = new MarcaNegocio();
        private int Id => int.TryParse(Request.QueryString["id"], out var x) ? x : 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            Permisos.RequiereAdmin(this); // Candado puesto 🔒

            if (!IsPostBack)
            {
                txtNombre.Focus();

                if (Id != 0)
                {
                    lblTitulo.InnerText = "Editar Marca";

                    // Cambiamos el texto del botón que abre el modal
                    btnProcesarUI.InnerHtml = "<span class=\"material-symbols-outlined fs-5\">save_as</span> Guardar Cambios";

                    var lista = _negocio.Listar();
                    var m = lista.Find(x => x.Id == Id);
                    if (m != null) txtNombre.Text = m.Nombre;
                }
            }
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            // Cerramos forzosamente el modal de pregunta para que no quede tildado en pantalla
            ScriptManager.RegisterStartupScript(this, this.GetType(), "PopCerrar", "cerrarModalSeguridad();", true);

            lblError.Text = ""; // Limpiamos errores anteriores

            // Forzamos la validación para evitar el error de Page.IsValid
            Page.Validate();

            if (Page.IsValid)
            {
                try
                {
                    var m = new Dominio.Marca { Id = Id, Nombre = txtNombre.Text.Trim() };

                    if (m.Id == 0)
                        _negocio.Agregar(m);
                    else
                        _negocio.Modificar(m);

                    // Configuramos el mensaje del modal según si es alta o edición
                    lblMensajeExitoModal.Text = m.Id > 0
                        ? "La marca ha sido actualizada correctamente."
                        : "La nueva marca ha sido registrada con éxito.";

                    // Abrimos el modal de éxito final
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "PopExito", "mostrarModalExito();", true);
                }
                catch (Exception ex)
                {
                    lblError.Text = "Ocurrió un error al guardar: " + ex.Message;
                }
            }
        }

        protected void btnCancelar_Click(object sender, EventArgs e)
        {
            Response.Redirect("Marcas.aspx", false);
        }
    }
}