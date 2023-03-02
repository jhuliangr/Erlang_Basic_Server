-module(supervisor_pro).
-behaviour(supervisor).
% API
-export([start_link/0]).
% supervisor
-export([init/1]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).


init([]) ->
    io:format("~p (~p) Iniciando supervisor...~n", [{global, ?MODULE},self()]),
    % {ok, {{one_for_one, 5, 10}, []}}.
    EstrategiaRestart = one_for_all,
    MaxRestarts = 3,
    MaxSecondsBetweenRestarts = 5,
    Flags = {EstrategiaRestart, MaxRestarts, MaxSecondsBetweenRestarts},

    %% permanent  -> Siempre reinicia
    %% temporary  -> Nunca reinicia
    %% transient  -> reinicia si termina de forma anormal
    Restart = permanent,

    %% brutal_kill -> usa exit(Child, kill)
    %% Integer     -> usa exit(Child, shutdown) - milisegundos
    Apagar = infinity,

    
    %% worker
    %% supervisor
    Type = worker,
    
    %% {ChildId, {ProcesoAIniciar = {modulo, funcion, arg}, reiniciar, apagar, type, modulos}}
    EspecificacionesHeredadas = {serverId, {server, start_link,[]}, Restart, Apagar, Type, [server]},
    MnesiaSpecification = {mnesiaID, {servidor_DB, start_link,[]}, Restart, Apagar, Type, [servidor_DB]},
    
    %% tupla de la estrategia de reinicios max restart y max time
    {ok, {Flags, [EspecificacionesHeredadas, MnesiaSpecification]}}.

