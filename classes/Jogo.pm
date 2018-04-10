BEGIN {
  unshift @INC,"./classes";
  #@INC is the directory list, where perl searches for .pm files
}
package Jogo;
use strict;
use warnings;
use Cena;
use CenaRead;
use Personagem;
use ObjetoRead;
use Objeto;
use Npc;
use NpcRead;

sub new
{	
    my ( $class ) = shift;
    my $self = { };
    bless $self;
    $self->{cenas} = [];					#vetor de cenas
    $self->{cena_atual} = 0;				#index do vetor 
    
    return $self;
}
sub init{
    my $self= shift;
    ## INSTACIAR CLASSE DE OBJETOS ##
    $self->{objetos} = new ObjetoRead("object.xml");
    $self->{objetos}->preparar_missoes();


    ## INSTANCIAR CLASSE DE NPCS ##
    $self->{npc} = new NpcRead("npc.xml",$self->{objetos});


    ## INSTANCIAR CLASSE DE CENAS ##
    $self->{cenas} = new CenaRead("cena.xml",$self->{objetos},$self->{npc});
}
sub game_start{
    my $self=shift;
    print("Digite QUIT para sair!\n");
    while(1){
        my $evento= <>;# aguarda a entrada do usuario
        chomp ($evento);#transforma $evento em uma string

        if (lc $evento eq "sair" || lc $evento eq "quit" ){
            print ("até a proxima velho amigo");
            exit(1);
        }
    }
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