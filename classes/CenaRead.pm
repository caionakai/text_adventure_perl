BEGIN {
  unshift @INC,"./classes";
  #@INC is the directory list, where perl searches for .pm files
}


package CenaRead;

use 5.010;
use strict;
use warnings;

use Cena;
use XML::LibXML;

my $dom;

sub new
{
    my ( $class ) = shift;
    my $file = XML::LibXML->load_xml(location => shift);
    my $temp;
    my @list_of_cena=();
    foreach my $cena ($file->findnodes('/list/cena')) {
        
        $temp= new Cena($cena->findvalue("./id"),$cena->findvalue("./titulo"),$cena->findvalue("./descricao"),$cena->findvalue("./itens"));
        push (@list_of_cena,$temp);
    }
    return @list_of_cena;
}

1;