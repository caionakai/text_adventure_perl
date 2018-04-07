package Objeto;


sub new
{
    my ( $class ) = shift;
    my $self = {};
    $self->{id}=shift;
    $self->{tipo}=shift;
    $self->{nome}=shift;
    $self->{dano_min}=shift;
    $self->{dano_max}=shift;
    $self->{slots}=[];
    bless $self, $class;
    my $i=shift;
    while($i >= 0){
        push(@{$self->{slots}},shift);
        $i=$i-1;
    }
    $self->{descricao}=shift;

    return $self;
}
sub get_nome(){
    my $self=shift;
    return $self->{nome};
}
sub get_id{
    my $self=shift;
    return $self->{id};
}
1;