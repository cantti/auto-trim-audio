function [ spectral_flatness ] = spectralFlatness( frame )
    per = periodogram(frame);
    spectral_flatness = var(per);
end

