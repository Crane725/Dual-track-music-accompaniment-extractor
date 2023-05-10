[m,Fs] = audioread("ラムジ - PLANET.wav");
L = size(m,1);%歌曲采样总数
t0 = (L-1)/Fs;%歌曲总时长
ts = 1/Fs;%采样间隔
m1 = m(:,1);%左声道
m2 = m(:,2);%右声道
k1 = (0:ts:t0);%原始时域
y1 = fft(m1);%左声道傅里叶变换
y2 = fft(m2);%右声道傅里叶变换

Ly = size(y1,1);%左声道采样总数
fily=[]*Ly;
for i=1:Ly
    fily(i) = y1(i)-y2(i);%进行声道频域相减操作，可以让人声的响度一定程度降低
end
k=((0:L-1)*Fs)/L;
lim1 = round(300*L/44100);lim2 = round(3400*L/44100);%设置带阻滤波器的阈值
for i=lim1:lim2%进行带阻滤波
    fily(i) = 0;
    fily(Ly-i+1) = 0;
end

film = ifft(fily);%滤波后反变换
figure(5)
subplot(211)
plot(k,abs(fily));
title('滤波后的频谱图')
xlabel('频率 ω');
ylabel('幅度');
subplot(212)
film = real(film);%去虚取实
plot(k1,film);
title('滤波后的时域信号')
xlabel('时刻 t');
ylabel('振幅');
audiowrite("C:\Users\95779\Desktop\result.wav",film,Fs);