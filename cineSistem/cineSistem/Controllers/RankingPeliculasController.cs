using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using cineSistem.Models;

namespace cineSistem.Controllers
{
    public class RankingPeliculasController : Controller
    {
        private readonly CineSistemContext _context;

        public RankingPeliculasController(CineSistemContext context)
        {
            _context = context;
        }

        // GET: RankingPeliculas
        public async Task<IActionResult> Index()
        {
            var cineSistemContext = _context.RankingPeliculas.Include(r => r.IdPelNavigation);
            return View(await cineSistemContext.ToListAsync());
        }
        public IActionResult Grafica()
        {
            // Recuperar los nombres de las películas y las calificaciones promedio
            var datos = _context.Peliculas
                .Select(p => new
                {
                    NombrePelicula = p.Nombre,
                    CalificacionPromedio = p.RankingPeliculas.Average(rp => rp.Ranking)
                })
                .OrderByDescending(p => p.CalificacionPromedio)
                .Take(5) // Obtener las 5 películas con calificación promedio más alta
                .ToList();

            // Convertir los datos en dos arrays separados para usar en la gráfica
            var nombresPeliculas = datos.Select(d => d.NombrePelicula).ToArray();
            var calificacionesPromedio = datos.Select(d => d.CalificacionPromedio).ToArray();

            // Pasar los datos a la vista
            ViewBag.NombresPeliculas = nombresPeliculas;
            ViewBag.CalificacionesPromedio = calificacionesPromedio;

            return View();
        }
        // GET: RankingPeliculas/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null || _context.RankingPeliculas == null)
            {
                return NotFound();
            }

            var rankingPelicula = await _context.RankingPeliculas
                .Include(r => r.IdPelNavigation)
                .FirstOrDefaultAsync(m => m.Id == id);
            if (rankingPelicula == null)
            {
                return NotFound();
            }

            return View(rankingPelicula);
        }

        // GET: RankingPeliculas/Create
        public IActionResult Create()
        {
            ViewData["IdPel"] = new SelectList(_context.Peliculas, "IdPel", "IdPel");
            return View();
        }

        // POST: RankingPeliculas/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("Id,IdPel,Ranking")] RankingPelicula rankingPelicula)
        {
            
                _context.Add(rankingPelicula);
                await _context.SaveChangesAsync();


            ViewData["IdPel"] = new SelectList(_context.Peliculas, "IdPel", "IdPel", rankingPelicula.IdPel);
            return RedirectToAction(nameof(Index));
        }
        public IActionResult Calificar(int idPel, int rank)
        {
            var nuevoRanking = new RankingPelicula
            {
                IdPel = idPel,
                Ranking = rank
            };
            _context.Add(nuevoRanking);
            _context.SaveChangesAsync();
            TempData["MensajeExito"] = "El ranking se ha guardado exitosamente.";
            return RedirectToAction("Index", "Peliculas");
        }
        // GET: RankingPeliculas/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null || _context.RankingPeliculas == null)
            {
                return NotFound();
            }

            var rankingPelicula = await _context.RankingPeliculas.FindAsync(id);
            if (rankingPelicula == null)
            {
                return NotFound();
            }
            ViewData["IdPel"] = new SelectList(_context.Peliculas, "IdPel", "IdPel", rankingPelicula.IdPel);
            return View(rankingPelicula);
        }

        // POST: RankingPeliculas/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to.
        // For more details, see http://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("Id,IdPel,Ranking")] RankingPelicula rankingPelicula)
        {
            if (id != rankingPelicula.Id)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(rankingPelicula);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!RankingPeliculaExists(rankingPelicula.Id))
                    {
                        return NotFound();
                    }
                    else
                    {
                        throw;
                    }
                }
                return RedirectToAction(nameof(Index));
            }
            ViewData["IdPel"] = new SelectList(_context.Peliculas, "IdPel", "IdPel", rankingPelicula.IdPel);
            return View(rankingPelicula);
        }

        // GET: RankingPeliculas/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null || _context.RankingPeliculas == null)
            {
                return NotFound();
            }

            var rankingPelicula = await _context.RankingPeliculas
                .Include(r => r.IdPelNavigation)
                .FirstOrDefaultAsync(m => m.Id == id);
            if (rankingPelicula == null)
            {
                return NotFound();
            }

            return View(rankingPelicula);
        }

        // POST: RankingPeliculas/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            if (_context.RankingPeliculas == null)
            {
                return Problem("Entity set 'CineSistemContext.RankingPeliculas'  is null.");
            }
            var rankingPelicula = await _context.RankingPeliculas.FindAsync(id);
            if (rankingPelicula != null)
            {
                _context.RankingPeliculas.Remove(rankingPelicula);
            }
            
            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool RankingPeliculaExists(int id)
        {
          return (_context.RankingPeliculas?.Any(e => e.Id == id)).GetValueOrDefault();
        }
    }
}
