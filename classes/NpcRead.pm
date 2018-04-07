BEGIN {
  unshift @INC,"./classes";
  #@INC is the directory list, where perl searches for .pm files
}



package NpcRead;

use Npc;
use Objeto;
use XML::LibXML;

my $dom;

sub new
{
    my ( $class ) = shift;
    my $file = XML::LibXML->load_xml(location => shift);
    my $objeto= shift;
    my $temp;
    my @list_of_npc=();
  
    foreach my $npc ($file->findnodes('/list/npc')) {
        $temp= new Npc($npc->findvalue("./id"),$npc->findvalue("./nome"),$npc->findvalue("./falas/fala"),$npc->findvalue("./itens/item"));
        $temp->set_id($npc->findvalue("./id"));
        $temp->set_nome($npc->findvalue("./nome"));
        # @aux recebe 'fala' em cada posicao do array
        my @aux = map{
            $_->to_literal(); 
        }$npc->findnodes('./falas/fala');
        $temp->set_fala(@aux);
        # @aux2 recebe 'item' em cada posicao do array
        my @aux2 = map{
            $objeto->get_obj_by_id($_->to_literal()); 
        }$npc->findnodes('./itens/item');
        
        $temp->set_item(@aux2);

        push (@list_of_npc,$temp);
    }
    return @list_of_npc;
}

1;