using System;
using Dominio;

namespace TPC_Equipo20B
{
    public partial class Site : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Response.Cache.SetCacheability(System.Web.HttpCacheability.NoCache);
            Response.Cache.SetExpires(DateTime.UtcNow.AddMinutes(-1));
            Response.Cache.SetNoStore();
            Response.AppendHeader("Pragma", "no-cache");

            // Verificar si el usuario está logueado
            if (Session["Usuario"] == null)
            {
                Response.Redirect("~/Default.aspx");
            }
        }

        protected void btnCerrarSesion_Click(object sender, EventArgs e)
        {
            // Limpiar todas las variables de sesión
            Session.Clear();
            Session.Abandon();

            // Redirigir al login
            Response.Redirect("~/Default.aspx");
        }
    }
}