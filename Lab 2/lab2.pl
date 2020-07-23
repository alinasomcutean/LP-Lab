gcd(X,X,X).
gcd(X,Y,Z):-
	X>Y,
	R is X-Y,
	gcd(R,Y,Z).
gcd(X,Y,Z):-
	X<Y,
	R is Y-X,
	gcd(X,R,Z).
	
fact(0,1).
fact(N,F):-
	N>0,
	N1 is N-1,
	fact(N1,F1),
	F is F1*N.
	
fact1(0,X,X).
fact1(N,Y,X):-
	N>0,
	N1 is N-1,
	Y1 is Y*N,
	fact1(N1,Y1,X).
	
fact1_pretty(N,F):-
	fact1(N,1,F).
	
forLoop(Start,Sum,0):-write(Start).
forLoop(Start,Sum,End):-
	NewStart is Start+End,
	NewEnd is End-1,
	forLoop(NewStart,Sum,NewEnd).
	
lcm(X,X,X).
lcm(0,_,_):-
	write(0).
lcm(_,0,_):-
	write(0).
lcm(X,Y,Z):-
	Product is X*Y,
	gcd(X,Y,Z1),
	R is div(Product,Z1),
	write(R).
	
fib(0,R):-
	R is 1.
fib(1,R):-
	R is 1.
fib(X,R):-
	X>1,
	X1 is X-1,
	X2 is X-2,
	fib(X1,R1),
	fib(X2,R2),
	R is R1+R2.
	
fib(X):-
	fib(X,R),
	write(R).
	
repeatUntil(Start,End):-
	NewStart is Start+1,
	writeln(NewStart),
	repeatUntil(NewStart,End).
	
whileLoop(Start,End):-
	NewStart is Start+1,
	NewEnd is End-1,
	NewStart<NewEnd,
	writeln(NewStart),
	whileLoop(NewStart,End).
	
triangle(A,B,C):-
	Sum1 is A+B,
	Sum1>=C,
	Sum2 is A+C,
	Sum2>=B,
	Sum3 is B+C,
	Sum3>=A.
	
delta(A,B,C,D):-
	D is B*B-4*A*C.
	
solveEq(A,B,C,X):-
	delta(A,B,C,D1),
	(D1 < 0 -> X is 0;
	D1 =:= 0 -> X is -B/2*A;
	X is -B-sqrt(D1)/2*A).