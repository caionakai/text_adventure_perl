BEGIN {
  unshift @INC,"./classes";
  #@INC is the directory list, where perl searches for .pm files
}



package NpcRead;

use Npc;
use Objeto;
use ObjetoRead;
use XML::LibXML;

my $dom;

sub new
{
    my ( $class ) = shift;
    my $file = XML::LibXML->load_xml(location => shift);
    my $objeto= shift;
    my $temp;
    my $self={npcs=>[]};
  
    foreach my $npc ($file->findnodes('/list/npc')) {
        $temp= new Npc();
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

        push (@{$self->{npcs}},$temp);
    }
    return bless $self,$class;
}
sub get_npc_by_id(){
    my $self = shift;
    my $value= shift;

    foreach my $npc (@{$self->{npcs}}){
        if($npc->get_id()==$value){
            return $npc;
        }
    }
    return -1;
}

sub get_npc_list(){
    my $self=shift;
    return $self->{npcs};
}

1;