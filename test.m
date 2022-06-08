
Screen('Preference', 'SkipSyncTests', 1);    
HideCursor;
%打开窗口，设置参数
screenNumber=max(Screen('Screens'));
%Screen('Resolution',screenNumber,1024,768,60);
[wptr, wRect]=Screen('OpenWindow',screenNumber, 128,[],32,2);
[cx,cy]=WindowCenter(wptr);

pic_select = randperm(20,8); %随机选出八张图片
            
for pic_index = 1:8
    %每张图片的位置
    pic_x(pic_index) = randi([1/6 * cx, 5/3 *cx]);
    pic_y(pic_index) = randi([1/6 * cy, 5/3 *cy]);
    %绘制图片
    pic_present(pic_index) = Screen('MakeTexture',wptr,imread(['pic\', num2str(pic_index), '.png']));
end

% 第一次呈现图片
for present_index = 1:8
    Screen('DrawTexture', wptr, pic_present(present_index), [pic_x(present_index), pic_y(present_index), pic_x(present_index)+50, pic_y(present_index)+40 ]);
end
% Screen('Flip', wptr);

% 打标记的4张图片
pic_red = randperm(8, 4);
for red_index = 1:4
    Screen('Framerect', wptr, [255, 0, 0], [pic_x(present_index), pic_y(present_index), pic_x(present_index)+50, pic_y(present_index)+40 ] ); %画红线框
end

Screen('Flip', wptr);
WaitSecs(3);



ShowCursor;
sca;