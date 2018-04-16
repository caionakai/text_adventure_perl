package Objeto;

use Data::Dumper qw(Dumper);
sub new
{
    my ( $class ) = shift;
    my $self = {};
    bless $self, $class;
    #padrao em todos
    $self->{id}=0;
    $self->{tipo}="";
    $self->{espaco}="";
    $self->{nome}="";
    $self->{descricao}="";
    $self->{preco_de_compra}="";

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
sub get_defesa(){
    my $self=shift;
    return $self->{defesa};
}
sub set_recompensa(){
    my $self=shift;
    $self->{recompensa}=shift;
}
sub set_objetivo(){
    my $self=shift;
    @{$self->{objetivo}}=@_;
}
sub set_drops(){
    my $self=shift;
    @{$self->{drops}}=@_;
}
sub get_drops(){
    my $self=shift;
    @{$self->{drops}};
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
sub get_descricao{
    my $self=shift;
    return $self->{descricao};
}
sub get_id{
    my $self=shift;
    if($self != -1){
        return $self->{id};
    }
    return undef;
}
sub set_preco_de_compra{
    my $self=shift;
    $self->{preco_de_compra}=shift;
}
sub get_preco_de_compra{
    my $self=shift;
    return $self->{preco_de_compra};
}
sub get_preco_de_venda{
    my $self=shift;
    return $self->{preco_de_venda};
}
sub set_preco_de_venda{
    my $self=shift;
    $self->{preco_de_venda}=shift;
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
sub is_monstro{
    my $self=shift;
    if ($self->{tipo} eq "monstro"){
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
    if($self->is_arma || $self->is_personagem || $self->is_monstro ){
        return $self->{dano_min}+ int rand($self->{dano_max}-$self->{dano_min});
    }
}
sub drop{
    my $self=shift;
    my @drop=();
    foreach (@{$self->{drops}}){
        if( int rand(100) <30){
            print("Você dropou: ", $_->get_nome, "\n");
            push @drop, $_;
        }
    }

    return @drop;
}
sub ataque{
    my $self=shift;
    my $vida=shift;
    $self->{defesa}=$self->{defesa}-$vida;
    print("seu ataque no ",$self->{nome}," causou ",$vida, "de dano\n");
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
        #print($self->{descricao},"\n");
        foreach my $i (@{$self->{objetivo}}){
            print($i->{alvo}->get_nome," ",$i->{quantidade},"\n");
        }
    }
}

sub imprimi_objeto{
    my $self=shift;
    print(
        "\tTipo: $self->{tipo}\n", 
        "\tEspaço: $self->{espaco}\n",
        "\tNome: $self->{nome}\n",
        "\tDescricao: $self->{descricao}\n"
    );
    # verifica se existe uma quest 
    if($self->is_mission()){
        $self->print_quest();
    }

    #verifica se eh arma
    if($self->is_arma()){
        print(
            $self->get_dano()
        );
    }

    #verifica se eh armadura
    if($self->is_armadura){
        print(
            $self->{defesa}
        );
    }
}

1;