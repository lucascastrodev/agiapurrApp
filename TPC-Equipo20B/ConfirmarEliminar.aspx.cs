using Dominio;
using Negocio;
using System;

namespace TPC_Equipo20B
{
    public partial class ConfirmarEliminar : System.Web.UI.Page
    {
        private string Entidad => (Request.QueryString["tipo"] ?? "").ToLowerInvariant();
        private int Id => int.TryParse(Request.QueryString["id"], out var x) ? x : 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session["VolverA"] = Request.UrlReferrer?.ToString();
                lblMensaje.Text = Server.UrlDecode(Request.QueryString["msg"] ?? "¿Confirmar eliminación?");

                if (Entidad == "compra" || Entidad == "venta")
                    panelMotivo.Visible = true;
            }
        }

        protected void btnCancelar_Click(object sender, EventArgs e)
        {
            Volver();
        }

        protected void btnConfirmar_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            if (Id == 0) { Volver(); return; }

            try
            {

                switch (Entidad)
            {
                case "producto":
                    new ProductoNegocio().Eliminar(Id);
                    Response.Redirect("Productos.aspx");
                    return;

                case "categoria":
                    new CategoriaNegocio().Eliminar(Id);
                    Response.Redirect("Categorias.aspx");
                    return;

                case "marca":
                    new MarcaNegocio().Eliminar(Id);
                    Response.Redirect("Marcas.aspx");
                    return;

                case "proveedor":
                    new ProveedorNegocio().Eliminar(Id);
                    Response.Redirect("Proveedores.aspx");
                    return;

                case "cliente":
                    new ClienteNegocio().Eliminar(Id);
                    Response.Redirect("Clientes.aspx");
                    return;

                case "compra":

                     // Motivo ingresado
                     string motivo = txtMotivo.Text.Trim();

                     // Usuario actual (provisorio hasta que haya login real)
                     var usuario = (Usuario)Session["usuario"];
                     int idUsuario = usuario != null ? usuario.Id : 1;

                     // Cancelar la compra
                     new CompraNegocio().Cancelar(Id, motivo, idUsuario);

                     Response.Redirect("Compras.aspx");
                     return;

                    case "venta":
                        string mot = txtMotivo.Text.Trim();
                        var usu = (Usuario)Session["usuario"];
                        int idUsu = usu != null ? usu.Id : 1;

                        new VentaNegocio().Cancelar(Id, mot, idUsu);
                        Response.Redirect("Ventas.aspx");
                        return;


                    default:
                 Volver();
                 return;
            }
          }

            catch (Exception ex)
            {
                lblMensaje.Text = ex.Message;
            }
        }

        private void Volver()
        {
            var url = Session["VolverA"] as string;

            if (!string.IsNullOrEmpty(url))
                Response.Redirect(url);
            else
                Response.Redirect("Dashboard.aspx");
        }
    }
}
