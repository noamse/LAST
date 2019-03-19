%runnig a live image poll
ExpTime = Q.expTime; %[sec]
filepath = '/home/qhy/QHY/logs/occultation.txt';
filepath = '/home/qhy/QHY/Images/';
Period = ExpTime;


T =timer( ...
    'ExecutionMode', 'fixedSpacing',...
    'StartDelay',Period,....
    'Period' , Period, ...
    'StartFcn', 'start_sequence_take(Q)',...
    'TimerFcn', 'Im = QHYfun.take_seq(Q,filepath);',...
    'StopFcn', 'stop_sequence_take(Q)' ...
);
start(T)
%    'TimerFcn', 'Im = QHYfun.ImagePoll(Q,filepath);',...

