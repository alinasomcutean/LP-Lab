member(X,[_|T]):-
	member(X,T).
member(X,[X|_]).

my_append([],L,L).
my_append([H|T],L,[H|R]):-
	my_append(T,L,R).

delete(X,[X|T],T).	
delete(X,[H|T],[H|R]):-
	delete(X,T,R).
delete(_,[],[]).

delete_all(X,[X|T],R):-
	delete_all(X,T,R).
delete_all(X,[H|T],[H|R]):-
	delete_all(X,T,R).
delete_all(_,[],[]).

append3([],[],L,L).
append3([],[H|T],L,[H|R]):-
	append3([],T,L,R).
append3([H|T],L1,L2,[H|R]):-
	append3(T,L1,L2,R).
	
addFirst(X,[],X).
addFirst(X,L,[X|L]).

addLast(X,Y,Z):-
	my_append(Y,[X],Z).

sum([],0).
sum([H|T],S):-
	sum(T,S1),
	S is H+S1.
	
separate_parity([],[],[]).
separate_parity([H|T],E,O):-
	0 is H mod 2,
	separate_parity(T,Ex,O),
	my_append([H],Ex,E).
separate_parity([H|T],E,O):-
	1 is H mod 2,
	separate_parity(T,E,Ox),
	my_append([H],Ox,O).
	
remove_duplicates([],[]).
remove_duplicates([H|T],R):-
	member(H,T),
	remove_duplicates(T,R).
remove_duplicates([H|T],[H|T1]):-
	remove_duplicates(T,T1).
	
replace_all(_,_,[],[]).
replace_all(X,Y,[X|T1],[Y|T2]):-
	replace_all(X,Y,T1,T2).
replace_all(X,Y,[H|T1],[H|T2]):-
	replace_all(X,Y,T1,T2).
	
drop([],_,[],_).
drop([_|T],N,X,1):-
	drop(T,N,X,N).
drop([H|T1],N,[H|T2],K):-
	K > 1,
	K1 is K - 1,
	drop(T1,N,T2,K1).
	
drop_k(L,K,R):-
	drop(L,K,R,K).