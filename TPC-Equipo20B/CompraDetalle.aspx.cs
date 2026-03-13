using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using Dominio;
using Negocio;

namespace TPC_Equipo20B
{
    public partial class CompraDetalle : System.Web.UI.Page
    {
        public string NombreComprobante { get; private set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                int idCompra;
                if (int.TryParse(Request.QueryString["id"], out idCompra))
                {
                    CargarDetalle(idCompra);
                }
                else
                {
                    Response.Redirect("Compras.aspx");
                }
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

            // Formatear textos con Title Case
            System.Globalization.TextInfo textInfo = new System.Globalization.CultureInfo("es-AR", false).TextInfo;

            lblCompraId.Text = compra.Id.ToString("D5"); // Formato 00001
            lblFecha.Text = compra.Fecha.ToString("dd/MM/yyyy");
            lblUsuario.Text = textInfo.ToTitleCase((compra.Usuario?.Nombre ?? "(no especificado)").ToLower());
            lblObservaciones.Text = string.IsNullOrEmpty(compra.Observaciones) ? "Sin observaciones" : compra.Observaciones;

            if (compra.Proveedor != null && !string.IsNullOrEmpty(compra.Proveedor.Nombre))
            {
                lblProveedor.Text = textInfo.ToTitleCase(compra.Proveedor.Nombre.ToLower());
            }
            else
            {
                lblProveedor.Text = "(Proveedor no especificado)";
            }

            // Cargar líneas de la compra
            CompraLineaNegocio lineaNegocio = new CompraLineaNegocio();
            List<CompraLinea> lineas = lineaNegocio.ListarPorCompra(idCompra);

            // Aplicar Title Case a los productos para la grilla
            foreach (var linea in lineas)
            {
                if (linea.Producto != null && !string.IsNullOrEmpty(linea.Producto.Descripcion))
                {
                    linea.Producto.Descripcion = textInfo.ToTitleCase(linea.Producto.Descripcion.ToLower());
                }
            }

            // Ordenar por ID o Nombre para facilitar el punteo
            var lineasOrdenadas = lineas.OrderBy(l => l.Producto.Descripcion).ToList();

            gvLineas.DataSource = lineasOrdenadas;
            gvLineas.DataBind();

            lblTotal.Text = lineas.Sum(l => l.Subtotal).ToString("C");

            // Configurar el nombre del archivo PDF al descargar
            NombreComprobante = $"Ingreso_Stock_{compra.Id:D5}";

            if (compra.Cancelada)
            {
                panelCancelada.Visible = true;
                lblMotivo.Text = compra.MotivoCancelacion;
                lblFechaCanc.Text = compra.FechaCancelacion?.ToString("dd/MM/yyyy HH:mm");
                lblUsuarioCanc.Text = textInfo.ToTitleCase((compra.UsuarioCancelacion?.Nombre ?? "-").ToLower());

                NombreComprobante = $"CompraCancelada_{compra.Id:D5}";
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