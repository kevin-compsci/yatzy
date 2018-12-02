-module(yatzy_turn).
-export([start/0, roll/2, dice/1, stop/1]).


-spec start() -> {ok, TurnPid::pid()}.
-spec roll(TurnPid::pid(), Keep::[1..6]) -> {ok, yatzy:roll()} | invalid_keepers | finished.
% Once the player has selected which dice to keep roll the remaining dice unless they
% have already been rolled twice.

-spec dice(TurnPid::pid()) -> yatzy_score:roll().
% Just the rolled dice as it stands at this point.

-spec stop(TurnPid::pid()) -> yatzy_score:roll().
% Just stop the procees and get out what was rolled.





%STATES = first_roll, second_roll,... Round_one, etc..? Will those States look Similar?
	%Total number of States?

%How many Rounds? 3 TURNS per ROUND?

%Keeping dice? pattern match all combinations? user-input? randomly?
	% [2, 1, 2, 1, 1] keep an extra list of dices that rerolled? (1st and 3rd dice was rerolled)

%roll(TurnPid, Keep)...keep track which dices have been re-rolled?


start() ->
	Roll = [rand:uniform(6) || _ <- lists:seq(1, 5)],
  	TurnPid = spawn(fun() ->
                first_roll(Roll)
              end),
	{ok, TurnPid}.


first_roll(Roll) ->
	receive	
		{From, {roll, Keep}} ->
			case valid_keepers(Roll, Keep) of
				true ->
					NewSize = length(Roll)-length(Keep),
					NewRoll = randomroll(NewSize),
					From ! {ok, Roll},
					second_roll(NewRoll++Keep);
				false ->
				    From ! invalid_keepers,
				    first_roll(Roll)
			end;
		{From, get_dice} ->
			From ! Roll,
			first_roll(Roll);
		{From, stop} ->
			From ! Roll
 	end.

second_roll(Roll) ->
	receive	
		{From, {roll, Keep}} ->
			case valid_keepers(Roll, Keep) of
				true ->
					NewSize = length(Roll)-length(Keep),
					NewRoll = randomroll(NewSize),
					From ! {ok, Roll},
					final_roll(NewRoll++Keep);
				bad ->
				    From ! invalid_keepers,
				    second_roll(Roll)
			end;
		{From, get_dice} ->
			From ! Roll,
			second_roll(Roll);
		{From, stop} ->
			From ! Roll
 	end.

final_roll(Roll) ->
	receive	
		{From, {roll, Keep}} ->
			From ! finished,
			final_roll(Roll);
		{From, get_dice} ->
			From ! Roll,
			final_roll(Roll);
		{From, stop} ->
			From ! Roll
 	end.

roll(TurnPid, Keep) -> 
	TurnPid ! {self(), {roll, Keep}},
    receive
    	{ok, Roll} ->
    		{ok, Roll};
    	Msg ->
    		Msg
    end.

dice(TurnPid) ->
	TurnPid ! {self(), get_dice},
	receive 
		Roll ->
			Roll
	end.

stop(TurnPid) ->
	TurnPid ! {self(), stop},
	receive
		Roll ->
			Roll
	end.

randomroll(Length) ->
	[rand:uniform(6) || _ <- lists:seq(1, Length)].

valid_keepers(Roll, Keep) ->
	case Keep--Roll of
		[] ->
			true;	
		_ ->
			false
	end.