BEGIN {
  unshift @INC,"./";
  #@INC is the directory list, where perl searches for .pm files
}
use Classe;

new Classe("caio", "nakai");


