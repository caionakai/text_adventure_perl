package Classe;
sub new
{
    my ( $class ) = shift;
    my $self = {
        _nome => shift,
        _sobrenome => shift
        };
    bless $self, $class;

    print "Nome: $self->{_nome}\n";
    print "Sobrenome: ", $self->{_sobrenome};
    return $self;
}


1;