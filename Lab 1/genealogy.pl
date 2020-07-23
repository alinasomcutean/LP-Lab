woman(ana).
woman(sara).
woman(ema).
woman(maria).
woman(carmen).
woman(dorina).
woman(irina).

man(andrei).
man(george).
man(alex).
man(marius).
man(mihai).
man(sergiu).

parent(maria,ana).%maria is ana's parent
parent(george,ana).
parent(maria,andrei).
parent(george,andrei).
parent(carmen,sara).
parent(carmen,ema).
parent(alex,sara).
parent(alex,ema).
parent(marius,maria).
parent(dorina,maria).
parent(mihai,george).
parent(mihai,carmen).
parent(irina,george).
parent(irina,carmen).

% X is Y's mother if X is a woman and X is the parent of Y
mother(X,Y):-
    woman(X),
    parent(X,Y).

% X is Y's father is X is a man and X is the parent of Y
father(X,Y):-
    man(X),
    parent(X,Y).

% X and Y are siblings if they have a common parent, and they are
% different
sibling(X,Y):-
    parent(Z,X),
    parent(Z,Y),
    X\=Y.

% X is Y’s sister if X is a woman and X and Y are siblings
sister(X,Y):-
    sibling(X,Y),
    woman(X).

% X is Y's aunt if she is the sister of Z, who is a parent for Y
aunt(X,Y):-
    sister(X,Z),
    parent(Z,Y).

brother(X,Y):-
    sibling(X,Y),
    man(X).

uncle(X,Y):-
    brother(X,Z),
    parent(Z,Y).

grandmother(X,Y):-
    parent(X,Z),
    parent(Z,Y),
    woman(X).

grandfather(X,Y):-
    parent(X,Z),
    parent(Z,Y),
    man(X).

ancestor(X,Y):-
    parent(X,Z),
    ancestor(Z,Y).
ancestor(X,Y):-
    uncle(X,Z),
    ancestor(Z,Y).
ancestor(X,Y):-
    aunt(X,Z),
    ancestor(Z,Y).
ancestor(X,Y):-
    parent(X,Y).
