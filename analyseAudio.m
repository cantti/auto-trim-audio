function [ startFrame, endFrame] = analyseAudio( filePath, frameLenMs )
    % parametrs
    silenceFramesCount = 100;
    k = 20;  
    
    [audio, fs] = audioread(filePath);
    
    % convert to mono
    if size(audio) > 2
        audioMono = sum(audio, 2);
        audioMono = audioMono / 2;
    else
        audioMono = audio;
    end
    
    frames = getAudioFrames(audioMono, fs, frameLenMs);
    
    [framesCount, ~] = size(frames);
     
    % вычисление начального treshEnergy и treshSF
    silenceEnergy = zeros(1, silenceFramesCount);
    silenceSF = zeros(1, silenceFramesCount); 
    for iFrame = 1:silenceFramesCount
        silenceEnergy(iFrame) = shortTermEnergy(frames(iFrame, :));
        silenceSF(iFrame) = spectralFlatness(frames(iFrame, :));
    end
    treshEnergy = mean(silenceEnergy);
    treshSF = mean(silenceSF);
    
    voiceFramesMask = zeros(1, framesCount);
    
    for iFrame = silenceFramesCount+1:framesCount
           
        energy = shortTermEnergy(frames(iFrame, :));
        SF = spectralFlatness(frames(iFrame, :));
        ZCR = zeroCrossingRate(frames(iFrame, :));
        
        isVoice = 0;
        
        % основное условие
        if energy > k * treshEnergy      
            isVoice = 1;        
        end
        
        % дополнительное условие для тех фреймов, которая не были признаны
        % голосом
        if isVoice == 0 && ZCR >= 5 && ZCR <= 15 && SF > treshSF
            isVoice = 1;
        end 
        
        if (isVoice)
            voiceFramesMask(iFrame) = 1;
        else
            voiceFramesMask(iFrame) = 0;
            
            % calculate new energy tresh
            varOld = var(silenceEnergy);
            silenceEnergy = [silenceEnergy(2:end) energy];
            varNew = var(silenceEnergy);
            varRatio = varNew/varOld;  

            if varRatio >= 1.25
                    p = 0.25;
            elseif varRatio >= 1.10 && varRatio <= 1.25
                    p = 0.20;
            elseif varRatio >= 1 && varRatio <= 1.10
                    p = 0.15;
            elseif varRatio < 1
                    p = 0.10;
            end
                                   
            treshEnergy = (1-p)*treshEnergy + p*energy;
            treshSF = (1-p)*treshSF + p*SF;
        end
    end
   
    %drop short voice areas
    voiceFramesMaskFilterd = dropShortSequenceByValue(voiceFramesMask, 1, 20);
    
    startFrame = find(voiceFramesMaskFilterd, 1, 'first') - 1;
    endFrame = find(voiceFramesMaskFilterd, 1, 'last') - 1;
    
    % convert frame number to actual frame
    startFrame = startFrame * length(frames(1,:));
    endFrame = endFrame * length(frames(1,:));
        
    % алгоритм не нашел голос
    if length(startFrame) == 0
        startFrame = 0;
    end    
    if length(endFrame) == 0
        endFrame = 0;
    end      
end

function [ frames] = dropShortSequenceByValue( frames, val, tresh )
    start = 0;
    slength = 0;
    for iFrame = 1:length(frames)
        if frames(iFrame) == val
            if start == 0
                start = iFrame;
            end
            slength = slength + 1;
        else
            if start > 0 && slength < tresh
                frames(start:start+slength) = ~val;
            end
            start = 0;
            slength = 0;
        end
    end    
end