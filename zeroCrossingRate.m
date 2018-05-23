function [ zcr ] = zeroCrossingRate( frame )
    zcr = sum(abs(diff(frame>0)));
end

