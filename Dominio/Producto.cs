using System;
using System.Collections.Generic;
using System.Linq;

namespace Dominio
{
    public class Producto
    {
        public int Id { get; set; }
        public string CodigoSKU { get; set; }
        public string Descripcion { get; set; }
        public Marca Marca { get; set; }
        public Categoria Categoria { get; set; }
        public Proveedor Proveedor { get; set; }
        public decimal StockMinimo { get; set; }

        public decimal PrecioNeto { get; set; }
        public decimal StockActual { get; set; }

        // % Editable desde la pantalla (Solo afecta al Mayorista SIN IVA)
        public decimal PorcentajeGanancia { get; set; }

        public bool Activo { get; set; } = true;
        public bool Habilitado { get; set; } = true;

        public List<PrecioCompra> PreciosCompra { get; set; } = new List<PrecioCompra>();

        // -----------------------------------------------------------
        // PRECIO MAYORISTA (Columna Z en tu Excel) - REDONDEADO A 100
        // -----------------------------------------------------------
        public decimal PrecioMayorista
        {
            get
            {
                if (Proveedor == null) return 0;

                decimal neto = PrecioNeto > 0
                               ? PrecioNeto
                               : (PreciosCompra != null && PreciosCompra.Count > 0
                                  ? PreciosCompra.OrderByDescending(p => p.Fecha).FirstOrDefault().PrecioUnitario
                                  : 0);

                if (neto == 0) return 0;

                decimal mayoristaExacto = 0;

                if (Proveedor.VendeConIVA)
                {
                    // --- CAMBIO DINÁMICO ---
                    // Antes usábamos 1.21m fijo. 
                    // Ahora usamos el PorcentajeIVA que cargaste en el ABM de Proveedores.
                    // Si el IVA es 21, esto hace: neto * (1 + 0.21) = neto * 1.21
                    decimal factorIVA = 1 + (Proveedor.PorcentajeIVA / 100m);
                    mayoristaExacto = neto * factorIVA;
                }
                else
                {
                    decimal porcentajeEditable = PorcentajeGanancia / 100m;
                    if (porcentajeEditable >= 1m) porcentajeEditable = 0.99m;

                    mayoristaExacto = neto / (1m - porcentajeEditable);
                }

                return Math.Ceiling(mayoristaExacto / 100m) * 100m;
            }
        }

        // -----------------------------------------------------------
        // PRECIO CONSUMIDOR FINAL - REDONDEADO A 100
        // -----------------------------------------------------------
        public decimal PrecioVenta
        {
            get
            {
                if (Proveedor == null) return 0;

                // Z = Precio Mayorista (Traemos el valor calculado arriba ya redondeado a 100)
                decimal mayorista = this.PrecioMayorista;
                if (mayorista == 0) return 0;

                // Tu excel usa el 25% FIJO para Consumidor Final en todos los casos
                decimal porcentajeCF = 0.25m;
                decimal finalExacto = 0;

                if (Proveedor.VendeConIVA)
                {
                    // Fórmula Excel: =(Z7 * 25%) + Z7
                    finalExacto = (mayorista * porcentajeCF) + mayorista;
                }
                else
                {
                    // Fórmula Excel: =Z16 / (1 - 25%)
                    finalExacto = mayorista / (1m - porcentajeCF);
                }

                // Redondeo SIEMPRE para arriba al múltiplo de 100 más cercano
                return Math.Ceiling(finalExacto / 100m) * 100m;
            }
        }
    }
}