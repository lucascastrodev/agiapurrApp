using Dominio;
using Negocio;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace TPC_Equipo20B
{
    public partial class Proveedores : System.Web.UI.Page
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

        protected void gvProveedores_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvProveedores.PageIndex = e.NewPageIndex;
            BindGrid(txtBuscar.Text.Trim());
        }

        private void BindGrid(string q)
        {
            ProveedorNegocio negocio = new ProveedorNegocio();
            List<Proveedor> lista = negocio.Listar(q);

            var listaView = lista.Select(p => new
            {
                p.Id,
                NombreCompleto =
                    string.IsNullOrWhiteSpace(p.Nombre)
                        ? p.RazonSocial.ToUpper()
                        : (p.Nombre.ToUpper() + " (" + p.RazonSocial.ToUpper() + ")"),
                Documento = p.Documento ?? "",
                Telefono = p.Telefono ?? ""
            }).ToList();

            gvProveedores.DataSource = listaView;
            gvProveedores.DataBind();
        }

    }
}
