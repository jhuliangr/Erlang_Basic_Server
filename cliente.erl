-module(cliente).

-export([ factorial/1, factorialEscrito/2, guardarComentarios/2, getComentarios/1, getComentarios_2/1, eliminarDatos/1]).

% start() ->
%     server:start_link().

% stop() ->
%     server:stop().

factorial(Val) ->
    server:factorial(Val).

factorialEscrito(Val, Archivo) ->
    server:factorial(Val, Archivo).

guardarComentarios(NodeName, Comment) ->
    servidor_DB:store(NodeName, Comment).

getComentarios(NodeName) ->
    servidor_DB:getDB(NodeName).

getComentarios_2(NodeName) ->
    servidor_DB:getDB_2(NodeName).

eliminarDatos(NodeName) ->
    servidor_DB:vaciarNodo(NodeName).