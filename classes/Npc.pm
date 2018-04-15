package Npc;
BEGIN {
  unshift @INC,"./classes";
  #@INC is the directory list, where perl searches for .pm files
}
use strict;
use warnings;
use Objeto;


sub new
{
    my $class = shift;
    my $self = { };
    bless $self;
    $self->{"id"} = "";
    $self->{"nome"} = "";
    $self->{"falas"} = [];
    $self->{"itens"} = [];

    return $self;
}

sub set_id{
    my $self = shift;
    my $value = shift;

    $self->{id} = $value;
}

sub get_id{
    my $self = shift;
    return $self->{id};
}

sub set_nome{
    my $self = shift;
    my $value = shift;

    $self->{nome} = $value;
}

sub get_nome{
    my $self = shift;
    return $self->{nome};
}

sub set_fala{
    my $self = shift;
    my @value = @_;
    
    # loop para colocar todas as 'fala' dentro do vetor de 'falas'
    foreach my $i (0..$#value){
        push ((@{$self->{falas}}), $value[$i]);
    }
}

sub get_fala{
    my $self = shift;
    my $i = shift;

    return $self->{falas}[$i];
}

sub set_item{
    my $self = shift;
    my @value = @_;
    
    # loop para colocar todas os 'item' dentro do vetor de'itens'
    foreach my $i (0..$#value){
        push ((@{$self->{itens}}), $value[$i]);
    }
}

sub get_item{
    my $self = shift;
    my $i = shift;
    return $self->{itens}[$i];
}

sub comandos_possiveis{
    my $self=shift;
    my @commandos=();

    foreach my $i (@{$self->{itens}}){
        push @commandos, ({comando=>"buy",alvo=>$i->get_nome});
        push @commandos, ({comando=>"sell",alvo=>$i->get_nome});
        push @commandos, ({comando=>"check",alvo=>$i->get_nome});
    }
    push @commandos, {comando=>"bye"};
    return @commandos;
}

sub conversa{
    my $self=shift;
    
}

1;