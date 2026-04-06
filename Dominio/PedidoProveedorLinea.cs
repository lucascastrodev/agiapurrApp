using System;

namespace Dominio
{
    public class PedidoProveedorLinea
    {
        public int Id { get; set; }

        // Referencia al producto del catálogo del proveedor
        public ProductoProveedor Producto { get; set; }

        public int Cantidad { get; set; }

        public decimal PrecioUnitario { get; set; }

        public decimal Subtotal
        {
            get { return Cantidad * PrecioUnitario; }
            set {  }
        }

        // Constructor para evitar nulos
        public PedidoProveedorLinea()
        {
            Producto = new ProductoProveedor();
        }
    }
}