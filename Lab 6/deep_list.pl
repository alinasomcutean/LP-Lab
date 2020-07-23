my_append([],L,L).
my_append([H|T],L,[H|R]):-
	my_append(T,L,R).
	
my_delete(X, [X|T], T):-!.
my_delete(X, [H|T], [H|R]):-
	my_delete(X, T, R).
my_delete(_, [], []).

maxim(X,Y,R):-
	X>Y,
	R is X.
maxim(X,Y,R):-
	R is Y.

% calculate the depth of the list
depth([],1).
depth([H|T],R):-
	atomic(H), !,
	depth(T,R).
depth([H|T],R):-
	depth(H,R1),
	depth(T,R2),
	R3 is R1 + 1,
	maxim(R3,R2,R).
	
% flatten a deep list
flatten([],[]).
flatten([H|T],[H|R]):-
	atomic(H), !,
	flatten(T,R).
flatten([H|T],R):-
	flatten(H,R1),
	flatten(T,R2),
	my_append(R1,R2,R).
	
% shows atomic elements which are at the head of a shallow list
heads([],[],_).
heads([H|T],[H|R],1):-
	atomic(H), !,
	heads(T,R,0).
heads([H|T],R,0):-
	atomic(H), !,
	heads(T,R,0).
heads([H|T],R,_):-
	heads(H,R1,1),
	heads(T,R2,0),
	append(R1,R2,R).
heads_pretty(L,R):-
	heads(L,R,1).

% a simple member for deep list	
member1(H,[H|_]).
member1(X,[H|_]):-
	member1(X,H).
member1(X,[_|T]):-
	member1(X,T).

% finds only atomic elements	
member2(X,L):-
	flatten(L,L1),
	member(X,L1).
	
% Quiz exercises
/* 7.3.1 Predicare which computes the number of atomic elements from a list
 If the head of the list is an atom, count it. 
 Otherwise find the number of elements in head list.
 Continue do the same thing for the tail.
*/
atomic_elem([H|T],N):-
	atomic(H), !,
	atomic_elem(T,N1),
	N is N1 + 1.
atomic_elem([H|T],N):-
	atomic_elem(H,N1),
	atomic_elem(T,N2),
	N is N1 + N2.
atomic_elem([],0).

/* 7.3.2 Compute the sum of atomic elements from a deep list
 If the head of the list is an atom, add it to the sum. 
 Otherwise, compute the sum of the head list and add it to the final sum.
 Continue do the same thing for the tail.
*/
sum_atomic_elem([H|T],S):-
	atomic(H), !,
	sum_atomic_elem(T,S1),
	S is S1 + H.
sum_atomic_elem([H|T],S):-
	sum_atomic_elem(H,S1),
	sum_atomic_elem(T,S2),
	S is S1 + S2.
sum_atomic_elem([],0).

/* 7.3.3 Deterministic version of the member predicate
*/
member_det(X,[X|_]):-!.
member_det(X,[_|T]):-
	member_det(X,T).

% Moodle quiz
d(X,[X|T],R):-
	d(X,T,R).
d(X,[H|T],[H|R]):-
	d(X,T,R).
d(_,[],[]).

d1(X,[X|T],T).
d1(X,[H|T],[H|R]):-
	d1(X,T,R).
	
% Problems
/* 7.4.1 Atomic elements from a deep lists, which are at the end of a shallow list
 If the head of the list is an atom, continue searching in the tail.
 Otherwise, look in the head list and continue with the tail list.
 In the end, append all the elements from the end of a shallow list.
*/
getLastAtomic([H|T],R):-
	atomic(H), !,
	getLastAtomic(T,R1),
	append(R1,[H],R).
getLastAtomic([H|T],R):-
	getLastAtomic(H,R1),
	getLastAtomic(T,R2),
	append(R2,[R1],R).
getLastAtomic([],[]).

getLast(L,R):-
	getLastAtomic(L,R1),
	heads(R1,R2,1),
	getLastAtomic(R2,R).
	
/* 7.4.2. Replace an element, list, deep list in a deep list with another expression.
 If the element which you want to replace is the same with the new element, final list is the same.
 If head of the list is the searching element, the put the new one in the final list.
 Otherwise, if the head of the list is an atom, go search in the tail.
 If not, search in the head list and in the tail.
*/
replace(K,K,L,L).
replace(X,K,[X|T],[K|R]):-
	!,
	replace(X,K,T,R).
replace(X,K,[H|T],[H|R]):-
	atomic(H), !,
	replace(X,K,T,R).
replace(X,K,[H1|T],[H2|R]):-
	replace(X,K,H1,H2),
	replace(X,K,T,R).
replace(_,_,[],[]).

/* 7.4.3. Order elements of a deep list by depth
 First you have to find which is the smaller depth between 2 elements.
 Then you compute the resulting list, by inserting each element in the right position.
*/
smaller_depth(X,Y):-
	depth(X,D1),
	depth(Y,D2),
	D1 < D2, !.
smaller_depth(X,Y):-
	depth(X,D1),
	depth(Y,D2),
	D1 > D2, !,
	fail.
smaller_depth(X,Y):-
	atomic(X),
	atomic(Y), !.
smaller_depth([H|TX],[H|TY]):-
	!,
	smaller_depth(TX,TY).
smaller_depth([HX|_],[HY|_]):-
	smaller_depth(HX,HY).
	
insert_ord(X,[H|T],[H|R]):-
	smaller_depth(H,X), !,
	insert_ord(X,T,R).
insert_ord(X,T,[X|T]).

sort_list([H|T],R):-
	sort_list(T,R1),
	insert_ord(H,R1,R).
sort_list([],[]).