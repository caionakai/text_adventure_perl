BEGIN {
  unshift @INC,"./";
  #@INC is the directory list, where perl searches for .pm files
}
use 5.010;
use strict;
use warnings;

my $object = {
    nome =>"caio",
    ra => 123456,
};
print $object->{nome};