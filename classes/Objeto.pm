package Objeto;


sub new
{
    my ( $class ) = shift;
    my $self = {};
    bless $self, $class;
    #padra em todos
    $self->{id}=0;
    $self->{tipo}="";
    $self->{espaco}="";
    $self->{nome}="";
    $self->{descricao}="";

    #quest
    $self->{objetivo}=[];
    
    #armas e armaduras
    $self->{slots}=[];
    
    $self->{dano_min}=0;
    $self->{dano_max}=0;
    
    $self->{armadura}=0;

    return $self;
}
sub set_recompensa(){
    my $self=shift;
    $self->{recompensa}=shift;
}
sub set_objetivo(){
    my $self=shift;
    @{$self->{objetivo}}=@_;
}
sub set_descricao(){
    my $self=shift;
    $self->{descricao}= shift;
}
sub set_slots(){
    my $self=shift;
    @{$self->{slots}}= @_;
}
sub set_dano_max(){
    my $self=shift;
    $self->{dano_max}=shift
}
sub set_dano_min(){
    my $self=shift;
    $self->{dano_min}=shift
}
sub set_nome(){
    my $self=shift;
    $self->{nome}=shift
}
sub set_espaco(){
    my $self=shift;
    $self->{espaco}=shift
}
sub set_tipo(){
    my $self=shift;
    $self->{tipo}=shift
}
sub set_id(){
    my $self=shift;
    $self->{id}=shift
}
sub get_nome(){
    my $self=shift;
    if($self != -1){
        return $self->{nome};
    }
    return undef;
}
sub get_id{
    my $self=shift;
    if($self != -1){
        return $self->{id};
    }
    return undef;
}
sub is_mission{
    my $self=shift;
    if ($self->{tipo} eq "missao"){
        return 1;
    }
    return 0;
}
sub get_objetivo{
    my $self=shift;
    return @{$self->{objetivo}};
}

sub print_quest{
    my $self=shift;
    if ($self->is_mission()){
        print($self->{descricao},"\n");
        foreach my $i (@{$self->{objetivo}}){
            print($i->{alvo}->get_nome," ",$i->{quantidade},"\n");
        }
    }
}
1;