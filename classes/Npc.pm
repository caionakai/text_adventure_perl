BEGIN {
  unshift @INC,"./classes";
  #@INC is the directory list, where perl searches for .pm files
}
package Npc;
use strict;
use warnings;

our @itens;
our @falas;

sub new
{
    my ( $class ) = shift;
    #print (@_);
    my $id = shift,
    my $nome = shift,
    #falas = @_,
    #itens = @_;
    return bless {}, $class;

}

sub get_fala{
    my $class = shift;
    my $i = shift;

    return $falas[$i];
}
