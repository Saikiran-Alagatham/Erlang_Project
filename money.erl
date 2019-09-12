%%%-------------------------------------------------------------------
%%% @author saikiranask
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. Jun 2019 13:34
%%%-------------------------------------------------------------------
-module(money).
-export([start/0]).

start() ->
  case file:consult("banks.txt") of
    {ok, Banks} ->
      BankInfos = [{erlang:spawn(fun() -> bank:start_bank(B) end), element(1, B)}||B<-Banks],
      case file:consult("customers.txt") of
        {ok, Custs} ->
          [erlang:spawn(fun() -> customer:start_customer(Cust, BankInfos) end)||Cust <- Custs], ok;
        {error, R} ->
          io:format("customers read error ~p", [R])
      end;
    {error, R} ->
      io:format("banks read error ~p", [R])
  end.

