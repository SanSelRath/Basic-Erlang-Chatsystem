%%%-------------------------------------------------------------------
%%% @author Geethu
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 02. Dec 2016 6:50 PM
%%%-------------------------------------------------------------------
-module(manager).
-author("Geethu").

-export([start/0,create/2,loop/0,group/1,addgroupmem/2,removegroupmem/2,listmem/1]).

start()->spawn(manager,loop,[]).


group(List)->spawn(worker,gchat,[ List ]).

addgroupmem(Pid,Workerid)->Pid!{add,Workerid}.
removegroupmem(Pid,Workerid)->Pid!{remove,Workerid}.
listmem(Pid)->Pid!{list}.

create(Pid,Name)->
     Pid!{ self() , startA ,Name},
     receive
     Resp -> Resp
end.

worker()->spawn(worker,chat,[]).


loop()->
  receive
    {Frompid,startA,Name} -> io:format("~n Worker created"),
      Wid=worker(),
      register(Name,Wid),
      Frompid!Wid,
    loop()
  end.
