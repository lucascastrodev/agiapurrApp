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
        private const string NombreRemitente = "AGIAPURR App";
        private const string EmailAdministrador = "lucastro1991.lc@gmail.com";

        // --- PLANTILLA BASE PREMIUM ---
        private static string GenerarPlantillaBase(string titulo, string contenidoHtml)
        {
            return $@"
            <!DOCTYPE html>
            <html>
            <head>
                <meta charset='utf-8'>
            </head>
            <body style='font-family: system-ui, -apple-system, ""Segoe UI"", Roboto, Helvetica, Arial, sans-serif; background-color: #eef2f6; margin: 0; padding: 40px 20px;'>
                <table align='center' width='100%' border='0' cellspacing='0' cellpadding='0' style='max-width: 600px; background-color: #ffffff; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 12px rgba(0,0,0,0.08); margin: auto;'>
                    <tr>
                        <td style='background-color: #1e293b; padding: 30px 40px; text-align: center; border-top: 6px solid #10b957;'>
                            <h1 style='color: #ffffff; margin: 0; font-size: 24px; font-weight: 800; letter-spacing: 0.5px;'>AGIAPURR</h1>
                            <p style='color: #94a3b8; margin: 5px 0 0 0; font-size: 13px; text-transform: uppercase; letter-spacing: 1.5px; font-weight: 600;'>Sistema de Gestión</p>
                        </td>
                    </tr>
                    <tr>
                        <td style='padding: 40px; color: #4b5563; line-height: 1.6; font-size: 15px;'>
                            <h2 style='color: #1e293b; margin-top: 0; font-size: 20px; border-bottom: 2px solid #e2e8f0; padding-bottom: 15px;'>{titulo}</h2>
                            {contenidoHtml}
                        </td>
                    </tr>
                    <tr>
                        <td style='background-color: #f8fafc; padding: 25px 40px; text-align: center; color: #64748b; font-size: 12px; border-top: 1px solid #e2e8f0;'>
                            <p style='margin: 0;'>Este es un mensaje automático generado por AGIAPURR App.</p>
                            <p style='margin: 5px 0 0 0;'>© {DateTime.Now.Year} Todos los derechos reservados.</p>
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
                    // Lanza el error real si Google bloquea el puerto o la credencial
                    throw new Exception("Error del servidor SMTP: " + ex.Message);
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
                            <td style='padding: 12px 10px; border-bottom: 1px solid #e2e8f0; color: #334155; font-size: 14px;'>{linea.Producto.Descripcion}</td>
                            <td style='padding: 12px 10px; border-bottom: 1px solid #e2e8f0; text-align: center; color: #334155; font-size: 14px;'>{linea.Cantidad:N2}</td>
                            <td style='padding: 12px 10px; border-bottom: 1px solid #e2e8f0; text-align: right; color: #334155; font-size: 14px;'>{linea.PrecioUnitario:C}</td>
                            <td style='padding: 12px 10px; border-bottom: 1px solid #e2e8f0; text-align: right; font-weight: 600; color: #1e293b; font-size: 14px;'>{linea.Subtotal:C}</td>
                        </tr>");
                }
            }

            string contenido = $@"
                <p>Hola <strong style='color: #1e293b;'>{venta.Cliente.Nombre}</strong>,</p>
                <p>Adjuntamos el detalle de tu reciente operación con nosotros.</p>
                
                <table width='100%' style='background-color: #f1f5f9; padding: 15px; border-radius: 8px; margin-bottom: 25px; border-left: 4px solid #10b957;'>
                    <tr>
                        <td style='font-size: 14px; color: #334155;'><strong>Fecha:</strong> {venta.Fecha:dd/MM/yyyy HH:mm}</td>
                        <td style='font-size: 14px; color: #334155;'><strong>Método de pago:</strong> {venta.MetodoPago ?? "N/A"}</td>
                    </tr>
                </table>

                <table width='100%' border='0' cellspacing='0' cellpadding='0' style='margin-bottom: 20px; border-collapse: collapse;'>
                    <thead>
                        <tr>
                            <th style='background-color: #1e293b; color: #ffffff; padding: 12px 10px; text-align: left; border-radius: 6px 0 0 0; font-size: 13px; text-transform: uppercase;'>Producto</th>
                            <th style='background-color: #1e293b; color: #ffffff; padding: 12px 10px; text-align: center; font-size: 13px; text-transform: uppercase;'>Cant.</th>
                            <th style='background-color: #1e293b; color: #ffffff; padding: 12px 10px; text-align: right; font-size: 13px; text-transform: uppercase;'>P. Unit</th>
                            <th style='background-color: #1e293b; color: #ffffff; padding: 12px 10px; text-align: right; border-radius: 0 6px 0 0; font-size: 13px; text-transform: uppercase;'>Subtotal</th>
                        </tr>
                    </thead>
                    <tbody>
                        {lineasHtml}
                    </tbody>
                    <tfoot>
                        <tr>
                            <td colspan='3' style='padding: 20px 10px 10px 10px; text-align: right; font-weight: 700; font-size: 15px; color: #64748b;'>TOTAL FINAL:</td>
                            <td style='padding: 20px 10px 10px 10px; text-align: right; font-weight: 800; font-size: 18px; color: #10b957;'>{venta.TotalFinal:C}</td>
                        </tr>
                    </tfoot>
                </table>
                <p style='text-align: center; font-size: 16px; margin-top: 35px; color: #1e293b; font-weight: 700;'>¡Muchas gracias por tu compra!</p>";

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
                <p>¡Hola <strong style='color: #1e293b;'>{cliente.Nombre}</strong>!</p>
                <p>Te damos una cálida bienvenida a nuestro sistema de clientes.</p>
                <p>A partir de ahora, recibirás de forma automática todos tus comprobantes, facturas y novedades importantes directamente en esta casilla de correo.</p>
                <div style='text-align: center; margin-top: 35px;'>
                    <p style='font-size: 18px; font-weight: 800; color: #10b957;'>¡Gracias por confiar en AGIAPURR!</p>
                </div>";

            EnviarCorreo(cliente.Email, "¡Bienvenido a AGIAPURR!", GenerarPlantillaBase("¡Alta de Cliente Exitosa!", contenido));
        }

        public static void EnviarBienvenidaUsuario(Usuario usuario, string passwordPlana)
        {
            if (usuario == null || string.IsNullOrWhiteSpace(usuario.Email)) return;

            string contenido = $@"
                <p>¡Hola <strong style='color: #1e293b;'>{usuario.Nombre}</strong>!</p>
                <p>El administrador te ha dado de alta en el sistema. Ya podés ingresar para comenzar a operar.</p>
                
                <table width='100%' style='background-color: #f1f5f9; border-left: 4px solid #10b957; padding: 20px; margin: 25px 0; border-radius: 4px;'>
                    <tr>
                        <td>
                            <h3 style='margin-top: 0; color: #1e293b; font-size: 16px;'>Tus Credenciales de Acceso:</h3>
                            <p style='margin: 8px 0; color: #334155;'><strong>Usuario:</strong> {usuario.Username}</p>
                            <p style='margin: 8px 0; color: #334155;'><strong>Contraseña:</strong> <span style='font-family: monospace; background-color: #e2e8f0; padding: 2px 6px; border-radius: 4px;'>{passwordPlana}</span></p>
                        </td>
                    </tr>
                </table>

                <p style='font-size: 13px; color: #64748b;'><em>Por motivos de seguridad, te recomendamos ingresar al sistema y cambiar tu contraseña desde la opción 'Mi Perfil' lo antes posible.</em></p>";

            EnviarCorreo(usuario.Email, "Tus credenciales de acceso", GenerarPlantillaBase("¡Bienvenido al Equipo!", contenido));
        }

        public static void EnviarRecuperacionPassword(Usuario usuario, string nuevaPassword)
        {
            if (usuario == null || string.IsNullOrWhiteSpace(usuario.Email)) return;

            string contenido = $@"
                <p>Hola <strong style='color: #1e293b;'>{usuario.Nombre}</strong>,</p>
                <p>Hemos recibido una solicitud para restablecer tu contraseña en el sistema.</p>
                
                <table width='100%' style='background-color: #fffbeb; border-left: 4px solid #f59e0b; padding: 20px; margin: 25px 0; border-radius: 4px;'>
                    <tr>
                        <td>
                            <p style='margin: 0; color: #92400e; font-size: 15px;'>Tu nueva contraseña temporal es:</p>
                            <p style='margin: 10px 0 0 0; font-size: 22px; font-weight: 800; color: #b45309; letter-spacing: 2px;'>{nuevaPassword}</p>
                        </td>
                    </tr>
                </table>

                <p>Iniciá sesión con esta clave e inmediatamente dirigite a tu perfil para establecer una nueva contraseña privada.</p>
                <p style='font-size: 12px; color: #94a3b8; margin-top: 25px;'>Si no solicitaste este cambio, avisale de urgencia al Administrador.</p>";

            EnviarCorreo(usuario.Email, "Recuperación de Contraseña", GenerarPlantillaBase("Restablecimiento de Clave", contenido));
        }

        public static void EnviarAvisoCambioPassword(Usuario usuario)
        {
            if (usuario == null || string.IsNullOrWhiteSpace(usuario.Email)) return;

            string contenido = $@"
                <p>Hola <strong style='color: #1e293b;'>{usuario.Nombre}</strong>,</p>
                <p>Te enviamos este correo para notificarte que <strong>tu contraseña ha sido modificada con éxito</strong> desde la gestión de tu perfil.</p>
                <p>Ya podés utilizar tu nueva clave para los próximos inicios de sesión.</p>
                
                <table width='100%' style='background-color: #fef2f2; border-left: 4px solid #ef4444; padding: 15px; margin: 25px 0; border-radius: 4px;'>
                    <tr>
                        <td>
                            <p style='margin: 0; color: #991b1b; font-weight: 700; font-size: 15px;'>⚠️ ¿No fuiste vos?</p>
                            <p style='margin: 5px 0 0 0; color: #991b1b; font-size: 13px;'>Si no realizaste este cambio, tu cuenta podría estar comprometida. Contactate con el Administrador de inmediato.</p>
                        </td>
                    </tr>
                </table>";

            EnviarCorreo(usuario.Email, "Aviso de Seguridad: Cambio de Contraseña", GenerarPlantillaBase("Alerta de Seguridad", contenido));
        }
    }
}