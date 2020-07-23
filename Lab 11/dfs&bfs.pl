edge(a,b).
edge(b,a).
edge(b,c).
edge(c,b).
edge(b,d).
edge(d,b).
edge(c,d).
edge(d,c).
edge(a,d).
edge(d,a).
edge(a,f).
edge(f,a).
edge(f,e).
edge(e,f).
edge(e,g).
egde(g,e).

/* DFS
 d_search(Start, Path) */
d_search(X,_):-
	df_search(X,_).
d_search(_,L):-
	collect_v([],L).
	
df_search(X,L):-
	asserta(vert(X)),
	edge(X,Y),
	\+vert(Y),
	df_search(Y,L).
	
collect_v(L,P):-
	retract(vert(X)), !,
	collect_v([X|L],P).
collect_v(L,L).

/* BFS
 do_bfs(Start,Path) */
do_bfs(X,Path):-
	assertz(q(X)),
	asserta(vert(X)),
	bfs(Path).
	
bfs(Path):-
	q(X), !,
	expand(X),
	bfs(Path).
bfs(Path):-
	collect_v([],Path).
	
expand(X):-
	edge(X,Y),
	\+(vert(Y)),
	asserta(vert(Y)),
	assertz(q(Y)),
	fail.
expand(X):-
	retract(q(X)), !.