namespace CasoDePoliciaConverter.Classes
{
    internal class GameData
    {
        public List<Suggestion> Sugestoes { get; set; } = [];

        public List<News> Noticias { get; set; } = [];

        public Configuracoes Configuracoes { get; set; } = new();


    }
}
