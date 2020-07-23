tree1(t(6, t(4, t(2, nil, nil), t(5, nil, nil)), t(9, t(7, nil, nil), nil))).
tree2(t(8, t(5, nil, t(7, nil, nil)), t(9, nil, t(11, nil, nil)))).
tree3(t(6,t(4,t(2,nil,nil,nil),nil,t(7,nil,nil,nil)),t(5,nil,nil,nil),t(9,nil,nil,t(3,nil,nil,nil)))).

inorder(t(K,L,R),List):-
	inorder(L,LL),
	inorder(R,LR),
	append(LL,[K|LR],List).
inorder(nil,[]).

preorder(t(K,L,R),List):-
	preorder(L,LL),
	preorder(R,LR),
	append([K|LL],LR,List).
preorder(nil,[]).

postorder(t(K,L,R),List):-
	postorder(L,LL),
	postorder(R,LR),
	append(LL,LR,R1),
	append(R1,[K],List).
postorder(nil,[]).

% inorder traversal
pretty_print(nil,_).
pretty_print(t(K,L,R),D):-
	D1 is D+1,
	pretty_print(L,D1),
	print_key(K,D),
	pretty_print(R,D1).

% predicate which prints key K at D tabs from the screen left margin 
% and then proceeds to a new line
print_key(K,D):-
	D>0, !,
	D1 is D-1,
	write('\t'),
	print_key(K,D1).
print_key(K,_):-
	write(K),
	nl.
	
search_key(Key, t(Key, _, _)):-!.
search_key(Key, t(K,L,_)):-
	Key < K, !,
	search_key(Key, L).
search_key(Key, t(_,_,R)):-
	search_key(Key, R).
	
insert_key(Key, nil, t(Key,nil,nil)):-
	write('Inserted '),
	write(Key),
	nl.
insert_key(Key, t(Key,L,R), t(Key,L,R)):-!,
	write('Key already in tree\n').
insert_key(Key, t(K,L,R), t(K,NL,R)):-
	Key < K, !,
	insert_key(Key,L,NL).
insert_key(Key, t(K,L,R), t(K,L,NR)):-
	insert_key(Key, R, NR).
	
delete_key(Key, nil, nil):-
	write(Key),
	write('not in tree\n').
% this clause covers also case for leaf (L=nil)
delete_key(Key, t(Key,L,nil),L):-!.
delete_key(Key, t(Key,L,R),t(Pred,NL,R)):-
	!,
	get_pred(L,Pred,NL).
delete_key(Key, t(K,L,R),t(K,NL,R)):-
	Key < K, !,
	delete_key(Key,L,NL).
delete_key(Key, t(K,L,R), t(K,L,NR)):-
	delete_key(Key, R, NR).
	
get_pred(t(Pred,L,nil),Pred,L):-!.
get_pred(t(Key,L,R), Pred, t(Key,L,NR)):-
	get_pred(R,Pred,NR).
	
% predicate which computes the maximum between 2 numbers
max(A,B,A):-
	A > B, !.
max(_,B,B).

% predicate which computes the height of a binary tree
height(nil, -1).
height(t(_,L,R),H):-
	height(L,H1),
	height(R,H2),
	max(H1,H2,H3),
	H is H3 + 1.
	
% Exercise 8.7: pretty print for a ternary tree
pretty_print_ternary(nil,_).
pretty_print_ternary(t(K,L,M,R),D):-
	D1 is D+1,
	print_key_ternary(K,D),
	pretty_print_ternary(L,D1),
	pretty_print_ternary(M,D1),
	pretty_print_ternary(R,D1).
	
print_key_ternary(K,D):-
	D>0, !,
	D1 is D-1,
	write('\t'),
	print_key_ternary(K,D1).
print_key_ternary(K,_):-
	write(K),
	nl.
	
% Exercise 8.8: tree traversal operations for a ternary tree
inorder_ternary(t(K,L,M,R),List):-
	inorder_ternary(L,LL),
	inorder_ternary(M,LM),
	inorder_ternary(R,LR),
	append(LL,[K|LM],List1),
	append(List1,LR,List).
inorder_ternary(nil,[]).

preorder_ternary(t(K,L,M,R),List):-
	preorder_ternary(L,LL),
	preorder_ternary(M,LM),
	preorder_ternary(R,LR),
	append([K|LL],LM,List1),
	append(List1,LR,List).
preorder_ternary(nil,[]).

postorder_ternary(t(K,L,M,R),List):-
	postorder_ternary(L,LL),
	postorder_ternary(M,LM),
	postorder_ternary(R,LR),
	append(LL,LM,List1),
	append(List1,LR,List2),
	append(List2,[K],List).
postorder_ternary(nil,[]).

% Exercise 8.9: height of a ternary tree
max_three(A,B,C,R):-
	max(A,B,R1),
	max(R1,C,R).
	
height_ternary(nil, -1).
height_ternary(t(_,L,M,R),H):-
	height_ternary(L,H1),
	height_ternary(M,H2),
	height_ternary(R,H3),
	max_three(H1,H2,H3,H4),
	H is H4 + 1.
	
% P8.1: Diameter of a binary tree
diameter(nil, 1).
diameter(t(_,L,R),D):-
	height(L,H1),
	height(R,H2),
	diameter(L,D1),
	diameter(R,D2),
	D3 is H1 + H2 + 2,
	max_three(D1, D2, D3, D).