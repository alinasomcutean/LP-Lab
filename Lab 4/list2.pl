member1(X,[X|_]):-!.
member1(X,[_|T]):-
	member1(X,T).
	
delete1(X, [X|T], T):-!.
delete1(X, [H|T], [H|R]):-
	delete1(X, T, R).
delete1(_, [], []).

% backward approach
mylength([],0).
mylength([_|T], Len):-
	mylength(T,Len1), 
	Len is Len1+1.
	
% forward approach
length_fwd([], Acc, Res):-
	Res = Acc.
length_fwd([_|T], Acc, Res):-
	Acc1 is Acc+1, 
	length_fwd(T, Acc1, Res).
	
length_fwd_pretty(L, Len):-
	length_fwd(L, 0, Len).
	
% backward approach
reverse([], []).
reverse([H|T], Res):-
	reverse(T, R1), 
	append(R1, [H], Res).
	
% forward approach
reverse_fwd([], R, R).
reverse_fwd([H|T], Acc, R):-
	reverse_fwd(T, [H|Acc], R).
	
reverse_fwd_pretty(L, R):- 
	reverse_fwd(L, [], R).
	
% forward approach
minimum([], M, M).
minimum([H|T], MP, M):-
	H<MP, !, 
	minimum(T, H, M).
minimum([_|T], MP, M):-
	minimum(T, MP, M).
	
minimum_pretty([H|T], R):-
	minimum([H|T], H, R).
	
% backward approach
minimum_bwd([H|T], M):-
	minimum_bwd(T, M), 
	H>=M, !.
minimum_bwd([H|_], H).

maximum_bwd([H|T], M):-
	maximum_bwd(T, M), 
	H=<M, !.
maximum_bwd([H|_], H).

myunion([],L,L).
myunion([H|T],L2,R) :- 
	member(H,L2),!,
	myunion(T,L2,R).
myunion([H|T],L,[H|R]):-
	myunion(T,L,R).
	
inters([],_,[]).
inters([H|T],L2,R):-
	member(H,L2), !,
	R = [H|RT],
	inters(T,L2,RT).
inters([_|T],L2,R):-
	inters(T,L2,R).
	
diff([HA|TA],B,R):-
	member(HA,B),!,
	diff(TA,B,R).
diff([HA|TA],B,[HA|R]):-
	diff(TA,B,R).
diff([],_,[]).

% First, search the min from the list, then delete it.
delMin([],[]).
delMin(L,R):-
	minimum_bwd(L,M),
	delete1(M,L,R).
	
% First, search the max from the list, then delete it.
delMax([],[]).
delMax(L,R):-
	maximum_bwd(L,M),
	delete1(M,L,R).

/* Reverse the elements of a list from K element
 The first K elements, put it in the final result.
 When N1=K, then reverse the remaining list from position K to the end.
 Function referseFromK_pretty is used for the user to give only 3 arguments, as it should be.*/
reverseFromK([H|T],K,N,[H|R]) :-
	N1 is N+1,
	reverseFromK(T,K,N1,R).
reverseFromK(T,K,K,R) :-
	reverse_fwd_pretty(T,R).	
	
reverseFromK_pretty(L,K,R) :-
	reverseFromK(L,K,0,R).

/* Run-length encoding (pack consecutive duplicates of an elemenet)
 While the first element is repeated, count.
 Otherwise, reset counting.*/
rle([H|T],H,Count,R):- 
	!,
	Count1 is Count + 1,
	rle(T,H,Count1,R).
rle([H|T],X,Count,[[X,Count]|R]):- 
	rle(T,H,1,R).
rle([],X,Count,[[X,Count]]).

rle_pretty([], []).
rle_pretty([H|T], R) :-
	rle(T, H, 1, R).
	

/* Split a list into 2 parts
 The first K elements are put in R1 and the elements from K position until the end are placed in R2.*/
split(L,0,[],L).
split([H|T],K,[H|R1],R2):-
	K > 0,
	K1 is K - 1,
	split(T,K1,R1,R2).
	
/* Rotate a list K positions to the right
 First split the list after K.
 Then the second result given by split must be add to the first result.*/
rotate_right([],_,[]).
rotate_right(L,0,L).
rotate_right(L,K,R):-
	length_fwd_pretty(L,K1),
	split(L,K1 - K,L1,L2),
	append(L2,L1,R).
	
% extract k random elements from a list and place them in another list
randomList_pretty([],[]).
randomList_pretty(L,K,R):-
	length_fwd_pretty(L,Len),
	random(1,Len,X).
	randomList(L,X,R).

randomList([H|T],K,[H|R],0).
randomList([H|T],K,R,K):-
	K1 is K - 1,
	randomList(T,K,R,K1).
