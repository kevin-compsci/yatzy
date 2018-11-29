-module(yatzy_turn).
-export([start/0]).%, roll/2, dice/1, stop/1]).


-spec start() -> {ok, TurnPid}.
% -spec roll(TurnPid, Keep) -> ok | invalid_keepers | finished.
% Once the player has selected which dice to keep roll the remaining dice unless they
% have already been rolled twice.

% -spec dice(TurnPid) -> yatzy_score:roll().
% Just the rolled dice as it stands at this point.

% -spec stop(TurnPid) -> yatzy_score:roll().
% Just stop the procees and get out what was rolled.

%STATES = first_roll, second_roll,... Round_one, etc..? Will be Similar?
%How many Rounds? how many Rolls per round?

start() ->
	Roll = [rand:uniform(6) || _ <- lists:seq(1, 5)],
  	TurnPid = spawn(fun() ->
                first_roll(Roll)
              end),
	{ok, TurnPid}.


first_roll(Roll) ->
	%keep track which dices have been re-rolled?
	%keep which ones?
	%recieve
		%call roll(TurnPid, Keep)
		%pass to second_roll
	%end


%second_roll(Roll) ->
%final_roll(Roll) ->

% roll(TurnPid, Keep) ->

% dice(TurnPid) -> 

% stop(TurnPid) ->
