using System;
using System.Collections.Generic;

namespace cineSystem.Models;

public partial class Pelicula
{
    public int IdPel { get; set; }

    public string? Nombre { get; set; }

    public string? Descripcion { get; set; }

    public string? Director { get; set; }

    public string? Genero { get; set; }

    public string? Imagen { get; set; }

    public virtual ICollection<RankingPelicula> RankingPeliculas { get; set; } = new List<RankingPelicula>();
}
