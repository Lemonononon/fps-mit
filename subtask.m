function output = subtask(type, wptr, number)
    responseTime = 1;
    WaitSecs(1);
    %type 1视觉次任务2听觉次任务
    %wptr 窗口曲柄
    %number 任务里要出现的3个数字
    %关于音频文件，暂时写成1~9.mp3，可改（
    for i = 1:3
        if type==1
            DrawFormattedText(wptr,num2str(number(i)),'center','center',[255,255,255]);
            Screen('Flip', wptr);
            WaitSecs(0.5);
        end
        
        if type==2
            [y,Fs]=audioread([num2str(number(i)),'.mp3']);
            sound(y,Fs);
        end
        
        RTstart = GetSecs;
        [secs, keyCode] = KbWait([],[],RTstart + Stim.responseTime);
        RT = secs - RTstart;
        KbName('UnifyKeyNames');
        if (mod(number,3) == 0 && keyCode(KbName('LeftArrow'))) || (mod(number,3) ~= 0 && keyCode(Key.Right))
            correction(i) = 1;
            Screen('Flip',wptr);
        elseif (mod(number,3) == 0 && keyCode(KbName('RightArrow'))) || (mod(number,3) ~= 0 && keyCode(Key.Left))
            correction(i) = 0;
            Screen('Flip',wptr);
        else
            if keyCode(Key.Esc)
                break;
            end
            correction(i) = -1;
            Screen('Flip',wptr);
        end
        while sum(keyCode)~=0
            [keyIsDown,secs,keyCode] = KbCheck;
        end
    end
    if sum(correction)==3
        output = 1;
    else
        output = 0;
    end
    end