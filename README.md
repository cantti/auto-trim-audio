# ExaminatorVAD

The prototype of the component that sets the start and end marks of the response in the audio wave

Main method: [iStart iEnd] = analyzeAudio(audioFilePath, 10). The method accepts the path to the file and the size of the frame. Returns the number of the first sample of the first active frame - the beginning of the voice activity, and the number of the last sample of the last active frame - the end of the voice activity.
