using System.Reflection.PortableExecutable;

namespace CasoDePoliciaConverter.Classes
{
    internal class Configuracoes
    {    
        public float CriminalidadeInicial { get; set; } = 0;
        
        public float PopularidadeInicial { get; set; } = 0;

        public float DinheiroInicial { get; set; } = 0;

        public float TempoTransicao { get; set; } = 0;

        public int LimiteDias { get; set; } = 0;

        public float CriminalidadeVitoriaAlta { get; set; } = 0;

        public float CriminalidadeVitoriaModerada { get; set; } = 0;

        public float PopularidadeVitoriaAlta { get; set; } = 0;

        public float PopularidadeVitoriaModerada { get; set; } = 0;

        public float InclinacaoNeutro { get; set; } = 0;

        public string TextoVitoriaModerada { get; set; } = string.Empty;

        public string TextoVitoriaAlta { get; set; } = string.Empty;

        public string TextoDerrota { get; set; } = string.Empty;

        public string TextoDerrotaDinheiro { get; set; } = string.Empty;

        public string TextoNeutro { get; set; } = string.Empty;



    }
}
