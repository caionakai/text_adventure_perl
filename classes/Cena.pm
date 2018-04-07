package Cena;
sub new
{
    my ( $class ) = shift;
    my $self = { };
    bless $self;
    $self->{"id"} = "";
    $self->{"titulo"} = "";
    $self->{"descricao"} = "";
    $self->{"itens"} = [];
    $self->{"npcs"} = [];

    return $self;
}
sub get_titulo{
    my $self = shift;
    return $self->{titulo};
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

1;