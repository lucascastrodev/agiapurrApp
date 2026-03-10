using System;
using System.Net;
using System.Net.Mail;
using System.Text;
using Dominio;

namespace Negocio
{
    public static class EmailService
    {
        private const string Remitente = "tpcomercio.equipo20b@gmail.com";
        private const string Clave = "wnutobmznfmnnpog";
        private const string NombreRemitente = "Comercio";

        public static void EnviarCorreo(string destinatario, string asunto, string cuerpoHtml)
        {
            if (string.IsNullOrWhiteSpace(destinatario))
                return;

            MailMessage mensaje = new MailMessage();
            mensaje.From = new MailAddress(Remitente, NombreRemitente);
            mensaje.To.Add(destinatario);
            mensaje.Subject = asunto;
            mensaje.BodyEncoding = Encoding.UTF8;
            mensaje.IsBodyHtml = true;
            mensaje.Body = cuerpoHtml;

            using (SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587))
            {
                smtp.EnableSsl = true;
                smtp.UseDefaultCredentials = false;
                smtp.Credentials = new NetworkCredential(Remitente, Clave);
                smtp.Send(mensaje);
            }
        }

        // Asegurate de agregar el mail del admin acá arriba junto a tus otras constantes
        private const string EmailAdministrador = "lucastro1991.lc@gmail.com"; // CAMBIAR POR EL MAIL REAL

        public static void EnviarFactura(Venta venta)
        {
            // Validamos que exista la venta y el cliente
            if (venta == null || venta.Cliente == null || string.IsNullOrEmpty(venta.Cliente.Email))
                return;

            string asunto;
            // ACÁ ESTABA EL ERROR: Cambiamos "venta.Cancelada" por "venta.Estado == 'Cancelada'"
            if (venta.Estado == "Cancelada" && !string.IsNullOrEmpty(venta.NumeroNC))
                asunto = "Nota de crédito " + venta.NumeroNC;
            else
                asunto = "Comprobante de compra " + (venta.NumeroFactura ?? "");

            StringBuilder sb = new StringBuilder();

            sb.Append("<html><body>");
            sb.Append("<h2>Detalle de la compra</h2>");

            sb.Append("<p>Cliente: " + venta.Cliente.Nombre + "</p>");
            sb.Append("<p>Fecha: " + venta.Fecha.ToString("dd/MM/yyyy") + "</p>");
            sb.Append("<p>Método de pago: " + (venta.MetodoPago ?? "") + "</p>");
            sb.Append("<p>Número de remito: " + (venta.NumeroFactura ?? "") + "</p>");

            sb.Append("<table border='1' cellspacing='0' cellpadding='4'>");
            sb.Append("<tr>");
            sb.Append("<th>Producto</th>");
            sb.Append("<th>Cantidad</th>");
            sb.Append("<th>Precio unitario</th>");
            sb.Append("<th>Subtotal</th>");
            sb.Append("</tr>");

            if (venta.Lineas != null)
            {
                foreach (var linea in venta.Lineas)
                {
                    sb.Append("<tr>");
                    sb.Append("<td>" + linea.Producto.Descripcion + "</td>");
                    sb.Append("<td style='text-align:right;'>" + linea.Cantidad.ToString("N2") + "</td>");
                    sb.Append("<td style='text-align:right;'>" + linea.PrecioUnitario.ToString("C") + "</td>");
                    sb.Append("<td style='text-align:right;'>" + linea.Subtotal.ToString("C") + "</td>");
                    sb.Append("</tr>");
                }
            }

            sb.Append("<tr>");
            sb.Append("<td colspan='3' style='text-align:right; font-weight:bold;'>Total</td>");
            sb.Append("<td style='text-align:right; font-weight:bold;'>" + venta.Total.ToString("C") + "</td>");
            sb.Append("</tr>");
            sb.Append("</table>");
            sb.Append("<p>Muchas gracias por su compra.</p>");
            sb.Append("</body></html>");

            // --- LÓGICA DE ENVÍO MÚLTIPLE ---
            MailMessage mensaje = new MailMessage();
            mensaje.From = new MailAddress(Remitente, NombreRemitente);

            // 1. Destinatario Principal (El Cliente)
            mensaje.To.Add(venta.Cliente.Email);

            // 2. Copia (CC) para el Vendedor (Validamos que exista el vendedor y su mail)
            if (venta.Usuario != null && !string.IsNullOrWhiteSpace(venta.Usuario.Email))
            {
                mensaje.CC.Add(venta.Usuario.Email);
            }

            // 3. Copia Oculta (BCC) para el Administrador (para llevar registro de todo)
            mensaje.Bcc.Add(EmailAdministrador);

            mensaje.Subject = asunto;
            mensaje.BodyEncoding = Encoding.UTF8;
            mensaje.IsBodyHtml = true;
            mensaje.Body = sb.ToString();

            // Enviar el correo armado
            using (SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587))
            {
                smtp.EnableSsl = true;
                smtp.UseDefaultCredentials = false;
                smtp.Credentials = new NetworkCredential(Remitente, Clave);
                try
                {
                    smtp.Send(mensaje);
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("Error enviando email: " + ex.Message);
                }
            }
        }

        public static void EnviarBienvenidaCliente(Cliente cliente)
        {
            if (cliente == null || string.IsNullOrWhiteSpace(cliente.Email))
                return;

            string asunto = "Bienvenido a Comercio";

            StringBuilder sb = new StringBuilder();
            sb.Append("<html><body>");
            sb.Append("<h2>¡Hola " + cliente.Nombre + "!</h2>");
            sb.Append("<p>Te damos la bienvenida a nuestro sistema de clientes.</p>");
            sb.Append("<p>Desde ahora vas a recibir por correo tus comprobantes y novedades importantes.</p>");
            sb.Append("<p>Muchas gracias por confiar en nosotros.</p>");
            sb.Append("</body></html>");

            EnviarCorreo(cliente.Email, asunto, sb.ToString());
        }

        public static void EnviarBienvenidaUsuario(Usuario usuario)
        {
            if (usuario == null || string.IsNullOrWhiteSpace(usuario.Email))
                return;

            string asunto = "Bienvenido al sistema de gestión";

            StringBuilder sb = new StringBuilder();
            sb.Append("<html><body>");
            sb.Append("<h2>¡Hola " + usuario.Nombre + "!</h2>");
            sb.Append("<p>Tu usuario ha sido creado correctamente.</p>");
            sb.Append("<p>Ya podés iniciar sesión en el sistema y comenzar a operar como vendedor.</p>");
            sb.Append("<p>Cualquier duda, contactate con el administrador.</p>");
            sb.Append("</body></html>");

            EnviarCorreo(usuario.Email, asunto, sb.ToString());
        }

        public static void EnviarRecuperacionPassword(Usuario usuario, string nuevaPassword)
        {
            if (usuario == null || string.IsNullOrWhiteSpace(usuario.Email))
                return;

            string asunto = "Restablecimiento de contraseña - Comercio";

            StringBuilder sb = new StringBuilder();
            sb.Append("<html><body>");
            sb.Append("<h2>Hola " + usuario.Nombre + "!</h2>");
            sb.Append("<p>Recibimos una solicitud para restablecer tu contraseña en el sistema de gestión.</p>");
            sb.Append("<p>Tu nueva contraseña temporal es: <strong>" + nuevaPassword + "</strong></p>");
            sb.Append("<p>Por seguridad, te recomendamos cambiarla después de iniciar sesión.</p>");
            sb.Append("<p>Si no fuiste vos quien solicitó este cambio, por favor contactate con el administrador.</p>");
            sb.Append("<p>Saludos,<br/>Comercio</p>");
            sb.Append("</body></html>");

            EnviarCorreo(usuario.Email, asunto, sb.ToString());
        }
    }
}