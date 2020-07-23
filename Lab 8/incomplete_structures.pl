tree1(t(7, t(5, t(3, _, _), t(6, _, _)), t(11, _, _))).
tree2(t(7, t(5, t(3, _, _), _), t(11, _, _))).

% must test explicitly for the end of the list, and fail
member_il(_,L):-
	var(L), !,
	fail.
member_il(X,[X|_]):-!.
member_il(X,[_|T]):-
	member_il(X,T).
	
insert_il(X,L):- % found end of list, add element
	var(L), !,
	L=[X|_].
insert_il(X,[X|_]):-!. % found element, stop
insert_il(X,[_|T]):- % traverse input list to reach end
	insert_il(X,T).
	
delete_il(_,L,L):- % reached end, stop
	var(L), !. 
delete_il(X, [X|T], T):-!. % found element, remove it and stop
delete_il(X, [H|T], [H|R]):- % search for the element
	delete_il(X,T,R).
	
search_it(_, T):-
	var(T), !,
	fail.
search_it(Key, t(Key, _, _)):- !.
search_it(Key, t(K, Left, _)):-
	Key < K, !,
	search_it(Key, Left).
search_it(Key, t(_, _, Right)):-
	search_it(Key, Right).
	
insert_it(Key, t(Key, _, _)):-!.
insert_it(Key, t(K, Left, _)):-
	Key < K, !,
	insert_it(Key, Left).
insert_it(Key, t(_, _, Right)):-
	insert_it(Key, Right).
	
delete_it(Key, T, T):-
	var(T), !, 
	write(Key), 
	write(' not in tree\n').
delete_it(Key, t(Key, Left, Right), Left):-
	var(Right), !.
delete_it(Key, t(Key, Left, Right), Right):-
	var(Left), !.
delete_it(Key, t(Key, Left, Right), t(Pred, NL, Right)):-
	!,
	get_pred(Left, Pred, NL).
delete_it(Key, t(K, Left, Right), t(K, NL, Right)):-
	Key < K, !, 
	delete_it(Key, Left, NL).
delete_it(Key, t(K, Left, Right), t(K, Left, NR)):-
	delete_it(Key, Right, NR).
	
get_pred(t(Pred, Left, Right), Pred, Left):-
	var(Right), !.
get_pred(t(Key, Left, Right), Pred, t(Key, Left, NR)):-
	get_pred(Right, Pred, NR).
	
/* Q 9.1: Append 2 incomplete lists.
 I will iterate only through the first list, so no need to check the second list.
 When the end of the first list is met, append the second list to the first.
*/
append_il(L1,L2,L2):-
	var(L1), !.
append_il([H|T1],L2,[H|R]):-
	append_il(T1,L2,R).
	
/* Q 9.2: Reverse an incomplete list.
*/
reverse_il(L,L):-
	var(L), !.
reverse_il([H|T],R):-
	reverse_il(T,R1),
	append_il(R1,[H|_],R).
	
/* Q 9.3: Transform an incomplete list into a complete list
 When you found the end of the list, put empty list in the final list.
*/
transform(L,[]):-
	var(L), !.
transform([H|T],[H|R]):-
	transform(T,R).
	
/* Q 9.4: Performs a preorder traversal on an incomplete tree, 
and collects the keys in an incomplete list.
*/
preorder(X,_):-
	var(X), !.
preorder(t(K,L,R),List):-
	preorder(L,LL),
	preorder(R,LR),
	append_il([K|LL],LR,List).
	
/* Q 9.5: Computes the height of an incomplete binary tree.
*/
max(A,B,A):-
	A > B, !.
max(_,B,B).

height_incomp(X, -1):-
	var(X), !.
height_incomp(t(_,L,R),H):-
	height_incomp(L,H1),
	height_incomp(R,H2),
	max(H1,H2,H3),
	H is H3 + 1.
	
% Q 9.6: Transforms an incomplete tree into a complete tree
incomp_to_comp_tree(X,nil):-
	var(X), !.
incomp_to_comp_tree(t(K,L,R), t(K,LL,RR)):-
	incomp_to_comp_tree(L,LL),
	incomp_to_comp_tree(R,RR).
	
/* P9.1: Flatten an incomplete list */
flatten_il(X,_) :-
	var(X), !.
flatten_il([H|T], [H|R]) :-
	atomic(H), !,
	flatten_il(T,R).
flatten_il([H|T], R) :-
	flatten_il(H,R1),
	flatten_il(T,R2),
	append_il(R1, R2, R).
	
/* P9.2: Computes the diameter of a binary incomplete tree*/
max_three(A,B,C,R):-
	max(A,B,R1),
	max(R1,C,R).
	
diameter_incomp(X, 1):-
	var(X), !.
diameter_incomp(t(_,L,R),D):-
	height_incomp(L,H1),
	height_incomp(R,H2),
	diameter_incomp(L,D1),
	diameter_incomp(R,D2),
	D3 is H1 + H2 + 2,
	max_three(D1, D2, D3, D).

/* P9.3: Determine if an incomplete list is sub-list
in another incomplete list
*/
check(S,_) :-
	var(S), !.
check(_,L) :-
	var(L), !,
	fail.
check([H|T1],[H|T2]):-
	check(T1,T2).

sublist_il(S,_) :-
	var(S), !.
sublist_il([HS|TS],[HS|TL]):-
	check(TS,TL), !.
sublist_il([HS|TS],[_|TL]):-
	sublist_il([HS|TS],TL).