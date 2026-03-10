using Dominio;
using Negocio;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web.UI.WebControls;

namespace TPC_Equipo20B
{
    public partial class Reportes : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Permisos.RequiereAdmin(this);

            if (IsPostBack) return;

            CargarReportes();
        }

        private void CargarReportes()
        {
            try
            {
                var ventaNegocio = new VentaNegocio();
                var productoNegocio = new ProductoNegocio();

                // 🛠️ Herramienta para convertir Texto
                TextInfo textInfo = new CultureInfo("es-AR", false).TextInfo;

                // Etiquetas de Ventas
                lblRptVentasMes.Text = ventaNegocio.ObtenerTotalVentasMes(null).ToString("C");
                lblRptPedidos.Text = ventaNegocio.ObtenerPedidosCompletadosMes(null).ToString();
                lblRptClientes.Text = ventaNegocio.ObtenerClientesNuevosMes(null).ToString();
                lblRptTicket.Text = ventaNegocio.ObtenerTicketPromedioMes(null).ToString("C");

                // --- 1. Reporte de Inflación con DataTable ---
                DataTable dtInflacionTotal = productoNegocio.ObtenerReporteInflacionAnual();

                if (dtInflacionTotal != null && dtInflacionTotal.Rows.Count > 0)
                {
                    // A. Calculamos el promedio usando TODOS los datos (Realidad del catálogo)
                    object sumObject = dtInflacionTotal.Compute("Avg(Porcentaje)", "");
                    lblRptInflacion.Text = Convert.ToDecimal(sumObject).ToString("N1") + "%";

                    // B. Creamos una tabla reducida para mostrar SOLO EL TOP 5 en la grilla
                    // Esto evita que la página se estire infinitamente
                    DataTable dtTop5Aumentos = dtInflacionTotal.Clone(); // Copiamos solo la estructura (columnas)

                    // Importamos solo las primeras 5 filas (o menos si hay menos productos)
                    for (int i = 0; i < dtInflacionTotal.Rows.Count && i < 5; i++)
                    {
                        dtTop5Aumentos.ImportRow(dtInflacionTotal.Rows[i]);
                    }

                    // C. Formateamos el texto solo de los 5 que vamos a mostrar
                    foreach (DataRow row in dtTop5Aumentos.Rows)
                    {
                        if (row["Producto"] != DBNull.Value)
                        {
                            string nombreOriginal = row["Producto"].ToString();
                            row["Producto"] = textInfo.ToTitleCase(nombreOriginal.ToLower());
                        }
                    }

                    gvTopAumentos.DataSource = dtTop5Aumentos;
                    gvTopAumentos.DataBind();
                }
                else
                {
                    lblRptInflacion.Text = "0,0%";
                }

                // --- 2. Top Ventas (Lista) ---
                // Nota: Usualmente este método ya trae un Top 5 desde SQL, así que quedarán parejos.
                var topProductos = ventaNegocio.TopProductosVendidosMes(null);

                foreach (var item in topProductos)
                {
                    if (!string.IsNullOrEmpty(item.Producto))
                        item.Producto = textInfo.ToTitleCase(item.Producto.ToLower());

                    if (!string.IsNullOrEmpty(item.Categoria))
                        item.Categoria = textInfo.ToTitleCase(item.Categoria.ToLower());
                }

                gvTopProductos.DataSource = topProductos;
                gvTopProductos.DataBind();
            }
            catch (Exception)
            {
                lblRptInflacion.Text = "Error";
            }
        }
    }
}