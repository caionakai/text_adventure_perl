BEGIN {
  #@INC is the directory list, where perl searches for .pm files
  unshift @INC,"./classes";
}
use utf8;
use strict;
use ObjetoRead;
use Objeto;
use CenaRead;
use Cena;
use Personagem;
use Jogo;
use Npc;
use NpcRead;
use Thread;
use Time::HiRes qw(sleep);

use Data::Dumper;
use Audio::Play::MPlayer;
sub play_song(){
  my $self=shift;
  my $mp3 = "Naruto_Rocks.mp3";
  system( qq("START /MIN mplayer $mp3 /SEPARATE"));
} 


#my $result = Win32::Sound::Play($mp3);

#$player->poll(1) until $player->state == 0;
#my $player = Audio::Play::MPlayer->new;
#$player->load($mp3);
#$player->poll(1) until $player->state == 0;

#system( qq("mplayer $mp3"));

    my $huh = Thread->new(\&play_song);
    my $stuff = $huh->join;
my $game = new Jogo();
  $game->init();
  $game->game_start;



#my $test=$dump->xml2pl($file);
#print (Dumper $test);

## @{$cenas->{npcs}} é na verdade um vetor de cenas '-'

#print (${$cenas->{npcs}}[0]->print_all_npcs());
#print (${$cenas->{npcs}}[0]->print_all_obj());


## INSTANCIAR JOGO PASSANDO O VETOR DE CENAS ##
#my $jogo = new Jogo(@vet_cena);

## 





#my @xml= new ObjetoRead("object.xml");

#$xml[0]->get_id();
#my $inventory= new Inventario(5);

#foreach my $i (0 .. $#xml) {
#  $inventory->add_item($xml[$i]);
#}
#$inventory->print_list_of_itens();
#$inventory->remove(0);
#$inventory->print();

#foreach my $i(@xml){
#  print $i->get_nome,"\n";
#}

#$jogo->get_cenas(1);
#print ($jogo->get_cenas(1)->get_titulo());

#my @vetor = new Cena();
#my $n = 0;


#while ($n < 10){
#	@vetor[$n] = new Cena();
#	$n = $n + 1; 
#}

#@vetor = $jogo->get_cenas;

#print $vetor[0]->get_titulo;

#foreach my $elem(@vetor){
#	print $elem->get_titulo;
#}

#foreach my $x($jogo->get_cenas){
#	print $x->get_titulo;

#}


#foreach my $x(@teste){
#	print $x->get_id,"\n";
#	print $x->get_titulo,"\n";
#	print $x->get_descricao,"\n";
#	print $x->get_itens,"\n";
#}



#while (1) {
	
#}