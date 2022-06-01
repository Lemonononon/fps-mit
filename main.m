function main()
    clear all;
    global subinfo;

    %% 输入被试信息 
    prompt = {'学号','姓名','年龄','性别（1=男，2=女）', '类型（1-fps玩家，2-非fps玩家）'};
    dlg_title = '被试信息';
    num_line = [1 45;1 45;1 45;1 45;1 45];
    def_answer = {'','','','', ''};
    options = 'off';
    subinfo = inputdlg(prompt,dlg_title,num_line,def_answer,options);
    subID = [subinfo{1}];
    global name;
    name = [subinfo{2}];
    global age;
    age = str2num ([subinfo{3}]);
    gender = str2num([subinfo{4}]);
    type = [subinfo{5}];
    global Gender;
    if gender == 1
        Gender = 'Male';
    else
        Gender = 'Female';
    end

    % subinfo=getSubInfo;
    Screen('Preference', 'SkipSyncTests', 1);
    HideCursor;

    %打开窗口，设置参数
    screenNumber=max(Screen('Screens'));
    %Screen('Resolution',screenNumber,1024,768,60);
    [wptr, wRect]=Screen('OpenWindow',screenNumber, 128,[],32,2);
    Screen(wptr,'BlendFunction',GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    [cx,cy]=WindowCenter(wptr);
    frame_rate=Screen('FrameRate',wptr);
    framedur=1000/frame_rate;%单位ms


    %输出文件打开-------------------------------------
    filefind=strcat('results\','FPS_MIT_',char(subID),'_',char(name),'_',Gender,'.csv');
    if exist(filefind,'file')==0
        fid=fopen(['results\','FPS_MIT_',char(subID),'_',char(name),'_',Gender,'.csv'],'w');
    else
        filev=2;
        while true
            filefind=strcat('results\','FPS_MIT_',char(subID),'_',char(name),'_',Gender,'(',num2str(filev),')','.csv');
            if exist(filefind,'file')==0
                fid=fopen(['results\','FPS_MIT_',char(subID),'_',char(name),'_',Gender,'(',num2str(filev),')','.csv'],'w');
                break;
            else
                filev=filev+1;
            end
        end
    end
    fprintf(fid,'%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\r\n','ID','SubName','SubSex','SubAge','Similarity','ISMatch','SetNum','ColorLeft','ColorRight','MotionDirection','ColorTarget','TargetPosition','ISResponseCorrect','ReactionTime');
    
    %% 实验前指导语
    Screen('TextSize',wptr,40);
    Screen('TextFont',wptr,'Simsun');
    DrawFormattedText(wptr,double(start_text),'center','center',[0,0,0]);
    Screen('Flip',wptr);
    KbWait;

    %% 练习实验
    practice(wptr, fid);
    WaitSecs(1);

    %% 正式实验
    formal(wptr, fid);

    %关闭数据文件
    fclose(fid);

    %% 结束语
    Screen('TextSize',wptr,40);
    Screen('TextFont',wptr,'Simsun');
    DrawFormattedText(wptr,double(end_text),'center','center',[0,0,0]);
    Screen('Flip',wptr);
    WaitSecs(1);
    ShowCursor;
    Screen('CloseAll');

end
    


function practice(wptr, fid)
    [cx,cy]=WindowCenter(wptr);

    
end


function formal(wptr, fid)
    

    
end