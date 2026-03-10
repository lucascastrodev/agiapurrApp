using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Dominio;
using Negocio;

namespace TPC_Equipo20B
{
    public partial class CompraDetalle : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                int idCompra;
                if (int.TryParse(Request.QueryString["id"], out idCompra))
                    CargarDetalle(idCompra);
                else
                    Response.Redirect("Compras.aspx");
            }
        }


        private void CargarDetalle(int idCompra)
        {

            CompraNegocio negocio = new CompraNegocio();
            List<Compra> compras = negocio.Listar();

            Compra compra = compras.FirstOrDefault(c => c.Id == idCompra);
            if (compra == null)
            {
                Response.Redirect("Compras.aspx");
                return;
            }

            lblProveedor.Text = compra.Proveedor?.Nombre ?? "(sin proveedor)";
            lblFecha.Text = compra.Fecha.ToString("dd/MM/yyyy");
            lblUsuario.Text = compra.Usuario?.Nombre ?? "(no especificado)";
            lblObservaciones.Text = string.IsNullOrEmpty(compra.Observaciones) ? "-" : compra.Observaciones;

            // Cargar líneas de la compra
            CompraLineaNegocio lineaNegocio = new CompraLineaNegocio();
            List<CompraLinea> lineas = lineaNegocio.ListarPorCompra(idCompra);

            gvLineas.DataSource = lineas;
            gvLineas.DataBind();

            lblTotal.Text = lineas.Sum(l => l.Subtotal).ToString("C");


            if (compra.Cancelada)
            {
                panelCancelada.Visible = true;
                lblMotivo.Text = compra.MotivoCancelacion;
                lblFechaCanc.Text = compra.FechaCancelacion?.ToString("dd/MM/yyyy HH:mm");
                lblUsuarioCanc.Text = compra.UsuarioCancelacion?.Nombre ?? "-";
            }
            else
            {
                panelCancelada.Visible = false;
            }

        }

        protected void btnCerrar_Click(object sender, EventArgs e)
        {
            Response.Redirect("Compras.aspx");
        }
    }
}
