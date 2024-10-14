namespace CasoDePoliciaConverter.Classes
{
    internal class GameData
    {
        public List<Suggestion> Suggetions { get; set; } = [];

        public List<News> News { get; set; } = [];

        public InitialStatus InitialStatus { get; set; } = new();


    }
}
