function [ frameEnergy ] = shortTermEnergy( frame )
    frameEnergy = sum(frame.^2);
end

