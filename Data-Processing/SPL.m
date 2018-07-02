clear all
clc

load('D:\BK_Recording\0516\0516_3.mat');
A=[Channel_1_Data Channel_2_Data Channel_3_Data Channel_4_Data Channel_5_Data Channel_6_Data Channel_7_Data Channel_8_Data Channel_9_Data Channel_10_Data Channel_11_Data Channel_12_Data Channel_13_Data Channel_14_Data Channel_15_Data Channel_16_Data];
[P,Q]=size(A);
fs=65536;

%% 总声级（线性计权）
% for i=1:Q
%     signal=A(:,i);
%     Pe(i)=sum(signal.^2)/P;
%     Lp(i)=10*log10(Pe(i)/4e-10);
%     if i==Q
%         disp(Lp)
%     end
% end

%% 总声级（A计权）
% for i=1:Q
%     signal=A(:,i);
%     h=fdesign.audioweighting('WT,Class','A',1,fs);
%     Ha=design(h,'ansis142');
%     signal=filter(Ha,signal);
%     PeA(i)=sum(signal.^2)/P;
%     LpA(i)=10*log10(PeA(i)/4e-10);
%     if i==Q
%         disp(LpA)
%     end
% end

%% 时域波形
% time=(1/fs)*P;
% t=linspace(0,time,P);
% a=0:20:180;
% b=-8:4:8;
% 座位点
% figure;
% for i=1:5
%     signal=A(:,i);
%     subplot(5,1,i);
%     plot(t,signal);
%     axis([0 180 -8 8]);
%     set(gca,'XTick',a,'YTick',b,'Fontname','Times New Roman','Fontsize',10);
%     xlabel('t/s','Fontname','Times New Roman','Fontsize',11);
%     ylabel('Pe/Pa','Fontname','Times New Roman','Fontsize',11);
%     titlename=strcat('座位点',num2str(i));
%     title(titlename,'Fontname','宋体','Fontsize',10);
% end
% set(gcf,'Position',[420 50 500 630]);
% 显控点
% figure;
% for i=6:15
%     signal=A(:,i);
%     subplot(5,2,i-5);
%     plot(t,signal);
%     axis([0 180 -8 8]);
%     set(gca,'XTick',a,'YTick',b,'Fontname','Times New Roman','Fontsize',10);
%     xlabel('t/s','Fontname','Times New Roman','Fontsize',11);
%     ylabel('Pe/Pa','Fontname','Times New Roman','Fontsize',11);
%     titlename=strcat('显控点',num2str(i-5));
%     title(titlename,'Fontname','宋体','Fontsize',10);
% end
% set(gcf,'Position',[200 50 900 630]);
% 机柜
% figure;
% signal=A(:,16);
% plot(t,signal);
% axis([0 180 -8 8]);
% set(gca,'XTick',a,'YTick',b,'Fontname','Times New Roman','Fontsize',10);
% xlabel('t/s','Fontname','Times New Roman','Fontsize',11);
% ylabel('Pe/Pa','Fontname','Times New Roman','Fontsize',11);
% title('机柜','Fontname','宋体','Fontsize',10);
% set(gcf,'Position',[420 240 500 200]);

nfft=fs*2;
f=((0:1/nfft:1-1/nfft)*fs).';
window=hanning(nfft);
amp=zeros(nfft,Q);
c=0:100:800;
d=0:10:100;
for i=1:Q
    data=buffer(A(:,i),nfft,ceil(nfft*2/3));
    dw=bsxfun(@times,data,window);
    sp=fft(dw)/(nfft/2);
    a_t=abs(sp)/2^0.5;
    amp(:,i)=mean(a_t,2);
    lp=20*log10(amp/(2e-5));
    figure;
    plot(f(1:nfft/2),lp(1:nfft/2,i));
    axis([0 800 0 100]);
    set(gca,'XTick',c,'YTick',d,'Fontname','Times New Roman','Fontsize',10);
    xlabel('f/Hz','Fontname','Times New Roman','Fontsize',11);
    ylabel('Lp/dB','Fontname','Times New Roman','Fontsize',11);
    if i<=5
        titlename=strcat('座位点',num2str(i));
    else if i<=15
            titlename=strcat('显控点',num2str(i-5));
        else
            titlename=strcat('机柜');
        end
    end
    title(titlename,'Fontname','宋体','Fontsize',10)
end
