using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Dominio
{
    public class PrecioCompra
    {
        public int Id { get; set; }
        public int ProductoId { get; set; }
        public DateTime Fecha { get; set; }
        public decimal PrecioUnitario { get; set; }
    }
}
