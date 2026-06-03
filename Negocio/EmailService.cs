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
        private const string NombreRemitente = "AGIAPURR Distribuidora";
        private const string EmailAdministrador = "lucastro1991.lc@gmail.com";

        // --- PLANTILLA BASE PARA TODOS LOS CORREOS ---
        // Esto asegura que todos los mails tengan la misma estética profesional
        private static string GenerarPlantillaBase(string titulo, string contenidoHtml)
        {
            return $@"
            <html>
            <body style='font-family: ""Segoe UI"", Tahoma, Geneva, Verdana, sans-serif; background-color: #f6f8f6; margin: 0; padding: 20px;'>
                <table width='100%' border='0' cellspacing='0' cellpadding='0'>
                    <tr>
                        <td align='center'>
                            <table width='600' border='0' cellspacing='0' cellpadding='0' style='background-color: #ffffff; border-radius: 8px; overflow: hidden; box-shadow: 0 4px 10px rgba(0,0,0,0.05);'>
                                <tr>
                                    <td style='background-color: #11d452; padding: 25px; text-align: center;'>
                                        <h1 style='color: #102216; margin: 0; font-size: 24px; font-weight: 800; letter-spacing: 1px;'>AGIAPURR</h1>
                                        <p style='color: #102216; margin: 5px 0 0 0; font-size: 14px; opacity: 0.8;'>Distribuidora</p>
                                    </td>
                                </tr>
                                <tr>
                                    <td style='padding: 30px; color: #333333; line-height: 1.6;'>
                                        <h2 style='color: #111813; margin-top: 0; border-bottom: 2px solid #f0f0f0; padding-bottom: 10px;'>{titulo}</h2>
                                        {contenidoHtml}
                                    </td>
                                </tr>
                                <tr>
                                    <td style='background-color: #f1f5f2; padding: 20px; text-align: center; color: #61896f; font-size: 12px;'>
                                        <p style='margin: 0;'>Este es un mensaje automático generado por el sistema ERP.</p>
                                        <p style='margin: 5px 0 0 0;'>© {DateTime.Now.Year} AGIAPURR Distribuidora. Todos los derechos reservados.</p>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </body>
            </html>";
        }

        public static void EnviarCorreo(string destinatario, string asunto, string cuerpoHtml)
        {
            if (string.IsNullOrWhiteSpace(destinatario)) return;

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
                try
                {
                    smtp.Send(mensaje);
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("Error enviando email base: " + ex.Message);
                }
            }
        }

        public static void EnviarFactura(Venta venta)
        {
            if (venta == null || venta.Cliente == null || string.IsNullOrEmpty(venta.Cliente.Email)) return;

            string tipoComprobante = (venta.Estado == "Cancelada" && !string.IsNullOrEmpty(venta.NumeroNC))
                ? $"Nota de Crédito {venta.NumeroNC}"
                : $"Factura {venta.NumeroFactura}";

            string asunto = $"Tu comprobante de AGIAPURR - {tipoComprobante}";

            StringBuilder lineasHtml = new StringBuilder();
            if (venta.Lineas != null)
            {
                foreach (var linea in venta.Lineas)
                {
                    lineasHtml.Append($@"
                        <tr>
                            <td style='padding: 10px; border-bottom: 1px solid #eeeeee;'>{linea.Producto.Descripcion}</td>
                            <td style='padding: 10px; border-bottom: 1px solid #eeeeee; text-align: center;'>{linea.Cantidad:N2}</td>
                            <td style='padding: 10px; border-bottom: 1px solid #eeeeee; text-align: right;'>{linea.PrecioUnitario:C}</td>
                            <td style='padding: 10px; border-bottom: 1px solid #eeeeee; text-align: right; font-weight: bold;'>{linea.Subtotal:C}</td>
                        </tr>");
                }
            }

            string contenido = $@"
                <p>Hola <strong>{venta.Cliente.Nombre}</strong>,</p>
                <p>Adjuntamos el detalle de tu reciente operación con nosotros.</p>
                
                <table width='100%' style='background-color: #f9f9f9; padding: 15px; border-radius: 6px; margin-bottom: 20px;'>
                    <tr>
                        <td><strong>Fecha:</strong> {venta.Fecha:dd/MM/yyyy}</td>
                        <td><strong>Método de pago:</strong> {venta.MetodoPago ?? "N/A"}</td>
                    </tr>
                </table>

                <table width='100%' border='0' cellspacing='0' cellpadding='0' style='margin-bottom: 20px; font-size: 14px;'>
                    <thead>
                        <tr>
                            <th style='background-color: #102216; color: white; padding: 10px; text-align: left; border-radius: 4px 0 0 0;'>Producto</th>
                            <th style='background-color: #102216; color: white; padding: 10px; text-align: center;'>Cant.</th>
                            <th style='background-color: #102216; color: white; padding: 10px; text-align: right;'>P. Unitario</th>
                            <th style='background-color: #102216; color: white; padding: 10px; text-align: right; border-radius: 0 4px 0 0;'>Subtotal</th>
                        </tr>
                    </thead>
                    <tbody>
                        {lineasHtml}
                    </tbody>
                    <tfoot>
                        <tr>
                            <td colspan='3' style='padding: 15px 10px; text-align: right; font-weight: bold; font-size: 16px;'>TOTAL:</td>
                            <td style='padding: 15px 10px; text-align: right; font-weight: bold; font-size: 18px; color: #11d452;'>{venta.Total:C}</td>
                        </tr>
                    </tfoot>
                </table>
                <p style='text-align: center; font-size: 16px; margin-top: 30px;'>¡Muchas gracias por tu compra!</p>";

            MailMessage mensaje = new MailMessage();
            mensaje.From = new MailAddress(Remitente, NombreRemitente);
            mensaje.To.Add(venta.Cliente.Email);

            if (venta.Usuario != null && !string.IsNullOrWhiteSpace(venta.Usuario.Email))
                mensaje.CC.Add(venta.Usuario.Email);

            mensaje.Bcc.Add(EmailAdministrador);
            mensaje.Subject = asunto;
            mensaje.BodyEncoding = Encoding.UTF8;
            mensaje.IsBodyHtml = true;
            mensaje.Body = GenerarPlantillaBase($"Detalle de {tipoComprobante}", contenido);

            using (SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587))
            {
                smtp.EnableSsl = true;
                smtp.UseDefaultCredentials = false;
                smtp.Credentials = new NetworkCredential(Remitente, Clave);
                try { smtp.Send(mensaje); }
                catch (Exception ex) { System.Diagnostics.Debug.WriteLine("Error enviando factura: " + ex.Message); }
            }
        }

        public static void EnviarBienvenidaCliente(Cliente cliente)
        {
            if (cliente == null || string.IsNullOrWhiteSpace(cliente.Email)) return;

            string contenido = $@"
                <p>¡Hola <strong>{cliente.Nombre}</strong>!</p>
                <p>Te damos una cálida bienvenida a nuestro sistema de clientes exclusivos.</p>
                <p>A partir de ahora, recibirás de forma automática todos tus comprobantes, facturas y novedades importantes directamente en esta casilla de correo.</p>
                <div style='text-align: center; margin-top: 30px;'>
                    <p style='font-size: 16px; font-weight: bold;'>¡Gracias por confiar en AGIAPURR!</p>
                </div>";

            EnviarCorreo(cliente.Email, "¡Bienvenido a AGIAPURR!", GenerarPlantillaBase("¡Alta de Cliente Exitosa!", contenido));
        }

        // --- MODIFICADO: AHORA RECIBE LA CONTRASEÑA EN TEXTO PLANO ---
        public static void EnviarBienvenidaUsuario(Usuario usuario, string passwordPlana)
        {
            if (usuario == null || string.IsNullOrWhiteSpace(usuario.Email)) return;

            string contenido = $@"
                <p>¡Hola <strong>{usuario.Nombre}</strong>!</p>
                <p>El administrador te ha dado de alta en el sistema ERP de la empresa. Ya podés ingresar para comenzar a gestionar ventas y catálogos.</p>
                
                <div style='background-color: #f1f5f2; border-left: 4px solid #11d452; padding: 15px; margin: 20px 0;'>
                    <h3 style='margin-top: 0; color: #102216;'>Tus Credenciales de Acceso:</h3>
                    <p style='margin: 5px 0;'><strong>Usuario:</strong> {usuario.Username}</p>
                    <p style='margin: 5px 0;'><strong>Contraseña:</strong> {passwordPlana}</p>
                </div>

                <p><em>Por motivos de seguridad, te recomendamos ingresar al sistema y cambiar tu contraseña desde la opción 'Mi Perfil' lo antes posible.</em></p>";

            EnviarCorreo(usuario.Email, "Tus credenciales de acceso", GenerarPlantillaBase("¡Bienvenido al Equipo!", contenido));
        }

        public static void EnviarRecuperacionPassword(Usuario usuario, string nuevaPassword)
        {
            if (usuario == null || string.IsNullOrWhiteSpace(usuario.Email)) return;

            string contenido = $@"
                <p>Hola <strong>{usuario.Nombre}</strong>,</p>
                <p>Hemos recibido una solicitud para restablecer tu contraseña en el sistema.</p>
                
                <div style='background-color: #fff3cd; border-left: 4px solid #ffc107; padding: 15px; margin: 20px 0;'>
                    <p style='margin: 0;'>Tu nueva contraseña temporal es: <strong style='font-size: 18px;'>{nuevaPassword}</strong></p>
                </div>

                <p>Te pedimos que inicies sesión con esta clave e inmediatamente te dirijas a la configuración de tu perfil para establecer una nueva contraseña privada.</p>
                <p style='font-size: 12px; color: #999; mt-3'>Si no solicitaste este cambio, por favor avisale urgentemente al Administrador del sistema.</p>";

            EnviarCorreo(usuario.Email, "Recuperación de Contraseña", GenerarPlantillaBase("Restablecimiento de Clave", contenido));
        }

        // --- NUEVO: AVISO POR CAMBIO DE CONTRASEÑA MANUAL ---
        public static void EnviarAvisoCambioPassword(Usuario usuario)
        {
            if (usuario == null || string.IsNullOrWhiteSpace(usuario.Email)) return;

            string contenido = $@"
                <p>Hola <strong>{usuario.Nombre}</strong>,</p>
                <p>Te enviamos este correo para notificarte que <strong>tu contraseña ha sido modificada con éxito</strong> desde la gestión de tu perfil.</p>
                <p>Ya podés utilizar tu nueva clave para los próximos inicios de sesión.</p>
                
                <div style='background-color: #f8d7da; border-left: 4px solid #dc3545; padding: 15px; margin: 20px 0;'>
                    <p style='margin: 0; color: #721c24; font-weight: bold;'>⚠️ ¿No fuiste vos?</p>
                    <p style='margin: 5px 0 0 0; color: #721c24; font-size: 13px;'>Si no realizaste este cambio, tu cuenta podría estar comprometida. Contactate con el Administrador de inmediato.</p>
                </div>";

            EnviarCorreo(usuario.Email, "Aviso de Seguridad: Cambio de Contraseña", GenerarPlantillaBase("Alerta de Seguridad", contenido));
        }
    }
}