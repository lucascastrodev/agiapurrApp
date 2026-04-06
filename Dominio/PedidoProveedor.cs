using System;
using System.Collections.Generic;

namespace Dominio
{
    public class PedidoProveedor
    {
        public int Id { get; set; }

        // Quién es el proveedor al que le pedimos
        public Proveedor Proveedor { get; set; }

        // Qué usuario (empleado/admin) registró este pedido
        public Usuario Usuario { get; set; }

        public DateTime FechaEmision { get; set; }

        public decimal TotalEstimado { get; set; }

        public string Estado { get; set; } // Pendiente, Recibido, Cancelado

        // Lista con todos los productos que tiene este pedido adentro
        public List<PedidoProveedorLinea> Lineas { get; set; }

        // Constructor para inicializar los objetos y la lista, evitando errores de "Referencia Nula"
        public PedidoProveedor()
        {
            Proveedor = new Proveedor();
            Usuario = new Usuario();
            Lineas = new List<PedidoProveedorLinea>();
            Estado = "Pendiente"; // Estado por defecto al crear uno nuevo
            FechaEmision = DateTime.Now;
        }
    }
}