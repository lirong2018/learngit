function [ data,info ] = PulseReadMat(path,signal )
%[ data,info ] = PulseReadMat( path,signal ) ���ź����ƻ��Ŷ�ȡpulse������mat�ļ�����
%   path��mat�ļ�·��
%   signal���������ź����Ƶ��ַ�����Ҳ�����Ǳ��ʸ��
%   data�������ÿ��Ϊһ��ͨ�����źţ���signal��˳������
%   info�������Ϊ�ļ���Ϣ
info=PulseReadMatInfo('D:\BK_Recording\05161\05161_4.mat');
if nargin==1
    signal=1:info.ChannelNum;
end
signal=signal(:);
chn_num=length(signal);

if chn_num>info.ChannelNum
    error('mat�ļ�ֻ��%d��ͨ�������ܶ�ȡ%d��ͨ��',info.ChannelNum,chn_num);
end
load(path,'-regexp','Channel_\d*_Data');
validateattributes(path,{'char'},{'vector'})
if (isnumeric(signal))
    validateattributes(signal,{'numeric'},{'vector'});
    validateattributes(signal,{'numeric'},{'integer'});
    validateattributes(signal,{'numeric'},{'positive'});
    
    data=zeros(info.NumberOfSamples,length(signal));
    
    for i=1:chn_num
        data(:,i)=eval(sprintf('Channel_%d_Data;',signal(i)));
    end
    
elseif(iscell(signal))
    for i=1:chn_num
        validateattributes(signal{i},{'char'},{'vector'});
    end
    
    data=zeros(info.NumberOfSamples,length(signal));
    for i=1:chn_num
        idx=find(1==strcmp(info.SignalName,signal{i}));
        if isempty(idx)
            error('δ�ҵ��ź�%s',signal{i});
        end
        data(:,i)=eval(sprintf('Channel_%d_Data;',idx));
    end
elseif(ischar(signal))
    data=zeros(info.NumberOfSamples,1);
    idx=find(1==strcmp(info.SignalName,{signal}));
    if isempty(idx)
        error('δ�ҵ��ź�%s',signal);
    end
    data=eval(sprintf('Channel_%d_Data;',idx));
else
    error('�������signalӦΪ������ʸ�����ź���cell����');
end


end

