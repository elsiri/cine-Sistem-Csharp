using System;
using System.Collections.Generic;

namespace cineSistem.Models;

public partial class RankingPelicula
{
    public int Id { get; set; }

    public int IdPel { get; set; }

    public int Ranking { get; set; }

    public virtual Pelicula IdPelNavigation { get; set; } = null!;
}
