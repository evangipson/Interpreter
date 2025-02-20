using System.Text.Json;

namespace Interpreter.Domain.Extensions
{
    /// <summary>
    /// A <see langword="static"/> collection of methods used to extend <see langword="string"/>.
    /// </summary>
    public static class StringExtensions
    {
        /// <summary>
        /// Tries to get a JSON object from the <paramref name="scriptOutput"/>.
        /// <para>
        /// Will give back <paramref name="scriptOutput"/> if it's unable to parse it as JSON.
        /// </para>
        /// </summary>
        /// <param name="scriptOutput">
        /// The <see langword="string"/> to parse as JSON.
        /// </param>
        /// <returns>
        /// Either a JSON-friendly version of <paramref name="scriptOutput"/>, or <paramref name="scriptOutput"/> itself.
        /// </returns>
        public static object TryGetJsonObject(this string scriptOutput)
        {
            // Don't even try to deserialize the JSON if the right characters aren't there.
            IEnumerable<char> jsonCharacters = [ '{', '[' ];
            if (!jsonCharacters.Any(scriptOutput.StartsWith))
            {
                return scriptOutput;
            }

            try
            {
                return JsonSerializer.Deserialize<JsonElement>(scriptOutput);
            }
            catch
            {
                return scriptOutput;
            }
        }
    }
}
