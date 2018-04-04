BEGIN {
  unshift @INC,"./classes";
  #@INC is the directory list, where perl searches for .pm files
}
package Jogo;
use strict;
use warnings;
use Cena;
sub new
{	
    my ( $class ) = shift;
    my $JogoData = {
        cenas => [],
        cena_atual => shift,	#index do vetor 

    };
    my @listCena;
    bless $JogoData, $class;


    return $JogoData;
}

sub get_cenas{
    my ($JogoData)= @_;
    #print $JogoData->{cenas}->get_titulo;
    return @{$JogoData->{cenas}} ;
}


1;