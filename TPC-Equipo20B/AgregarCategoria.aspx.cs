using System;
using System.Web.UI;
using Negocio;
using Dominio;

namespace TPC_Equipo20B
{
    public partial class AgregarCategoria : System.Web.UI.Page
    {
        private readonly CategoriaNegocio _negocio = new CategoriaNegocio();
        private int Id => int.TryParse(Request.QueryString["id"], out var x) ? x : 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            Permisos.RequiereAdmin(this);

            if (!IsPostBack)
            {
                txtNombre.Focus();

                if (Id != 0)
                {
                    lblTitulo.InnerText = "Editar Categoría";

                    // Cambiamos el texto del botón que abre el modal
                    btnProcesarUI.InnerHtml = "<span class=\"material-symbols-outlined fs-5\">save_as</span> Guardar Cambios";

                    var cat = _negocio.ObtenerPorId(Id);
                    if (cat != null) txtNombre.Text = cat.Nombre;
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
                    var cat = new Categoria { Id = Id, Nombre = txtNombre.Text.Trim() };

                    if (cat.Id == 0)
                        _negocio.Agregar(cat);
                    else
                        _negocio.Modificar(cat);

                    // Configuramos el mensaje del modal según si es alta o edición
                    lblMensajeExitoModal.Text = cat.Id > 0
                        ? "La categoría ha sido actualizada correctamente."
                        : "La nueva categoría ha sido registrada con éxito.";

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
            Response.Redirect("Categorias.aspx", false);
        }
    }
}