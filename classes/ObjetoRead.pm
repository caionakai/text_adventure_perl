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

sub new
{
    my ( $class ) = shift;
    my $file = XML::LibXML->load_xml(location => shift);
    my $self;
    $self->{objects}=[];
    foreach my $object ($file->findnodes('/list/object')) {
        
        # Pega um array de nodes e adiciona em um array!
        my $new_object= new Objeto();
        $new_object->set_id($object->findvalue("./id"));
        $new_object->set_tipo($object->findvalue("./tipo"));
        $new_object->set_espaco($object->findvalue("./espaco"));
        $new_object->set_nome($object->findvalue("./nome"));
        $new_object->set_descricao($object->findvalue("./descricao"));
        $new_object->set_preco_de_compra($object->findvalue("./preco_de_compra"));
        $new_object->set_preco_de_venda($object->findvalue("./preco_de_venda"));

        $new_object->set_descricao($object->findvalue("./descricao"));

        if($object->findvalue("./tipo") eq "arma" || $object->findvalue("./tipo") eq "armadura"){
            my @slot= map {
                $_->to_literal();
            }$object->findnodes('./slots/slot');
        

            $new_object->set_slots(@slot);
            if($object->findvalue("./tipo") eq "armadura"){
                $new_object->set_defesa($object->findvalue('./defesa'));
            }
            else{
                $new_object->set_dano_min($object->findvalue('./dano/@min'));
                $new_object->set_dano_max($object->findvalue('./dano/@max'));  
            }
        }
        elsif($object->findvalue("./tipo") eq "missao"){
            my @quest= map {
                {
                    alvo=>$_->findvalue('./@id'),
                    quantidade=>$_->findvalue('./@numero'),
                };
            }$object->findnodes('./quest/objetivo');
        
            $new_object->set_objetivo(@quest);
            $new_object->set_recompensa($object->findvalue('./recompensa'));
        }
        elsif( $object->findvalue("./tipo") eq  "monstro" || $object->findvalue("./tipo") eq  "personagem"){
            
            $new_object->set_dano_min($object->findvalue('./dano/@min'));
            $new_object->set_dano_max($object->findvalue('./dano/@max'));
            $new_object->set_defesa($object->findvalue('./defesa'));
        }
        push @{$self->{objects}},$new_object;
    }
    return bless $self,$class;
}
sub get_user{
    my $self=shift;
    return ${$self->{objects}}[0];
}
sub get_object_list(){
    my $self=shift;
    return $self->{objects};
}
sub get_obj_by_id(){
    my $self = shift;
    my $value= shift;

    foreach my $obj (@{$self->{objects}}){
        if($obj->get_id()==$value){
            return $obj;
        }
    }
    return -1;
}
sub preparar_missoes(){
    my $self= shift;
    foreach my $i (@{$self->{objects}}){
        if($i->is_mission()){
            my @objetivos= $i->get_objetivo();
            my @new_objetivos=();
            foreach my $j (@objetivos){
                push @new_objetivos, { 
                    alvo=>          $self->get_obj_by_id($j->{alvo}),
                    quantidade=>    $j->{quantidade}
                    };
            }
            $i->set_objetivo(@new_objetivos);
            
        }
    }
}
1;