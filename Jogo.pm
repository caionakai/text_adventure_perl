package Jogo;
sub new
{
    my ( $class ) = shift;
    my $JogoData = {
        cenas => shift,
        cena_atual => shift

    };
    bless $JogoData, $class;

    return $JogoData;
}

1;