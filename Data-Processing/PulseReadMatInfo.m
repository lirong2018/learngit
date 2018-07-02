function [info]=PulseReadMatInfo(path)
%PulseReadMatInfo 读取pulse导出的mat文件信息
%   path文件路径
validateattributes('D:\BK_Recording\05161\05161_4.mat',{'char'},{'vector'})
load('D:\BK_Recording\05161\05161_4.mat','-regexp','.*Header');
info.ChannelNum=str2num(File_Header.NumberOfChannels);
info.Fs=str2num(File_Header.SampleFrequency);
info.NumberOfSamples=str2num(File_Header.NumberOfSamplesPerChannel);
info.SignalName=cell(1,info.ChannelNum);
for i=1:info.ChannelNum
    info.SignalName{i}=eval(sprintf('Channel_%d_Header.SignalName;',i));
    info.Unit{i}=eval(sprintf('Channel_%d_Header.Unit;',i));
end


end

