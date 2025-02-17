using Scalar.AspNetCore;

using Interpreter.Domain.Options;
using Interpreter.Logic.Managers;
using Interpreter.Logic.Services;

namespace Interpreter.API.Extensions;

/// <summary>
/// A <see langword="static"/> collection of methods for bootstrapping the application.
/// </summary>
internal static class BootstrapExtensions
{
    /// <summary>
    /// Configures the provided <paramref name="builder"/> by adding Open API, authorization, and all required services, then returns it.
    /// </summary>
    /// <param name="builder">
    /// The <see cref="WebApplicationBuilder"/> to configure and <see langword="return"/>.
    /// </param>
    /// <returns>
    /// The configured <paramref name="builder"/>.
    /// </returns>
    internal static WebApplicationBuilder ConfigureBuilder(this WebApplicationBuilder builder)
    {
        builder.AddConfigurationOptions();

        builder.Services
            .Configure<RouteOptions>(options => options.LowercaseUrls = true)
            .AddOpenApi()
            .AddAuthorization()
            .AddSingleton<ISettingsService, SettingsService>()
            .AddSingleton<IScriptService, ScriptService>()
            .AddSingleton<IScriptManager, ScriptManager>()
            .AddControllers();

        return builder;
    }

    /// <summary>
    /// Configures the provided <paramref name="app"/> by adding Open API development configuration, and HTTP configurations, then returns it.
    /// </summary>
    /// <param name="builder">
    /// The <see cref="WebApplication"/> to configure and <see langword="return"/>.
    /// </param>
    /// <returns>
    /// The configured <paramref name="app"/>.
    /// </returns>
    internal static WebApplication ConfigureApplication(this WebApplication app)
    {
        if (app.Environment.IsDevelopment())
        {
            app.MapOpenApi();
            app.MapScalarApiReference(options =>
            {
                options.WithTitle("Interpreter Api v1 Documentation");
                options.WithLayout(ScalarLayout.Modern);
                options.WithDarkMode(true);
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
