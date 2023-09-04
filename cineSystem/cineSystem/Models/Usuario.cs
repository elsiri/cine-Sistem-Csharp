using System;
using System.Collections.Generic;

namespace cineSystem.Models;

public partial class Usuario
{
    public int IdUser { get; set; }

    public string? Nombre { get; set; }

    public string? Email { get; set; }

    public string? Password { get; set; }
}
