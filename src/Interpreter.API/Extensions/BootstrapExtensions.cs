using Scalar.AspNetCore;

using Interpreter.Domain.Options;
using Interpreter.Logic.Managers;
using Interpreter.Logic.Services;

namespace Interpreter.API.Extensions;

internal static class BootstrapExtensions
{
    internal static WebApplicationBuilder ConfigureBuilder(this WebApplicationBuilder builder)
    {
        builder.AddConfigurationOptions();

        builder.Services
            .Configure<RouteOptions>(options => options.LowercaseUrls = true)
            .AddOpenApi()
            .AddAuthorization()
            .AddScoped<ISettingsService, SettingsService>()
            .AddScoped<IScriptService, ScriptService>()
            .AddScoped<IScriptManager, ScriptManager>()
            .AddControllers();

        return builder;
    }

    internal static WebApplication ConfigureApplication(this WebApplication app)
    {
        if (app.Environment.IsDevelopment())
        {
            app.MapOpenApi();
            app.MapScalarApiReference(options =>
            {
                options.WithTitle("My API");
                options.WithTheme(ScalarTheme.BluePlanet);
                options.WithSidebar(false);
            });
        }

        app.UseHttpsRedirection();
        app.UseAuthorization();
        app.MapControllers();

        return app;
    }

    private static WebApplicationBuilder AddConfigurationOptions(this WebApplicationBuilder builder) => builder
        .BindOptions<ScriptSettings>();

    private static WebApplicationBuilder BindOptions<T>(this WebApplicationBuilder builder) where T : class
    {
        var configurationSection = builder.Configuration.GetSection(typeof(T).Name);
        if (!configurationSection.GetChildren().Any())
        {
            throw new InvalidOperationException($"{nameof(BindOptions)}: '{typeof(T).Name}' section missing from application settings.");
        }

        _ = builder.Services.AddOptions<T>().Bind(configurationSection);

        return builder;
    }
}
