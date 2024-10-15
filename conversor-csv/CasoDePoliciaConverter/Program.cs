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
    var newsFile = "news.csv";
    var suggestionFile = "suggestions.csv";

    if (opts.Interactive)
    {
        Console.WriteLine("Selecione o arquivo de Noticias (news.csv):");
        newsFile = Console.ReadLine();
        if (string.IsNullOrEmpty(newsFile))
        {
            newsFile = "news.csv";
        }
        Console.WriteLine("Selecione o arquivo de sugestões (suggestions.csv):");
        suggestionFile = Console.ReadLine();
        if (string.IsNullOrEmpty(suggestionFile))
        {
            suggestionFile = "suggestions.csv";
        }

        Console.WriteLine("Nivel de segurança inicial (50):");
        var initialSecurity = Console.ReadLine();
        if (string.IsNullOrEmpty(initialSecurity) || !float.TryParse(initialSecurity, out var _))
        {
            initialSecurity = "50";
        }
        gameData.InitialStatus.Criminality = float.Parse(initialSecurity);

        Console.WriteLine("Nivel de popularidade inicial (50):");
        var initialPopularity = Console.ReadLine();
        if (string.IsNullOrEmpty(initialPopularity) || !float.TryParse(initialPopularity, out var _))
        {
            initialPopularity = "50";
        }
        gameData.InitialStatus.Popularity = float.Parse(initialPopularity);

        Console.WriteLine("Dinheiro inicial (20):");
        var initialCash = Console.ReadLine();
        if (string.IsNullOrEmpty(initialCash) || !float.TryParse(initialCash, out var _))
        {
            initialCash = "20";
        }
        gameData.InitialStatus.Cash = float.Parse(initialCash);

        Console.WriteLine("Tempo de duração da transicao em segundos (2):");
        var transitionTime = Console.ReadLine();
        if (string.IsNullOrEmpty(transitionTime) || !float.TryParse(transitionTime, out var _))
        {
            transitionTime = "2";
        }
        gameData.InitialStatus.TransitionTime = float.Parse(transitionTime);

        Console.WriteLine("Limite de dias (7):");
        var daysLimit = Console.ReadLine();
        if (string.IsNullOrEmpty(daysLimit) || !float.TryParse(daysLimit, out var _))
        {
            daysLimit = "7";
        }
        gameData.InitialStatus.DaysLimit = float.Parse(daysLimit);
    }
    else
    {
        newsFile = opts.News;
        suggestionFile = opts.Suggestions;
        gameData.InitialStatus.TransitionTime = opts.TransitionTime;
        gameData.InitialStatus.Cash = opts.InitialCash;
        gameData.InitialStatus.Popularity = opts.InitialPopularity;
        gameData.InitialStatus.Criminality = opts.InitialCriminality;
        gameData.InitialStatus.DaysLimit = opts.DaysLimit;
    }

    foreach (var line in CsvReader.ReadFromText(File.ReadAllText(newsFile)))
    {

        gameData.News.Add(new News
        {
            Text = line["Text"],
            SuggestionId = line["SuggestionId"]
        });
    }

    foreach (var line in CsvReader.ReadFromText(File.ReadAllText(suggestionFile)))
    {

        gameData.Suggetions.Add(new Suggestion
        {
            Id = line["Id"],
            Text = line["Text"],
            Candidate = line["Candidate"],
            Cost = float.TryParse(line["Cost"], out var cost) ? cost : 0,
            Criminality = float.TryParse(line["Criminality"], out var security) ? security : 0,
            Popularity = float.TryParse(line["Popularity"], out var popularity) ? popularity : 0,
        });
    }

    var gameDataJson = JsonSerializer.Serialize(gameData, new JsonSerializerOptions { WriteIndented = true, Encoder = JavaScriptEncoder.UnsafeRelaxedJsonEscaping });

    File.WriteAllText("GameData.json", gameDataJson, Encoding.UTF8);

    Console.WriteLine("Arquivo salvo : GameData.json");
}



