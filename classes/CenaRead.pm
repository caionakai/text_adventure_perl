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


sub new
{
    my ( $class ) = shift;
    my $file = XML::LibXML->load_xml(location => shift);
    my $objeto = shift;
    my $npc = shift;
    my $temp;
    my $self;
    $self->{cenas}=[];

    foreach my $cena ($file->findnodes('/list/cena')) {
        
        $temp= new Cena();
        $temp->set_id($cena->findvalue("./id"));
        $temp->set_titulo($cena->findvalue("./titulo"));
        $temp->set_descricao($cena->findvalue("./descricao"));
        $temp->set_cena_anterior($cena->findvalue("./cena_anterior"));
        $temp->set_cena_seguinte($cena->findvalue("./cena_seguinte"));
        # @aux recebe 'npc' em cada posicao do array
        my @aux = map{
           $npc->get_npc_by_id($_->to_literal());
        }$cena->findnodes('./npcs/npc');
        $temp->set_npcs(@aux);

        my @aux3 = map{
            $objeto->get_obj_by_id($_->to_literal()); 
        }$cena->findnodes('./monstros/monstro');
        $temp->set_monstro(@aux3);

        my @aux2 = map{
            $objeto->get_obj_by_id($_->to_literal()); 
        }$cena->findnodes('./itens/item');
        $temp->set_item(@aux2);

        push (@{$self->{cenas}},$temp);
    }
    
    return bless $self, $class;
}

sub get_cena_list(){
    my $self=shift;
    return $self->{cenas};
}

1;