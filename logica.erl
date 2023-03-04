-module(logica).

-export([factorial_handler/0]).

factorial(Int, Acc) when Int > 0 ->
  factorial(Int-1,Acc * Int);
factorial(0, Acc) ->
  Acc.

% Sobrecarga del Metodo
factorial(Int, Acc, IoDevice)
  when Int > 0 ->
  io:format(IoDevice, "Current Factorial Log: ~p~n",[Acc]),
  factorial(Int-1,Acc * Int,IoDevice);
factorial(0, Acc,IoDevice) ->
  io:format(IoDevice, "Factorial Results: ~p~n",[Acc]).


factorial_handler() ->
  receive
    {factorial, Int}->
      io:format("Factorial para ~p es ~p ~n",[Int, factorial(Int, 1)]),
      factorial_handler();

    {factorialRecorder, Int, File}->
      {ok, Archivo} = file:open(File, write),
      factorial(Int,1,Archivo),
      io:format("Factorial por escrito terminado. ~n",[]),
      file:close(Archivo),
      factorial_handler();
    Other->
      io:format("El codigo ~p no esta reconocido...~n" ,[Other]),
      factorial_handler()
  end.