using CommandLine;

namespace CasoDePoliciaConverter.Configuration
{
    internal class Options
    {
        [Option('i', "interativo", Required = false, HelpText = "execução interativa", Default = false)]
        public bool Interactive { get; set; }

        [Option('s', "sugestoes", Required = false, HelpText = "arquivo .csv de sugestões", Default = "suggestions.csv")]
        public string Suggestions { get; set; } = "suggestions.csv";

        [Option('n', "noticias", Required = false, HelpText = "arquivo .csv de noticias", Default = "news.csv")]
        public string News { get; set; } = "news.csv";

        [Option('c', "criminalidade", Required = false, HelpText = "criminalidade inicial", Default = 50)]
        public int InitialCriminality { get; set; } = 50;

        [Option('p', "popularidade", Required = false, HelpText = "popularidade inicial", Default = 50)]
        public int InitialPopularity { get; set; } = 50;

        [Option('d', "dinheiro", Required = false, HelpText = "dinheiro inicial", Default = 50)]
        public int InitialCash { get; set; } = 50;

        [Option('t', "tempo", Required = false, HelpText = "tempo de transição do dia", Default = 2)]
        public float DayTime { get; set; } = 2;
    }
}
