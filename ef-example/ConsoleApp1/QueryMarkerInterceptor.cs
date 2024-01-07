using Microsoft.EntityFrameworkCore.Diagnostics;
using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace ConsoleApp1
{
    public class QueryMarkerInterceptor : DbCommandInterceptor
    {
        public override InterceptionResult<DbDataReader> ReaderExecuting(DbCommand command, CommandEventData eventData, InterceptionResult<DbDataReader> result)
        {
            FillWithStacktrace(command);

            return result;
        }

        public override InterceptionResult<object> ScalarExecuting(DbCommand command, CommandEventData eventData, InterceptionResult<object> result)
        {
            FillWithStacktrace(command);

            return result;
        }

        private static void FillWithStacktrace(DbCommand cmd)
        {
            var trace = new System.Diagnostics.StackTrace().ToString();
            cmd.CommandText += "--" + trace.Split(new[] { '\r', '\n' }, StringSplitOptions.RemoveEmptyEntries)
                .Aggregate((x, y) => x + " - " + y);
        }
    }
}
