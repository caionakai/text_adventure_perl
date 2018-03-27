package Objeto;
sub new
{
    my ( $class ) = shift;
    my $ObjetoData = {
        id => shift,
        tipo => shift,
        nome => shift,
        descricao => shift,
        resultado_positivo => shift,
        resultado_negativo => shift,
        comando_correto => shift,
        cena_alvo => shift,
        resolvido => 0

    };
    bless $ObjetoData, $class;

    print "id: $ObjetoData->{id}\n";
    print "tipo: $ObjetoData->{tipo}\n";
    print "nome: $ObjetoData->{nome}\n";
    print "descricao: $ObjetoData->{descricao}\n";
    print "resultado_positivo: $ObjetoData->{resultado_positivo}\n";
    print "resultado_negativo: $ObjetoData->{resultado_negativo}\n";
    print "comando_correto: $ObjetoData->{comando_correto}\n";
    print "cena_alvo: $ObjetoData->{cena_alvo}\n";
    print "resolvido: $ObjetoData->{resolvido}\n";
    return $ObjetoData;
}


1;