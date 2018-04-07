BEGIN {
  unshift @INC,"./classes";
  #@INC is the directory list, where perl searches for .pm files
}
package Jogo;
use strict;
use warnings;
use Cena;
use CenaRead;
use Inventario;
use ObjetoRead;
use Objeto;
use Npc;
use NpcRead;

sub new
{	
    my ( $class ) = shift;
    my $self = { };
    bless $self;
    $self->{"cenas"} = [];					#vetor de cenas
    $self->{"cena_atual"} = 0;				#index do vetor 

    return $self;
}

sub get_cenas{
	my $self=shift;
	my $i = shift;

  return $self->{cenas}[$i];
}

sub get_cena_atual{
  my $self = shift;
  return $self->{cena_atual};
}

sub set_cenas{
    my $self = shift;
    my @value = @_;
    
    # loop para colocar todas as 'cenas' dentro do vetor de'cenas'
    foreach my $i (0..$#value){
        push ((@{$self->{cenas}}), $value[$i]);
    }
}

sub set_cena_atual{
    my $self = shift;
    my $value = shift;

    $self->{cena_atual} = $value;
}


1;