using CommandLine;

namespace CasoDePoliciaConverter.Configuration
{
    internal class Options
    {
        [Option('i', "interativo", Required = false, HelpText = "execução interativa", Default = false)]
        public bool Interactive { get; set; }

        [Option('s', "sugestoes", Required = false, HelpText = "arquivo .csv de sugestões", Default = "sugestoes.csv")]
        public string Suggestions { get; set; } = "sugestoes.csv";

        [Option('n', "noticias", Required = false, HelpText = "arquivo .csv de noticias", Default = "noticias.csv")]
        public string News { get; set; } = "noticias.csv";

        [Option('c', "config", Required = false, HelpText = "arquivo .csv de configurações", Default = "config.csv")]
        public string Config { get; set; } = "config.csv";
    }
}
