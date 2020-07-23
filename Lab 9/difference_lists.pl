tree1(t(6, t(4, t(2, nil, nil), t(5, nil, nil)), t(9, t(7, nil, nil), nil))).
tree2(t(8, t(5, nil, t(7, nil, nil)), t(9, nil, t(11, nil, nil)))).
tree3(t(6,t(4,t(2,nil,nil,nil),nil,t(7,nil,nil,nil)),t(5,nil,nil,nil),t(9,nil,nil,t(3,nil,nil,nil)))).

/* Add an element at the end of a simple list */
add(X,[H|T],[H|R]):-
	add(X,T,R).
add(X,[],[X]).

/* Add an element at the end of a difference list */
add_diff(X,SL,EL,RS,RE):-
	RS = SL,
	EL = [X|RE].
	
/* Inorder traversel using regular list */
inorder(t(K,L,R),List):-
	inorder(L,ListL),
	inorder(R,ListR),
	append(ListL, [K|ListR],List).
inorder(nil,[]).

/* Inorder traversal using difference list 
 inorder_diff(tree node currently processing, start of the result list, end of the result list)
 
 when we reached the end of the tree we unify the beggining 
 and end of the partial result list – representing an empty list 
 as a difference list 
*/
% Explicit unifications
inorder_diff(nil,L,L). 
inorder_diff(t(K,L,R),SL,EL):- /* obtain the start and end of the lists for the left and right subtrees */
	inorder_diff(L,LSL,LEL),
	inorder_diff(R,RSL,REL),
	SL = LSL, /* the start of the result list is the start of the left subtree list */
	LEL = [K|RSL], /* insert the key between the end of the left subtree list and start of the right subtree list */
	EL = REL. /* the end of the result list is the end of the right subtree list */
	
% Implicit unifications
inorder_diff_imp(nil,L,L).
inorder_diff_imp(t(K,L,R),SL,EL):-
	inorder_diff_imp(L,SL,[K|T]),
	inorder_diff_imp(R,T,EL).
	
/* Ex 10.2: Preorder using difference lists */
preorder(t(K,L,R),List):-
	preorder(L,LL),
	preorder(R,LR),
	append([K|LL],LR,List).
preorder(nil,[]).
	
preorder_diff(nil,L,L).
preorder_diff(t(K,L,R),SL,EL):-
	preorder_diff(L,[SL|K],T),
	preorder_diff(R,T,EL).	
	
/* Ex 10.3: Postorder using difference lists */
postorder(t(K,L,R),List):-
	postorder(L,LL),
	postorder(R,LR),
	append(LL,LR,R1),
	append(R1,[K],List).
postorder(nil,[]).

postorder_diff(nil,L,L).
postorder_diff(t(K,L,R),SL,EL):-
	postorder_diff(L,SL,T),
	postorder_diff(R,T,[K|EL]).
	
/* preorder */
preorder(nil,L,L).
preorder(t(K,L,R),LS,LE):-
  preorder(L,LSL,LEL),
  preorder(R,LSR,LER),
  LS = [K|LSL],
  LEL = LSR,
  LE = LER. 

/* postorder */
postorder(nil,L,L).
postorder(t(K,L,R),LS,LE):-
  postorder(L,LSL,LEL),
  postorder(R,LSR,LER),
  LS = LSL,
  LEL = LSR,
  LER = [K|LE].

partition(H,[X|T],[X|Sm],Lg):-
	X < H, !,
	partition(H,T,Sm,Lg).
partition(H,[X|T],Sm,[X|Lg]):-
	partition(H,T,Sm,Lg).
partition(_,[],[],[]).

quicksort_diff([H|T],S,E):-
	partition(H,T,Sm,Lg),
	quicksort_diff(Sm,S,[H|L]),
	quicksort_diff(Lg,L,E).
quicksort_diff([],L,L).	

/* An example of memoisation with side effects is the following predicate
which computes the nth number in the fibonacci sequence */
fib(N,F):-
	memo_fib(N,F), !.
fib(N,F):-
	N > 1,
	N1 is N-1,
	N2 is N-2,
	fib(N1,F1),
	fib(N2,F2),
	F is F1 + F2,
	assertz(memo_fib(N,F)).
fib(0,1).
fib(1,1).

print_all:-
	memo_fib(N,F),
	write(N),
	write('-'),
	write(F),
	nl,
	fail.
print_all.

/* Permutations of the input list */
all_perm(L,_):-
	all_perm(L,L1),
	assertz(p(L1)),
	fail.
all_perm(_,R):-
	collect_perms(R).
	
collect_perms([L1|R]):-
	retract(p(L1)), !,
	collect_perms(R).
collect_perms([]).


/* Quiz exercises
Q 10.4.1: transforms an incomplete list into a difference list */
transform_incomp_diff(L,R,R):-
	var(L), !.
transform_incomp_diff([H|T],[H|SR],SE):-
	transform_incomp_diff(T,SR,SE).
	
transform_diff_incomp(L,_,_):-
	var(L), !.
transform_diff_incomp([H|SL],EL,[H|R]):-
	transform_diff_incomp(SL,EL,R).
	
/* Q 10.4.2: transforms a complete list into a difference list */
transform_comp_diff([],R,R).
transform_comp_diff([H|T],[H|SR],ER):-
	transform_comp_diff(T,SR,ER).
	
transform_diff_comp(L,_,[]):-
	var(L), !.
transform_diff_comp([H|SL],EL,[H|R]):-
	transform_diff_comp(SL,EL,R).
	
/* P 10.5.1: flattens a deep list using difference lists instead of
append. */
flatten([],R,R).
flatten([H|T],Start,End):-
	atomic(H), !,
	flatten(T,Start,End),
	Start = [H|End].
flatten([H|T],Start,End):-
	flatten(H,StartH,EndH),
	flatten(T,StartT,EndT),
	Start = StartH,
	EndH = StartT,
	End = EndT.
	
/* P 10.5.2: collects all even keys in a binary tree, using difference
lists */
collect_even(nil,Rez,Rez).
collect_even(t(K,nil,nil),Start,End):-
	0 is K mod 2, !,
	Start = [K|End].
collect_even(t(K,L,R),Start,End):-
	collect_even(L,StartL,EndL),
	collect_even(R,StartR,EndR),
	Start = StartL,
	EndL = StartR,
	End = EndR.
