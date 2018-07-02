function [ amp,f ] = FFTAnalyze( sig,nfft,window,fs )
%[ amp,f ] = FFTAnalyze( sig,nfft,window,fs ) 求sig的FFT
%   sig信号每列为一组信号
%   nfft点数
%   window窗函数
%   fs采样率
%   amp平均有效幅度
%   f频率轴
chn=length(sig(1,:));
f=((0:1/nfft:1-1/nfft)*fs).';
amp=zeros(nfft,chn);
for i=1:chn
    data=buffer(sig(:,i),nfft,0); % 分帧
    dw=bsxfun(@times,data,window); % 加窗 @times 表示数组相乘
    sp=fft(dw)/(nfft/2);
    a_t=abs(sp)/2^0.5;
    amp(:,i)=mean(a_t,2);
end
end

