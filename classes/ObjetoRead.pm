BEGIN {
  unshift @INC,"./classes";
  #@INC is the directory list, where perl searches for .pm files
}

package ObjetoRead;

use 5.010;
use strict;
use warnings;


use Objeto;
use XML::LibXML;

my $dom;

sub new
{
    my ( $class ) = shift;
    my $file = XML::LibXML->load_xml(location => shift);
    my $obj;
    my @list_of_object=();
    
    foreach my $object ($file->findnodes('/list/object')) {
        
        # Pega um array de nodes e adiciona em um array!
        my @slot= map {
            $_->to_literal();
        }$object->findnodes('./slots/slot');

        $obj= new Objeto(
            $object->findvalue("./id"),
            $object->findvalue("./tipo"),
            $object->findvalue("./nome"),
            $object->findvalue('./dano/@min'),
            $object->findvalue('./dano/@max'),
            $#slot,#$i da ultima casas do array 
            @slot,#array
            $object->findvalue("./descricao"));
        push (@list_of_object,$obj);
    }
    return @list_of_object;
}

1;