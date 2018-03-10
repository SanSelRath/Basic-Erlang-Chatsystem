%%%-------------------------------------------------------------------
%%% @author Geethu
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 03. Dec 2016 2:04 PM
%%%-------------------------------------------------------------------
-module(worker).
-author("Geethu").

%% API
-export([chat/0,gchat/1]).

chat()->
  receive
    {state,State}->
      io:format("~n Message ~p ",[State]),
      chat();




    {onetoone,From,Message}->
      io:format("~nMessage from ~p: ~p~n",[From,Message]),
      From!{state,"sent"},
      chat();


      {group,Fromuser,Fromgroup,Message}->
       io:format("~nFrom group:~p and User ~p : ~p~n",[Fromgroup,Fromuser,Message]),
        Fromgroup!{acknowledment,Fromuser},
        chat()

  end.

gchat(List)->
  receive
    {list}->
      io:format("~nMembers in the group are :~p",[List]),
      gchat(List);
    {add,Pid}->
      List1=List ++ [Pid],
      gchat(List1);
    {remove,Pid}->
      List1=List -- [Pid],
      gchat(List1);

    {acknowledgment,From}->io:format("~nMessage received by ~p~n",[From]),
      gchat(List);

    {group,From,Message} ->
      [ User!{group,From,self(),Message} || User<-List , User=/=From ],
      gchat(List)


  end.
