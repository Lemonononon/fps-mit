function main()
    clear all;
    global subinfo;

    %% 输入被试信息 
    prompt = {'编号','姓名','年龄','性别（1=男，2=女）', '类型（1-fps玩家，2-非fps玩家）'};
    dlg_title = '被试信息';
    num_line = [1 45;1 45;1 45;1 45;1 45];
    def_answer = {'','','','', ''};
    options = 'off';
    subinfo = inputdlg(prompt,dlg_title,num_line,def_answer,options);
    subID = str2num([subinfo{1}]);
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

    %读入图片
    for img_read_index = 1:20
        pic(img_read_index) = Screen('MakeTexture', wptr, imread( ['pic\', num2str(img_read_index),'.png']) );
    end
    
    %设置指导语
    start_text = '欢迎您参加本次实验\n\n';
    end_text = '实验结束！\n\n感谢您的参与！';

    %生成参数矩阵
    para_subtasktype = [1 2]; % 1-视觉 2-听觉
    para_color = [1 2 3]; % 1-红 2-绿 3-蓝
    para_match = [1 2 3 3]; %1-same 2-different 3-not match; noMatch = same + different
    para_posi = [1 2]; % 1-上 2-下
 
    [x0,x1,x2,x3]=ndgrid( para_simil, para_color, para_match,para_posi );%生成参数组合矩阵
    para_temp=[x0(:),x1(:),x2(:),x3(:)];%所有条件组合,生成2*3*4*2=48种基本情况的参数矩阵，第1列是否相似，第2列颜色，第3列匹配情况，第4列靶子出现的位置

    % for r = 1:48
    %     if para_temp(r,2)==0
    %        para_temp(r,3) = 0;
    %     end
    % end
    %生成所有试次的参数矩阵
    global para;
    global para_practice; %全局的参数矩阵
    para = [];
    para_practice = Shuffle(para_temp);
    for i = 1 : total/48
        para = [para; Shuffle(para_temp)];
    end

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
    fprintf(fid,'%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\r\n','ID','SubName','SubSex','SubAge','IsMasterPlayer','SubTask','Order','NumOfCorrectIdentity','NumOfCorrectPosition','IsSubTaskCorrect');
    
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
    [cx,cy]=WindowCenter(wptr);
    global name;
    global Gender;
    global age;
    global type;



    for i = 1:3
        for ii = 1:40
            %随机8个数字
            pic_select = randperm(20,8); %随机选出八张图片
            posi_pic = %每张图片的位置
            %这样子呈现图片
            for pic_index = 1:8
                % pic_present(pic_index) = getfield(pic,);
                
            end
        end
    end



end