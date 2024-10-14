namespace CasoDePoliciaConverter.Classes
{
    internal class Suggestion
    {
        public string Id { get; set; } = string.Empty;

        public string Candidate { get; set; } = string.Empty;

        public string Text { get; set; } = string.Empty;

        public float Cost { get; set; } = 0;

        public float Criminality { get; set; } = 0;

        public float Popularity { get; set; } = 0;
    }
}
