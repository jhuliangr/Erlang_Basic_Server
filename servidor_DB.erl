-module(servidor_DB).
-behaviour(gen_server).
%% Cliente
-export([start_link/0, store/2, getDB/1, getDB_2/1, vaciarNodo/1]).

%% API
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).


-record(state, {}).
%====================================================================
%   client calls
%====================================================================

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

store(NodeName, Comment) ->
    gen_server:call({global, ?MODULE}, {store, NodeName, Comment}).
getDB(NodeName) ->
    gen_server:call({global, ?MODULE}, {getDB, NodeName}).
getDB_2(NodeName) ->
    gen_server:call({global, ?MODULE}, {getDB_2, NodeName}).
vaciarNodo(NodeName) ->
    gen_server:call({global, ?MODULE}, {vaciarNodo, NodeName}).

%====================================================================
%   Callbacks
%====================================================================



init(_Args) ->
    process_flag(trap_exit, true),
    io:format("~p   (~p) Iniciando Base de datos", [{global, ?MODULE}, self()]),
    database:initDB(),
    {ok, #state{}}.

handle_call({store, NodeName, Comment}, _From, State) ->
    database:getDB(NodeName, Comment),
    io:format("El dato ha sido guardado con exito en ~p", [NodeName]),
    {reply, ok, State};

handle_call({getDB, NodeName}, _From, State) ->
    Comentarios = database:getDB(NodeName),
    list:foreach(fun(Com) -> 
        io:format("Recibido: ~p", [Com]) 
    end, Comentarios),
    {reply, ok, State};

handle_call({getDB_2, NodeName}, _From, State) ->
    Comentarios = database:getDB_2(NodeName),
    list:foreach(fun({Com, Fecha}) -> 
        io:format("Recibido: ~p fecha: ~p", [Com, Fecha]) 
    end, Comentarios),
    {reply, ok, State};

handle_call({vaciarNodo, NodeName}, _From, State) ->
    database:vaciarNodo(NodeName),
    io:format("Datos eliminados para el nodo ~p", [NodeName]),
    {reply, ok, State};

handle_call(stop, _From, State) ->
    {stop, normal, stopped, State};

handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
