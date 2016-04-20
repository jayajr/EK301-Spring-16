%-----------------------------------------------------------%
%--------------------In Mechanics We Truss------------------%
%-----------------------------------------------------------%

fprintf('EK 301, Section A1, In Mechanics We Truss, 4/5/2016\n');
fprintf('Jessica Alberto, ID U54547230\n')
fprintf('Jerome Andaya Jr, ID U41337769\n')
fprintf('Samantha Marfoglio, ID U19404039\n\n')

%-----------------------------------------------------------%
%-------------------------File Input------------------------%
%-----------------------------------------------------------%

dataIn = input ('Enter .mat file name: ', 's');

load(dataIn);

%-----------------------------------------------------------%
%---------------------------Calculations--------------------%
%-----------------------------------------------------------%

[row,col] = size(C);
Ct = C';

Axt = zeros(col, row);
Ayt = zeros(col, row);

for i = 1:length(Y)
    Y(i) = Y(i) + 6.3345;
end

for i = 1:length(X)
    X(i) = X(i) + 6.3345;
end

Len = 0;												%Length of straw

for i = 1:col                                           %column of Ct
    for j = 1:row                                       %row of Ct
        Axt(i, j) = X(j)*Ct(i,j);                       %input in reverse order to transpose
        Ayt(i, j) = Y(j)*Ct(i,j);
    end
end

negx = zeros(col,row);
negy = zeros(col,row);

%address placeholders
p = 0;
q = 0;
m = 0;
n = 0;

%X switch values
for i = 1:col
    for j = 1:row
        if Axt(i,j) ~= 0 && p == 0
            p = j;
            continue
        end
        
        if Axt(i, j) ~= 0 && p ~= 0
            q = j;
        end
        
        if p ~= 0 && q ~= 0
            negx(i, q) = Axt(i, p);
            negx(i, p) = Axt(i, q);
            
            p = 0;
            q = 0;
        end
    end
end

%Y switch values
for i = 1:col
    for j = 1:row
        if Ayt(i,j) ~= 0 && m == 0
            m = j;
            continue
        end
        
        if Ayt(i, j) ~= 0 && m ~= 0
            n = j;
        end
        
        if m ~= 0 && n ~= 0
            negy(i, n) = Ayt(i, m);
            negy(i, m) = Ayt(i, n);
            
            n = 0;
            m = 0;
        end
    end
end

Ax = zeros(col, row);
Ay = zeros(col, row);

for i = 1:col
    for j = 1:row
        if sqrt(((negx(i,j) - Axt(i,j))^2) + ((negy(i,j)-Ayt(i,j))^2)) ~= 0
            Ax(i, j) = ((negx(i,j) - Axt(i,j))/sqrt(((negx(i,j) - Axt(i,j))^2) + ((negy(i,j)-Ayt(i,j))^2)));
            Ay(i, j) = ((negy(i,j) - Ayt(i,j))/sqrt(((negx(i,j) - Axt(i,j))^2) + ((negy(i,j)-Ayt(i,j))^2)));
            
            dLen = sqrt(((negx(i,j)-Axt(i,j))^2)+((negy(i,j)-Ayt(i,j))^2))/2;
            Len = Len + dLen;										%Keeps track of straw length
        end
    end
end

Ax = Ax';
Ay = Ay';

A = [Ax, Sx; Ay, Sy];
Ainv = pinv(A);
T = Ainv*L;

findL = L(find(L));
cost = 10*j + Len;

%-----------------------------------------------------------%
%--------------------------Output---------------------------%
%-----------------------------------------------------------%

fprintf('Load: %.3f N\n',findL)
fprintf('Member Forces in Newtons\n')

TLength = length(T);

for k = 1:TLength - 3
    tension = T(k);
    if tension > 0
        fprintf('Member %d: %.3f N (T)\n', k, tension)
    elseif tension == 0
        fprintf('Member %d: 0.000 N\n', k)
    elseif tension < 0
    	negtension = tension*-1;
        fprintf('Member %d: %.3f N (C)\n', k, negtension)
    end
end

fprintf('\nReaction Forces in Newtons\n')

RFSx1 = T(TLength - 2);
fprintf('Sx1: %.2f\n', RFSx1)

RFSy1 = T(TLength - 1);
fprintf('Sy1: %.2f\n', RFSy1)

RFSy2 = T(TLength);

fprintf('Sy2: %.2f\n', RFSy2)
fprintf('Cost of truss: $%.2f\n', cost);

loadtocost = findL/cost;
fprintf('Theoretical max load/cost ratio in N/$: %.4f\n\n', loadtocost)

for i = 1:col
    for j = 1:row
        mLen(i,j) = sqrt(((negx(i,j)-Axt(i,j))^2)+((negy(i,j)-Ayt(i,j))^2));
    end
end