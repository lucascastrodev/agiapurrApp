using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Dominio
{
    public class ProductoProveedor
    {
        public int Id { get; set; }

        // Relación con el Proveedor
        public Proveedor Proveedor { get; set; }

        public string Codigo { get; set; }

        // El nombre específico que usa el proveedor en su lista de precios
        public string Descripcion { get; set; }

        // Relación con la Marca
        public Marca Marca { get; set; }

        public decimal PrecioUnitario { get; set; }

        public int UnidadesPorPack { get; set; }

        public bool Estado { get; set; }

        public decimal SubtotalBruto { get; set; }
        public decimal DescuentoPorcentaje { get; set; }
        public decimal DescuentoMonto { get; set; }
        public decimal SubtotalNeto { get; set; }
        public decimal MontoIVA { get; set; }
        public decimal MontoIIBB { get; set; }
        public decimal MontoPercepcion { get; set; }

        // Recordá que ya tenías la propiedad TotalEstimado

        // Constructor para inicializar los objetos anidados y evitar NullReferenceExceptions
        public ProductoProveedor()
        {
            Proveedor = new Proveedor();
            Marca = new Marca();
        }
    }
}
