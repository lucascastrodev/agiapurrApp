using System;
using System.Linq;
using Negocio;
using Dominio;

namespace TPC_Equipo20B
{
    public partial class VentaDetalle : System.Web.UI.Page
    {
        public string NombreComprobante { get; private set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["id"] != null)
                {
                    int idVenta = int.Parse(Request.QueryString["id"]);
                    CargarVenta(idVenta);
                }
                else
                {
                    Response.Redirect("Ventas.aspx");
                }
            }
        }

        private void CargarVenta(int id)
        {
            VentaNegocio negocio = new VentaNegocio();
            Venta venta = negocio.ObtenerPorId(id);

            if (venta == null)
            {
                Response.Redirect("Ventas.aspx");
                return;
            }

            // CANDADO DE SEGURIDAD
            bool esAdmin = Session["EsAdmin"] != null && (bool)Session["EsAdmin"];
            int idUsuarioLogueado = Session["UsuarioId"] != null ? (int)Session["UsuarioId"] : -1;

            if (!esAdmin)
            {
                if (venta.Usuario == null || venta.Usuario.Id != idUsuarioLogueado)
                {
                    Response.Redirect("Ventas.aspx");
                    return;
                }
            }

            // ESTADO
            if (venta.Estado == "Cancelada")
            {
                panelCancelada.Visible = true;
                lblMotivo.Text = venta.MotivoCancelacion;
                lblFechaCanc.Text = venta.FechaCancelacion?.ToString("dd/MM/yyyy HH:mm");
                lblUsuarioCanc.Text = venta.UsuarioCancelacion?.Nombre ?? "(no encontrado)";
                lblNC.Text = string.IsNullOrEmpty(venta.NumeroNC) ? "-" : venta.NumeroNC;
                btnImprimir.Text = "Imprimir NC / PDF";
            }
            else
            {
                panelCancelada.Visible = false;
                btnImprimir.Text = "Imprimir Remito / PDF";
            }

            // Formatear textos con Title Case
            System.Globalization.TextInfo textInfo = new System.Globalization.CultureInfo("es-AR", false).TextInfo;

            lblFecha.Text = venta.Fecha.ToString("dd/MM/yyyy");
            lblMetodoPago.Text = venta.MetodoPago ?? "-";
            lblFactura.Text = venta.NumeroFactura ?? "-";
            lblTotal.Text = venta.TotalBD.ToString("C");

            // --- DATOS COMPLETOS DEL CLIENTE ---
            if (venta.Cliente != null)
            {
                lblCliente.Text = textInfo.ToTitleCase(venta.Cliente.Nombre.ToLower());

                string dir = string.IsNullOrEmpty(venta.Cliente.Direccion) ? "" : textInfo.ToTitleCase(venta.Cliente.Direccion.ToLower());
                string loc = string.IsNullOrEmpty(venta.Cliente.Localidad) ? "" : textInfo.ToTitleCase(venta.Cliente.Localidad.ToLower());
                lblDireccion.Text = string.IsNullOrEmpty(dir) && string.IsNullOrEmpty(loc) ? "No especificada" : $"{dir}, {loc}".Trim(',', ' ');

                lblTelefono.Text = string.IsNullOrEmpty(venta.Cliente.Telefono) ? "No especificado" : venta.Cliente.Telefono;

                lblObservacionesCliente.Text = string.IsNullOrEmpty(venta.Cliente.Observaciones) ? "Sin observaciones" : venta.Cliente.Observaciones;
            }
            else
            {
                lblCliente.Text = "Consumidor Final";
                lblDireccion.Text = "-";
                lblTelefono.Text = "-";
                lblObservacionesCliente.Text = "-";
            }

            // --- MAGIA: HACER EDITABLE SOLO PARA EL ADMIN ANTES DE IMPRIMIR ---
            if (esAdmin)
            {
                lblObservacionesCliente.Attributes.Add("contenteditable", "true");
                lblObservacionesCliente.ToolTip = "Podés editar este texto temporalmente antes de imprimir (No se guarda en la base de datos).";
                iconoEdicion.Visible = true;
            }

            // --- ORDENAR LOS PRODUCTOS POR CÓDIGO/ID DE MENOR A MAYOR Y APLICAR TITLE CASE ---
            if (venta.Lineas != null && venta.Lineas.Count > 0)
            {
                foreach (var linea in venta.Lineas)
                {
                    if (linea.Producto != null && !string.IsNullOrEmpty(linea.Producto.Descripcion))
                    {
                        linea.Producto.Descripcion = textInfo.ToTitleCase(linea.Producto.Descripcion.ToLower());
                    }
                }

                var lineasOrdenadas = venta.Lineas.OrderBy(l => l.Producto.Id).ToList();
                gvLineas.DataSource = lineasOrdenadas;
                gvLineas.DataBind();
            }

            // Nombre del PDF
            string nombreArchivo = (venta.Estado == "Cancelada")
                ? (!string.IsNullOrEmpty(venta.NumeroNC) ? venta.NumeroNC : "NotaCredito")
                : (!string.IsNullOrEmpty(venta.NumeroFactura) ? venta.NumeroFactura : "Remito");

            NombreComprobante = nombreArchivo.Replace("'", "");
        }

        protected void btnCerrar_Click(object sender, EventArgs e)
        {
            Response.Redirect("Ventas.aspx");
        }

        protected void btnEnviarMail_Click(object sender, EventArgs e)
        {
            try
            {
                int idVenta;
                if (!int.TryParse(Request.QueryString["id"], out idVenta))
                {
                    ClientScript.RegisterStartupScript(GetType(), "MailError", "alert('No se pudo determinar la venta.');", true);
                    return;
                }

                VentaNegocio negocio = new VentaNegocio();
                Venta venta = negocio.ObtenerPorId(idVenta);

                if (venta == null || venta.Cliente == null || string.IsNullOrEmpty(venta.Cliente.Email))
                {
                    ClientScript.RegisterStartupScript(GetType(), "MailError", "alert('El cliente no tiene un correo electrónico cargado.');", true);
                    return;
                }

                negocio.EnviarMailFactura(venta);

                string tipoComprobante = (venta.Estado == "Cancelada") ? "la nota de crédito" : "el remito";
                string numeroComprobante = (venta.Estado == "Cancelada")
                    ? (string.IsNullOrEmpty(venta.NumeroNC) ? "" : " " + venta.NumeroNC)
                    : (string.IsNullOrEmpty(venta.NumeroFactura) ? "" : " " + venta.NumeroFactura);

                string mensaje = $"Se reenvi\u00f3 {tipoComprobante}{numeroComprobante} a {venta.Cliente.Nombre} ({venta.Cliente.Email}) correctamente.";
                string mensajeJs = mensaje.Replace("'", "\\'");

                ClientScript.RegisterStartupScript(GetType(), "MailOk", $"alert('{mensajeJs}');", true);
            }
            catch (Exception ex)
            {
                ClientScript.RegisterStartupScript(GetType(), "MailError", "alert('Error al reenviar: " + ex.Message.Replace("'", "\\'") + "');", true);
            }
        }
    }
}