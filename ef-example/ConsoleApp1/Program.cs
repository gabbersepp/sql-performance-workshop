// See https://aka.ms/new-console-template for more information

using System.Transactions;
using ConsoleApp1;
using Microsoft.EntityFrameworkCore;
using IsolationLevel = System.Data.IsolationLevel;

public class Program
{
    public static void Main()
    {
        Console.WriteLine("Hello, World!");

        using (var context = new ExampleContext(new RecompileInterceptor(), new QueryMarkerInterceptor(), new SlowQueryInterceptor()))
        {
            // für slow query interceptor:
            /* READ COMMITTED SNAPSHOT ISOLATION ausschalten
             * begin transaction
                select * from action where id = 1
             */
            context.Database.BeginTransaction(IsolationLevel.ReadCommitted);
            context.Database.SetCommandTimeout(20);
            var action = context.Actions.First();

            // Select *, aber es wird nur ein Property benutzt
            Console.WriteLine(action.SystemAction);
        }
    }
}
