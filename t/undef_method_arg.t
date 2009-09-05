#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 6;
use Test::Exception;

use MooseX::Declare;

class Foo {
    method m1(:$bar!) { }
    method m2(:$bar?) { }
    method m3(:$bar ) { }

    method m4( $bar!) { }
    method m5( $bar?) { }
    method m6( $bar ) { }
}

my $foo = Foo->new;

TODO: {
    local $TODO = 'allow explicit passing of undef to args';
    lives_ok(sub { $foo->m1(bar => undef) }, 'Explicitly pass undef to positional required arg');
    lives_ok(sub { $foo->m2(bar => undef) }, 'Explicitly pass undef to positional explicit optional arg');
    lives_ok(sub { $foo->m3(bar => undef) }, 'Explicitly pass undef to positional implicit optional arg');

    lives_ok(sub { $foo->m4(undef) }, 'Explicitly pass undef to required arg');
    lives_ok(sub { $foo->m5(undef) }, 'Explicitly pass undef to explicit required arg');
    lives_ok(sub { $foo->m6(undef) }, 'Explicitly pass undef to implicit required arg');
}
