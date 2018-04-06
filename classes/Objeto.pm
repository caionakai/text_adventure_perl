package Objeto;

sub new
{
    my ( $class ) = shift;
    my $ObjetoData = {
        id => shift,
        tipo => shift,
        nome => shift,
        descricao => shift,
        #resultado_positivo => shift,
        #resultado_negativo => shift,
        #comando_correto => shift,
        #cena_alvo => shift,
        #resolvido => 0

    };
    bless $ObjetoData, $class;

    return $ObjetoData;
}
sub valor{
    my ($ObjetoData)= @_;
    print $ObjetoData->{nome},"\n";
}

1;