using Interpreter.API.Extensions;

namespace Interpreter.API
{
    public class Program
    {
        public static void Main(string[] args) => WebApplication.CreateBuilder(args)
            .ConfigureBuilder()
            .Build()
            .ConfigureApplication()
            .Run();
    }
}
