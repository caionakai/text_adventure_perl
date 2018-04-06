package Npc;


our @itens;
our @falas;

sub new
{
    my ( $class ) = shift;
    my $id = shift,
    my $nome = shift,
    falas = @_,
    itens = @_;

    return bless {}, $class;

}

sub get_fala{
    my $class = shift;
    my $i = shift;

    return $falas[$i];
}
