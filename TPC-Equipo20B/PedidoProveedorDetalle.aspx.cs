using System;
using System.Web.UI;
using Dominio;
using Negocio;

namespace TPC_Equipo20B
{
    public partial class PedidoProveedorDetalle : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Permisos.RequiereAdmin(this);

            if (!IsPostBack)
            {
                if (Request.QueryString["id"] != null)
                {
                    int idPedido = int.Parse(Request.QueryString["id"]);
                    CargarComprobante(idPedido);
                }
                else
                {
                    Response.Redirect("PedidosProveedores.aspx", false);
                }
            }
        }

        private void CargarComprobante(int idPedido)
        {
            try
            {
                // USAMOS UN MÉTODO DIFERENTE, CREADO ESPECÍFICAMENTE PARA ESTO
                PedidoProveedor pedido = ObtenerDetalleCompletoPorId(idPedido);

                if (pedido != null)
                {
                    // 1. Cargar Cabecera
                    lblNumeroPedido.Text = pedido.Id.ToString("D5");
                    lblFecha.Text = pedido.FechaEmision.ToString("dd/MM/yyyy");
                    lblEstado.Text = pedido.Estado.ToUpper();

                    if (pedido.Estado == "Recibido") lblEstado.CssClass = "badge bg-success bg-opacity-10 text-success border border-success";
                    else if (pedido.Estado == "Cancelado") lblEstado.CssClass = "badge bg-danger bg-opacity-10 text-danger border border-danger";

                    // 2. Cargar Proveedor y Usuario (Ahora sí tienen nombre)
                    lblProveedorNombre.Text = pedido.Proveedor.Nombre;
                    lblUsuario.Text = pedido.Usuario.Nombre;

                    // 3. Cargar Tabla de Productos (Detalle)
                    repDetalles.DataSource = pedido.Lineas;
                    repDetalles.DataBind();

                    // 4. Cargar Total
                    lblTotal.Text = pedido.TotalEstimado.ToString("C");
                }
                else
                {
                    lblError.Text = "No se encontró el pedido.";
                    lblError.Visible = true;
                    pnlComprobante.Visible = false;
                }
            }
            catch (Exception ex)
            {
                lblError.Text = "Error al cargar el detalle: " + ex.Message;
                lblError.Visible = true;
                pnlComprobante.Visible = false;
            }
        }

        // --- MÉTODO DE NEGOCIO LOCAL (Para evitar tocar la clase Negocio y re-hacerlo acá) ---
        private PedidoProveedor ObtenerDetalleCompletoPorId(int idPedido)
        {
            PedidoProveedor pedido = new PedidoProveedor();
            AccesoDatos datos = new AccesoDatos();
            try
            {
                // ESTA CONSULTA SÍ TRAE EL NOMBRE DEL PROVEEDOR
                datos.setearConsulta(@"
                    SELECT P.Id, P.IdProveedor, PR.Nombre AS NombreProveedor, 
                           P.IdUsuario, U.Nombre AS NombreUsuario, 
                           P.FechaEmision, P.TotalEstimado, P.Estado 
                    FROM PEDIDOS_PROVEEDOR P
                    INNER JOIN PROVEEDORES PR ON P.IdProveedor = PR.Id
                    INNER JOIN USUARIOS U ON P.IdUsuario = U.Id
                    WHERE P.Id = @id");

                datos.setearParametro("@id", idPedido);
                datos.ejecutarLectura();

                if (datos.Lector.Read())
                {
                    pedido.Id = (int)datos.Lector["Id"];
                    pedido.Proveedor.Id = (int)datos.Lector["IdProveedor"];
                    pedido.Proveedor.Nombre = (string)datos.Lector["NombreProveedor"]; // CARGAR EL NOMBRE
                    pedido.Usuario.Id = (int)datos.Lector["IdUsuario"];
                    pedido.Usuario.Nombre = (string)datos.Lector["NombreUsuario"]; // CARGAR EL NOMBRE DEL USUARIO
                    pedido.FechaEmision = (DateTime)datos.Lector["FechaEmision"];
                    pedido.TotalEstimado = (decimal)datos.Lector["TotalEstimado"];
                    pedido.Estado = (string)datos.Lector["Estado"];
                }
                datos.CerrarConexion();

                // Traemos el detalle
                datos = new AccesoDatos();
                datos.setearConsulta(@"
                    SELECT D.Id, D.IdProductoProveedor, D.Cantidad, D.PrecioUnitario, D.Subtotal, 
                           P.Codigo, P.Descripcion 
                    FROM PEDIDOS_PROVEEDOR_DETALLE D
                    INNER JOIN PRODUCTOS_PROVEEDOR P ON D.IdProductoProveedor = P.Id
                    WHERE D.IdPedido = @idPed");

                datos.setearParametro("@idPed", idPedido);
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    PedidoProveedorLinea linea = new PedidoProveedorLinea();
                    linea.Id = (int)datos.Lector["Id"];
                    linea.Cantidad = (int)datos.Lector["Cantidad"];
                    linea.PrecioUnitario = (decimal)datos.Lector["PrecioUnitario"];
                    linea.Producto.Id = (int)datos.Lector["IdProductoProveedor"];
                    linea.Producto.Codigo = (string)datos.Lector["Codigo"];
                    linea.Producto.Descripcion = (string)datos.Lector["Descripcion"];

                    pedido.Lineas.Add(linea);
                }
                return pedido;
            }
            finally { datos.CerrarConexion(); }
        }
    }
}