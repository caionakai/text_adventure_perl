BEGIN {
  unshift @INC,"./classes";
  #@INC is the directory list, where perl searches for .pm files
}
package Jogo;
use strict;
use Cena;
use CenaRead;
use Personagem;
use ObjetoRead;
use Objeto;
use Npc;
use NpcRead;
use Data::Dumper qw(Dumper);
use Win32::Console;


use XML::Dumper;

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
    my $personagem= $self->{objetos}->get_user();

    ## INSTANCIAR CLASSE DE NPCS ##
    $self->{npc} = new NpcRead("npc.xml",$self->{objetos});


    ## INSTANCIAR CLASSE DE CENAS ##
    my $temp =  new CenaRead("cena.xml",$self->{objetos},$self->{npc});
    $self->{cenas} = $temp->get_cena_list();
    $self->preparar_cenas();

    ## Inicializar Inventario ##
    $self->{personagem}=new Personagem();
    $self->{personagem}->set_personagem($personagem);


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

    #atribui 50 de ouro pro personagem
    $self->{personagem}->add_ouro(2000);

    print("Este jogo possui varias cenas, para cada cena e apresentado um titulo e uma descricao, e possivel navegar entre as cenas.\n",
        "Cada cena possui objetos utilizaveis, ou seja, eles resultam em algum efeito quando combinado com um comando, alem disso os objetos utilizaveis sao apresentados em letra maiuscula.\n\n");
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
            print (${$self->{cenas}}[$self->{cena_atual}]->print_all_monstro, "\n");
            $nova_cena=0;
        }
        print("$msg->");
        my $entrada= <>;# aguarda a entrada do usuario
        chomp ($entrada);#transforma $entrada em uma string
        my $OUT = Win32::Console->new(STD_OUTPUT_HANDLE);
        $OUT->Cls;
    while(1){
        if (lc $entrada eq "help" ){
            print("Comandos Disponiveis:\n");
             foreach (@{$self->{comandos}}){
                 if ($_->{alvo}){
                     print("\t- ", $_->{comando}," ", $_->{alvo},"\n");
                 }
                 else{
                     print("\t- ", $_->{comando},"\n");
                 }
             }
        }
        if (lc $entrada eq "sair" || lc $entrada eq "quit" ){
            print ("\nAte a proxima velho amigo!");
            exit(1);
        }
        $nova_cena=$self->verifica_comando($entrada);
       
        $msg=${$self->{cenas}}[$self->{cena_atual}]->get_titulo();
        if($nova_cena==1){
            $OUT->Cls;
            print (${$self->{cenas}}[$self->{cena_atual}]->get_titulo(), "\n");
            print (${$self->{cenas}}[$self->{cena_atual}]->get_descricao(), "\n");
            print (${$self->{cenas}}[$self->{cena_atual}]->print_all_npcs(), "\n");
            print (${$self->{cenas}}[$self->{cena_atual}]->print_all_obj, "\n");
            print (${$self->{cenas}}[$self->{cena_atual}]->print_all_monstro, "\n");
            $nova_cena=0;
        }
        if($nova_cena==3){
            print (${$self->{cenas}}[$self->{cena_atual}]->print_all_obj, "\n");
        }

        $self->comandos_disponiveis();
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
    my $temp =shift @tokens;
    if(lc $temp eq "help"){
        return 0;
    }
    
    my $temp2= join " ", @tokens;

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
        print("Comando Invalido! Digite 'help' para ajuda.\n");
        return 0;
    }


    #como existe mais de um comando possivel verifica qual o alvo do comando
    my @cont2 = ();
    foreach my $i (@cont){
        if(lc $temp2 eq lc $i->{alvo} ){
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
                $test2=lc $temp2;
            }
            $_= lc $i->{alvo};
            if(/$test2/){
                push @cont2,$i;
            }
        }
    }

    #verifica se o alvo existe
    if(scalar @cont2==0){
        print("comando invalido!!\n");
        return 0;
    }
    #caso tenha mais de um coamndo disponivel lista todos e volta a tela de comandos
    if(scalar @cont2>1 ){
        print("Voce pode usar os seguintes comandos:\n");
        foreach (@cont2){
            print("\t- ", $_->{comando}," ", $_->{alvo},"\n");
        }
        return 0;
    }

    #comando escolhido como uma hash(comando, alvo)
    my $comando_usado=shift @cont2;


    #tratamento do comando talk
    if($comando_usado->{comando} eq "talk"){
        my $npc=$self->get_npc_by_nome($comando_usado->{alvo});
        return $npc->conversa($self->{personagem});
    }
    #tratamento do comando check
    if($comando_usado->{comando} eq "check"){
        if(${$self->{cenas}}[$self->{cena_atual}]->is_monster_by_nome($comando_usado->{alvo})){
            ${$self->{cenas}}[$self->{cena_atual}]->print_monster_by_nome($comando_usado->{alvo});
        }
        else{   
            my $objeto = ${$self->{cenas}}[$self->{cena_atual}]->get_item_by_nome($comando_usado->{alvo});
            $objeto->imprimi_objeto();
        }
    }

    #tratamento do comando walk
    if($comando_usado->{comando} eq "walk"){
        my $id_to_go = $self->get_id_cena_by_nome($comando_usado->{alvo});
        $self->{cena_atual} = $id_to_go;
        return 1;
    }

    #tratamento do comando use 'POCAO'
    if($comando_usado->{comando} eq "use"){
        my $objeto = ${$self->{cenas}}[$self->{cena_atual}]->get_item_by_nome($comando_usado->{alvo});
        if($objeto->is_potion()){
            $self->{personagem}->atualiza_vida(-50);          
        }
    }

    if($comando_usado->{comando} eq "savegame"){
        my $dump = new XML::Dumper;
        my $file = $temp2.".xml";
        my $xml = $dump->pl2xml( $self->{personagem} ,$file);
    }
    if($comando_usado->{comando} eq "loadgame"){
        my $dump = new XML::Dumper;
        my $file = $temp2.".xml";
        $self->{personagem} = $dump->xml2pl($file);
    }
    
    #Comando attack dos animais
    if($comando_usado->{comando} eq "attack"){
        my $lutar_com =${$self->{cenas}}[$self->{cena_atual}]->get_monstro_by_nome($comando_usado->{alvo});
       ${$self->{cenas}}[$self->{cena_atual}]->duelo($lutar_com,$self->{personagem});

    }
    if($comando_usado->{comando} eq "pick"){
        my $personagem=$self->{personagem};
        
        my $obj=${$self->{cenas}}[$self->{cena_atual}]->get_item_by_nome($comando_usado->{alvo});

        if($personagem->add_item($obj)==0){
            print("Inventario cheio!!");
        }
    }
    if($comando_usado->{comando} eq "open"){
        my $personagem=$self->{personagem};
        
        return $personagem->open_menu($comando_usado->{alvo});
    }
    $self->comandos_disponiveis();
    return 0;
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