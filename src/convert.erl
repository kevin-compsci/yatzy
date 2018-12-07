-module(convert).

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.

-export([d2b/1, d2h/1, d2n/2]).
-export([d2btr/2, d2htr/2, d2ntr/3, anybaserem/1]).

-type base() :: 2..26.

%% -----------------------------------------------------------------------------

-spec d2b(pos_integer()) -> string().

d2b(Num) ->
	lists:concat(d2btr(Num, [])). %TAIL RECURSION?


d2btr(0, List) ->
	[0];
d2btr(1, List) ->
	[1]++List;
d2btr(Num, List) ->
	X = Num rem 2,
	Y = Num div 2,
	d2btr(Y, [X]++List).



-spec d2h(pos_integer()) -> string().

d2h(Num) ->
	lists:concat(d2htr(Num, [])).

d2htr(0, List) ->
	[0];
d2htr(1, List) ->
	[1]++List;
d2htr(Num, List) ->
	X = Num rem 16,
	Y = Num div 16,
	case X of
		10 -> 
			d2htr(Y, ['A']++List);
		11 ->
			d2htr(Y, ['B']++List);
		12 ->
			d2htr(Y, ['C']++List);
		13 ->
			d2htr(Y, ['D']++List);
		14 ->
			d2htr(Y, ['E']++List);
		15 ->
			d2htr(Y, ['F']++List);
		_ ->
			d2htr(Y, [X]++List)
	end.




-spec d2n(pos_integer(), base()) -> string().

d2n(Num, Base) -> 
	lists:concat(d2ntr(Num, Base, [])).


d2ntr(0, Base, List) ->
	List;
d2ntr(1, Base, List) ->
	[1]++List;
d2ntr(Num, Base, List) ->
	X = anybaserem(Num rem Base),
	Y = Num div Base,
	d2ntr(Y, Base, [X]++List).

anybaserem(Num) ->
	case Num > 9 of
		true ->
			lists:nth(Num-9, [a,b,c,e,f,g,h,i,j,k,l,m,n,o,p]);
		false ->
			Num
	end.


%% -----------------------------------------------------------------------------

-ifdef(TEST).

d2b_test() ->
    ok.

d2h_test() ->
    ok.

d2n_test() ->
    ok.

-endif.