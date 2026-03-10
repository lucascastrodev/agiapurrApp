using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Dominio
{
    public class Usuario
    {
        public int Id { get; set; }
        public string Nombre { get; set; }
        public string Documento { get; set; }
        public string Email { get; set; }
        public string Telefono { get; set; }
        public string Direccion { get; set; }

        public string Observaciones { get; set; }
        public string Localidad { get; set; }
        public string Username { get; set; }
        public string Password { get; set; }
        public bool Activo { get; set; } = true;

        public List<UsuarioRol> Roles { get; set; } = new List<UsuarioRol>();

        public string RolDescripcion
        {
            get
            {
                return Roles.Count > 0 ? Roles.First().Nombre : "Sin rol";
            }
        }

    }
}
