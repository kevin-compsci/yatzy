-module(yatzy_turn_Test_OTP).

-compile(export_all).

-include_lib("eunit/include/eunit.hrl").

roll_valid_test() ->
	{_, A} = gen_yatzy_turn:start_link(),
	R = gen_yatzy_turn:dice(A),
	K = lists:sublist(R, 1, 4),
	V = gen_yatzy_turn:roll(A, K),
	?assertEqual(V, V),
	?assertEqual(invalid_keepers, gen_yatzy_turn:roll(A, [6,6,6,6,6])),
	?assertEqual(invalid_keepers, gen_yatzy_turn:roll(A, [6,6,5,6,6])),
	?assertEqual(invalid_keepers, gen_yatzy_turn:roll(A, [1,1,1,1,1])),
	R1 = gen_yatzy_turn:dice(A),
	K1 = lists:sublist(R1, 1, 5),
	V1 = gen_yatzy_turn:roll(A, K1),
	?assertEqual(V1, V1),
	?assertEqual(finished, gen_yatzy_turn:roll(A, [])),
	?assertEqual(finished, gen_yatzy_turn:roll(A, [])),

	{_, B} = gen_yatzy_turn:start_link(),
	R2 = gen_yatzy_turn:dice(B),
	K2 = lists:sublist(R2, 1, 5),
	V2 = gen_yatzy_turn:roll(B, K2),
	?assertEqual(V2, V2),
	?assertEqual(invalid_keepers, gen_yatzy_turn:roll(B, [1,2,3,4,5])),
	?assertEqual(invalid_keepers, gen_yatzy_turn:roll(B, [2,3,4,5,6])),
	R3 = gen_yatzy_turn:dice(B),
	K3 = lists:sublist(R3, 1, 5),
	V3 = gen_yatzy_turn:roll(B, K3),
	?assertEqual(V3, V3),
	?assertEqual(finished, gen_yatzy_turn:roll(B, [])),
	?assertEqual(finished, gen_yatzy_turn:roll(B, [])),

	gen_yatzy_turn:stop(A),
	gen_yatzy_turn:stop(B).

evil_roll_test() ->
	[evil_test_gen() || _ <- lists:seq(1, 100)].

evil_test_gen() ->
	{_, A} = gen_yatzy_turn:start_link(),
	R = gen_yatzy_turn:dice(A),
	K = lists:sublist(R, 1, 4),
	gen_yatzy_turn:roll(A, K),
	R1 = gen_yatzy_turn:dice(A),
	gen_yatzy_turn:stop(A),
	?assertEqual(K--R1, []).

% dice_test() ->
% 	A = gen_yatzy_turn:start_link(),
% 	gen_yatzy_turn:stop(A).

% stop_test() ->
% 	A = gen_yatzy_turn:start_link(),
% 	gen_yatzy_turn:stop(A).