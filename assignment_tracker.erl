%%%-------------------------------------------------------------------
%%% @author 9486 - Team Erlang
%%% @copyright (C) 2025, IT311 Prelim Project
%%% @doc
%%%
%%% @end
%%% Created : 31. Aug 2025 9:18 PM
%%%-------------------------------------------------------------------
%% File: assignment_tracker.erl
%% Compile: c(assignment_tracker).
%% Run: assignment_tracker:start().

-module(assignment_tracker).
-export([start/0, menu/1, add_assignment/1, view_assignments/1, mark_done/2, remove_assignment/2]).

%% Entry point
start() ->
  io:format("~n=== Assignment & Deadline Tracker ===~n"),
  menu([]).

%% Main Menu (Set of functionalities)
menu(Assignments) ->
  io:format("~nChoose an option:~n"),
  io:format("1. Add Assignment~n"),
  io:format("2. View Assignments~n"),
  io:format("3. Mark Assignment as Done~n"),
  io:format("4. Remove Assignment~n"),
  io:format("5. Exit~n"),
  {ok, [Choice]} = io:fread("Enter choice: ", "~d"),
  case Choice of
    1 -> menu(add_assignment(Assignments));
    2 -> view_assignments(Assignments), menu(Assignments);
    3 ->
      {ok, [Index]} = io:fread("Enter assignment index to mark done: ", "~d"),
      menu(mark_done(Index, Assignments));
    4 ->
      {ok, [Index]} = io:fread("Enter assignment index to remove: ", "~d"),
      menu(remove_assignment(Index, Assignments));
    5 -> io:format("Exiting...~n"), ok;
    _ -> io:format("Invalid choice!~n"), menu(Assignments)
  end.

%% Add a new assignment
add_assignment(Assignments) ->
  {ok, [Subject]} = io:fread("Enter subject: ", "~s"),
  {ok, [Title]} = io:fread("Enter title: ", "~s"),
  {ok, [Deadline]} = io:fread("Enter deadline (YYYY-MM-DD): ", "~s"),
  New = {assignment, Subject, Title, Deadline, "pending"},
  io:format("Assignment added successfully!~n"),
  Assignments ++ [New].

%% View assignments
view_assignments([]) ->
  io:format("No assignments yet.~n");
view_assignments(Assignments) ->
  io:format("~n--- Assignment List ---~n"),
  lists:foreach(
    fun({assignment, Subject, Title, Deadline, Status}, Index) ->
      io:format("~p. [~s] ~s - Due: ~s - Status: ~s~n",
        [Index, Subject, Title, Deadline, Status])
    end,
    lists:zip(Assignments, lists:seq(1, length(Assignments)))
  ).

%% Mark assignment as done
mark_done(Index, Assignments) ->
  case lists:nth(Index, Assignments) of
    {assignment, S, T, D, _} ->
      New = {assignment, S, T, D, "done"},
      io:format("Assignment marked as done!~n"),
      lists:sublist(Assignments, Index-1) ++ [New] ++ lists:nthtail(Index, Assignments)
  end.

%% Remove assignment
remove_assignment(Index, Assignments) ->
  io:format("Assignment removed!~n"),
  lists:sublist(Assignments, Index-1) ++ lists:nthtail(Index, Assignments).

