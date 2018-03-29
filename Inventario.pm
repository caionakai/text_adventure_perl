package Inventario;
sub new
{
    my ( $class ) = shift;
    my $InventarioData = {
        itens => shift

    };
    bless $InventarioData, $class;

    return $InventarioData;
}

1;