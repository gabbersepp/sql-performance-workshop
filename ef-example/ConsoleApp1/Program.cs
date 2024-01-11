// See https://aka.ms/new-console-template for more information
using ConsoleApp1;

public class Program
{
    public static void Main()
    {
        Console.WriteLine("Hello, World!");

        using (var context = new ExampleContext(new RecompileInterceptor(), new QueryMarkerInterceptor()))
        {
            var action = context.Actions.First();

            // Select *, aber es wird nur ein Property benutzt
            Console.WriteLine(action.SystemAction);
        }
    }
}
