-module(process_test).
-export([go/0, loop/0]).

go() ->
	register(process_test, sawn(process_test, loop, helloworld)),
	process_test ! {self(), hello},
	receive
		{_Pid, Msg} ->
			io:format("~w~n", [Msg])
		end.

loop(hw) ->
	receive
		{From, Msg} ->
			From ! {self(), Msg},
			loop();
		stop ->
			true
	end.