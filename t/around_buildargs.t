use strict;
use warnings;
use Test::More;
use Test::Exception;

use MooseX::Declare;

class Foo {
    has bar => (is => 'ro', isa => 'Int');

    around BUILDARGS(@args?) { $self->$orig(@args) }
}

lives_ok(sub { my $foo = Foo->new({ bar => 1 }) }, "Didn't die with around BUILDARGS");

done_testing;
