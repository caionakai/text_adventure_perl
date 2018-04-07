package Objeto;


our @slots;

sub new
{
    my ( $class ) = shift;
    my $ObjetoData = {
        id => shift,
        tipo => shift,
        nome => shift,
        dano_min=>shift,
        dano_max=>shift,       
        #descricao=>"",
        #resultado_positivo => shift,
        #resultado_negativo => shift,
        #comando_correto => shift,
        #cena_alvo => shift,
        #resolvido => 0

    };
    my $i=shift;
    while($i >= 0){
        push(@slots,shift);
        $i=$i-1;
    }
    $ObjetoData->{descricao}=shift;
    bless $ObjetoData, $class;

    return $ObjetoData;
}
sub valor{
    my $self=shift;
    
    my ($ObjetoData)= @_;
    print $ObjetoData->{nome},"\n";
}
1;