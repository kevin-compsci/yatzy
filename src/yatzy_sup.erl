%%%-------------------------------------------------------------------
%% @doc yatzy top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(yatzy_sup).

-behaviour(supervisor).

%% API
-export([start_link/0, new_child/1, end_child/1]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%====================================================================
%% API functions
%%====================================================================

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, na).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: #{id => Id, start => {M, F, A}}
%% Optional keys are restart, shutdown, type, modules.
%% Before OTP 18 tuples must be used to specify a child. e.g.
%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}

init(na) ->
	SupFlags = {one_for_one, 0, 1},
 	ChildSpecs = [],
    {ok, {SupFlags, ChildSpecs}}.


%%====================================================================
%% Internal functions
%%====================================================================

new_child(Name) ->
	supervisor:start_child(?SERVER, {Name, {gen_yatzy_player, start_link, [Name]}, permanent, brutal_kill, worker, [gen_yatzy_player]}).


end_child(Name) ->
	supervisor:terminate_child(?MODULE, Name).










%           ORIGINAL BELOW
% %%%-------------------------------------------------------------------
% %% @doc yatzy top level supervisor.
% %% @end
% %%%-------------------------------------------------------------------

% -module(yatzy_sup).

% -behaviour(supervisor).

% %% API
% -export([start_link/0]).

% %% Supervisor callbacks
% -export([init/1]).

% -define(SERVER, ?MODULE).

% %%====================================================================
% %% API functions
% %%====================================================================

% start_link() ->
%     supervisor:start_link({local, ?SERVER}, ?MODULE, []).

% %%====================================================================
% %% Supervisor callbacks
% %%====================================================================

% %% Child :: #{id => Id, start => {M, F, A}}
% %% Optional keys are restart, shutdown, type, modules.
% %% Before OTP 18 tuples must be used to specify a child. e.g.
% %% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
% init([]) ->
%     {ok, {{one_for_all, 0, 1}, []}}.

% %%====================================================================
% %% Internal functions
% %%====================================================================

