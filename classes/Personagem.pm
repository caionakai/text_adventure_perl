package Personagem;

BEGIN {
  unshift @INC,"./classes";
  #@INC is the directory list, where perl searches for .pm files
}
use Time::HiRes qw(sleep);
use Objeto;

use Data::Dumper qw(Dumper);
sub new {
    my $class = shift;
    my $self;

    $self->{dinheiro}=0;
    
    #equipados
    # personagem    equipes[0]
    # arma          equipes[1]
    # armadura      equipes[2]
    # mochila       equipes[3]
    $self->{equipes}=();
    #quest
    $self->{missoes_concluidas}=[];
    $self->{missoes_ativas}=[];
    $self->{ouro}=0;
    
    $self->{vida}=0;
    #personagem 
    # numero de itens: $self->{limite};
    # 
    #inventario
    $self->{itens}=[];
    $self->{quantidade}=0;  
    return bless $self, $class;
  }
sub set_personagem{
    my $self=shift;
    ${$self->{equipes}}[0]=shift;
}
sub get_ouro{
    my $self=shift;
    return $self->{ouro};
}
sub remove_ouro{
    my $self=shift;
    $self->{ouro}=$self->{ouro}-shift;
}
sub add_ouro{
    my $self=shift;
    $self->{ouro}=$self->{ouro}+shift;
}
sub set_arma{
    my $self=shift;
    if(${$self->{equipes}}[1]){
        $self->add_item(${$self->{equipes}}[1]);
    }
    ${$self->{equipes}}[1]=shift;
}
sub set_armadura{
    my $self=shift;
    if(${$self->{equipes}}[2]){
        $self->add_item(${$self->{equipes}}[2]);
    }
    ${$self->{equipes}}[2]=shift;
}
sub set_mochila{
    my $self=shift;
    if(${$self->{equipes}}[3]){
        $self->add_item(${$self->{equipes}}[3]);
    }
    ${$self->{equipes}}[3]=shift;
}
sub get_dano{
    my $self=shift;
    return $self->{dano};
}
sub get_defesa{
    my $self=shift;
    return $self->{defesa}-$self->{vida};
}
sub atualiza_vida{
    my $self=shift;
    my $vida=shift;
    if($vida>0){
        print("você perdeu $vida de vida\n");
    }
    else{
        print("você foi curado com $vida de vida\n");
    }
    $self->{vida}=$self->{vida}+$vida;
    if($self->{vida}<0){
        $self->{vida}=0;
    }
}
sub calcula_personagem{
    my $self=shift;
    $self->{dano}=0;
    $self->{defesa}=0;
    $self->{limite_bag}=0;
    foreach my $i (@{$self->{equipes}}){
        $self->{dano}=$self->{dano}+$i->get_dano();
        $self->{defesa}=$self->{defesa}+$i->get_defesa();
        $self->{limite_bag}=$self->{limite_bag}+$i->get_espaco();
    }
}
# use_item($comando,$item)
sub remove_item{ 
    my $self=shift;
    my $item=shift;
    $self->{quantidade}= $item->get_espaco + $self->{quantidade};
    @{$self->{itens}} = grep {$_ != $item}  @{$self->{itens}};
}
sub unequipe{ 
    my $self=shift;
    my $item=shift;
    @{$self->{equipes}} = grep {$_ != $item}  @{$self->{equipes}};
}
sub find_item{
    my $self=shift;
    my $item=shift;
    foreach my $i (@{$self->{itens}}){
        if ($i->get_id() == $item->get_id() ){
            return 1;
        }
    }
return 0;
}
sub comandos_possiveis{
    my $self=shift;
    my @commands;
    foreach my $i (@{$self->{itens}}){
        push @commands, ({comando=>"check", alvo=>$i->get_nome});
        if($i->is_arma || $i->is_armadura){
            push @commands, ({comando=>"equip", alvo=>$i->get_nome});
        }
    }
    foreach my $i (@{$self->{equipes}}){
        push @commands, ({comando=>"check", alvo=>$i->get_nome});
        if($i->is_arma || $i->is_armadura){
            push @commands, ({comando=>"unequip", alvo=>$i->get_nome});
        }
    }
    return @commands;
}

sub open_menu{
    my $self=shift;
    my $comando=shift;
    $self->calcula_personagem();
    print("Menu personagem!\n");
    my @comando= $self->comandos_possiveis();
    if(lc $comando eq "inventario"){
        print("Espaço disponivel: ",($self->{limite_bag} +$self->{quantidade})*-1,"\n");
        foreach my $i (@{$self->{itens}}){
            print($i->get_nome);
        }
        
        my $msg="inventário";

        print("\nDigite quit para voltar\n");
        print("$msg->");
        my $entrada= <>;# aguarda a entrada do usuario
        chomp ($entrada);#transforma $entrada em uma string
        while(1){
            my @tokens = split / /, $entrada;
            my $comando1= shift @tokens;
            my $comando2= join " ", @tokens;
            if (lc $entrada eq "bye" || lc $entrada eq "quit" ){
                #print ("Até a próxima velho amigo!\n");
                return 1;
            }
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

                    #comando escolhido como uma hash(comando, alvo)
                    my $comando_usado=shift @cont2;
                    if(lc $comando_usado->{comando} eq lc "check"){
                        my $obj=$self->get_item_by_nome($comando_usado->{alvo});
                        $obj->imprimi_objeto();
                    }
                    if(lc $comando_usado->{comando} eq lc "equip"){
                        my $obj=$self->get_item_by_nome($comando_usado->{alvo});
                        if($obj->is_arma){
                            $self->set_arma($obj);
                        }
                        if($obj->is_armadura){
                            $self->set_armadura($obj);
                        }
                        if($obj->is_mochila){
                            $self->set_mochila($obj);
                        }
                        #$obj->imprimi_objeto();

                    }
                    if(lc $comando_usado->{comando} eq lc "unequipe"){
                        my $obj=$self->get_item_by_nome($comando_usado->{alvo});
                        #$obj->imprimi_objeto();
                        $self->unequipe($obj);
                    }
                }
            }
        print("$msg->");
        $entrada= <>;# aguarda a entrada do usuario
        chomp ($entrada);#transforma $entrada em uma string
        }
    }
    if(lc $comando eq "status"){
        print(
            "Meus Status:\n",
            "defesa:",$self->get_defesa(),"/",$self->{defesa},"\n",
            "ataque:",$self->get_dano(),"\n"
            );
        print("Equipamentos:\n");
        if(${$self->{equipes}}[1]){
        print("arma:",${$self->{equipes}}[1]->get_nome,"\n");
        }
        if(${$self->{equipes}}[2]){
        print("armadura:",${$self->{equipes}}[2]->get_nome,"\n")
        }
        if(${$self->{equipes}}[3]){
        print("mochila:",${$self->{equipes}}[3]->get_nome,"\n");
        }
        sleep(2);
    }
}
sub get_item_by_nome{
    my $self = shift;
    my $nome = shift;
    foreach my $i (@{$self->{itens}}){
        if(lc $i->get_nome eq lc $nome){
            return pop @{$self->{itens}}, $i;
        }
    }
}
sub add_item{
    my $self=shift;
    my $value= shift;
    $self->calcula_personagem();
    if($self->{limite_bag} + $value->get_espaco + $self->{quantidade} <=0){
        push @{$self->{itens}},$value;
        $self->{quantidade}= $value->get_espaco + $self->{quantidade};
        
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