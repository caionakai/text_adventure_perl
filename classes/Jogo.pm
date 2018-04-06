BEGIN {
  unshift @INC,"./classes";
  #@INC is the directory list, where perl searches for .pm files
}
package Jogo;
use strict;
use warnings;
use Cena;

our @cenas;							#variavel global
our $cena_atual;					#variavel global
sub new
{	
    my ( $class ) = shift;
    @cenas = @_;					#vetor de cenas
    $cena_atual = 0,				#index do vetor 

    return bless {}, $class;
}

sub get_cenas{
	my $class=shift;
	my $i = shift;
	#print ($cenas[$i]);
    return $cenas[$i];
}


1;