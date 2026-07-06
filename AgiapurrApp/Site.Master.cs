using System;
using System.Web;
using Dominio;

namespace AgiapurrApp
{
    public partial class Site : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // 1. BLINDAJE GLOBAL DE CACHÉ
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.Cache.SetExpires(DateTime.UtcNow.AddMinutes(-1));
            Response.Cache.SetNoStore();
            Response.AppendHeader("Pragma", "no-cache");

            // 2. VERIFICACIÓN DE SESIÓN (Redirección limpia)
            if (Session["Usuario"] == null)
            {
                Response.Redirect("~/Default.aspx", false);
                HttpContext.Current.ApplicationInstance.CompleteRequest();
            }
        }

        protected void btnCerrarSesion_Click(object sender, EventArgs e)
        {
            // 1. Limpiar todas las variables de la sesión actual
            Session.Clear();

            // 2. Destruir la sesión por completo en la memoria del servidor
            Session.Abandon();

            // 3. Redirigir al login de forma limpia (evitando excepciones de hilo)
            Response.Redirect("~/Default.aspx", false);
            HttpContext.Current.ApplicationInstance.CompleteRequest();
        }
    }
}