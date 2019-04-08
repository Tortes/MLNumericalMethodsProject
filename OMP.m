function alpha = OMP(B,C,K,lambda)

coefMatrix=C;
[L_c, W_c] = size(C);

alpha=zeros(K^2,1);
F = B;
theta = [];
a = zeros(1,K^2); 
for p=1:lambda
    % Find Ai with largest inner product
    index = 1;
    prod = 0;
    for n=1:K^2 % optimize later (dont iterate if it's been picked)
        a(n) = abs(F'*coefMatrix(:,n));
        if(a(n)>prod && (sum(theta==n)==0))
            prod=a(n);
            index=n;
        end
    end
    theta = [theta index];
    
    % solve for alpha using residuals
    % alpha(theta) = C(:,theta)\B;
    % alpha(theta) = pinv(C(:,theta).' * C(:,theta), 1e-4) * C(:,theta).' * B;
    alpha(theta) = lsqminnorm(C(:,theta), B); 

    % Calculating residue with Ai & ai
    F = B - C*alpha;
end
end