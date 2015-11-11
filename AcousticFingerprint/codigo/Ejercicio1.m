info = audioinfo("audios/caprici_di_diablo.wav");
audio_doble = audioread("audios/caprici_di_diablo.wav");

audio = mean(audio_doble'(:,:));
 
intervalo = info.Duration/info.TotalSamples;
figure 1
plot(0:intervalo:249*intervalo ,audio(1:250));
xlabel ("tiempo [s]");
ylabel ("Canal de audio");
print('canal.png','-dpng');

player = audioplayer(audio, info.SampleRate);
play(player);