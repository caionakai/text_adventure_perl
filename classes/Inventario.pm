package Inventario;

BEGIN {
  unshift @INC,"./classes";
  #@INC is the directory list, where perl searches for .pm files
}

use Objeto;
our @itens;
our $limit;

sub new {
    @itens=();
    $limit=5;

    my $class = shift;
    return bless {}, $class;
  }

# use_item($comando,$item)
sub use_item{ 
    my $self=shift;
    my $comando=shift @_;
    my $item=shift @_;

}
sub add_item{
    my $self=shift;
    my $value= shift @_;
    if(scalar @itens< $limit){
        push @itens,$value;
        $limit=$limit+1;
        return 1;#Sucesso
    }
    else{
        return 0;#Inventario cheio
    }
}
sub print_list_of_itens{
    foreach my $i (0 .. $#itens) {
        $itens[$i]->valor();
    }
}

1;