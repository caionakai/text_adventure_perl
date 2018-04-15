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

    ## Inicializar Inventario ##

}
sub game_start{
    my $self=shift;
    print("Digite QUIT para sair!\n");

    print("Este jogo possui várias cenas, para cada cena é apresentado um título e uma descrição, é possível navegar entre as cenas.\n",
        "Cada cena possui objetos utilizáveis, ou seja, eles resultam em algum efeito quando combinado com um comando, além disso os objetos utilizáveis são apresentados em letra maiúscula.\n\n");
        #"Os comandos possíveis são: use, attack, buy, sell, talk, pick, help, save, load, newgame.\n\n");
    while(1){
        # IMPRIMIR CENA ATUAL
        print (${$self->{cenas}}[$self->{cena_atual}]->get_titulo(), "\n");
        print (${$self->{cenas}}[$self->{cena_atual}]->get_descricao(), "\n");
        print (${$self->{cenas}}[$self->{cena_atual}]->print_all_npcs(), "\n");
        print (${$self->{cenas}}[$self->{cena_atual}]->print_all_obj, "\n");

        # COMANDOS DIGITADOS PELO JOGADOR
        my $entrada= <>;# aguarda a entrada do usuario
        chomp ($entrada);#transforma $entrada em uma string


        if (lc $entrada eq "sair" || lc $entrada eq "quit" ){
            print ("\nAté a próxima velho amigo!");
            exit(1);
        }
        $self->verifica_comando($entrada);


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
        return;
    }

    #se o cara digita help aparece isso
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
    #verifica se o alvo existe
    if(scalar @cont2==0){
        print("comando invalido!!\n");
        return;
    }
    #caso tenha mais de um coamndo disponivel lista todos e volta a tela de comandos
    if(scalar @cont2>1){
        print("voce pode usar os seguintes comandos:\n");
        foreach (@cont2){
            print("\t- ", $_->{comando}," ", $_->{alvo},"\n");
        }
        return;
    }

    #comando escolhido como uma hash(comando, alvo)
    my $comando_usado=$cont2[0];


    #tratamento do comando talk
    if($comando_usado->{comando} eq "talk"){
        #não implementado ainda
        #my $npc=$self->get_npc_by_nome();
        #$npc->conversa();
    }

    if($comando_usado->{comando} eq "check"){
        #não implementado ainda
        my $objeto = ${$self->{cenas}}[$self->{cena_atual}]->get_item_by_nome($comando_usado->{alvo});
        $objeto->imprimi_objeto($objeto);
        #print(Dumper $objeto);
    }

    print (Dumper $comando_usado);
}
sub get_npc_by_nome{
    my $self=shift;

}


sub get_cenas{
	my $self=shift;
	my $i = shift;

  return $self->{cenas}[$i];
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