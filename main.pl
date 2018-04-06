BEGIN {
  unshift @INC,"./classes";
  #@INC is the directory list, where perl searches for .pm files
}
use ObjetoRead;
use Objeto;
use CenaRead;
use Cena;
use Inventario;

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

#my @teste = new CenaRead("cena.xml");
#
#foreach my $x(@teste){
#	print $x->get_id,"\n";
#	print $x->get_titulo,"\n";
#	print $x->get_descricao,"\n";
#	print $x->get_itens,"\n";
#}

#while (1) {
	
#}