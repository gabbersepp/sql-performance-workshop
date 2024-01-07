using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Diagnostics;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApp1
{
    public class ExampleContext : DbContext
    {
        public DbSet<Action> Actions { get; set; }
        public DbSet<Detail> Details { get; set; }

        private List<DbCommandInterceptor> interceptors = new List<DbCommandInterceptor>();

        public ExampleContext() { }

        public ExampleContext(params DbCommandInterceptor[] interceptors)
        {
            this.interceptors.AddRange(interceptors);
        }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            interceptors.ForEach(x => optionsBuilder.AddInterceptors(x));
            optionsBuilder.UseSqlServer("Server=localhost;Database=workshop;User Id=sa;Password=Test1234!;TrustServerCertificate=True");
        }
    }
}
