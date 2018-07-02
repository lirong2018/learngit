function [ level ] = EstimateLevel( x,fs,ref_level,weighing_type )
%[ level ] = EstimateLevel( x,fs,weighing_filter,ref_level )
%   估计信号级
%   x信号，每列为一组信号
%   fs采样率
%   ref_level参考级
%   weighing_type计权类型 'linear'、'A'

x=load('D:\BK_Recording\05161\05161_4.mat');
fs=5898240;
if nargin==2
    ref_level=0;
    weighing_type='linear';
end

if nargin==3
    weighing_type='linear';
end
switch weighing_type
    case 'linear'
    case 'A'
        h = fdesign.audioweighting('WT,Class','A',1,fs);
        Ha = design(h,'ansis142');
        x=filter(Ha,x);
    otherwise
        error('无法识别的计权类型')
end

if isrow(x)
    x=x.';
end

x=mean(x.^2,1).^0.5;
level=20*log10(x)-ref_level;


end

