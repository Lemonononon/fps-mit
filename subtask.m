function output = subtask(type, wptr, number)
responseTime = 1;
WaitSecs(1);
%type 1视觉次任务2听觉次任务
%wptr 窗口曲柄
%number 任务里要出现的3个数字
%关于音频文件，暂时写成1~9.mp3，可改（
for i = 1:3
if type==1
    for ii=1:MosaicDuration
        DrawFormattedText(wptr,num2str(number(i)),'center','center',[255,255,255]);
        Screen('Flip', wptr);
    end
end

if type==2
    [y,Fs]=audioread([num2str(number(i)),'.mp3']);
    sound(y,Fs);
    for ii=1:MosaicDuration
        DrawFormattedText(wptr,'Press Space to Start','center','center',[255,255,255]);
        Screen('Flip', wptr);
    end
end

RTstart = GetSecs;
[secs, keyCode] = KbWait([],[],RTstart + Stim.responseTime);
RT = secs - RTstart;
if (mod(number,3) == 0 && keyCode(Key.Left)) || (mod(number,3) ~= 0 && keyCode(Key.Right))
    correction = 1;
    Screen('Flip',wptr);
elseif (mod(number,3) == 0 && keyCode(Key.Right)) || (mod(number,3) ~= 0 && keyCode(Key.Left))
    correction = 0;
    Screen('Flip',wptr);
    Beeper();
else
    if keyCode(Key.Esc)
        break;
    end
    correction = -1;
    Screen('Flip',wptr);
    Beeper();
end
while sum(keyCode)~=0
    [keyIsDown,secs,keyCode] = KbCheck;
end
end
end