BEGIN {
  unshift @INC,"./classes";
  #@INC is the directory list, where perl searches for .pm files
}
use strict;
use warnings;
use ObjetoRead;
use Objeto;
use CenaRead;
use Cena;
use Inventario;
use Jogo;

my @xml= new ObjetoRead("object.xml");
my $inventory= new Inventario(5);

foreach my $i (0 .. $#xml) {
  $inventory->add_item($xml[$i]);
}
$inventory->print_list_of_itens();
#$inventory->remove(0);
#$inventory->print();

#foreach my $i(@xml){
#  print $i->get_nome,"\n";
#}

my @teste = new CenaRead("cena.xml");
my $jogo = new Jogo(@teste);
#$jogo->get_cenas(1);
print ($jogo->get_cenas(1)->get_titulo());

#my @vetor = new Cena();
#my $n = 0;


#while ($n < 10){
#	@vetor[$n] = new Cena();
#	$n = $n + 1; 
#}

#@vetor = $jogo->get_cenas;

#print $vetor[0]->get_titulo;

#foreach my $elem(@vetor){
#	print $elem->get_titulo;
#}

#foreach my $x($jogo->get_cenas){
#	print $x->get_titulo;

#}


#foreach my $x(@teste){
#	print $x->get_id,"\n";
#	print $x->get_titulo,"\n";
#	print $x->get_descricao,"\n";
#	print $x->get_itens,"\n";
#}



#while (1) {
	
#}