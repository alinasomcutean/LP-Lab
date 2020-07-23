% Permutation sort
perm_sort(L,R):-
	perm(L,R),
	is_ordered(R), !.
	
perm(L,[H|T]):-
	append(A,[H|T],L),
	append(A,T,L1),
	perm(L1,R).
perm([],[]).

is_ordered([_]).
is_ordered([H1,H2|T]):-
	H1 =< H2,
	is_ordered([H2|T]).
	
% Selection sort selecting the minimum
sel_sort(L,[M|R]):-
	min(L,M),
	delete1(M,L,L1),
	sel_sort(L1,R),
	write(R).
sel_sort([],[]).

min([H|T], M):-
	min(T, M), 
	H>=M, !.
min([H|_], H).

delete1(X, [X|T], T):-!.
delete1(X, [H|T], [H|R]):-
	delete1(X, T, R).
delete1(_, [], []).

delMin([],[]).
delMin(L,R):-
	min(L,M),
	delete1(M,L,R).
	
% Selection sort combining minim with delete
min_del([H|T], M, [H|R]) :-
    min_del(T, M, R),
    H > M, !.
min_del([H|T], H, T).

sel_sort2(L,[M|R]):-
	min_del(L,M,L1),
	sel_sort2(L1,R).
sel_sort2([],[]).
	
% Insertion sort
ins_sort([H|T],R):-
	ins_sort(T,R1),
	insert_ord(H,R1,R),
	write(R1).
ins_sort([],[]).

insert_ord(X,[H|T],[H|R]):-
	X > H, !,
	insert_ord(X,T,R).
insert_ord(X,T,[X|T]).

% Bubble sort
bubble_sort(L,R):-
	one_pass(L,R1,F),
	nonvar(F), !,
	bubble_sort(R1,R).
bubble_sort(L,L).

one_pass([H1,H2|T],[H2|R],F):-
	H1 > H2, !,
	F = 1,
	one_pass([H1|T],R,F).
one_pass([H1|T],[H1|R],F):-
	one_pass(T,R,F).
one_pass([],[],_).


% Quick sort
quick_sort([H|T],R):-
	partition(H,T,Sm,Lg),
	quick_sort(Sm,SmS),
	quick_sort(Lg,LgS),
	append(SmS,[H|LgS],R).
quick_sort([],[]).

partition(H,[X|T],[X|Sm],Lg):-
	X < H, !,
	partition(H,T,Sm,Lg).
partition(H,[X|T],Sm,[X|Lg]):-
	partition(H,T,Sm,Lg).
partition(_,[],[],[]).

% Merge sort
merge_sort(L,R):-
	split(L,L1,L2),
	merge_sort(L1,R1),
	merge_sort(L2,R2),
	merge(R1,R2,R).
merge_sort([H],[H]).
merge_sort([],[]).

split(L,L1,L2):-
	length(L,Len),
	Len > 1,
	K is Len/2,
	splitK(L,K,L1,L2).
	
splitK([H|T],K,[H|L1],L2):-
	K > 0, !,
	K1 is K - 1,
	splitK(T,K1,L1,L2).
splitK(T,_,[],T).

merge([H1|T1],[H2|T2],[H1|R]):-
	H1 < H2, !,
	merge(T1,[H2|T2],R).
merge([H1|T1],[H2|T2],[H2|R]):-
	merge([H1|T1],T2,R).
merge([],L,L).
merge(L,[],L).

% Quiz exercises 
/*
 Generating permutations extracting an element from the list
*/
perm1(L,[X|R]):-
	member(X,L),
	delete1(X,L,L1),
	perm1(L1,R).
perm1([],[]).

perm1_sort(L,R):-
	perm1(L,R),
	is_ordered(R), !.

/* 
 Selection sort selecting the maximum
 Quiz exercise 5.2
*/
sel_sort_max(L,[M|R]):-
	max(L,M),
	delete1(M,L,L1),
	sel_sort_max(L1,R),
	write(R).
sel_sort_max([],[]).

max([H|T], M):-
	max(T, M), 
	H=<M, !.
max([H|_], H).

/*
 Insertion sort using forward recursion
*/
ins_sort_fwd(L,R):-
	my_ins_sort(L,[],R).

my_ins_sort([H|T],Acc,R):-
	insert_ord(H,Acc,R1),
	my_ins_sort(T,R1,R).
my_ins_sort([],R,R).

%  Problems
/* Problem 1: sorting a list according to ASCII codes

 create a list with ASCII codes from a list with letters
*/ 
to_ascii([H|T],[C|R]):-
	char_code(H,C),
	to_ascii(T,R).
to_ascii([],[]).	
	
% transform the list with ascii codes into a list with letters
from_ascii([H|T],[C|R]):-
	char_code(C,H),
	from_ascii(T,R).
from_ascii([],[]).

/*
 This is the main function.
 initially, transforms the list of letters in a list with the corresponding ASCII codes
 Then, sorts the resulted list.
 Finally, the sorted list is converted back in letters.
*/
sort_chars(L,R):-
	to_ascii(L,R1),
	ins_sort_fwd(R1,R2),
	from_ascii(R2,R).
sort_chars([],[]).

/*
	Problem 2: sort a list containing other lists
	
	Function used to find the length of the list
*/
mylength([],0).
mylength([_|T], Len):-
	mylength(T,Len1), 
	Len is Len1+1.

% Classic insertion sort but using the length of the list
ins_sort_lists([H|T],R):-
	ins_sort_lists(T,R1),
	insert_ord_lists(H,R1,R).
ins_sort_lists([],[]).

insert_ord_lists(X,[H|T],[H|R]):-
	mylength(X,L1),
	mylength(H,L2),
	L1 > L2, !,
	insert_ord_lists(X,T,R).
insert_ord_lists(X,T,[X|T]).