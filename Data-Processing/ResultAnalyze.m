clear all
clc
A=rand(65536*180,16);
% load('D:\BK_Recording\0516\0516_3.mat');
% A=[Channel_1_Data Channel_2_Data Channel_3_Data Channel_4_Data Channel_5_Data Channel_6_Data Channel_7_Data Channel_8_Data Channel_9_Data Channel_10_Data Channel_11_Data Channel_12_Data Channel_13_Data Channel_14_Data Channel_15_Data Channel_16_Data];
[P,Q]=size(A);
fs=65536;



%% �����������Լ�Ȩ��
for i=1:Q
    signal=A(:,i);
    Pe(i)=sum(signal.^2)/P;
    Lp(i)=10*log10(Pe(i)/4e-10);
end

%% ��������A��Ȩ��
for i=1:Q
    signal=A(:,i);
    h=fdesign.audioweighting('WT,Class','A',1,fs);
    Ha=design(h,'ansis142');
    signal=filter(Ha,signal);
    PeA(i)=sum(signal.^2)/P;
    LpA(i)=10*log10(PeA(i)/4e-10);
end

SLP=[Lp' LpA'];
filename='������.xlsx';
SLPtitle1={'Z��Ȩ����/dB'};
SLPtitle2={'A��Ȩ����/dB(A)'};
sheet=1;
xlRange1='A1';
xlRange2='B1';
xlRange3='A2';
xlswrite(filename,SLPtitle1,sheet,xlRange1);
xlswrite(filename,SLPtitle2,sheet,xlRange2);
xlswrite(filename,SLP,sheet,xlRange3);
winopen('������.xlsx');
figure('NumberTitle','off','Name','������');
t=uitable('Data',SLP,'Position',[20 20 255 343],'Fontname','Times New Roman','Fontsize',11);
t.ColumnName={'Z��Ȩ����/dB','A��Ȩ����/dB(A)'};
t.RowName={'��λ��1','��λ��2','��λ��3','��λ��4','��λ��5','�Կص�1','�Կص�2','�Կص�3','�Կص�4','�Կص�5','�Կص�6','�Կص�7','�Կص�8','�Կص�9','�Կص�10','����'};
set(gcf,'Position',[500 200 290 380]);



%% ʱ����
time=(1/fs)*P;
t=linspace(0,time,P);
a=0:20:180;
b=-8:4:8;

% ��λ��
figure('NumberTitle','off','Name','��λ��ʱ����');
for i=1:5
    signal=A(:,i);
    subplot(5,1,i);
    plot(t,signal);
    axis([0 180 -8 8]);
    set(gca,'XTick',a,'YTick',b,'Fontname','Times New Roman','Fontsize',10);
    xlabel('t/s','Fontname','Times New Roman','Fontsize',11);
    ylabel('Pe/Pa','Fontname','Times New Roman','Fontsize',11);
    titlename=strcat('��λ��',num2str(i));
    title(titlename,'Fontname','����','Fontsize',10);
end
set(gcf,'Position',[420 50 500 630]);

% �Կص�
figure('NumberTitle','off','Name','�Կ�̨ʱ����');
for i=6:15
    signal=A(:,i);
    subplot(5,2,i-5);
    plot(t,signal);
    axis([0 180 -8 8]);
    set(gca,'XTick',a,'YTick',b,'Fontname','Times New Roman','Fontsize',10);
    xlabel('t/s','Fontname','Times New Roman','Fontsize',11);
    ylabel('Pe/Pa','Fontname','Times New Roman','Fontsize',11);
    titlename=strcat('�Կص�',num2str(i-5));
    title(titlename,'Fontname','����','Fontsize',10);
end
set(gcf,'Position',[200 50 900 630]);

% ����
figure('NumberTitle','off','Name','����ʱ����');
signal=A(:,16);
plot(t,signal);
axis([0 180 -8 8]);
set(gca,'XTick',a,'YTick',b,'Fontname','Times New Roman','Fontsize',10);
xlabel('t/s','Fontname','Times New Roman','Fontsize',11);
ylabel('Pe/Pa','Fontname','Times New Roman','Fontsize',11);
title('����','Fontname','����','Fontsize',10);
set(gcf,'Position',[420 240 500 200]);



%% FFTƵ��
nfft=fs*2;
f=((0:1/nfft:1-1/nfft)*fs).';
window=hanning(nfft);
c=0:100:800;
d=0:10:100;

% Z��Ȩ
amp=zeros(nfft,Q);
for i=1:Q
    data=buffer(A(:,i),nfft,ceil(nfft*2/3));
    dw=bsxfun(@times,data,window);
    sp=fft(dw)/(nfft/2);
    a_t=abs(sp)/2^0.5;
    amp(:,i)=mean(a_t,2);
    lp=20*log10(amp/(2e-5));
    figure('NumberTitle','off','Name','FFTƵ�� Z��Ȩ');
    plot(f(1:nfft/2),lp(1:nfft/2,i));
    axis([0 800 0 100]);
    set(gca,'XTick',c,'YTick',d,'Fontname','Times New Roman','Fontsize',10);
    xlabel('f/Hz','Fontname','Times New Roman','Fontsize',11);
    ylabel('Lp/dB','Fontname','Times New Roman','Fontsize',11);
    set(gcf,'Position',[380 120 600 500]);
    if i<=5
        titlename=strcat('��λ��',num2str(i));
    else if i<=15
            titlename=strcat('�Կص�',num2str(i-5));
        else
            titlename=strcat('����');
        end
    end
    title(titlename,'Fontname','����','Fontsize',10)
end

% A��Ȩ
h=fdesign.audioweighting('WT,Class','A',1,fs);
Ha=design(h,'ansis142');
lpA=filter(Ha,lp);
for i=1:Q
%     data=buffer(A(:,i),nfft,ceil(nfft*2/3));
%     dw=bsxfun(@times,data,window);
%     sp=fft(dw)/(nfft/2);
%     a_t=abs(sp)/2^0.5;
%     ampA(:,i)=mean(a_t,2);    
%     h=fdesign.audioweighting('WT,Class','A',1,fs);
%     Ha=design(h,'ansis142');
%     ampA=filter(Ha,ampA);
%     lp=20*log10(ampA/(2e-5));
    figure('NumberTitle','off','Name','FFTƵ�� A��Ȩ');
    plot(f(1:nfft/2),lp(1:nfft/2,i));
    axis([0 800 0 100]);
    set(gca,'XTick',c,'YTick',d,'Fontname','Times New Roman','Fontsize',10);
    xlabel('f/Hz','Fontname','Times New Roman','Fontsize',11);
    ylabel('LpA/dB(A)','Fontname','Times New Roman','Fontsize',11);
    set(gcf,'Position',[380 120 600 500]);
    if i<=5
        titlename=strcat('��λ��',num2str(i));
    else if i<=15
            titlename=strcat('�Կص�',num2str(i-5));
        else
            titlename=strcat('����');
        end
    end
    title(titlename,'Fontname','����','Fontsize',10)
end



%% CPB
% ��Ƶ��
fcentre1=roundn(10^3*(2.^[-6:0]),0);
fd1=2^(1/2);
fupper1=roundn(fcentre1.*fd1,0);
flower1=roundn(fcentre1./fd1,0);
f1=[flower1(1) fupper1];

for j=1:Q
    for i=1:(length(f1)-1)
        k=find(f>f1(i)&f<=f1(i+1));
        CPB1=amp(k,j);
        Pe1(i,j)=sum(CPB1.^2);
        Lp1(i,j)=10*log10(Pe1(i,j)/4e-10);
    end
end
for i=1:Q
    figure('NumberTitle','off','Name','1/1��Ƶ��CPB Z��Ȩ');
    bar(Lp1(:,i),1);
    axis([0 8 0 100]);
    set(gca,'Xtick',1:7,'YTick',0:10:100,'Fontname','Times New Roman','Fontsize',10);
    set(gca,'Xticklabel',fcentre1,'Xticklabelrotation',270)
    xlabel('f/Hz','Fontname','Times New Roman','Fontsize',11);
    ylabel('Lp/dB','Fontname','Times New Roman','Fontsize',11);
    set(gcf,'Position',[280 120 800 500]);
    if i<=5
        titlename=strcat('��λ��',num2str(i));
    else if i<=15
            titlename=strcat('�Կص�',num2str(i-5));
        else
            titlename=strcat('����');
        end
    end
    title(titlename,'Fontname','����','Fontsize',10)
end

h=fdesign.audioweighting('WT,Class','A',1,fs);
Ha=design(h,'ansis142');
Lp1A=filter(Ha,Lp1);
for i=1:Q
    figure('NumberTitle','off','Name','1/1��Ƶ��CPB A��Ȩ');
    bar(Lp1A(:,i),1);
    axis([0 8 0 100]);
    set(gca,'Xtick',1:7,'YTick',0:10:100,'Fontname','Times New Roman','Fontsize',10);
    set(gca,'Xticklabel',fcentre1,'Xticklabelrotation',270)
    xlabel('f/Hz','Fontname','Times New Roman','Fontsize',11);
    ylabel('LpA/dB(A)','Fontname','Times New Roman','Fontsize',11);
    set(gcf,'Position',[280 120 800 500]);
    if i<=5
        titlename=strcat('��λ��',num2str(i));
    else if i<=15
            titlename=strcat('�Կص�',num2str(i-5));
        else
            titlename=strcat('����');
        end
    end
    title(titlename,'Fontname','����','Fontsize',10)
end


% 1/3��Ƶ��
fcentre2=roundn(10^3*(2.^([-17:0]/3)),-1);
fd2=2^(1/6);
fupper2=roundn(fcentre2.*fd2,-1);
flower2=roundn(fcentre2./fd2,-1);
f2=[flower2(1) fupper2];

for j=1:Q
    for i=1:(length(f2)-1)
        k=find(f>f2(i)&f<=f2(i+1));
        CPB2=amp(k,j);
        Pe2(i,j)=sum(CPB2.^2);
        Lp2(i,j)=10*log10(Pe2(i,j)/4e-10);
    end
end
for i=1:Q
    figure('NumberTitle','off','Name','1/3��Ƶ��CPB Z��Ȩ');
    bar(Lp2(:,i),1);
    axis([0 19 0 100]);
    set(gca,'Xtick',1:18,'YTick',0:10:100,'Fontname','Times New Roman','Fontsize',10);
    set(gca,'Xticklabel',fcentre2,'Xticklabelrotation',270)
    xlabel('f/Hz','Fontname','Times New Roman','Fontsize',11);
    ylabel('Lp/dB','Fontname','Times New Roman','Fontsize',11);
    set(gcf,'Position',[280 120 800 500]);
    if i<=5
        titlename=strcat('��λ��',num2str(i));
    else if i<=15
            titlename=strcat('�Կص�',num2str(i-5));
        else
            titlename=strcat('����');
        end
    end
    title(titlename,'Fontname','����','Fontsize',10)
end

Lp2A=filter(Ha,Lp2);
for i=1:Q
    figure('NumberTitle','off','Name','1/3��Ƶ��CPB A��Ȩ');
    bar(Lp2A(:,i),1);
    axis([0 19 0 100]);
    set(gca,'Xtick',1:18,'YTick',0:10:100,'Fontname','Times New Roman','Fontsize',10);
    set(gca,'Xticklabel',fcentre2,'Xticklabelrotation',270)
    xlabel('f/Hz','Fontname','Times New Roman','Fontsize',11);
    ylabel('LpA/dB(A)','Fontname','Times New Roman','Fontsize',11);
    set(gcf,'Position',[280 120 800 500]);
    if i<=5
        titlename=strcat('��λ��',num2str(i));
    else if i<=15
            titlename=strcat('�Կص�',num2str(i-5));
        else
            titlename=strcat('����');
        end
    end
    title(titlename,'Fontname','����','Fontsize',10)
end


% 1/12��Ƶ��
fcentre3=roundn(10^3*(2.^([-47:0]/12)),-1);
fd3=2^(1/24);
fupper3=roundn(fcentre3.*fd3,-1);
flower3=roundn(fcentre3./fd3,-1);
f3=[flower3(1) fupper3];

for j=1:Q
    for i=1:(length(f3)-1)
        k=find(f>f3(i)&f<=f3(i+1));
        CPB3=amp(k,j);
        Pe3(i,j)=sum(CPB3.^2);
        Lp3(i,j)=10*log10(Pe3(i,j)/4e-10);
    end
end
for i=1:Q
    figure('NumberTitle','off','Name','1/12��Ƶ��CPB Z��Ȩ');
    bar(Lp3(:,i),1);
    axis([0 49 0 100]);
    set(gca,'Xtick',1:48,'YTick',0:10:100,'Fontname','Times New Roman','Fontsize',10);
    set(gca,'Xticklabel',fcentre3,'Xticklabelrotation',270)
    xlabel('f/Hz','Fontname','Times New Roman','Fontsize',11);
    ylabel('Lp/dB','Fontname','Times New Roman','Fontsize',11);
    set(gcf,'Position',[280 120 800 500]);
    if i<=5
        titlename=strcat('��λ��',num2str(i));
    else if i<=15
            titlename=strcat('�Կص�',num2str(i-5));
        else
            titlename=strcat('����');
        end
    end
    title(titlename,'Fontname','����','Fontsize',10)
end

Lp3A=filter(Ha,Lp3);
for i=1:Q
    figure('NumberTitle','off','Name','1/12��Ƶ��CPB A��Ȩ');
    bar(Lp3A(:,i),1);
    axis([0 49 0 100]);
    set(gca,'Xtick',1:48,'YTick',0:10:100,'Fontname','Times New Roman','Fontsize',10);
    set(gca,'Xticklabel',fcentre3,'Xticklabelrotation',270)
    xlabel('f/Hz','Fontname','Times New Roman','Fontsize',11);
    ylabel('LpA/dB(A)','Fontname','Times New Roman','Fontsize',11);
    set(gcf,'Position',[280 120 800 500]);
    if i<=5
        titlename=strcat('��λ��',num2str(i));
    else if i<=15
            titlename=strcat('�Կص�',num2str(i-5));
        else
            titlename=strcat('����');
        end
    end
    title(titlename,'Fontname','����','Fontsize',10)
end