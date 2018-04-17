package Cena;
use Time::HiRes qw(sleep);
use Data::Dumper qw(Dumper);
use Storable 'dclone';

sub new
{
    my ( $class ) = shift;
    my $self = { };
    bless $self;
    $self->{id} = "";
    $self->{titulo} = "";
    $self->{descricao} = "";
    $self->{itens} = [];
    $self->{npcs} = [];
    $self->{monstro}= ();
    $self->{cena_anterior}=0;
    $self->{cena_seguinte}=0;
    return $self;
}
sub get_titulo{
    my $self = shift;
    return $self->{titulo};
}
sub set_cena_anterior{
    my $self = shift;
    my $value = shift;

    $self->{cena_anterior} = $value;
}
sub set_cena_seguinte{
    my $self = shift;
    my $value = shift;

    $self->{cena_seguinte} = $value;
}
sub get_cena_anterior{
    my $self = shift;
    return $self->{cena_anterior};
}
sub get_cena_seguinte{
    my $self = shift;
    return $self->{cena_seguinte};
}
sub set_titulo{
    my $self = shift;
    my $value = shift;

    $self->{titulo} = $value;
}

sub get_id{
    my $self = shift;
    return $self->{id};
}

sub set_id{
    my $self = shift;
    my $value = shift;

    $self->{id} = $value;
}
sub comandos_possiveis{
    my $self=shift;
    my @commands;
    foreach my $i (@{$self->{npcs}}){
        push @commands, ({comando=>"talk", alvo=>$i->get_nome});
    }
    foreach my $i (@{$self->{monstro}}){
        push @commands, ({comando=>"attack",alvo=>$i->get_nome});
        push @commands, ({comando=>"check",alvo=>$i->get_nome});
    }

    foreach my $i (@{$self->{itens}}){
        if($i->is_potion){
            push @commands, ({comando=>"use",alvo=>$i->get_nome});
        }
        push @commands, ({comando=>"pick",alvo=>$i->get_nome});
        push @commands, ({comando=>"check",alvo=>$i->get_nome});
    }
    #se tem cena anterior entao:
    if($self->{cena_anterior}){
        push @commands, ({comando=>"walk",alvo=>$self->{cena_anterior}->get_titulo});
    }
    if($self->{cena_seguinte}){
        push @commands, ({comando=>"walk",alvo=>$self->{cena_seguinte}->get_titulo});
    }
    push @commands, ({comando=>"open",alvo=>"inventario"});
    push @commands, ({comando=>"open",alvo=>"status"});
    push @commands, ({comando=>"savegame",alvo=>""});
    push @commands, ({comando=>"loadgame",alvo=>""});

    push @commands, ({comando=>"quit"});

    return @commands;
}

sub get_descricao{
    my $self = shift;
    return $self->{descricao};
}

sub set_descricao{
    my $self = shift;
    my $value = shift;

    $self->{descricao} = $value;
}

sub get_itens{
    my $self = shift;
    my $i = shift;

    return $self->{itens}[$i];
}

sub set_item{
    my $self = shift;
    my @value = @_;
    
    # loop para colocar todas os 'item' dentro do vetor de'itens'
    foreach my $i (0..$#value){
        push ((@{$self->{itens}}), $value[$i]);
    }
}

sub get_npcs{
    my $self = shift;
    my $i = shift;

    return $self->{npcs}[$i];
}
sub get_all_npc{
    my $self= shift;
    return @{$self->{npcs}};
}

sub set_monstro{
    my $self = shift;
    my @value = @_;
    
    # loop para colocar todas os 'npc' dentro do vetor de'npcs'
    foreach my $i (0..$#value){
        push ((@{$self->{monstro}}), $value[$i]);
    }
}
sub set_npcs{
    my $self = shift;
    my @value = @_;
    
    # loop para colocar todas os 'npc' dentro do vetor de'npcs'
    foreach my $i (0..$#value){
        push ((@{$self->{npcs}}), $value[$i]);
    }
}

sub print_all_npcs{
    my $self = shift;
    print ("NPCS: ");
    foreach my $i (@{$self->{npcs}}){
        print($i->get_nome(), ", ");
    }
}

sub print_all_obj{
    my $self = shift;
    print ("OBJETOS: ");
    foreach my $i (@{$self->{itens}}){
        print($i->get_nome(), ", ");
    }
}

sub get_item_by_nome{
    my $self = shift;
    my $nome = shift;
    foreach my $i (@{$self->{itens}}){
        if(lc $i->get_nome eq lc $nome){
            return pop @{$self->{itens}},$i;
        }
    }
}
sub get_monstro_by_nome{
    my $self = shift;
    my $nome = shift;
    foreach my $i (@{$self->{monstro}}){
        if(lc $i->get_nome eq lc $nome){
            return $i;
        }
    }
}
sub duelo{
    my $self=shift;
    my $enemy= dclone shift;

    my $personagem=shift;

    while($enemy->get_defesa >0){

        $personagem->calcula_personagem();
        if($personagem->get_defesa<=0){
            print("Voce morreu!\n");
            return(2);
        }
        else{
            my $dano_do_monstro=$enemy->get_dano();
            my $dano_do_personagem=$personagem->get_dano();
            $enemy->ataque($dano_do_personagem);
            $personagem->atualiza_vida($dano_do_monstro);

        }
        if($enemy->get_defesa <=0){
            print("Você matou o ",$enemy->get_nome,"\n");
            $self->set_item($enemy->drop());
            return 3;
        }
        sleep(1);
    }
    return 0;
}

sub print_all_monstro{
    my $self = shift;
    print ("MONSTROS: ");
    foreach my $i (@{$self->{monstro}}){
        print($i->get_nome(), ", ");
    }

}

sub is_monster_by_nome{
    my $self = shift;
    my $nome = shift;
    foreach my $i (@{$self->{monstro}}){
        if(lc $i->get_nome() eq lc $nome){
            return 1;
        }
    }

}

sub print_monster_by_nome{
    my $self = shift;
    my $nome = shift;
    foreach my $i (@{$self->{monstro}}){
        if(lc $i->get_nome() eq lc $nome){
            #print (Dumper $i);
            print(
              "\tNome: ", $i->get_nome(), "\n", 
              "\tDescricao:", $i->get_descricao(), "\n",
              "\tDano: ", $i->get_dano(), "\n",
            );
        }
    }
}

1;