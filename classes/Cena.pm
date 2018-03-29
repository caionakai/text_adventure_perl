package Cena;
sub new
{
    my ( $class ) = shift;
    my $CenaData = {
        id => shift,
        titulo => shift,
        descricao => shift,
        itens => shift

    };
    bless $CenaData, $class;

    return $CenaData;
}
sub get_titulo{
    my ($CenaData)= @_;

    return $CenaData->{titulo};
}

1;