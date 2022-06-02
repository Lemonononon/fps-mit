
Screen('Preference', 'SkipSyncTests', 1);    
HideCursor;
%打开窗口，设置参数
screenNumber=max(Screen('Screens'));
%Screen('Resolution',screenNumber,1024,768,60);
[wptr, wRect]=Screen('OpenWindow',screenNumber, 128,[],32,2);
Screen(wptr,'BlendFunction',GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
pic(img_read_index) = Screen('MakeTexture',wptr,imread(['pic\', char(img_read_index),'.png']));