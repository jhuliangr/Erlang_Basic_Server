-module(database).

-export([initDB/0, storeDB/2, getDB/1, getDB_2/1, vaciarNodo/1]).
-include_lib("stdlib/include/qlc.hrl").% para hacer consultas a la base de datos
-record(factorial ,{nodeName, comment, createdOn }).

initDB() ->
    mnesia:create_schema([node()]),
    mnesia:start(),
    try
        mnesia:table_info(type, factorial)
    catch
        exit: _ ->
            mnesia:create_table(factorial, [{attributes, record_info(fields, factorial)}, {type, bag}, {disc_copies, [node()]}])
        end.

storeDB(NodeName, Comment) ->
    AF = fun() ->
        {CreatedOn, _} = calendar:universal_time(), 
    mnesia:write(#factorial{nodeName=NodeName, comment=Comment, createdOn=CreatedOn })
    end, 
    mnesia:transaction(AF).
% storeDB(node(), "asdasd").

getDB(NodeName) ->
    AF = fun() ->
        Query = qlc:q([X||X <- mnesia:table(factorial), X#factorial.nodeName =:= NodeName]),
        Results = qlc:e(Query),
        lists:map(fun(Obj) -> Obj#factorial.comment end,Results)
    end,
    {atomic, Comments} = mnesia:transaction(AF), 
    Comments.
% getDB(node()).

getDB_2(NodeName) ->
    AF = fun() ->
        Query = qlc:q([X||X <- mnesia:table(factorial), X#factorial.nodeName =:= NodeName]),
        Results = qlc:e(Query),
        lists:map(fun(Obj) -> {Obj#factorial.comment, Obj#factorial.createdOn} end,Results)
    end,
    {atomic, Comments} = mnesia:transaction(AF), 
    Comments.

vaciarNodo(NodeName) ->
    AF = fun() ->
        Query = qlc:q([X||X <- mnesia:table(factorial), X#factorial.nodeName =:= NodeName]),
        Results = qlc:e(Query),
        Funcion = fun() ->
            lists:foreach(fun(Res) -> mnesia:delete_object(Res) end, Results)
        end,
        mnesia:transaction(Funcion)
    end,
    mnesia:transaction(AF).