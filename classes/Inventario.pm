package Inventario;

BEGIN {
  unshift @INC,"./classes";
  #@INC is the directory list, where perl searches for .pm files
}

use Objeto;

sub new {
    my $class = shift;
    my $self;
    $self->{limite}=5;
    $self->{itens}=[];
    $self->{quantidade}=0;  
    return bless $self, $class;
  }

# use_item($comando,$item)
sub use_item{ 
    my $self=shift;
}
sub add_item{
    my $self=shift;
    my $value= shift;
    if(scalar @{$self->{itens}}< $self->{limite}){
        push @{$self->{itens}},$value;
        $self->{quantidade}=$value->{espaco}+$self->{quantidade};
        return 1;#Sucesso
    }
    else{
        return 0;#Inventario cheio
    }
}
sub print_list_of_itens{
    my $self=shift;
    foreach my $i (0 .. $#{$self->{itens}}) {
        ${$self->{itens}}[$i]->valor();
    }
}

1;