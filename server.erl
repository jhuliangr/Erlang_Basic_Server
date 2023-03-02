-module(server).
-behaviour(gen_server).

% Interfaz de Usuario
-export([start_link/0,stop/0, factorial/1, factorial/2]).

% gen_server
-export([init/1,handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3 ]).

%=============================================================================================================
% Llamadas de Cliente 
%=============================================================================================================

start_link() ->
    gen_server:start_link({global, ?MODULE}, ?MODULE, [],[]).

stop() ->
    gen_server:cast({global, ?MODULE}, stop).

factorial(Val) ->
    gen_server:call({global, ?MODULE}, {factorial, Val}).


factorial(Val, Archivo) ->
    gen_server:call({global, ?MODULE}, {factorial, Val, Archivo}).



%=============================================================================================================
% Funciones Callback 
%=============================================================================================================

init([]) ->
    process_flag(trap_exit, true),
    io:format("~p (~p) Iniciando... ~n",[{local, ?MODULE}, self()]),
    {ok, []}.

handle_call(stop, _From, State) ->
  {stop, normal, ok, State};

handle_call({factorial,Val}, _From, State) ->
  Pid = spawn(fun() -> logica:factorial_handler() end),
  {reply, Pid ! {factorial, Val},State};

handle_call({factorial,Val,Archivo}, _From, State) ->
  Pid = spawn(fun() -> logica:factorial_handler() end),
  {reply, Pid ! {factorialRecorder, Val, Archivo},State};

handle_call(_Request, _From, State) ->
  {reply,error, State}.



handle_cast(_Req, State) ->
    {noreply, State}.

handle_info(Info, State) ->
    {noreply, Info, State}.

terminate(_Razon, _State) ->
    io:format("Terminando ~p~n", [{local, ?MODULE}]),
    ok.
code_change(_oldVersion, State, _Extra) ->
    {ok, State}.

