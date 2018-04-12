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

sub new
{	
    my ( $class ) = shift;
    my $self = { };
    bless $self;
    $self->{cenas} = [];					#vetor de cenas
    $self->{cena_atual} = 0;				#index do vetor 
    $self->{comandos}= [];
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
        "Cada cena possui objetos utilizáveis, ou seja, eles resultam em algum efeito quando combinado com um comando, além disso os objetos utilizáveis são apresentados em letra maiúscula.\n\n",
        "Os comandos possíveis são: use, attack, buy, sell, talk, pick, help, save, load, newgame.\n\n");
    while(1){
        # IMPRIMIR CENA ATUAL
        print (${$self->{cenas}}[$self->{cena_atual}]->get_titulo(), "\n");
        print (${$self->{cenas}}[$self->{cena_atual}]->get_descricao(), "\n");
        print (${$self->{cenas}}[$self->{cena_atual}]->print_all_npcs(), "\n");


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

sub verifica_comando{
    my $self=shift;
    my @tokens = split / /, shift;
    my $temp = $tokens[0];
    my @comandos = ('use', 'attack', 'buy', 'sell', 'talk', 'pick', 'help', 'save', 'load', 'newgame');
    my $cont = 0;   #variável para verificação do comando digitado

    #verifica se o comando digitado é válido
    foreach my $i (@comandos){
        if($i eq lc $temp){
            $cont = 1;
        }
    }
    if($cont==0){
        print("Comando Inválido! Digite 'help' para ajuda.\n");
        return;
    }

    if($tokens[0] eq lc "help"){
        print("Os comandos possíveis são: use, attack, buy, sell, talk, pick, help, save, load, newgame.\n");
    }


  #  if($tokens[0] eq lc "buy"){
  #      
  #  }

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