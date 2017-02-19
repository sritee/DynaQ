%Comparison of non planning and planning agents on maze task
%Code by sridhar.T
% 1 right,2 left,3 up,4 down.
% % Note:In this case we already have a model of the environment hence we
% will not be updating it, or learning it. If not the case, model can be
%backed up during the learning part and these state action parts can be
%queried during learning.allstates=zeros(6,9)
alpha=0.1;
epsilon=0.1; % exploration policy
num_iters=50;
gamma=0.95;
num_planstepsarray=[0,5,50]; % The 3 values which will be tried.
allstates=zeros(6,9);
num_step_taken=zeros(num_iters,3);

for k=1:3
    num_plansteps=num_planstepsarray(k);
   qvisit=zeros(54,4); % certain dummy qvalues corresponding to blocks wont be updated
   qvalues=zeros(54,4);
    
for hi=1:num_iters
    num_steps=0;
    qvisit=zeros(54,4);
    curstate=[3,1]; % initialize the current state to start state [3,1];
    
    while (1) %until terminal state
        num_steps=num_steps+1;
        %LEARNING 
        csi=sub2ind(size(allstates),curstate(1),curstate(2)); % convert state to index
        
        if(rand<0.9) % greedy action
        [~,action]=max(qvalues(csi,:));
        qvisit(csi,action)=1; % mark as visited state
        else
            temp=randperm(4); % exploring action
            action=temp(1);
            qvisit(csi,action)=1; % mark as visited state
        end
        
        [rew,nextstate,signal]=transition(curstate,action);
        nsi=sub2ind(size(allstates),nextstate(1),nextstate(2));
        
        if(signal==1) % we have now reached a terminal state
            qvalues(csi,action)=qvalues(csi,action)+ alpha*(rew- qvalues(csi,action));
             qvisit(csi,action)=1;
             
             
        temp=find(qvisit==1); % finds the state action pairs which have been visited.
            
        temp2=datasample(temp,num_plansteps); % Sample the linear index of the state,A pairs to which planning will be applied.
        
        %planning steps
        
         for j=1:num_plansteps
            [a,b]=ind2sub(size(qvalues),temp2(j));
            [r,c]=ind2sub(size(allstates),a);
            plancurstate=horzcat(r,c);
            pcsi=sub2ind(size(allstates),plancurstate(1),plancurstate(2)); 
            act=b;
            % previous action taken in S
            [rew,plannextstate]= transition(plancurstate,act);  % Find S' and the reward
            nsi=sub2ind(size(allstates),plannextstate(1),plannextstate(2));                                             
          qmaxnext= max(qvalues(nsi,:));                                
            qvalues(pcsi,act)= qvalues(pcsi,act) + alpha*(rew+ gamma*qmaxnext - qvalues(pcsi,act));
         end
             
             
            break; %actionvalues for terminal state is all zero.
        else
            
        qmaxnext=max(qvalues(nsi,:)); % This is the max over action for the next state(unless terminal)
        end 
        
        qvalues(csi,action)=qvalues(csi,action)+ alpha*(rew+ gamma*qmaxnext - qvalues(csi,action));% Qlearning update
        curstate=nextstate;
    
    
        temp=find(qvisit==1); % finds the state action pairs which have been visited.
            
        temp2=datasample(temp,num_plansteps); % Sample the linear index of the state,A pairs to which planning will be applied.
        
        %planning steps
        
         for j=1:num_plansteps
            [a,b]=ind2sub(size(qvalues),temp2(j));
            [r,c]=ind2sub(size(allstates),a);
            plancurstate=horzcat(r,c);
            pcsi=sub2ind(size(allstates),plancurstate(1),plancurstate(2)); 
            act=b;
            % previous action taken in S
            [rew,plannextstate]= transition(plancurstate,act);  % Find S' and the reward
            nsi=sub2ind(size(allstates),plannextstate(1),plannextstate(2));                                             
          qmaxnext= max(qvalues(nsi,:));                                
            qvalues(pcsi,act)= qvalues(pcsi,act) + alpha*(rew+ gamma*qmaxnext - qvalues(pcsi,act));
         end
    end
    fprintf('Agent Henry has solved the maze in %d steps \n',num_steps);
    num_step_taken(hi,k)=num_steps;
    
end
end

plot(2:num_iters,num_step_taken(2:end,1),'b');
hold on;
plot(2:num_iters,num_step_taken(2:end,2),'r');
plot(2:num_iters,num_step_taken(2:end,3),'k');
xlabel('Number of episodes elapsed'),ylabel('Steps per episode'),title('Agent on Maze task');
legend('Non planning agent','N=5','N=50');
hold off;

 

        

  

