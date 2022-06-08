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
age = [subinfo{3}];
gender = str2num([subinfo{4}]);
sub_type = [subinfo{5}];
global Gender;
if gender == 1
    Gender = 'Male';
else
    Gender = 'Female';
end
if mod(subID,2) == 1
    subtask_type ={'0' '1' '2'};
else
    subtask_type = {'0' '2' '1'};
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
KbName('UnifyKeyNames');

% 字体
Screen('TextSize',wptr,40);
Screen('TextFont',wptr,'Simsun');

%读入图片
for img_read_index = 1:20
    pic(img_read_index) = Screen('MakeTexture', wptr, imread( ['pic\', num2str(img_read_index),'.png']) );
end

%设置指导语
start_text = '欢迎您参加本次实验\n\n';
judge_text = '请按下相应的数字键选择实验开始时红框标注的动物\n\n'
end_text = '实验结束！\n\n感谢您的参与!';

% for r = 1:48
%     if para_temp(r,2)==0
%        para_temp(r,3) = 0;
%     end
% end
%生成所有试次的参数矩阵
% 输出文件打开-------------------------------------
filefind=strcat('results\','FPS_MIT_',num2str(subID),'.csv');
if exist(filefind,'file')==0
    fid=fopen(['results\','FPS_MIT_',num2str(subID),'.csv'],'w');
else
    filev=2;
    while true
        filefind=strcat('results\','FPS_MIT_',num2str(subID),'(',num2str(filev),')','.csv');
        if exist(filefind,'file')==0
            fid=fopen(['results\','FPS_MIT_',num2str(subID),'(',num2str(filev),')','.csv'],'w');
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

for index = 1:8
    number_present{index} = Screen('MakeTexture',wptr, imread(['pic\number', num2str(index), '.png']));
end

animal = {'斑马', '大象', '大嘴鸟', '袋鼠', '鳄鱼', '公鸡', '狐狸', '浣熊', '狼狗', '老虎', '骆驼', '山羊', '狮子', '松鼠', '兔子', '鸵鸟', '乌龟', '犀牛', '猩猩', '长颈鹿'};
key = {'1!','2@','3#','4$','5%','6^','7&','8*'};

%% 正式实验
for i = 1:3
    for ii = 1:40
        %随机8个数字
        subtask_number=randperm(9,3);
        
        pic_select = randperm(20,8); %随机选出八张图片
        for pic_index = 1:8
            pic_x = randperm( wRect(3) - 80, 1);
            pic_y = randperm( wRect(4) - 80, 1 );
            %每张图片的位置
            pic_posi{pic_index} = [pic_x, pic_y, pic_x + 80, pic_y + 80];
            %绘制图片
            [img, map, alpha] = imread(['pic\', num2str(pic_select(pic_index)), '.png']);
            img(:,:,4)=alpha;
            pic_present{pic_index} = Screen('MakeTexture',wptr, img);
        end
        
        % 第一次呈现图片
        for present_index = 1:8
            Screen('DrawTexture', wptr, pic_present{present_index}, [],  pic_posi{present_index});
        end
        % Screen('Flip', wptr);
        
        % 打标记的4张图片
        pic_red = randperm(8, 4);
        for red_index = 1:4
            Screen('Framerect', wptr, [255, 0, 0], pic_posi{pic_red(red_index)} ); %画红线框
        end
        
        Screen('Flip', wptr);
        WaitSecs(3);
        
        % 开始随机运动，即更新位置，然后重新画图，并Flip
        
        for motion_first1 = 1:frame_rate
            for pic_index = 1:8
                motion_angle = pi*2*randperm(360, 8)/360;
                distance_x = 20*cos(motion_angle(pic_index));
                distance_y = 20*sin(motion_angle(pic_index));
                if pic_posi{pic_index}(1) + distance_x <=0 || pic_posi{pic_index}(1) + distance_x >= wRect(3)-80
                    distance_x = -distance_x;
                end
                if pic_posi{pic_index}(2) + distance_y <= 0 || pic_posi{pic_index}(2) + distance_y >= wRect(4) - 80
                    distance_y = -distance_y;
                end
                pic_posi{pic_index}(1) = pic_posi{pic_index}(1) + distance_x;
                pic_posi{pic_index}(2) = pic_posi{pic_index}(2) + distance_y;
                pic_posi{pic_index}(3) = pic_posi{pic_index}(1) + 80;
                pic_posi{pic_index}(4) = pic_posi{pic_index}(2) + 80;
            end
            for present_index = 1:8
                Screen('DrawTexture', wptr, pic_present{present_index}, [],  pic_posi{present_index});
            end
            
            Screen('Flip', wptr);
        end
        
        
        % motion_time =  round(randfixedsum(50, 8, time_left*frame_rate, 1, time_left * frame_rate));
        % for i = 1:8
        %     motion_time(50, i) = time_left*frame_rate - sum(motion_time(1:49, i));
        % end
        
        % for i = 1:8
        %     for ii = 2:50
        %         motion_time(ii, i) = motion_time(ii, i) + motion_time(ii - 1, i);
        %     end
        % end
        subtask_correction = 0;
        correction = [0 0 0];
        for j = 1:3
            if subtask_type{i}=='2'
            [y,Fs]=audioread(['audio\', num2str(subtask_number(j)),'.mp3']);
            sound(y,Fs);
            end
            for motion_second = 1:frame_rate
            
                for pic_index = 1:8
                    motion_angle = pi*2*randperm(360, 8)/360;
                    distance_x = 20*cos(motion_angle(pic_index));
                    distance_y = 20*sin(motion_angle(pic_index));
                    if pic_posi{pic_index}(1) + distance_x <=0 || pic_posi{pic_index}(1) + distance_x >= wRect(3)-80
                        distance_x = -distance_x;
                    end
                    if pic_posi{pic_index}(2) + distance_y <= 0 || pic_posi{pic_index}(2) + distance_y >= wRect(4) - 80
                        distance_y = -distance_y;
                    end
                    pic_posi{pic_index}(1) = pic_posi{pic_index}(1) + distance_x;
                    pic_posi{pic_index}(2) = pic_posi{pic_index}(2) + distance_y;
                    pic_posi{pic_index}(3) = pic_posi{pic_index}(1) + 80;
                    pic_posi{pic_index}(4) = pic_posi{pic_index}(2) + 80;
                    
                end
                for present_index = 1:8
                    Screen('DrawTexture', wptr, pic_present{present_index}, [],  pic_posi{present_index});
                end
                % 中间次任务

                if subtask_type{i}=='1'
                    Screen('Framerect', wptr); %画线框
                    DrawFormattedText(wptr,num2str(subtask_number(j)),'center','center',[255,255,255]);
                end
                
                
                [secs, keyCode, deltaSecs] = KbWait([],[] , GetSecs+0.005);
                if sum(keyCode)~=0
                    if (mod(subtask_number(j),3) == 0 && keyCode(KbName('LeftArrow'))) || (mod(subtask_number(j),3) ~= 0 && keyCode(KbName('RightArrow')))
                        correction(j) = correction(j)+1;
                    elseif (mod(subtask_number(j),3) == 0 && keyCode(KbName('RightArrow'))) || (mod(subtask_number(j),3) ~= 0 && keyCode(KbName('LeftArrow')))

                    else
                        if keyCode(KbName('ESCAPE'))
                            ShowCursor;
                            sca;
                        end

                    end
                    subtask_correction = sum(correction>0);
                end
                Screen('Flip', wptr);
            end
        end
        
        time_left = randi([1,3]);
        for jjj = 1:time_left*frame_rate
            for pic_index = 1:8
                motion_angle = pi*2*randperm(360, 8)/360;
                distance_x = 20*cos(motion_angle(pic_index));
                distance_y = 20*sin(motion_angle(pic_index));
                if pic_posi{pic_index}(1) + distance_x <=0 || pic_posi{pic_index}(1) + distance_x >= wRect(3)-80
                    distance_x = -distance_x;
                end
                if pic_posi{pic_index}(2) + distance_y <= 0 || pic_posi{pic_index}(2) + distance_y >= wRect(4) - 80
                    distance_y = -distance_y;
                end
                pic_posi{pic_index}(1) = pic_posi{pic_index}(1) + distance_x;
                pic_posi{pic_index}(2) = pic_posi{pic_index}(2) + distance_y;
                pic_posi{pic_index}(3) = pic_posi{pic_index}(1) + 80;
                pic_posi{pic_index}(4) = pic_posi{pic_index}(2) + 80;
            end
            for present_index = 1:8
                Screen('DrawTexture', wptr, pic_present{present_index}, [],  pic_posi{present_index});
            end
            
            Screen('Flip', wptr);
        end
        
        % 最终的判断
        for iii = 1:4
            DrawFormattedText(wptr,double(animal{pic_select(pic_red(iii))}),'center','center',[0,0,0]);
            Screen('Flip', wptr);
            WaitSecs(1);
            for index = 1:8
                Screen('DrawTexture', wptr, number_present{index}, [], pic_posi{index});
            end
            Screen('Flip',wptr);
            [~, keyCode] = KbWait();
            keyRecord{iii} = keyCode;
            if keyCode(KbName('ESCAPE'))
                fclose(fid);
                ShowCursor;
                sca;
            end
        end

        identity_correct = 0;
        position_correct = 0;

        for check_index = 1:4
            if keyRecord{check_index}(KbName([key{pic_red(check_index)}]))
                identity_correct  = identity_correct + 1;
            end
        end
        
        for check_index = 1:4
            if keyRecord{1}( KbName([key{pic_red(check_index)}]) ) || keyRecord{2}( KbName([key{pic_red(check_index)}]) ) || keyRecord{3}( KbName([key{pic_red(check_index)}]) ) || keyRecord{4}( KbName([key{pic_red(check_index)}]) )
                position_correct = position_correct + 1;
            end
        end

        % 数据记录
        fprintf(fid,'%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\r\n', num2str(subID), name, Gender, age, sub_type, subtask_type{i}, 'null', num2str(identity_correct), num2str(position_correct), num2str(subtask_correction));
        WaitSecs(1);
    end
end

% 关闭数据文件
    fclose(fid);

%% 结束语

DrawFormattedText(wptr,double(end_text),'center','center',[0,0,0]);
Screen('Flip',wptr);
WaitSecs(1);
ShowCursor;
Screen('CloseAll');

end