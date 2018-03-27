use 5.010;
use strict;
use warnings;

use XML::LibXML;

my $Object_list = 'object.xml';

my $dom = XML::LibXML->load_xml(location => $Object_list);

foreach my $object ($dom->findnodes('/object')) {
    say $object->findvalue("./id");
    say $object->findvalue("./name");
    say $object->findvalue("./damage");
}