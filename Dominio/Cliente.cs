using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Dominio
{
    public class Cliente
    {
        public int Id { get; set; }
        public string Nombre { get; set; }
        public string Documento { get; set; }
        public string Email { get; set; }
        public string Telefono { get; set; }
        public string Direccion { get; set; }
        public string Localidad { get; set; }

        public string Observaciones { get; set; }

        public string CondicionIVA { get; set; }
        public bool Habilitado { get; set; } = true;
        public int IdUsuarioAlta { get; set; }
        public string NombreVendedor { get; set; }

        public bool Activo { get; set; } = true;
    }
}