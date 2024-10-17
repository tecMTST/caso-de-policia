using CasoDePoliciaConverter.Classes;
using CasoDePoliciaConverter.Configuration;
using CommandLine;
using Csv;
using System.Text;
using System.Text.Encodings.Web;
using System.Text.Json;

Console.WriteLine("Conversão de csv para Json - Caso de Polícia");

Parser.Default.ParseArguments<Options>(args)
    .WithParsed(RunOptions);

 
static void RunOptions(Options opts)
{
    var gameData = new GameData();
    var configFile = "config.csv";
    var newsFile = "noticias.csv";
    var suggestionFile = "sugstoes.csv";

    if (opts.Interactive)
    {
        Console.WriteLine("Selecione o arquivo de Noticias (noticias.csv):");
        newsFile = Console.ReadLine();
        if (string.IsNullOrEmpty(newsFile))
        {
            newsFile = "news.csv";
        }
        Console.WriteLine("Selecione o arquivo de sugestões (sugstoes.csv):");
        suggestionFile = Console.ReadLine();
        if (string.IsNullOrEmpty(suggestionFile))
        {
            suggestionFile = "suggestions.csv";
        }
        Console.WriteLine("Selecione o arquivo de configurações (config.csv):");
        configFile = Console.ReadLine();
        if (string.IsNullOrEmpty(configFile))
        {
            configFile = "config.csv";
        }
    }
    else
    {
        newsFile = opts.News;
        suggestionFile = opts.Suggestions;
        configFile = opts.Config;        
    }

    foreach (var line in CsvReader.ReadFromText(File.ReadAllText(newsFile)))
    {

        gameData.Noticias.Add(new News
        {
            Texto = line["Texto"],
            SugestaoId = line["SugestaoId"]
        });
    }

    foreach (var line in CsvReader.ReadFromText(File.ReadAllText(suggestionFile)))
    {

        gameData.Sugestoes.Add(new Suggestion
        {
            Id = line["Id"],
            Texto = line["Texto"],
            Conselheiro = line["Conselheiro"],
            Custo = float.TryParse(line["Custo"], out var cost) ? cost : 0,
            Criminalidade = float.TryParse(line["Criminalidade"], out var security) ? security : 0,
            Popularidade = float.TryParse(line["Popularidade"], out var popularity) ? popularity : 0,
        });
    }

    var configLine = CsvReader.ReadFromText(File.ReadAllText(configFile)).FirstOrDefault();
    if (configLine != null)
    {
        gameData.Configuracoes = new Configuracoes
        {
            CriminalidadeInicial = float.TryParse(configLine["CriminalidadeInicial"], out var crime) ? crime : 0,
            PopularidadeInicial = float.TryParse(configLine["PopularidadeInicial"], out var popu) ? popu : 0,
            DinheiroInicial = float.TryParse(configLine["DinheiroInicial"], out var cash) ? cash : 0,
            LimiteDias = int.TryParse(configLine["LimiteDias"], out var days) ? days : 0,
            TempoTransicao = float.TryParse(configLine["TempoTransicao"], out var time) ? time : 0,
            CriminalidadeVitoriaAlta = float.TryParse(configLine["CriminalidadeVitoriaAlta"], out var crimeAlta) ? crimeAlta : 0,
            CriminalidadeVitoriaModerada = float.TryParse(configLine["TempoTransicao"], out var crimeModerada) ? crimeModerada : 0,
            PopularidadeVitoriaAlta = float.TryParse(configLine["CriminalidadeVitoriaModerada"], out var popAlta) ? popAlta : 0,
            PopularidadeVitoriaModerada = float.TryParse(configLine["PopularidadeVitoriaModerada"], out var popModerada) ? popModerada : 0,
            TextoVitoriaAlta = configLine["TextoVitoriaAlta"],
            TextoVitoriaModerada = configLine["TextoVitoriaModerada"],
            TextoDerrota = configLine["TextoDerrota"],
            TextoDerrotaDinheiro = configLine["TextoDerrotaDinheiro"],
            InclinacaoNeutro = float.TryParse(configLine["InclinacaoNeutro"], out var inclinacao) ? inclinacao : 0,
            TextoNeutro = configLine["TextoNeutro"]
        };
    }

    var gameDataJson = JsonSerializer.Serialize(gameData, new JsonSerializerOptions { WriteIndented = true, Encoder = JavaScriptEncoder.UnsafeRelaxedJsonEscaping });

    File.WriteAllText("GameData.json", gameDataJson, Encoding.UTF8);

    Console.WriteLine("Arquivo salvo : GameData.json");
}



