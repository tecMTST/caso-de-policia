namespace CasoDePoliciaConverter.Classes
{
    internal class Suggestion
    {
        public string Id { get; set; } = string.Empty;

        public string Conselheiro { get; set; } = string.Empty;

        public string Texto { get; set; } = string.Empty;

        public float Custo { get; set; } = 0;

        public float Criminalidade { get; set; } = 0;

        public float Popularidade { get; set; } = 0;
    }
}
