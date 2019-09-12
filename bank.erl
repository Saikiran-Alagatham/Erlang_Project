%%%-------------------------------------------------------------------
%%% @author saikiranask
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 21. Jun 2019 13:36
%%%-------------------------------------------------------------------
-module(bank).
-export([start_bank/1]).

start_bank({Name, Money} = _Bank) ->
  io:format("Bank ~p init with ~p~n", [Name, Money]),
  bank_listen(Name, Money).

bank_listen(Name, Money) ->
  receive
    {loan_req, Pid, ReqMoney} ->
      ToBeBal = Money - ReqMoney,
      case ToBeBal of
        ToBeBal when ToBeBal < 0 ->
          Pid ! {loan_reject},
          io:format("Bank name: ~p and pid: ~p closing due to insufficient balance ~n", [Name, self()]),
          bank_listen(Name, Money);
        ToBeBal when ToBeBal >=0 ->
          io:format("Bank name: ~p approved loan for value: ~p and remaining balance ~p ~n", [Name, ReqMoney, ToBeBal]),
          Pid ! {loan_approved},
          bank_listen(Name, ToBeBal)
      end;
    AnyReq ->
      io:format("bank ~p received error ~p, remaining bal ~p ~n",[Name, AnyReq, Money])
  end.
