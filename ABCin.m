function [nhanhcat,Ploss,Bestpower]=ABCin(dscat,Udm,linedata,powerdata)
global logLevel
import logging.*
logger = Logger.getLogger('Chuongtrinhchinh');
logger.setLevel(logLevel);
logger.info('(Start)')

%he so vong lap 
h=0.2;
m=dscat==0;
dscat(m)=[];
format short G;
CostFunction=@(x) Sloss(x,Udm,powerdata,dscat,linedata);

k=1;
% Decision Variables Lower Bound  
VarMin=1; 

% Decision Variables Upper Bound
VarMax=length(dscat);

%%ABC Settings

% Maximum Number of Iterations
MaxIt=1+h*round(length(dscat));

% Population Size (Colony Size)
nPop=round(1*length(dscat));               

% Number of Onlooker Bees
nOnlooker=nPop;  

% Abandonment Limit Parameter (Trial Limit)
L=3; 
%%Initialization

%Empty Bee Structure
empty_bee.Position=[];
empty_bee.Cost=[];

% Initialize Population Array
pop=repmat(empty_bee,nPop,1);

% Initialize Best Solution Ever Found
BestSol.Cost.ploss=inf;
BestSol.Cost.power=0;

BestSol.Position=inf;
Ploss=inf;
nhanhcat=[];

% Create Initial Population
for i=1:nPop
    p=randperm(VarMax,1);
    pop(i).Position=dscat(p);
    [pop(i).Cost.ploss,pop(i).Cost.power]=CostFunction(pop(i).Position);
    if real(pop(i).Cost.ploss)<=real(BestSol.Cost.ploss)
       BestSol=pop(i);
    end
end

% Abandonment Counter
C=zeros(nPop,1);

% Array to Hold Best Cost Values
Bestpower=[];
%%ABC Main Loop

for it=1:MaxIt
    
    % Recruited Bees
    for i=1:nPop
        E=1;
        while E==1
              K=-k:k;
              phi=K(randperm(numel(K),1));
        
              % New Bee Position
              if i+phi>=VarMin && i+phi<=VarMax
                 E=0;
              end
        end
        newbee.Position=dscat(i+phi);
        
        % Evaluation
        [newbee.Cost.ploss,newbee.Cost.power]=CostFunction(newbee.Position);
 
        % Comparision
        if real(newbee.Cost.ploss)<=real(pop(i).Cost.ploss)
            pop(i)=newbee;
        else
            C(i)=C(i)+1;
        end
        
    end
    
    % Calculate Fitness Values and Selection Probabilities
    F=zeros(nPop,1);
    for i=1:nPop
        if pop(i).Cost.ploss>=0
           F(i)=1/(1+real(pop(i).Cost.ploss));
        else
           F(i)=1+abs(real(pop(i).Cost.ploss));
        end
    end
    P=F/sum(F);
    
    % Onlooker Bees
    for m=1:nOnlooker
        i=randperm(numel(P),1);
        E=1;
        while E==1
              % Define Acceleration Coeff.
              K=-k:k;
              phi=K(randperm(numel(K),1));
        
              % New Bee Position
             
              if i+phi>=VarMin && i+phi<=VarMax
                 E=0;
              end
        end
        newbee.Position=dscat(i+phi);
        % Evaluation
        [newbee.Cost.ploss,newbee.Cost.power]=CostFunction(newbee.Position);

        % Comparision
        if real(newbee.Cost.ploss)<=real(pop(i).Cost.ploss)
            pop(i)=newbee;
        else
            C(i)=C(i)+1;
        end
        
    end
    
    % Scout Bees
    for i=1:nPop
        if C(i)>=L
           p=randperm(VarMax,1);
           pop(i).Position=dscat(p);
           [pop(i).Cost.ploss,pop(i).Cost.power]=CostFunction(pop(i).Position);

        end
    end
    
    % Update Best Solution Ever Found
    for i = 1:nPop
        if real(pop(i).Cost.ploss) <= real(BestSol.Cost.ploss)
           BestSol = pop(i);
        end
    end
    
    if  real(BestSol.Cost.ploss) < Ploss
        Ploss=real(BestSol.Cost.ploss);
        Bestpower=BestSol.Cost.power;
        nhanhcat=BestSol.Position;
        logger.fine(['vong lap vong doc lap ' num2str(it) ]);
        logger.info(['No.' num2str(it) ' (Success): Ploss = ' num2str(Ploss) ' kW' '; nhanh cat = ' num2str(nhanhcat) '; (giai phap duoc chon)']);
    else
        logger.info(['No.' num2str(it) ' (Fail): Ploss = ' num2str(Ploss) ' kW' '; nhanh cat = ' num2str(BestSol.Position) ';']);
    end
end
logger.info('(Success)')
end



function i=RouletteWheelSelection(P)

    r=rand;
    C=cumsum(P);
    i=find(r<=C,1,'first');

end