function x = backsub (A, y);
%backsub: solves upper triangular ststems A*x = y using backwards
%substitution
%A(nxn) - upper triangular matrix
%y(nx1) - vector
%x(nx1) - solution to A*x = y

if any(any(tril(A, -1)))
	error('A must be upper triangular')
end

[n, m] = size(A);
 if n ~= m
	 error ('A must be a square');
 end
 
 %Performs back substitution
 x = zeros(n , 1);
 x(n) = y(n)/ A(n, n);
 for i = n-1: -1 : 1
	 x(i) = (y(i) - A(i, i+1: n)* x(i+1: n))/ A(i, i);
 end