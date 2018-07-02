function [ amp,f ] = FFTAnalyze( sig,nfft,window,fs )
%[ amp,f ] = FFTAnalyze( sig,nfft,window,fs ) ��sig��FFT
%   sig�ź�ÿ��Ϊһ���ź�
%   nfft����
%   window������
%   fs������
%   ampƽ����Ч����
%   fƵ����
chn=length(sig(1,:));
f=((0:1/nfft:1-1/nfft)*fs).';
amp=zeros(nfft,chn);
for i=1:chn
    data=buffer(sig(:,i),nfft,0); % ��֡
    dw=bsxfun(@times,data,window); % �Ӵ� @times ��ʾ�������
    sp=fft(dw)/(nfft/2);
    a_t=abs(sp)/2^0.5;
    amp(:,i)=mean(a_t,2);
end
end

