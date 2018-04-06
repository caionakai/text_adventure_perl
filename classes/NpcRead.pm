BEGIN {
  unshift @INC,"./classes";
  #@INC is the directory list, where perl searches for .pm files
}



package NpcRead;

use Npc;
use XML::LibXML;

my $dom;

sub new
{
    my ( $class ) = shift;
    my $file = XML::LibXML->load_xml(location => shift);
    my $temp;
    my @list_of_npc=();
    foreach my $npc ($file->findnodes('/list/npc')) {
        $temp= new Npc($npc->findvalue("./id"),$npc->findvalue("./nome"),$npc->findvalue("./falas/fala"),$npc->findvalue("./itens/item"));
        push (@list_of_npc,$temp);
    }
    return @list_of_npc;
}

1;