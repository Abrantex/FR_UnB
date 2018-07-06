function [ new_state ] = getProNoise( statenr, sigProcess )
%GETPRONOISE Add process noise to state
%   state = getProNoise(state,standart_dev)
%
%   where state is a matrix with 6xN and sigProcess 6x1 


N = length(statenr);

for i = 1:6
    wProcess(i,:) = sigProcess(i,1)*randn(1,N);
end



new_state = statenr + wProcess;


end

