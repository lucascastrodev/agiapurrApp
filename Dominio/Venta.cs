using System;
using System.Collections.Generic;
using System.Linq;

namespace Dominio
{
    public class Venta
    {
        public int Id { get; set; }
        public Cliente Cliente { get; set; }
        public DateTime Fecha { get; set; }
        public Usuario Usuario { get; set; }
        public string NumeroFactura { get; set; }
        public string NumeroNC { get; set; }
        public string MetodoPago { get; set; }

        public decimal Descuento { get; set; }
        public string TipoVenta { get; set; }

        public List<VentaLinea> Lineas { get; set; } = new List<VentaLinea>();

        public decimal Total
        {
            get
            {
                if (Lineas == null || Lineas.Count == 0)
                    return 0;
                return Lineas.Sum(l => l.Subtotal);
            }
        }

        public decimal TotalBD { get; set; }

        public string Estado { get; set; } = "Activa";

        public string MotivoCancelacion { get; set; }
        public DateTime? FechaCancelacion { get; set; }
        public Usuario UsuarioCancelacion { get; set; }
        
        public decimal Subtotal
        {
            get
            {
                return Lineas != null ? Lineas.Sum(l => l.Subtotal) : 0;
            }
        }
        public decimal MontoDescuento
        {
            get
            {
                return Subtotal * (Descuento / 100m);
            }
        }

        public decimal TotalFinal
        {
            get
            {
                return Subtotal - MontoDescuento;
            }
        }
    }
}