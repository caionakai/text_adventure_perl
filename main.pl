BEGIN {
  unshift @INC,"./classes";
  #@INC is the directory list, where perl searches for .pm files
}
use ObjetoRead;
use Objeto;
use CenaRead;
use Cena;

#my @xml= new ObjetoRead("object.xml");

#foreach my $i(@xml){
#  print $i->get_nome,"\n";
#}

my @teste = new CenaRead("cena.xml");

foreach my $x(@teste){
	print $x->get_id,"\n";
	print $x->get_titulo,"\n";
	print $x->get_descricao,"\n";
	print $x->get_itens,"\n";
}

#while (1) {
	
#}