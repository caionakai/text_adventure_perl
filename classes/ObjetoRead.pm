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
        my @slot= map {
            $_->to_literal();
        }$object->findnodes('./slots/slot');

        push @{$self->{objects}} ,
            new Objeto(
                $object->findvalue("./id"),
                $object->findvalue("./tipo"),
                $object->findvalue("./espaco"),
                $object->findvalue("./nome"),
                $object->findvalue('./dano/@min'),
                $object->findvalue('./dano/@max'),
                $#slot,#$i da ultima casas do array 
                @slot,#array
                $object->findvalue("./descricao")
            );

    }
    return bless $self,$class;
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
1;