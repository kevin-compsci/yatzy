-module(gen_yatzy_player).
-export([start_link/1, stop/1, init/1, fill/3, sheet/1]).
-export([handle_call/3, handle_cast/2]).

-spec start_link(Name::atom()) -> {ok, yatzy_sheet:t()}.
-spec fill(Name::atom(), yatzy:slot(), yatzy:roll()) -> {ok, Score::integer()}
                                                      | {error, Reason::any()}.
-spec sheet(Name::atom()) -> yatzy_sheet:t().

-behavior(gen_server).

start_link(Name) ->
	gen_server:start_link({local, Name}, ?MODULE, na, []).

init(na) ->
   	Sheet = yatzy_scoresheet:new(),
	{ok, Sheet}.

fill(Name, Slot, Roll) ->
	gen_server:call(Name, {fill, Slot, Roll}).

sheet(Name) ->
	gen_server:call(Name, {sheet}).

stop(Name) ->
	gen_server:cast(Name, stop).

handle_call({fill, Slot, Roll}, _From, Sheet) ->
	case yatzy_scoresheet:fill(Slot, Roll, Sheet) of
		{ok, NewSheet} ->
			{filled, Score} = yatzy_scoresheet:get(Slot, NewSheet),
			{reply, {ok, Score}, NewSheet};
		Reason ->
			{reply, {error, Reason}, Sheet}
	end;
handle_call({sheet}, _From, Sheet) ->
	{reply, Sheet, Sheet}.

handle_cast(_Msg, State) ->
	{noreply, State}.








%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ORIGINAL BELOW
% new(Name) ->
%   Sheet = yatzy_scoresheet:new(),
%   Pid = spawn(fun() ->
%                 loop(Sheet)
%               end),
%   register(Name, Pid),
%   {ok, Pid}.

% loop(Sheet) ->
% 	receive
% 		{From, Slot, Roll} ->
% 			Sheet1 = yatzy_scoresheet:fill(Slot, Roll, Sheet),
% 				case Sheet1 of
% 					{ok, _} ->
% 						Score = yatzy_score:calc(Slot, Roll),
% 						From ! {success, Score},
% 						loop(Sheet1);
% 					'already_filled' ->
% 						From ! {'already_filled'},
% 						loop(Sheet);
% 					'invalid_slot' ->
% 						From ! {'invalid_slot'},
% 						loop(Sheet)
% 				end;
% 		{From, need_sheet} ->
% 			From ! {Sheet};
% 		stop ->
% 			true
% 	end.

% fill(Name, Slot, Roll) ->
% 	Name ! {self(), Slot, Roll},
% 	receive
% 		{success, Value} ->
% 			{ok, Value};
% 		{'already_filled'} ->
% 			{error, 'already_filled'};
% 		{'invalid_slot'} ->
% 			{error, 'invalid_slot'}
% 	end.

% sheet(Name) ->
% 	Name ! {self(), need_sheet},
% 	receive
% 		{Sheet} ->
% 			Sheet
% 	end.
