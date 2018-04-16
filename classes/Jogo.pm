BEGIN {
  unshift @INC,"./classes";
  #@INC is the directory list, where perl searches for .pm files
}
package Jogo;
use strict;
use warnings;
use Cena;
use CenaRead;
use Personagem;
use ObjetoRead;
use Objeto;
use Npc;
use NpcRead;
use Data::Dumper qw(Dumper);

sub new
{	
    my ( $class ) = shift;
    my $self = { };
    bless $self;
    $self->{cenas} = [];					#vetor de cenas
    $self->{cena_atual} = 0;				#index do vetor 
    $self->{comandos}= [];
    $self->{npc_ativo}=0;
    return $self;
}
sub init{
    my $self= shift;
    ## INSTACIAR CLASSE DE OBJETOS ##
    $self->{objetos} = new ObjetoRead("object.xml");
    $self->{objetos}->preparar_missoes();


    ## INSTANCIAR CLASSE DE NPCS ##
    $self->{npc} = new NpcRead("npc.xml",$self->{objetos});


    ## INSTANCIAR CLASSE DE CENAS ##
    my $temp =  new CenaRead("cena.xml",$self->{objetos},$self->{npc});
    $self->{cenas} = $temp->get_cena_list();
    $self->preparar_cenas();

    ## Inicializar Inventario ##
    $self->{personagem}=new Personagem();

}
sub preparar_cenas{
    my $self=shift;
    foreach (@{$self->{cenas}}){
        if($_->get_cena_anterior()>=0){
            my $temp= $self->get_cenas_by_id($_->get_cena_anterior());
            $_->set_cena_anterior($temp);
        }
        
        if($_->get_cena_seguinte()>=0){
            my $temp2= $self->get_cenas_by_id($_->get_cena_seguinte());
            $_->set_cena_seguinte($temp2);
        }
    }

}
sub game_start{
    my $self=shift;
    print("Digite QUIT para sair!\n");

    print("Este jogo possui várias cenas, para cada cena é apresentado um título e uma descrição, é possível navegar entre as cenas.\n",
        "Cada cena possui objetos utilizáveis, ou seja, eles resultam em algum efeito quando combinado com um comando, além disso os objetos utilizáveis são apresentados em letra maiúscula.\n\n");
        #"Os comandos possíveis são: use, attack, buy, sell, talk, pick, help, save, load, newgame.\n\n");
        # IMPRIMIR CENA ATUAL
        my @comando=$self->comandos_disponiveis();
        my $msg=${$self->{cenas}}[$self->{cena_atual}]->get_titulo();
        print("$msg->");
        my $nova_cena=1;
        if($nova_cena==1){
            print (${$self->{cenas}}[$self->{cena_atual}]->get_titulo(), "\n");
            print (${$self->{cenas}}[$self->{cena_atual}]->get_descricao(), "\n");
            print (${$self->{cenas}}[$self->{cena_atual}]->print_all_npcs(), "\n");
            print (${$self->{cenas}}[$self->{cena_atual}]->print_all_obj, "\n");
            $nova_cena=0;
        }
        print("$msg->");
        my $entrada= <>;# aguarda a entrada do usuario
        chomp ($entrada);#transforma $entrada em uma string
    while(1){
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
        if (lc $entrada eq "sair" || lc $entrada eq "quit" ){
            print ("\nAté a próxima velho amigo!");
            exit(1);
        }
        $nova_cena=$self->verifica_comando($entrada);
       
        $msg=${$self->{cenas}}[$self->{cena_atual}]->get_titulo();
        if($nova_cena==1){
            print (${$self->{cenas}}[$self->{cena_atual}]->get_titulo(), "\n");
            print (${$self->{cenas}}[$self->{cena_atual}]->get_descricao(), "\n");
            print (${$self->{cenas}}[$self->{cena_atual}]->print_all_npcs(), "\n");
            print (${$self->{cenas}}[$self->{cena_atual}]->print_all_obj, "\n");
            $nova_cena=0;
        }
        @comando=$self->comandos_disponiveis();
        # COMANDOS DIGITADOS PELO JOGADOR
        print("$msg->");
        $entrada= <>;# aguarda a entrada do usuario
        chomp ($entrada);#transforma $entrada em uma string
    }
}
sub comandos_disponiveis{
    my $self=shift;
    my $cena=$self->get_cenas($self->get_cena_atual());
    @{$self->{comandos}}=$cena->comandos_possiveis();
    return @{$self->{comandos}};
}

sub verifica_comando{
    my $self=shift;
    my @tokens = split / /, shift;
    my $temp = $tokens[0];
    if(lc $temp eq "help"){
        return 0;
    }

    $self->comandos_disponiveis();

    my @cont = ();   #variável para verificação do comando digitado
   
    #verifica se o comando digitado é válido

    #separa os comando pelo primeiro argumento
    foreach my $i (@{$self->{comandos}}){
        
        if($i->{comando} eq lc $temp){
            push @cont,$i;
        }
    }

    #verifica se existe o comando usado
    if(scalar @cont==0){
        print("Comando Inválido! Digite 'help' para ajuda.\n");
        return 0;
    }

    if($tokens[0] eq lc "help"){
        print("Os comandos possíveis são: use, attack, buy, sell, talk, pick, help, save, load, newgame.\n");
    }

    #como existe mais de um comando possivel verifica qual o alvo do comando
    my @cont2 = ();
    foreach my $i (@cont){
        my $test2;
        if(scalar @tokens <2){
            $test2="";
        }
        else{
            $test2=lc $tokens[1];
        }
        $_= lc $i->{alvo};

        if(/$test2/){
            push @cont2,$i;
        }
    }

    print (Dumper @cont2);
    #verifica se o alvo existe
    if(scalar @cont2==0){
        print("comando invalido!!\n");
        return 0;
    }
    #caso tenha mais de um coamndo disponivel lista todos e volta a tela de comandos
    if(scalar @cont2>1){
        print("voce pode usar os seguintes comandos:\n");
        foreach (@cont2){
            print("\t- ", $_->{comando}," ", $_->{alvo},"\n");
        }
        return 0;
    }

    #comando escolhido como uma hash(comando, alvo)
    my $comando_usado=$cont2[0];


    #tratamento do comando talk
    if($comando_usado->{comando} eq "talk"){
        my $npc=$self->get_npc_by_nome($comando_usado->{alvo});
        return $npc->conversa($self->{personagem});
    }
    #tratamento do comando check
    if($comando_usado->{comando} eq "check"){
        my $objeto = ${$self->{cenas}}[$self->{cena_atual}]->get_item_by_nome($comando_usado->{alvo});
        $objeto->imprimi_objeto($objeto);
    }

    #tratamento do comando walk
    if($comando_usado->{comando} eq "walk"){
        my $id_to_go = $self->get_id_cena_by_nome($comando_usado->{alvo});
        $self->{cena_atual} = $id_to_go;
        return 1;
    }
    return 1;
}
sub get_npc_by_nome{
    my $self=shift;
    my $nome=shift;
    foreach my $i (${$self->{cenas}}[$self->{cena_atual}]->get_all_npc()){
        if($i->it_is_me_by_nome($nome)){
            return $i;
        }
    }
}


sub get_cenas{
	my $self=shift;
	my $i = shift;

  return $self->{cenas}[$i];
}

sub get_cenas_by_id{
    my $self=shift;
    my $id = shift;
    foreach my $i(@{$self->{cenas}}){
        if($i->get_id() == $id){
            return $i;
        }
    }
    

}

sub get_id_cena_by_nome{
    my $self=shift;
    my $nome = shift;
    foreach my $i( 0 .. $#{$self->{cenas}}){
        if(lc ${$self->{cenas}}[$i]->get_titulo() eq lc $nome){
            return $i;
        }
    }
}

sub get_cena_atual{
  my $self = shift;
  return $self->{cena_atual};
}

sub set_cenas{
    my $self = shift;
    my @value = @_;
    
    # loop para colocar todas as 'cenas' dentro do vetor de'cenas'
    foreach my $i (0..$#value){
        push ((@{$self->{cenas}}), $value[$i]);
    }
}

sub set_cena_atual{
    my $self = shift;
    my $value = shift;

    $self->{cena_atual} = $value;
}


1;