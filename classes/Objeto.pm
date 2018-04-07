package Objeto;


sub new
{
    my ( $class ) = shift;
    my $self = {};
    bless $self, $class;
    #padra em todos
    $self->{id}=shift;
    $self->{tipo}=shift;
    $self->{espaco}=shift;
    $self->{nome}=shift;

    if($self->{tipo}=="arma"){
        $self->{dano_min}=shift;
        $self->{dano_max}=shift;
        $self->{slots}=[];
        my $i=shift;
        
        while($i >= 0){
            push(@{$self->{slots}},shift);
            $i=$i-1;
        }
    }
    elsif($self->{tipo}=="missao"){

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