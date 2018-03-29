BEGIN {
  unshift @INC,"./";
  #@INC is the directory list, where perl searches for .pm files
}

package XMLRead;

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
        
        $obj= new Objeto($object->findvalue("./id"),$object->findvalue("./tipo"),$object->findvalue("./nome"),$object->findvalue("./descricao"));
        push (@list_of_object,$obj);
    }
    return @list_of_object;
}

1;