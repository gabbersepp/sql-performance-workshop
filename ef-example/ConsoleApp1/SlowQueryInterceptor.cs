using Microsoft.EntityFrameworkCore.Diagnostics;
using System.Data.Common;
using System.Diagnostics;

namespace ConsoleApp1;

public class SlowQueryInterceptor : DbCommandInterceptor
{
    private const int DurationLongerThanMs = 10_000;
    private Stopwatch sw; 

    public override InterceptionResult<DbDataReader> ReaderExecuting(DbCommand command, CommandEventData eventData, InterceptionResult<DbDataReader> result)
    {
        sw = new Stopwatch();
        sw.Start();
        return base.ReaderExecuting(command, eventData, result);
    }

    public override void CommandFailed(DbCommand command, CommandErrorEventData eventData)
    {
        sw.Stop();
        if (sw.ElapsedMilliseconds > DurationLongerThanMs)
        {
            Console.WriteLine($"Slow Query: {command.CommandText}");
        }

        base.CommandFailed(command, eventData);
    }

    public override DbDataReader ReaderExecuted(DbCommand command, CommandExecutedEventData eventData, DbDataReader result)
    {
        sw.Stop();
        if (sw.ElapsedMilliseconds > DurationLongerThanMs)
        {
            Console.WriteLine($"Slow Query: {command.CommandText}");
        }
        return base.ReaderExecuted(command, eventData, result);
    }
}