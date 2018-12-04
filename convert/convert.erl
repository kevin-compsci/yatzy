-module(convert).

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.

-export([d2b/1, d2h/1, d2n/2]).

-type base() :: 2..26.

%% -----------------------------------------------------------------------------

-spec d2b(pos_integer()) -> string().

d2b(Num) ->
    "".

-spec d2h(pos_integer()) -> string().

d2h(Num) ->
    "".

-spec d2n(pos_integer(), base()) -> string().

d2n(Num, Base) -> "".

%% -----------------------------------------------------------------------------

-ifdef(TEST).

d2b_test() ->
    ok.

d2h_test() ->
    ok.

d2n_test() ->
    ok.

-endif.