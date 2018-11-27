-module(yatzy_score).
-export([calc/2]).


-spec calc(yatzy:slot(), yatzy:roll()) -> non_neg_integer().
calc(chance, Roll) -> 
	lists:sum(Roll);
calc(ones, Roll) ->
	funct(1, Roll);
calc(twos, Roll) ->
	funct(2, Roll);
calc(threes, Roll) ->
	funct(3, Roll);
calc(fours, Roll) ->
	funct(4, Roll);
calc(fives, Roll) ->
	funct(5, Roll);
calc(sixes, Roll) ->
	funct(6, Roll);
calc(three_of_kind, Roll) ->
	three_of_kind(lists:sort(Roll));
calc(four_of_kind, Roll) ->
	four_of_kind(lists:sort(Roll));
calc(small_straight, Roll) ->
	small_straight(lists:sort(Roll));
calc(large_straight, Roll) ->
	large_straight(lists:sort(Roll));
calc(full_house, Roll) ->
	full_house(lists:sort(Roll));
calc(one_pair, Roll) ->
	one_pair(lists:sort(Roll));
calc(two_pair, Roll) ->
	two_pair(lists:sort(Roll));
calc(yatzy, Roll) ->
	yatzy(lists:sort(Roll)).

funct(V, Roll) ->
	lists:sum(lists:filter(fun(X) -> X==V end, Roll)).

three_of_kind([X,X,X,_,_]) ->
	3*X;
three_of_kind([_,X,X,X,_]) ->
	3*X;
three_of_kind([_,_,X,X,X]) ->
	3*X;
three_of_kind([_,_,_,_,_]) ->
	0.

four_of_kind([X,X,X,X,_]) ->
	4*X;
four_of_kind([_,X,X,X,X]) ->
	4*X;
four_of_kind([_,_,_,_,_]) ->
	0.

small_straight([1,2,3,4,5]) ->
	1+2+3+4+5;
small_straight([_,_,_,_,_]) ->
	0.

large_straight([2,3,4,5,6]) ->
	2+3+4+5+6;
large_straight([_,_,_,_,_]) ->
	0.

full_house([X,X,X,Y,Y]) when X /= Y ->
	(3*X)+(2*Y);
full_house([Y,Y,X,X,X]) when Y /= X ->
	(2*Y)+(3*X);
full_house([_,_,_,_,_]) ->
	0.

one_pair([X,X,_,_,_]) ->
	(2*X);
one_pair([_,X,X,_,_]) ->
	(2*X);
one_pair([_,_,X,X,_]) ->
	(2*X);
one_pair([_,_,_,X,X]) ->
	(2*X);
one_pair([_,_,_,_,_]) ->
	0.

two_pair([X,X,Y,Y,_]) when X /= Y ->
	(2*X)+(2*Y);
two_pair([_,X,X,Y,Y]) when X /= Y ->
	(2*X)+(2*Y);
two_pair([_,_,_,_,_]) ->
	0.

yatzy([X,X,X,X,X]) ->
	(5*X);
yatzy([_,_,_,_,_]) ->
	0.

