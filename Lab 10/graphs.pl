%A1B2
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

is_edge(X,Y):-
	edge(X,Y);
	edge(Y,X).
	
%A2B2
neighbor(a,[b,d,f]).
neighbor(b,[a,c,d]).
neighbor(c,[b,d]).
neighbor(d,[a,b,c]).
neighbor(e,[f,g]).
neighbor(f,[a,e]).
neighbor(g,[e]).

neighb_to_edge:-
	neighbor(Node,List),
	process(Node,List),
	fail.
neighb_to_edge.

process(Node,[H|T]):-
	assertz(edge(Node,H)),
	process(Node,T).
process(_,[]).

% path(Source,Target,Path)	
path(X,Y,Path):-
	path(X,Y,[X],Path).
path(X,Y,PPath,FPath):-
	is_edge(X,Z),
	\+(member(Z,PPath)),
	path(Z,Y,[Z|PPath],FPath).
path(X,X,PPath,PPath).

% restricted_path(Source, Target, RestrictionsList, Path)
% check_restrictions(RestrictionsList, Path)
restricted_path(X,Y,LR,P):-
	path(X,Y,P),
	check_restrictions(LR,P).