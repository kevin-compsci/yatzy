-module(yatzy_player).
-export([new/1, fill/3, sheet/1]).

-spec new(Name::atom()) -> {ok, pid()}.
-spec fill(Name::atom(), yatzy:slot(), yatzy:roll()) -> {ok, Score::integer()}
                                                      | {error, Reason::any()}.
-spec sheet(Name::atom()) -> yatzy_sheet:t().

new(Name) ->
  Sheet = yatzy_scoresheet:new(),
  Pid = spawn(fun() ->
                loop(Sheet)
              end),
  register(Name, Pid),
  {ok, Pid}.

loop(Sheet) ->
	receive
		{From, Slot, Roll} ->
			Sheet1 = yatzy_scoresheet:fill(Slot, Roll, Sheet),
				case Sheet1 of
					{ok, _} ->
						Score = yatzy_score:calc(Slot, Roll),
						From ! {success, Score},
						loop(Sheet1);
					'already_filled' ->
						From ! {'already_filled'},
						loop(Sheet);
					'invalid_slot' ->
						From ! {'invalid_slot'},
						loop(Sheet)
				end;
		{From, need_sheet} ->
			From ! {Sheet};
		stop ->
			true
	end.

fill(Name, Slot, Roll) ->
	Name ! {self(), Slot, Roll},
	receive
		{success, Value} ->
			{ok, Value};
		{'already_filled'} ->
			{error, 'already_filled'};
		{'invalid_slot'} ->
			{error, 'invalid_slot'}
	end.

sheet(Name) ->
	Name ! {self(), need_sheet},
	receive
		{Sheet} ->
			Sheet
	end.
