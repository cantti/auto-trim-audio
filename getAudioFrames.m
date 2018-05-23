function [ frames ] = getAudioFrames( audioMondo, fs, frameLenMs)
    frameLength = frameLenMs / 1000 * fs;
    framesCount = ceil(length(audioMondo) / frameLength);
    
    frames = zeros(framesCount, frameLength);    
    
    for iFrameNum = 1:framesCount
        startAtIdx = (iFrameNum - 1) * frameLength + 1;
         if iFrameNum ~= framesCount
             frames(iFrameNum,:) = audioMondo(startAtIdx:startAtIdx+frameLength-1);
         else
             frames(iFrameNum,1:length(audioMondo)-startAtIdx+1) = audioMondo(startAtIdx:end);
         end        
    end  
end

