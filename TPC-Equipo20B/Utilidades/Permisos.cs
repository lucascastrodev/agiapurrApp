using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using System.Web.UI;

namespace Dominio
{
    public static class Permisos
    {
        public static void RequiereAdmin(Page pagina)
        {
            if (pagina.Session["Usuario"] == null)
            {
                pagina.Response.Redirect("Default.aspx");
                return;
            }

            // Validamos rol Admin
            bool esAdmin = (bool)(pagina.Session["EsAdmin"] ?? false);

            if (!esAdmin)
            {
                pagina.Response.Redirect("Dashboard.aspx");
                return;
            }
        }
    }
}
