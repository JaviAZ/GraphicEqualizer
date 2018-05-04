function [y, Fs, player, currTime, file, colour, text] = LoadAudio(y, Fs)
    [file, path] = uigetfile(fullfile(pwd,'Audio_Files','*.wav;*.wave;*.flac;*.mp3;*.m4a;*.mp4;*.3gp;*.m4b;*.m4p;*.m4r;*.m4v;*.aac'));
    fileAddress = strcat(path, file);
    player = 0;
    currTime = 1;
    try
        [y, Fs] = audioread(fileAddress);
    catch
        colour = [1,0,0];
        text = 'File input is not compatible';
        return;
    end
    y = mean(y,2);
    player = audioplayer(y, Fs);
    colour = [0,0,0];
    text = fileAddress;