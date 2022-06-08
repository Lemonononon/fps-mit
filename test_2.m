% Screen('Preference', 'SkipSyncTests', 1);    
% HideCursor;
% %打开窗口，设置参数
% screenNumber=max(Screen('Screens'));
% %Screen('Resolution',screenNumber,1024,768,60);
% [wptr, wRect]=Screen('OpenWindow',screenNumber, 128,[],32,2);
% [cx,cy]=WindowCenter(wptr);
% [~, keyCode{1}] = KbWait();
% if keyCode{1}(KbName([num2str(4),'$']))
%     Screen('TextSize',wptr,40);
%     Screen('TextFont',wptr,'Simsun');
%     DrawFormattedText(wptr,double('你好啊'),'center','center',[0,0,0]);
% end
% Screen('Flip', wptr);
% WaitSecs(3);
% ShowCursor;
% sca;
% filefind=strcat('results\','FPS_MIT_','1','.csv');
% if exist(filefind,'file')==0
    fid=fopen(['results\','FPS_MIT_','1','.csv'],'w');
    fclose(fid);
% end



