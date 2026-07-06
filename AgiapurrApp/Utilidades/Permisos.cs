using System;
using System.Web;
using System.Web.UI;

namespace Dominio
{
    public static class Permisos
    {
        public static void RequiereAdmin(Page pagina)
        {
            // Blindaje contra el botón "Atrás" del navegador
            pagina.Response.Cache.SetCacheability(HttpCacheability.NoCache);
            pagina.Response.Cache.SetExpires(DateTime.UtcNow.AddHours(-1));
            pagina.Response.Cache.SetNoStore();

            // Validación de sesión activa
            if (pagina.Session["Usuario"] == null)
            {
                pagina.Response.Redirect("Default.aspx", false);
                // CORRECCIÓN: Se utiliza el contexto actual global
                HttpContext.Current.ApplicationInstance.CompleteRequest();
                return;
            }

            // Validación de rol Administrador
            bool esAdmin = (bool)(pagina.Session["EsAdmin"] ?? false);

            if (!esAdmin)
            {
                pagina.Response.Redirect("Dashboard.aspx", false);
                // CORRECCIÓN: Se utiliza el contexto actual global
                HttpContext.Current.ApplicationInstance.CompleteRequest();
                return;
            }
        }

        public static void RequiereUsuario(Page pagina)
        {
            pagina.Response.Cache.SetCacheability(HttpCacheability.NoCache);
            pagina.Response.Cache.SetExpires(DateTime.UtcNow.AddHours(-1));
            pagina.Response.Cache.SetNoStore();

            if (pagina.Session["Usuario"] == null)
            {
                pagina.Response.Redirect("Default.aspx", false);
                // CORRECCIÓN: Se utiliza el contexto actual global
                HttpContext.Current.ApplicationInstance.CompleteRequest();
                return;
            }
        }
    }
}