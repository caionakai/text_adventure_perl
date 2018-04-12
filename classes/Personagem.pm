package Personagem;

BEGIN {
  unshift @INC,"./classes";
  #@INC is the directory list, where perl searches for .pm files
}

use Objeto;

sub new {
    my $class = shift;
    my $self;

    $self->{dinheiro}=0;
    
    #equipados
    # personagem    equipes[0]
    # arma          equipes[1]
    # armadura      equipes[2]
    # mochila       equipes[3]
    $self->{equipes}=();
    #quest
    $self->{missoes_concluidas}=[];
    $self->{missoes_ativas}=[];
    
    
    #personagem 
    # numero de itens: $self->{limite};
    # 
    #inventario
    $self->{itens}=[];
    $self->{quantidade}=0;  
    return bless $self, $class;
  }
sub set_personagem{
    my $self=shift;
    ${$self->{equipes}}[0]=shift;
}
sub set_arma{
    my $self=shift;
    if(${$self->{equipes}}[1]){
        $self->add_item(${$self->{equipes}}[1]);
    }
    ${$self->{equipes}}[1]=shift;
}
sub set_armadura{
    my $self=shift;
    if(${$self->{equipes}}[2]){
        $self->add_item(${$self->{equipes}}[2]);
    }
    ${$self->{equipes}}[2]=shift;
}
sub set_mochila{
    my $self=shift;
    if(${$self->{equipes}}[3]){
        $self->add_item(${$self->{equipes}}[3]);
    }
    ${$self->{equipes}}[3]=shift;
}
sub calcula_personagem{
    my $self=shift;
    $self->{dano}=0;
    foreach my $i (@{$self->{equipes}}){
        $self->{dano}=$self->{dano}+$i->get_dano();
    }
}
# use_item($comando,$item)
sub use_item{ 
    my $self=shift;
}
sub add_item{
    my $self=shift;
    my $value= shift;
    if(scalar @{$self->{itens}}+ $value->get_espaco <= $self->{limite}){
        push @{$self->{itens}},$value;

        $self->{quantidade}= $value->get_espaco + $self->{quantidade};
        
        return 1;#Sucesso
    }
    else{
        return 0;#Inventario cheio
    }
}
sub print_list_of_itens{
    my $self=shift;
    foreach my $i (0 .. $#{$self->{itens}}) {
        ${$self->{itens}}[$i]->valor();
    }
}

1;