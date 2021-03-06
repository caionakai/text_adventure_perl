package Npc;
BEGIN {
  unshift @INC,"./classes";
  #@INC is the directory list, where perl searches for .pm files
}
use strict;
use warnings;
use Objeto;

use Storable 'dclone';
use Data::Dumper qw(Dumper);


sub new
{
    my $class = shift;
    my $self = { };
    bless $self;
    $self->{id} = "";
    $self->{nome} = "";
    $self->{falas} = [];
    $self->{itens} = [];

    return $self;
}

sub set_id{
    my $self = shift;
    my $value = shift;

    $self->{id} = $value;
}

sub get_id{
    my $self = shift;
    return $self->{id};
}

sub set_nome{
    my $self = shift;
    my $value = shift;

    $self->{nome} = $value;
}

sub get_nome{
    my $self = shift;
    return $self->{nome};
}

sub set_fala{
    my $self = shift;
    my @value = @_;
    
    # loop para colocar todas as 'fala' dentro do vetor de 'falas'
    foreach my $i (0..$#value){
        push ((@{$self->{falas}}), $value[$i]);
    }
}

sub get_fala{
    my $self = shift;
    my $i = shift;

    return $self->{falas}[$i];
}

sub set_item{
    my $self = shift;
    my @value = @_;
    
    # loop para colocar todas os 'item' dentro do vetor de'itens'
    foreach my $i (0..$#value){
        push ((@{$self->{itens}}), $value[$i]);
    }
}
sub it_is_me_by_nome{
    my $self= shift;
    my $nome=shift;
    if(lc $nome eq lc $self->{nome}){
        return 1;
    }
    return 0;
}

sub get_item{
    my $self = shift;
    my $i = shift;
    return $self->{itens}[$i];
}

sub comandos_possiveis{
    my $self=shift;
    my $inventario=shift;

    my $ouro=$inventario->get_ouro();

    my @commandos=();

    foreach my $i (@{$self->{itens}}){
        if($i->get_preco_de_compra>0 && $i->get_preco_de_compra <= $ouro){
            push @commandos, ({comando=>"buy",alvo=>$i->get_nome});
        }
        if($i->is_mission){
            push @commandos, ({comando=>"accept",alvo=>$i->get_nome});
        }
        if($inventario->get_item_by_nome($i->get_nome)){
            push @commandos, ({comando=>"sell",alvo=>$i->get_nome});
        }
        push @commandos, ({comando=>"check",alvo=>$i->get_nome});
    }
    push @commandos, {comando=>"bye"};
    return @commandos;
}
sub print_itens{
    my $self=shift;
    my @comands=@_;
    foreach my $i (@comands){
        if($i->{comando} eq "check"){
            print("|",$i->{alvo},"| ");
        }
    }
}
sub conversa{
    my $self=shift;
    print "[$self->{nome}]:";
    print "$_ \n"for @{$self->{falas}};

    my $inventario=shift;
    my @comando= $self->comandos_possiveis($inventario);
    
    $self->print_itens(@comando);

    my $msg=$self->get_nome;
    
    
    print("\nDigite bye para sair\n");
    print("$msg->");
    my $entrada= <>;# aguarda a entrada do usuario
    chomp ($entrada);#transforma $entrada em uma string


    while(1){
        my @tokens = split / /, $entrada;
        my $comando1= shift @tokens;
        my $comando2= join " ", @tokens;
        if (lc $entrada eq "bye" || lc $entrada eq "quit" ){
            print ("Até a próxima velho amigo!\n");
            return 0;
        }
        @comando= $self->comandos_possiveis($inventario);
        if (lc $entrada eq "help" ){
            print("Comandos Disponiveis:\n");
             foreach (@comando){
                 if ($_->{alvo}){
                     print("\t- ", $_->{comando}," ", $_->{alvo},"\n");
                 }
                 else{
                     print("\t- ", $_->{comando},"\n");
                 }
             }
        }
        else{


        #separa os comando pelo primeiro argumento
        my @cont=();
        foreach my $i (@comando){
        
            if($i->{comando} eq lc $comando1){
                push @cont,$i;
            }
        }
         #como existe mais de um comando possivel verifica qual o alvo do comando
        my @cont2 = ();
        foreach my $i (@cont){
            if(lc $comando2 eq lc $i->{alvo} ){
                push @cont2,$i;
                last;
            }
        }
        if(scalar @cont2==0){
            foreach my $i (@cont){
                my $test2;
                if(scalar @tokens <2){
                    $test2="";
                }
                else{
                    $test2=lc $comando2;
                }
                $_= lc $i->{alvo};

                if(/$test2/){
                    push @cont2,$i;
                }
            }
        }
        #verifica se o alvo existe
        if(scalar @cont2==0){
            print("Comando inválido!!\n");
        }

        #caso tenha mais de um coamndo disponivel lista todos e volta a tela de comandos
        if(scalar @cont2>1){
            print("Você pode usar os seguintes comandos:\n");
            foreach (@cont2){
                print("\t- ", $_->{comando}," ", $_->{alvo},"\n");
            }
        }
        else{

            my $comando_usado=shift @cont2;
            if(lc $comando_usado->{comando} eq lc "accept"){
                 my $obj= dclone $self->get_item_by_nome($comando_usado->{alvo});
                $inventario->add_mission($obj);
                print("Missao aceita!\n");
            }
            
            if(lc $comando_usado->{comando} eq lc "buy"){
                my $obj= dclone $self->get_item_by_nome($comando_usado->{alvo});
               
                if($inventario->get_ouro() >= $obj->get_preco_de_compra() ){
                    if($inventario->add_item($obj)){
                        $inventario->remove_ouro($obj->get_preco_de_compra());
                        print("Você comprou: ", $obj->get_nome,"\n");
                    }
                    else{
                        print("Inventario cheio!\n");
                    }
                }
                else{
                    print("Dinheiro insuficiente\n");
                }
            }

            if(lc $comando_usado->{comando} eq lc "sell"){
                my $obj=$self->get_item_by_nome($comando_usado->{alvo});
                if($inventario->find_item($obj)){
                    $inventario->remove_item($obj);
                    $inventario->add_ouro($obj->get_preco_de_venda() );
                    print("Voce vendeu o: ", $obj->get_nome,"\n")
                }
                else{
                    print("Item não encontrado no inventário!\n");
                }
            }

            if(lc $comando_usado->{comando} eq lc "check"){
                my $obj=$self->get_item_by_nome($comando_usado->{alvo});
                $obj->imprimi_objeto();
            }
        }
        }
        print("$msg->");
        $entrada= <>;# aguarda a entrada do usuario
        chomp ($entrada);#transforma $entrada em uma string
    }
    return 0;
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