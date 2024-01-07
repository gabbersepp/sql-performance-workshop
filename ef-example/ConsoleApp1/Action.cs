using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApp1
{
    [Table("Action")]
    public class Action
    {
        [Key]
        public int Id { get; set; }
        [Column("Action")]
        public string SystemAction { get; set; }
        public DateTimeOffset Date { get; set; }
        public int CreatorId { get; set; }
        public virtual IList<Detail> Details { get; set; }
    }
}
