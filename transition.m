% Simulate the maze
function [reward,ns,signal]=transition(curs,action)
reward=0;
signal=0;
r=curs(1);
c=curs(2);

switch action
    case 1
        c=c+1; % move right
    case 2
        c=c-1; %move left
    case 3
        r=r-1; % move up
    case 4
        r=r+1; %move down
end
     ns=[r,c];
    if isequal([r,c],[1,9]) % reached goal state
        reward=1;
        signal=1;
        return;
    end
   
   % check if agent moves out of maze 
   if (c>9  || (c< 1 ) || r> 6 || r<1)
       ns=curs;
       return;
   end
   
   %check if it moves into obstacle
   if isequal(ns,[2,3]) ||isequal(ns, [3,3]) || isequal(ns, [4,3]) ||isequal(ns,[5,6]) || isequal(ns,[2,8])||isequal(ns,[3,8])||isequal(ns,[1,8])
       ns=curs;
   end 



