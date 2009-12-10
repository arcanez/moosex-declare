use Test::More;
use Test::Exception;
use MooseX::Declare;

class Person {
    has name   => (is => 'rw', isa => 'Str', required => 1);
    has age    => (is => 'rw', isa => 'Int', required => 1);
    has gender => (is => 'rw', isa => 'Str');
}

class Directory {
    use Moose::Util::TypeConstraints;

    coerce 'Person', from 'HashRef', via { Person->new($_) };

    has people => (
        is => 'ro',
        isa => 'HashRef[Person]',
        traits => ['Hash'],
        handles => {
            add_person    => 'set',
            get_person    => 'get',
            exists_person => 'exists',
        },
        default => sub { my %hash = (); return \%hash },
    );

    around add_person(Person $person does coerce) {
        $self->$orig($person->name, $person);
    }

}

my $dir = Directory->new;

isa_ok($dir, 'Directory');

my $person = Person->new({ name => 'Alice', age => 25, gender => 'F' });
lives_ok(sub { $dir->add_person($person) }, 'added a Person object');
lives_ok(sub { $dir->add_person({ name => 'Bob', age => 26, gender => 'M' }) }, 'added a coerced Person object');

ok($dir->exists_person('Alice'), 'Person object exists');
ok($dir->exists_person('Bob'), 'coerced Person object exists');

isa_ok($dir->get_person('Alice'), 'Person');
isa_ok($dir->get_person('Bob'), 'Person');

done_testing;
