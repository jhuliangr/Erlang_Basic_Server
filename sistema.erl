-module(sistema).
-behaviour(application).

-export([start/2, stop/1, start/0, stop/0]).

start() ->
    application:start(?MODULE).

start(_Type, _Args) ->
    supervisor_pro:start_link().

stop() ->
    mnesia:stop(),
    application:stop(?MODULE).
% application:unload(sistema).
stop(_Stats) ->
    ok.
