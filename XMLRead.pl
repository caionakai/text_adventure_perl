BEGIN {
  unshift @INC,"./";
  #@INC is the directory list, where perl searches for .pm files
}
use XMLRead;
use Objeto;

my @xml= new XMLRead("object.xml");

foreach my $i(@xml){
  print $i->get_nome,"\n";
}
#my $objr =$xml->load_objects;

#say $xml;