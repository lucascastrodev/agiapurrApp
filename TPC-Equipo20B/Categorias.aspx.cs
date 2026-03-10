using Dominio;
using Negocio;
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.UI.WebControls;


namespace TPC_Equipo20B
{
    public partial class Categorias : System.Web.UI.Page
    {
        private string cn => ConfigurationManager.ConnectionStrings["COMERCIO_DB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            Permisos.RequiereAdmin(this);

            if (!IsPostBack) BindGrid("");
        }

        protected void btnBuscar_Click(object sender, EventArgs e)
        {
            BindGrid(txtBuscar.Text.Trim());
        }

        protected void gvCategorias_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvCategorias.PageIndex = e.NewPageIndex;
            BindGrid(txtBuscar.Text.Trim());
        }

        private void BindGrid(string q)
        {
            CategoriaNegocio negocio = new CategoriaNegocio();
            var lista = negocio.Listar(q);

            // Agregamos el formateador acá también
            System.Globalization.TextInfo textInfo = new System.Globalization.CultureInfo("es-AR", false).TextInfo;

            gvCategorias.DataSource = lista.Select(c => new
            {
                c.Id,
                // En vez de .ToUpper(), usamos el formateador lindo
                Nombre = textInfo.ToTitleCase((c.Nombre ?? "").ToLower())
            }).ToList();

            gvCategorias.DataBind();
        }

    }
}
