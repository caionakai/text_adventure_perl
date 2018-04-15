package Cena;

use Data::Dumper qw(Dumper);
sub new
{
    my ( $class ) = shift;
    my $self = { };
    bless $self;
    $self->{id} = "";
    $self->{titulo} = "";
    $self->{descricao} = "";
    $self->{itens} = [];
    $self->{npcs} = [];
    $self->{cena_anterior}=0;
    $self->{cena_seguinte}=0;
    return $self;
}
sub get_titulo{
    my $self = shift;
    return $self->{titulo};
}
sub set_cena_anterior{
    my $self = shift;
    my $value = shift;

    $self->{cena_anterior} = $value;
}
sub set_cena_seguinte{
    my $self = shift;
    my $value = shift;

    $self->{cena_seguinte} = $value;
}
sub set_titulo{
    my $self = shift;
    my $value = shift;

    $self->{titulo} = $value;
}

sub get_id{
    my $self = shift;
    return $self->{id};
}

sub set_id{
    my $self = shift;
    my $value = shift;

    $self->{id} = $value;
}
sub comandos_possiveis{
    my $self=shift;
    my @commands;
    foreach my $i (@{$self->{npcs}}){
        push @commands, ({comando=>"talk", alvo=>$i->get_nome});
    }

    foreach my $i (@{$self->{itens}}){
        push @commands, ({comando=>"pick",alvo=>$i->get_nome});
        push @commands, ({comando=>"check",alvo=>$i->get_nome});
    }
    push @commands, ({comando=>"quit"});
    return @commands;
}

sub get_descricao{
    my $self = shift;
    return $self->{descricao};
}

sub set_descricao{
    my $self = shift;
    my $value = shift;

    $self->{descricao} = $value;
}

sub get_itens{
    my $self = shift;
    my $i = shift;

    return $self->{itens}[$i];
}

sub set_item{
    my $self = shift;
    my @value = @_;
    
    # loop para colocar todas os 'item' dentro do vetor de'itens'
    foreach my $i (0..$#value){
        push ((@{$self->{itens}}), $value[$i]);
    }
}

sub get_npcs{
    my $self = shift;
    my $i = shift;

    return $self->{npcs}[$i];
}

sub set_npcs{
    my $self = shift;
    my @value = @_;
    
    # loop para colocar todas os 'npc' dentro do vetor de'npcs'
    foreach my $i (0..$#value){
        push ((@{$self->{npcs}}), $value[$i]);
    }
}

sub print_all_npcs{
    my $self = shift;
    print ("NPCS: ");
    foreach my $i (@{$self->{npcs}}){
        print($i->get_nome(), ", ");
    }
}

sub print_all_obj{
    my $self = shift;
    print ("OBJETOS: ");
    foreach my $i (@{$self->{itens}}){
        print($i->get_nome(), ", ");
    }
}

sub get_item_by_nome{
    my $self = shift;
    my $nome = shift;
    foreach my $i (@{$self->{itens}}){
        if(lc $i->get_nome eq lc $nome){
            return $i;
        }
    }
}

1;