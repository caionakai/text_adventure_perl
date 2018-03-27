BEGIN {
  unshift @INC,"./";
  #@INC is the directory list, where perl searches for .pm files
}
use Classe;

new Objeto(100, "utilizavel", "martelo", "grande demais", "voce usou corretamente", "voce usou errado", "use o comando X", "cena alvo q");


