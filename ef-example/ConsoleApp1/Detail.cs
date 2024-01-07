using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApp1
{
    [Table("Detail")]
    public class Detail
    {
        public string Discriminator { get; set; }
        [Key]
        public int Id { get; set; }
        public DateTimeOffset Date { get; set; }
        public virtual Action Action { get; set; }
    }
}
