use v6;
use Test;
plan 2;

# Make sure that smarmatch doesn't return unexpected values. In particular, it must always return Boolean except for
# when used with regexes.
# Since optimizations may result in different code for matching directly against objects, when RHS is known exactly,
# or indirectly, when RHS type is hiddent behind a symbol, – we need to test both cases.

subtest "direct" => {
    plan 9;
    isa-ok (1 ~~ 1).WHAT, Bool, "plan smartmatch return Bool";
    isa-ok (any(1,2) ~~ 1).WHAT, Bool, "a junction on LHS doesn't autothread";
    isa-ok (1 ~~ any(1,2)).WHAT, Bool, "a junction on RHS doesn't autothread";
    isa-ok ("123" ~~ /\d+/).WHAT, Match, "simple regex returns a Match object on success";
    isa-ok ("123" ~~ m/\d+/).WHAT, Match, "successfull m// returns a Match object";
    my $s = "1..5";
    isa-ok ($s ~~ s/\.+/_/).WHAT, Match, "successfull s/// returns a Match object";
    cmp-ok ("abc" ~~ /\d+/), '===', Nil, "failed regex match returns Nil";
    cmp-ok ("abc" ~~ m/\d+/), '===', False, "failed m// returns False";
    cmp-ok ($s ~~ s/\.+/_/), '===', False, "failed s/// returns False";
}

subtest "indirect" => {
    plan 5;

    my sub test-sm(Mu $lhs, Mu $rhs --> Mu) is raw {
        $lhs ~~ $rhs
    }

    isa-ok test-sm(1, 1).WHAT, Bool, "plan smartmatch return Bool";
    isa-ok test-sm(any(1,2), 1).WHAT, Bool, "a junction on LHS doesn't autothread";
    isa-ok test-sm(1, any(1,2)).WHAT, Bool, "a junction on RHS doesn't autothread";
    isa-ok test-sm("123", /\d+/).WHAT, Match, "simple regex returns a Match object on success";
    my $s = "1..5";
    cmp-ok test-sm("abc", /\d+/), '===', Nil, "failed regex match returns Nil";
}


done-testing;
