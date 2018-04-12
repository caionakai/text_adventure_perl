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
    
    #armas e monstros
    $self->{dano_min}=0;
    $self->{dano_max}=0;
    
    # armadura e monstro
    $self->{defesa}=0;

    return $self;
}
sub set_defesa(){
    my $self=shift;
    $self->{defesa}=shift;
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
sub get_espaco{
    my $self=shift;
    return $self->{espaco};
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
sub is_personagem{
    my $self=shift;
    if ($self->{tipo} eq "personagem"){
        return 1;
    }
    return 0;
}
sub is_armadura{
    my $self=shift;
    if ($self->{tipo} eq "armadura"){
        return 1;
    }
    return 0;
}
sub is_arma{
    my $self=shift;
    if ($self->{tipo} eq "arma"){
        return 1;
    }
    return 0;
}
sub is_espacial{
    my $self=shift;
    if ($self->{tipo} eq "espacial"){
        return 1;
    }
    return 0;
}
sub get_dano{
    my $self=shift;
    if($self->is_arma || $self->is_personagem){
        return $self->{dano_min}+ int rand($self->{dano_max}-$self->{dano_min});
    }
}
sub get_objetivo{
    my $self=shift;
    return @{$self->{objetivo}};
}
sub comandos_possiveis{
    my $self=shift;
    my @commandos=();
    push @commandos, "drop";
    push @commandos, "pick";
    push @commandos, "info";
    
    if($self->is_arma){
        push @commandos, "attak";
    }
    if($self->is_mission){
        push @commandos, "view";
    }
    if($self->is_espacial){
        push @commandos, "use";        
    }
    return @commandos;
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