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

sub get_id{
    my ($CenaData)= @_;

    return $CenaData->{id};
}

sub get_descricao{
    my ($CenaData)= @_;

    return $CenaData->{descricao};
}

sub get_itens{
    my ($CenaData)= @_;

    return $CenaData->{itens};
}

1;