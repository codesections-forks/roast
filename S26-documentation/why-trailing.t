use Test;
plan 108;

my $pod_index = 0;

class Simple {
#= simple case
}

is $=pod[$pod_index++], 'simple case';

is Simple.WHY.contents, 'simple case', 'Class comment';
ok Simple.WHY.WHEREFORE === Simple, 'class WHEREFORE matches';
is Simple.WHY.trailing, 'simple case', 'Class comment';
ok !Simple.WHY.leading.defined;
is ~Simple.WHY, 'simple case', 'stringifies correctly';

class Outer {
#= giraffe
    class Inner {
    #= zebra
    }
}

is $=pod[$pod_index++], 'giraffe';
is $=pod[$pod_index++], 'zebra';

is Outer.WHY.contents, 'giraffe', 'Outer class comment';
ok Outer.WHY.WHEREFORE === Outer, 'outer class WHEREFORE matches';
is Outer.WHY.trailing, 'giraffe', 'Outer class comment';
ok !Outer.WHY.leading.defined;
is Outer::Inner.WHY.contents, 'zebra', 'Inner class comment';
ok Outer::Inner.WHY.WHEREFORE === Outer::Inner, 'inner class WHEREFORE matches';
is Outer::Inner.WHY.trailing, 'zebra', 'Inner class comment';
ok !Outer::Inner.WHY.leading.defined;

module foo {
#= a module
    package bar {
    #= a package
        class baz {
        #= and a class
        }
    }
}

is $=pod[$pod_index++], 'a module';
is $=pod[$pod_index++], 'a package';
is $=pod[$pod_index++], 'and a class';

is foo.WHY.contents,           'a module', 'module comment';
ok foo.WHY.WHEREFORE === foo, 'module WHEREFORE matches';
is foo.WHY.trailing,           'a module', 'module comment';
ok !foo.WHY.leading.defined;
is foo::bar.WHY.contents,      'a package', 'package comment';
ok foo::bar.WHY.WHEREFORE === foo::bar, 'inner package WHEREFORE matches';
is foo::bar.WHY.trailing,      'a package', 'package comment';
ok !foo::bar.WHY.leading.defined;
is foo::bar::baz.WHY.contents, 'and a class', 'module > package > class comment';
ok foo::bar::baz.WHY.WHEREFORE === foo::bar::baz, 'inner inner class WHEREFORE matches';
is foo::bar::baz.WHY.trailing, 'and a class', 'module > package > class comment';
ok !foo::bar::baz.WHY.leading.defined;

sub marine {} #= yellow

is $=pod[$pod_index++], 'yellow';

is &marine.WHY.contents, 'yellow', 'sub comment';
ok &marine.WHY.WHEREFORE === &marine, 'sub WHEREFORE matches';
is &marine.WHY.trailing, 'yellow', 'sub comment';
ok !&marine.WHY.leading.defined;

sub panther {}
#= pink

is $=pod[$pod_index++], 'pink';

is &panther.WHY.contents, 'pink', 'sub comment (the remix!)';
ok &panther.WHY.WHEREFORE === &panther, 'sub WHEREFORE matches';
is &panther.WHY.trailing, 'pink', 'sub comment (the remix!)';
ok !&panther.WHY.leading.defined;

class Sheep {
#= a sheep
    has $.wool; #= usually white

    method roar { 'roar!' }
    #= not too scary
}

is $=pod[$pod_index++], 'a sheep';
is $=pod[$pod_index++], 'usually white';
is $=pod[$pod_index++], 'not too scary';

is Sheep.WHY.contents, 'a sheep', 'class comment (again)';
ok Sheep.WHY.WHEREFORE === Sheep, 'class WHEREFORE matches';
is Sheep.WHY.trailing, 'a sheep', 'class comment (again)';
ok !Sheep.WHY.leading.defined;
my $wool-attr = Sheep.^attributes.grep({ .name eq '$!wool' })[0];
is $wool-attr.WHY, 'usually white', 'attribute comment';
ok $wool-attr.WHY.WHEREFORE === $wool-attr, 'attr WHEREFORE matches';
is $wool-attr.WHY.trailing, 'usually white', 'attribute comment';
ok !$wool-attr.WHY.leading.defined;
my $roar-method = Sheep.^find_method('roar');
is $roar-method.WHY.contents, 'not too scary', 'method comment';
ok $roar-method.WHY.WHEREFORE === $roar-method, 'method WHEREFORE matches';
is $roar-method.WHY.trailing, 'not too scary', 'method comment';
ok !$roar-method.WHY.leading.defined;

sub routine {}
is &routine.WHY.defined, False, 'lack of sub comment';

our sub oursub {}
#= our works too

is $=pod[$pod_index++], 'our works too';

is &oursub.WHY, 'our works too', 'works for our subs';
ok &oursub.WHY.WHEREFORE === &oursub, 'our sub WHEREFORE matches';
is &oursub.WHY.trailing, 'our works too', 'works for our subs';
ok !&oursub.WHY.leading.defined;

# two subs in a row

sub one {}
#= one

sub two {}
#= two

is $=pod[$pod_index++], 'one';
is $=pod[$pod_index++], 'two';

is &one.WHY.contents, 'one', 'another sub comment';
ok &one.WHY.WHEREFORE === &one, 'sub WHEREFORE matches';
is &one.WHY.trailing, 'one', 'another sub comment';
ok !&one.WHY.leading.defined;
is &two.WHY.contents, 'two', 'yet another sub comment';
ok &two.WHY.WHEREFORE === &two, 'sub WHEREFORE matches';
is &two.WHY.trailing, 'two', 'yet another sub comment';
ok !&two.WHY.leading.defined;

sub first {}
#= that will break

sub second {}
#= that will break

is $=pod[$pod_index++], 'that will break';
is $=pod[$pod_index++], 'that will break';

is &first.WHY.contents, 'that will break', 'even more sub comments!';
ok &first.WHY.WHEREFORE === &first, 'sub WHEREFORE matches';
is &first.WHY.trailing, 'that will break', 'even more sub comments!';
ok !&first.WHY.leading.defined;
is &second.WHY.contents, 'that will break', 'when will the sub comments end?!';
ok &second.WHY.WHEREFORE === &second, 'sub WHEREFORE matches';
is &second.WHY.trailing, 'that will break', 'when will the sub comments end?!';
ok !&second.WHY.leading.defined;

sub third {}
#=      leading space here

is $=pod[$pod_index++], 'leading space here';

is &third.WHY.contents, 'leading space here', 'sub comment - leading space';
ok &third.WHY.WHEREFORE === &third, 'sub WHEREFORE matches';
is &third.WHY.trailing, 'leading space here', 'sub comment - leading space';
ok !&third.WHY.leading.defined;

sub has-parameter(
    Str $param
    #= documented
) {}

is $=pod[$pod_index++], 'documented';

my $param = &has-parameter.signature.params[0];
is $param.WHY, 'documented', 'parameter comment';
ok $param.WHY.WHEREFORE === $param, 'param WHEREFORE matches';
is $param.WHY.trailing, 'documented', 'parameter comment';
ok !$param.WHY.leading.defined;

sub has-parameter-as-well(
    Str $param #= documented as well
) {}

is $=pod[$pod_index++], 'documented as well';

$param = &has-parameter-as-well.signature.params[0];
is $param.WHY, 'documented as well', 'parameter comment - same line';
ok $param.WHY.WHEREFORE === $param, 'param WHEREFORE matches';
is $param.WHY.trailing, 'documented as well', 'parameter comment - same line';
ok !$param.WHY.leading.defined;

sub so-many-params(
    Str $param, #= first param
    Int $other-param
) {}

is $=pod[$pod_index++], 'first param';

$param = &so-many-params.signature.params[0];
is $param.WHY, 'first param', 'parameter comment - same line, but after comma';
ok $param.WHY.WHEREFORE === $param, 'param WHEREFORE matches';
is $param.WHY.trailing, 'first param', 'parameter comment - same line, but after comma';
ok !$param.WHY.leading.defined;

$param = &so-many-params.signature.params[1];
ok !$param.WHY.defined, 'the second parameter has no comments' or diag($param.WHY.contents);

sub has-anon-param(
    Str $
    #= trailing
) {}

is $=pod[$pod_index++], 'trailing';

$param = &has-anon-param.signature.params[0];

is $param.WHY, 'trailing', 'anonymous parameters should work';

class DoesntMatter {
    method m(
        ::?CLASS $this:
        #= invocant comment
        $arg
    ) {}
}

is $=pod[$pod_index++], 'invocant comment';

$param = DoesntMatter.^find_method('m').signature.params[0];
is $param.WHY, 'invocant comment', 'invocant comments should work';

is $=pod.elems, $pod_index;
