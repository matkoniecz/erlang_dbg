-module(ping).
-export([start/0, stop/0, play/1, ping/0, pong/0]).

ping() ->
	receive
		0 ->
			pong ! kill;
			stop();
		kill ->
			stop();
		Number ->
			%io:format("ping ~w~n", [Number]),
			pong ! Number-1,
			ping()
		after
			20000 -> ok
	end.

pong() ->
	receive
		0 ->
			ping ! kill;
			stop();
		kill ->
			stop();
		Number ->
			%io:format("pong ~w~n", [Number]),
			ping ! Number-1,
			pong()
		after
			20000 -> ok
	end.

play(Number) ->
	ping ! Number.
	
stop() -> ok.

start() ->
	register(ping, spawn(ping, ping, [])),
	register(pong, spawn(ping, pong, [])).

