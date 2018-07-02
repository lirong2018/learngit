function [ data,info ] = PulseReadMat(path,signal )
%[ data,info ] = PulseReadMat( path,signal ) 按信号名称或编号读取pulse导出的mat文件数据
%   path：mat文件路径
%   signal：可以是信号名称的字符串，也可以是编号矢量
%   data：输出，每列为一个通道的信号，按signal的顺序排列
%   info：输出，为文件信息
info=PulseReadMatInfo('D:\BK_Recording\05161\05161_4.mat');
if nargin==1
    signal=1:info.ChannelNum;
end
signal=signal(:);
chn_num=length(signal);

if chn_num>info.ChannelNum
    error('mat文件只有%d个通道，不能读取%d个通道',info.ChannelNum,chn_num);
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
            error('未找到信号%s',signal{i});
        end
        data(:,i)=eval(sprintf('Channel_%d_Data;',idx));
    end
elseif(ischar(signal))
    data=zeros(info.NumberOfSamples,1);
    idx=find(1==strcmp(info.SignalName,{signal}));
    if isempty(idx)
        error('未找到信号%s',signal);
    end
    data=eval(sprintf('Channel_%d_Data;',idx));
else
    error('输入参数signal应为正整数矢量或信号名cell数组');
end


end

