.386
.model flat, stdcall
option casemap: none


; �����
includelib user32.lib
includelib gdi32.lib
includelib kernel32.lib
includelib msimg32.lib
includelib msvcrt.lib

; �����ļ�
include     pacman_define.inc
include     user32.inc
includelib	user32.lib
include     windows.inc
include     gdi32.inc
includelib	Gdi32.lib
include     kernel32.inc
includelib	kernel32.lib
include     msimg32.inc
include     msvcrt.inc
includelib msvcrt.lib
include     winmm.inc
includelib  winmm.lib

;TransparentBlt proto stdcall :HDC, :dword, :dword, :dword, :dword, :HDC, :dword, :dword, :dword, :dword, :UINT
; include paintmap.asm

; ��������
; ��ͼitem
Item_Empty equ 0
Item_Wall equ 1
Item_GhostHouse equ 2
Item_Bean equ 3
Item_SuperBean equ 4
; ǽ������
Wall_Corner_LeftUp equ 110
Wall_Corner_RightUp equ 111
Wall_Corner_LeftDown equ 112
Wall_Corner_RightDown equ 113
Wall_Horizontal equ 114
Wall_Vertical equ 115
; ��Ϸ״̬
Game_State_Ready equ 10
Game_State_Play equ 11
Game_State_Win equ 12
Game_State_Lose equ 13
Game_State_Pause equ 14

public mapX, mapY, mapGridWidth
public h_dc_bmp
public h_dc_buffer
public fps
public h_dc_pacman1_left, h_dc_pacman2_left, h_dc_pacman1_down, h_dc_pacman2_down, h_dc_pacman1_right, h_dc_pacman2_right, h_dc_pacman1_up, h_dc_pacman2_up
public h_dc_blinky_left, h_dc_blinky_down, h_dc_blinky_right, h_dc_blinky_up
public h_dc_blinky_left2, h_dc_blinky_down2, h_dc_blinky_right2, h_dc_blinky_up2
public h_dc_pinky_left, h_dc_pinky_down, h_dc_pinky_right, h_dc_pinky_up
public h_dc_pinky_left2, h_dc_pinky_down2, h_dc_pinky_right2, h_dc_pinky_up2
public h_dc_clyde_left, h_dc_clyde_down, h_dc_clyde_right, h_dc_clyde_up
public h_dc_clyde_left2, h_dc_clyde_down2, h_dc_clyde_right2, h_dc_clyde_up2
public h_dc_inky_left, h_dc_inky_down, h_dc_inky_right, h_dc_inky_up
public h_dc_inky_left2, h_dc_inky_down2, h_dc_inky_right2, h_dc_inky_up2
public h_dc_dazzled_down, h_dc_dazzled_left, h_dc_dazzled_right, h_dc_dazzled_up
public h_dc_dazzled_down2, h_dc_dazzled_left2, h_dc_dazzled_right2, h_dc_dazzled_up2
public h_dc_dead_left, h_dc_dead_down, h_dc_dead_right, h_dc_dead_up
public h_dc_cindy_left, h_dc_cindy_down, h_dc_cindy_right, h_dc_cindy_up
public h_dc_cindy_left2, h_dc_cindy_down2, h_dc_cindy_right2, h_dc_cindy_up2
public h_dc_redman1_down, h_dc_redman1_left, h_dc_redman1_right, h_dc_redman1_up
public h_dc_redman2_down, h_dc_redman2_left, h_dc_redman2_right, h_dc_redman2_up
public h_dc_redman3

public is_super_pacman, is_fast_pacman, is_invisible_pacman
public is_chasing_pacman

.data
;��������
str_class_name byte 'main_window', 0

pause_msg_title byte 'Pause', 0
gameover_msg_title byte 'Game Over', 0

win_msg byte 'Congratulations! Pac-Man has eaten all the dots.', 0
lose_msg byte 'Oh no! Better luck next time.', 0
pause_msg byte 'Game pause! Press -Enter- to continue', 0

str_main_caption   byte 200 dup(0)
str_main_caption_1 byte 'Pac-Man is currently searching for dots... Have fun!', 0
str_main_caption_2 byte 'Monsters are approaching you, stay vigilant!', 0
str_main_caption_3 byte 'Which way to go at the next corner? Think calmly!', 0
str_main_caption_4 byte 'Whats the use of bigger dots? Give it a try!', 0
str_main_caption_5 byte 'Collected all the dots to pass this level! Come on!', 0
str_main_caption_6 byte 'Watch out for the flashing monsters! They can still hurt you!', 0
str_main_caption_7 byte 'You have earned an extra life! How far can you go?', 0
str_main_caption_8 byte 'You have entered a bonus stage! Collect the fruits for extra points!', 0

;Image Path
pacman_icon byte './assert/PACMAN.ico', 0

background byte './assert/background.bmp', 0

pacman1_left byte './assert/pacman1_left.bmp', 0
pacman1_down byte './assert/pacman1_down.bmp', 0
pacman1_right byte './assert/pacman1_right.bmp', 0
pacman1_up byte './assert/pacman1_up.bmp', 0

pacman2_left byte './assert/pacman2_left.bmp', 0
pacman2_down byte './assert/pacman2_down.bmp', 0
pacman2_right byte './assert/pacman2_right.bmp', 0
pacman2_up byte './assert/pacman2_up.bmp', 0

redman1_down byte './assert/redman1_down.bmp', 0
redman1_left byte './assert/redman1_left.bmp', 0
redman1_right byte './assert/redman1_right.bmp', 0 
redman1_up byte './assert/redman1_up.bmp', 0
redman2_down byte './assert/redman2_down.bmp', 0
redman2_left byte './assert/redman2_left.bmp', 0
redman2_right byte './assert/redman2_right.bmp', 0
redman2_up byte './assert/redman2_up.bmp', 0
redman3 byte './assert/redman3.bmp', 0

blinky_left byte './assert/blinky_left.bmp', 0
blinky_down byte './assert/blinky_down.bmp', 0
blinky_right byte './assert/blinky_right.bmp', 0
blinky_up byte './assert/blinky_up.bmp', 0
blinky_left2 byte './assert/blinky_left2.bmp', 0
blinky_down2 byte './assert/blinky_down2.bmp', 0
blinky_right2 byte './assert/blinky_right2.bmp', 0
blinky_up2 byte './assert/blinky_up2.bmp', 0

pinky_left byte './assert/pinky_left.bmp', 0
pinky_down byte './assert/pinky_down.bmp', 0
pinky_right byte './assert/pinky_right.bmp', 0
pinky_up byte './assert/pinky_up.bmp', 0
pinky_up2 byte './assert/pinky_up2.bmp', 0
pinky_down2 byte './assert/pinky_down2.bmp', 0
pinky_left2 byte './assert/pinky_left2.bmp', 0
pinky_right2 byte './assert/pinky_right2.bmp', 0

inky_left byte './assert/inky_left.bmp', 0
inky_down byte './assert/inky_down.bmp', 0
inky_right byte './assert/inky_right.bmp', 0
inky_up byte './assert/inky_up.bmp', 0
inky_up2 byte './assert/inky_up2.bmp', 0
inky_down2 byte './assert/inky_down2.bmp', 0
inky_left2 byte './assert/inky_left2.bmp', 0
inky_right2 byte './assert/inky_right2.bmp', 0

clyde_left byte './assert/clyde_left.bmp', 0
clyde_down byte './assert/clyde_down.bmp', 0
clyde_right byte './assert/clyde_right.bmp', 0
clyde_up byte './assert/clyde_up.bmp', 0
clyde_left2 byte './assert/clyde_left2.bmp', 0
clyde_down2 byte './assert/clyde_down2.bmp', 0
clyde_right2 byte './assert/clyde_right2.bmp', 0
clyde_up2 byte './assert/clyde_up2.bmp', 0

cindy_left byte './assert/cindy_left.bmp', 0
cindy_down byte './assert/cindy_down.bmp', 0
cindy_right byte './assert/cindy_right.bmp', 0
cindy_up byte './assert/cindy_up.bmp', 0
cindy_left2 byte './assert/cindy_left2.bmp', 0
cindy_down2 byte './assert/cindy_down2.bmp', 0
cindy_right2 byte './assert/cindy_right2.bmp', 0
cindy_up2 byte './assert/cindy_up2.bmp', 0

dazzled_down byte './assert/dazzled_down.bmp', 0
dazzled_left byte './assert/dazzled_left.bmp', 0
dazzled_right byte './assert/dazzled_right.bmp', 0
dazzled_up byte './assert/dazzled_up.bmp', 0
dazzled_down2 byte './assert/dazzled_down2.bmp', 0
dazzled_left2 byte './assert/dazzled_left2.bmp', 0
dazzled_right2 byte './assert/dazzled_right2.bmp', 0
dazzled_up2 byte './assert/dazzled_up2.bmp', 0

dead_left byte './assert/dead_left.bmp', 0
dead_down byte './assert/dead_down.bmp', 0
dead_right byte './assert/dead_right.bmp', 0
dead_up byte './assert/dead_up.bmp', 0

FastBeanPath sbyte './assert/fastbean.bmp', 0
PortalPath sbyte './assert/portal.bmp', 0
InvisibleBeanPath sbyte './assert/invisiblebean.bmp', 0

; ���������ļ�
music_die sbyte '.\music\die.mp3', 0
music_eatghost sbyte '.\music\eatghost.mp3', 0
music_powerpill sbyte '.\music\powerpill.mp3', 0
music_theme sbyte '.\music\theme.mp3', 0
music_wake sbyte '.\music\wake.mp3', 0

.data
;�ⲿ��������
extern draw_list:draw_struct, draw_list_size:dword
extern game_state:dword
extern need_redraw:dword
extern player_PacMan:player_struct
extern player_RedMan:player_struct
extern player_Cindy:player_struct
extern item_map:dword 
extern score:dword
extern game_mode:dword
extern chase_target:dword
extern map_cols:dword                          ; ��ͼ�Ŀ���
extern map_rows:dword                    ; ��ͼ�ĸ߶�

.data
;in control_frame_rate draw_window
is_show dword 0         
is_buffer dword 1
fps dword 20000         ;!!!�����fps��������֡��!!!
dw1m dword 1000000      ;fps/dwlm=ÿn��ˢ��һ��,����Ϊÿ0.02��ˢ��һ��(֡��=50֡/s)
;in draw_window
buffer_index dword 0
buffer_cnt dword 0
;check_operation
pacman_dir dword 2
pacman_now_dir dword 2

; ���ӵ��߼�״̬����
is_super_pacman dword 0
superbean_time dword 10000000                ; time/dwlm=n(��)ʱ����
is_fast_pacman dword 0
fastbean_time dword 10000000
is_invisible_pacman dword 0
invisiblebean_time dword 10000000

switching_time dword 15000000
is_chasing_pacman dword 0
chasing_time dword 20000000
scatter_time dword 8000000

; �������ֶ���
play_die_music dword 0
play_eatghost_music dword 0
play_power_pill_music dword 0
play_theme_music dword 0
play_wake_music dword 0

; ��һ�ؿ���ʾ�����Զ��ر�ʱ��
is_gamenextstage dword 0
gamenextstage_time dword 5000000            ; 5��

; �ͷ���һ��ghost
release_nxt_ghost dword 0
firstghost_time dword 1000000
nextghost_time dword 3000000

.data
message sbyte 100 dup(0)
stdOutputHandle dword 0
format sbyte 'address %d', 0


.data
; ���ڼ���������
wndClassName sbyte 'PacMan', 0			; ��������
titleBarName sbyte 'Pac Man', 0			; ��������
windowX dword 200						; ����Xλ��
windowY dword 100						; ����Yλ��
windowWidth dword 900					; ���ڿ���
windowHeight dword 700					; ���ڸ߶�

playerX dword 100
playerY dword 100


mapGridWidth dword 20                   ; ��ͼһ��Ŀ���
mapX dword 10                           ; ��ͼ�ڴ����е�λ��
mapY dword 10

wallWidth dword 2                       ; ǽ�Ŀ���
wallColor dword 00FF9900h               ; ǽ����ɫ��00_B_G_R
wallSpecialColor dword 0000FF00h        ; ����ǽ����ɫ��00_B_G_R

beanHalfWidth dword 3                   ; ���鶹�Ŀ��ȵ�**һ��**
beahColor dword 0000FFFFh               ; ���鶹����ɫ
superBeanRadius dword 5                 ; Բ�ζ��İ뾶
superBeanColor dword 00FFFFFFh          ; Բ�ζ�����ɫ

hDc HDC ?
hMemoryDc HDC ?
hMemoryBitmap HBITMAP ?
stateSwitch dword 0                         ; ������ʾ�Զ��˻�����Ķ�̬�л�

textIsShow dword 1                          ; ����������˸Ч��ͨ���ñ�������

; ���������������
iconTop dword 100
iconRadius dword 60
iconColor dword 0000FFFFh
iconOpenSize dword 40
isIconOpening dword 0

gapBetweenIconAndGameName dword 10
gameName sbyte 'Pac-Man', 0
gameNameFontName sbyte 'Courier', 0
gameNameRectHeight dword 100
gameNameColor dword 00FFFFFFh

; ��Ϸģʽ������ģʽ��˫�˺���ģʽ��˫��׷��ģʽ
singleMode sbyte '����ģʽ', 0
doubleCooperateMode sbyte '˫�˺���ģʽ', 0
doubleChaseMode sbyte '˫��׷��ģʽ', 0
gapGameMode dword 10
gapBetweenGameNameAndGameMode dword 20
gameModeFontName sbyte '����', 0
gameModeRectHeight dword 20
gameModeColor dword 00FFFFFFh
gameModeSelect dword 000000FFh

; ��ʼ��Ϸ��ʾ
gapBetweenGameModeAndStartTip dword 10
startTip sbyte 'Press [Enter] to Start', 0
startTipFontName sbyte 'Courier', 0
startTipRectHeight dword 20
startTipColor dword 00CCCCCCh

;�رմ�����ʾ
gapBetweenFinalScoreAndCloseTip dword 40
closeTip sbyte 'Press [Enter] to Quit', 0
closeTipFontName sbyte 'Courier', 0
closeTipRectHeight dword 20
closeTipColor dword 00CCCCCCh

gapBetweenStartTipAndTeacher dword 80
teacher sbyte 'ָ����ʦ���Ż�ƽ', 0
teacherFontName sbyte '�����п�', 0
teacherRectHeight dword 30
teacherColor dword 0091FEFFh

gapBetweenTeacherAndAuthor dword 20
author sbyte 'С���Ա����Ӣ̩ ���ں� ����� ������', 0
authorFontName sbyte '����Ҧ��', 0
authorRectHeight dword 20
authorColor dword 00FFFFFFh

; �Ҳ������ز���
panelX dword 600
panelWidth dword 300
level dword 1
life dword 4
; scoreΪEXTERN����

; �Ҳ�����������
scoreStrTop dword 30
scoreStr sbyte 'SCORE', 0
scoreStrFontName sbyte 'Courier', 0
scoreStrRectHeight dword 40
scoreStrColor dword 000000FFh

gapBetweenScoreStrAndScoreNum dword 20
scoreNumFormat sbyte ' %d', 0
scoreNum sbyte 20 dup(0)
scoreNumFontName sbyte 'Courier', 0
scoreNumRectHeight dword 35
scoreNumColor dword 00FFFFFFh

gapBetweenScoreNumAndLevelStr dword 20
levelStr sbyte 'LEVEL', 0
levelStrFontName sbyte 'Courier', 0
levelStrRectHeight dword 40
levelStrColor dword 000000FFh

gapBetweenLevelStrAndLevelNum dword 20
levelNumFormat sbyte ' %d', 0
levelNum sbyte 20 dup(0)
levelNumFontName sbyte 'Courier', 0
levelNumRectHeight dword 35
levelNumColor dword 00FFFFFFh

gapBetweenLevelNumAndPauseStr dword 100
pauseStr sbyte 'PAUSE', 0
pauseStrFontName sbyte 'Courier', 0
pauseStrRectHeight dword 40
pauseStrColor dword 00FFFFFFh

gapBetweenPauseStrAndLifeStr dword 20
lifeStr sbyte 'LIFE', 0
lifeStrFontName sbyte 'Courier', 0
lifeStrRectHeight dword 40
lifeStrColor dword 000000FFh

gapBetweenLifeStrAndLifeNum dword 20
lifeNumFormat sbyte ' %d', 0
lifeNum sbyte 20 dup(0)
lifeNumFontName sbyte 'Courier', 0
lifeNumRectHeight dword 35
lifeNumColor dword 00FFFFFFh


; ���������������
gameOverTop dword 150
gameOver sbyte 'GAME OVER', 0
gameOverFontName sbyte 'Courier', 0
gameOverRectHeight dword 60
gameOverColor dword 00FFFFFFh

; ʤ�������������
gameWinTop dword 150
gameWin sbyte 'GRATS! YOU WIN', 0
gameWinFontName sbyte 'Courier', 0
gameWinRectHeight dword 60
gameWinColor dword 00FFFFFFh

; ��һ�ؿ������������
gameNxtStageTop dword 150
gameNxtStage sbyte 'GRATS! NEXT STAGE', 0
gameNxtStageFontName sbyte 'Courier', 0
gameNxtStageRectHeight dword 60
gameNxtStageColor dword 00FFFFFFh

; ���ص÷��������
gapBetweenGameNxtStageAndFinalScore dword 50
StageScoreFormat sbyte 'STAGE SCORE: %d', 0
StageScore sbyte 20 dup(0)
StageScoreFontName sbyte 'Courier', 0
StageScoreRectHeight dword 40
StageScoreColor dword 00FFFFFFh

; ���յ÷��������
gapBetweenGameOverAndFinalScore dword 50
gapBetweenGameWinAndFinalScore dword 50
finalScoreFormat sbyte 'FINAL SCORE: %d', 0
finalScore sbyte 20 dup(0)
finalScoreFontName sbyte 'Courier', 0
finalScoreRectHeight dword 40
finalScoreColor dword 00FFFFFFh
; mov [ebx], WndProc
; mov word ptr [ebx+2], cs
;invoke crt_sprintf, addr message, addr format, 10
;invoke crt_wcslen, addr message
;invoke WriteConsole, stdOutputHandle, addr message, eax, NULL, NULL

.data?
h_window_main dword ?
h_dc_background dword ?


h_dc_bmp dword ?
h_dc_bmp_size dword ?

h_dc_buffer dword buffer_size dup(?)
h_dc_buffer_size dword buffer_size dup(?)

h_dc_pacman1_left dword ?
h_dc_pacman1_down dword ?
h_dc_pacman1_right dword ?
h_dc_pacman1_up dword ?

h_dc_pacman2_left dword ?
h_dc_pacman2_down dword ?
h_dc_pacman2_right dword ?
h_dc_pacman2_up dword ?

h_dc_blinky_left dword ?
h_dc_blinky_down dword ?
h_dc_blinky_right dword ?
h_dc_blinky_up dword ?
h_dc_blinky_left2 dword ?
h_dc_blinky_down2 dword ?
h_dc_blinky_right2 dword ?
h_dc_blinky_up2 dword ?

h_dc_pinky_left dword ?
h_dc_pinky_down dword ?
h_dc_pinky_right dword ?
h_dc_pinky_up dword ?
h_dc_pinky_up2 dword ?
h_dc_pinky_down2 dword ?
h_dc_pinky_left2 dword ?
h_dc_pinky_right2 dword ?

h_dc_inky_left dword ?
h_dc_inky_down dword ?
h_dc_inky_right dword ?
h_dc_inky_up dword ?
h_dc_inky_up2 dword ?
h_dc_inky_down2 dword ?
h_dc_inky_left2 dword ?
h_dc_inky_right2 dword ?

h_dc_clyde_left dword ?
h_dc_clyde_down dword ?
h_dc_clyde_right dword ?
h_dc_clyde_up dword ?
h_dc_clyde_left2 dword ?
h_dc_clyde_down2 dword ?
h_dc_clyde_right2 dword ?
h_dc_clyde_up2 dword ?

h_dc_cindy_left dword ?
h_dc_cindy_down dword ?
h_dc_cindy_right dword ?
h_dc_cindy_up dword ?
h_dc_cindy_left2 dword ?
h_dc_cindy_down2 dword ?
h_dc_cindy_right2 dword ?
h_dc_cindy_up2 dword ?

h_dc_redman1_down dword ?
h_dc_redman1_left dword ?
h_dc_redman1_right dword ?
h_dc_redman1_up dword ?
h_dc_redman2_down dword ?
h_dc_redman2_left dword ?
h_dc_redman2_right dword ?
h_dc_redman2_up dword ?

h_dc_redman3 dword ?

h_dc_dazzled_down dword ?
h_dc_dazzled_left dword ?
h_dc_dazzled_right dword ?
h_dc_dazzled_up dword ?
h_dc_dazzled_down2 dword ?
h_dc_dazzled_left2 dword ?
h_dc_dazzled_right2 dword ?
h_dc_dazzled_up2 dword ?

h_dc_dead_down dword ?
h_dc_dead_left dword ?
h_dc_dead_right dword ?
h_dc_dead_up dword ?

h_dc_start_up dword ?
h_dc_game_over dword ?
h_dc_map_and_bean dword ?
h_dc_panel dword ?

.code
;�����ⲿ����
;C��׼�⺯��
printf PROTO C :dword, :vararg
srand PROTO C :dword
rand PROTO C

;pacman_animation.asm
draw_item PROTO :draw_struct,:dword

;pacman_logic.asm
draw_map PROTO   
init_map PROTO
speed_down_pacman PROTO
enter_frightened PROTO
end_frightened PROTO
cycle_to_chase PROTO
cycle_to_scatter PROTO
release_ghost PROTO
end_invisible_pacman PROTO

;pacman_music.asm
playMusic PROTO :ptr sbyte, :dword
closeMusic PROTO :dword
pauseMusic PROTO :dword
resumeMusic PROTO :dword
setAudioMusic PROTO :dword, :dword
pauseAllMusic PROTO
resumeAllMusic PROTO
setAudioAllMusic PROTO :dword
closeAllMusic PROTO
playDieMusic PROTO
playDieMusic PROTO
playEatghostMusic PROTO
playPowerpillMusic PROTO
playThemeMusic PROTO
playWakeMusic PROTO

.code
create_background proc uses esi edi eax, h_dc:HDC
    local @cnt:dword
    local h_bmp

    ;��δ����Ŀ���Ǵ���һ���豸������Device Context��DC�������������ڴ洢Ԥ��Ⱦ��ͼ��
    ;�������ĺô��ǿ������ͼ����Ƶ�Ч�ʡ�ͨ��Ԥ�ȴ����豸������λͼ��
    ;���Ա����ڻ���ͼ��ʱƵ���ش�����ɾ��GDI���󣬴Ӷ�������ܡ����ּ���ͨ������ͼ
    ;���ܼ��͵�Ӧ�ó�������Ϸ���߶�����������Ҫ���������ػ���ͼ��
    mov @cnt, 0
    mov esi, offset h_dc_buffer
    mov edi, offset h_dc_buffer_size
    .while @cnt != buffer_size
        invoke	CreateCompatibleDC, h_dc
        mov	[esi], eax
        invoke CreateCompatibleBitmap, h_dc, windowWidth, windowHeight
        mov [edi], eax
        invoke	SelectObject,[esi],[edi]
        invoke SetStretchBltMode,[esi],HALFTONE ;HALFTONE �� Windows GDI��ͼ���豸�ӿڣ��е�һ��λͼ����ģʽ
        add esi, 4
        add edi, 4
        inc @cnt
    .endw

    invoke	CreateCompatibleDC, h_dc    ;������h_dc���ݵ��ڴ��豸������,�����ڴ��豸�����ĵľ��
	mov	h_dc_background, eax
    invoke LoadImage, NULL, addr background, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_background, h_bmp
    invoke DeleteObject, h_bmp

    invoke	CreateCompatibleDC, h_dc
    mov h_dc_start_up, eax
    invoke CreateCompatibleBitmap, h_dc, windowWidth, windowHeight
    mov h_bmp, eax
    invoke SelectObject, h_dc_start_up, h_bmp
    invoke DeleteObject, h_bmp

    invoke	CreateCompatibleDC, h_dc
    mov h_dc_game_over, eax
    invoke CreateCompatibleBitmap, h_dc, windowWidth, windowHeight
    mov h_bmp, eax
    invoke SelectObject, h_dc_game_over, h_bmp
    invoke DeleteObject, h_bmp

    invoke	CreateCompatibleDC, h_dc
    mov h_dc_map_and_bean, eax
    invoke CreateCompatibleBitmap, h_dc, windowWidth, windowHeight
    mov h_bmp, eax
    invoke SelectObject, h_dc_map_and_bean, h_bmp
    invoke DeleteObject, h_bmp

    invoke	CreateCompatibleDC, h_dc
    mov h_dc_panel, eax
    invoke CreateCompatibleBitmap, h_dc, windowWidth, windowHeight
    mov h_bmp, eax
    invoke SelectObject, h_dc_panel, h_bmp
    invoke DeleteObject, h_bmp

    ; ���ر���λͼ�������ص�ָ���Ľ�����������
    invoke	CreateCompatibleDC, h_dc
	mov	h_dc_bmp, eax
    invoke CreateCompatibleBitmap, h_dc, windowWidth, windowHeight
    mov h_dc_bmp_size, eax
    invoke  SelectObject,h_dc_bmp,h_dc_bmp_size
    invoke  SetStretchBltMode,h_dc_bmp,COLORONCOLOR
    ;����λͼʱ����ɾ���������λͼ����ɫ����ʹ��Ŀ���豸��������ӽ�����ɫ���滻��
    ;����ģʽ�����ڼ�������λͼʱ����ɫʧ�档

    ;���سԶ��˺͹����λͼ��Դ�������ص�ָ��������������
    invoke	CreateCompatibleDC, h_dc      
	mov	h_dc_pacman1_left, eax
    invoke	CreateCompatibleDC, h_dc
    mov h_dc_pacman1_down, eax
    invoke	CreateCompatibleDC, h_dc
    mov h_dc_pacman1_right, eax
    invoke	CreateCompatibleDC, h_dc
    mov h_dc_pacman1_up, eax

    invoke	CreateCompatibleDC, h_dc
	mov	h_dc_pacman2_left, eax
    invoke	CreateCompatibleDC, h_dc
    mov h_dc_pacman2_down, eax
    invoke	CreateCompatibleDC, h_dc
    mov h_dc_pacman2_right, eax
    invoke	CreateCompatibleDC, h_dc
    mov h_dc_pacman2_up, eax

    invoke	CreateCompatibleDC, h_dc
	mov	h_dc_blinky_left, eax
    invoke	CreateCompatibleDC, h_dc
    mov h_dc_blinky_down, eax
    invoke	CreateCompatibleDC, h_dc
    mov h_dc_blinky_right, eax
    invoke	CreateCompatibleDC, h_dc
    mov h_dc_blinky_up, eax
    invoke	CreateCompatibleDC, h_dc
    mov h_dc_blinky_left2, eax
    invoke    CreateCompatibleDC, h_dc
    mov h_dc_blinky_down2, eax
    invoke    CreateCompatibleDC, h_dc
    mov h_dc_blinky_right2, eax
    invoke    CreateCompatibleDC, h_dc
    mov h_dc_blinky_up2, eax

    invoke	CreateCompatibleDC, h_dc
	mov	h_dc_pinky_left, eax
    invoke	CreateCompatibleDC, h_dc
    mov h_dc_pinky_down, eax
    invoke	CreateCompatibleDC, h_dc
    mov h_dc_pinky_right, eax
    invoke	CreateCompatibleDC, h_dc
    mov h_dc_pinky_up, eax
    invoke	CreateCompatibleDC, h_dc
    mov h_dc_pinky_left2, eax
    invoke    CreateCompatibleDC, h_dc
    mov h_dc_pinky_down2, eax
    invoke    CreateCompatibleDC, h_dc
    mov h_dc_pinky_right2, eax
    invoke    CreateCompatibleDC, h_dc
    mov h_dc_pinky_up2, eax

    invoke	CreateCompatibleDC, h_dc
	mov	h_dc_inky_left, eax
    invoke	CreateCompatibleDC, h_dc
    mov h_dc_inky_down, eax
    invoke	CreateCompatibleDC, h_dc
    mov h_dc_inky_right, eax
    invoke	CreateCompatibleDC, h_dc
    mov h_dc_inky_up, eax
    invoke    CreateCompatibleDC, h_dc
    mov h_dc_inky_left2, eax
    invoke    CreateCompatibleDC, h_dc
    mov h_dc_inky_down2, eax
    invoke    CreateCompatibleDC, h_dc
    mov h_dc_inky_right2, eax
    invoke    CreateCompatibleDC, h_dc
    mov h_dc_inky_up2, eax

    invoke	CreateCompatibleDC, h_dc
	mov	h_dc_clyde_left, eax
    invoke	CreateCompatibleDC, h_dc
    mov h_dc_clyde_down, eax
    invoke	CreateCompatibleDC, h_dc
    mov h_dc_clyde_right, eax
    invoke	CreateCompatibleDC, h_dc
    mov h_dc_clyde_up, eax
    invoke    CreateCompatibleDC, h_dc
    mov h_dc_clyde_left2, eax
    invoke    CreateCompatibleDC, h_dc
    mov h_dc_clyde_down2, eax
    invoke    CreateCompatibleDC, h_dc
    mov h_dc_clyde_right2, eax
    invoke    CreateCompatibleDC, h_dc
    mov h_dc_clyde_up2, eax

    invoke CreateCompatibleDC, h_dc
    mov h_dc_cindy_left, eax
    invoke CreateCompatibleDC, h_dc
    mov h_dc_cindy_down, eax
    invoke CreateCompatibleDC, h_dc
    mov h_dc_cindy_right, eax
    invoke CreateCompatibleDC, h_dc
    mov h_dc_cindy_up, eax
    invoke CreateCompatibleDC, h_dc
    mov h_dc_cindy_left2, eax
    invoke CreateCompatibleDC, h_dc
    mov h_dc_cindy_down2, eax
    invoke CreateCompatibleDC, h_dc
    mov h_dc_cindy_right2, eax
    invoke CreateCompatibleDC, h_dc
    mov h_dc_cindy_up2, eax

    invoke CreateCompatibleDC, h_dc
    mov h_dc_redman1_down, eax
    invoke CreateCompatibleDC, h_dc
    mov h_dc_redman1_left, eax
    invoke CreateCompatibleDC, h_dc
    mov h_dc_redman1_right, eax
    invoke CreateCompatibleDC, h_dc
    mov h_dc_redman1_up, eax
    invoke CreateCompatibleDC, h_dc
    mov h_dc_redman2_down, eax 
    invoke CreateCompatibleDC, h_dc 
    mov h_dc_redman2_left, eax
    invoke CreateCompatibleDC, h_dc
    mov h_dc_redman2_right, eax
    invoke CreateCompatibleDC, h_dc
    mov h_dc_redman2_up, eax

    invoke CreateCompatibleDC, h_dc
    mov h_dc_redman3, eax

    invoke    CreateCompatibleDC, h_dc
    mov h_dc_dazzled_down, eax
    invoke    CreateCompatibleDC, h_dc
    mov h_dc_dazzled_left, eax
    invoke    CreateCompatibleDC, h_dc
    mov h_dc_dazzled_right, eax
    invoke    CreateCompatibleDC, h_dc
    mov h_dc_dazzled_up, eax
    invoke    CreateCompatibleDC, h_dc
    mov h_dc_dazzled_down2, eax
    invoke    CreateCompatibleDC, h_dc
    mov h_dc_dazzled_left2, eax
    invoke    CreateCompatibleDC, h_dc
    mov h_dc_dazzled_right2, eax
    invoke    CreateCompatibleDC, h_dc
    mov h_dc_dazzled_up2, eax


    invoke    CreateCompatibleDC, h_dc
    mov h_dc_dead_down, eax
    invoke    CreateCompatibleDC, h_dc
    mov h_dc_dead_left, eax
    invoke    CreateCompatibleDC, h_dc
    mov h_dc_dead_right, eax
    invoke    CreateCompatibleDC, h_dc
    mov h_dc_dead_up, eax


invoke LoadImage, NULL, addr pacman1_left, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
mov h_bmp, eax
invoke SelectObject, h_dc_pacman1_left, h_bmp
invoke DeleteObject, h_bmp

invoke LoadImage, NULL, addr pacman1_down, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
mov h_bmp, eax
invoke SelectObject, h_dc_pacman1_down, h_bmp
invoke DeleteObject, h_bmp

invoke LoadImage, NULL, addr pacman1_right, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
mov h_bmp, eax
invoke SelectObject, h_dc_pacman1_right, h_bmp
invoke DeleteObject, h_bmp

invoke LoadImage, NULL, addr pacman1_up, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
mov h_bmp, eax
invoke SelectObject, h_dc_pacman1_up, h_bmp
invoke DeleteObject, h_bmp

invoke LoadImage, NULL, addr pacman2_left, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
mov h_bmp, eax
invoke SelectObject, h_dc_pacman2_left, h_bmp
invoke DeleteObject, h_bmp

invoke LoadImage, NULL, addr pacman2_down, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
mov h_bmp, eax
invoke SelectObject, h_dc_pacman2_down, h_bmp
invoke DeleteObject, h_bmp

invoke LoadImage, NULL, addr pacman2_right, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
mov h_bmp, eax
invoke SelectObject, h_dc_pacman2_right, h_bmp
invoke DeleteObject, h_bmp

invoke LoadImage, NULL, addr pacman2_up, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
mov h_bmp, eax
invoke SelectObject, h_dc_pacman2_up, h_bmp
invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr blinky_left, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_blinky_left, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr blinky_down, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_blinky_down, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr blinky_right, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_blinky_right, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr blinky_up, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_blinky_up, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr blinky_left2, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_blinky_left2, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr blinky_down2, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_blinky_down2, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr blinky_right2, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_blinky_right2, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr blinky_up2, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_blinky_up2, h_bmp
    invoke DeleteObject, h_bmp



    invoke LoadImage, NULL, addr pinky_left, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_pinky_left, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr pinky_down, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_pinky_down, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr pinky_right, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_pinky_right, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr pinky_up, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_pinky_up, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr pinky_left2, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_pinky_left2, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr pinky_down2, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_pinky_down2, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr pinky_right2, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_pinky_right2, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr pinky_up2, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_pinky_up2, h_bmp
    invoke DeleteObject, h_bmp



    invoke LoadImage, NULL, addr inky_left, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_inky_left, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr inky_down, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_inky_down, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr inky_right, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_inky_right, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr inky_up, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_inky_up, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr inky_left2, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_inky_left2, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr inky_down2, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_inky_down2, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr inky_right2, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_inky_right2, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr inky_up2, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_inky_up2, h_bmp
    invoke DeleteObject, h_bmp



    invoke LoadImage, NULL, addr clyde_left, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_clyde_left, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr clyde_down, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_clyde_down, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr clyde_right, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_clyde_right, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr clyde_up, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_clyde_up, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr clyde_left2, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_clyde_left2, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr clyde_down2, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_clyde_down2, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr clyde_right2, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_clyde_right2, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr clyde_up2, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_clyde_up2, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr cindy_left, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED 
    mov h_bmp, eax
    invoke SelectObject, h_dc_cindy_left, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr cindy_down, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_cindy_down, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr cindy_right, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_cindy_right, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr cindy_up, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_cindy_up, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr cindy_left2, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_cindy_left2, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr cindy_down2, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_cindy_down2, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr cindy_right2, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_cindy_right2, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr cindy_up2, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_cindy_up2, h_bmp
    invoke DeleteObject, h_bmp



    invoke LoadImage, NULL, addr redman1_down, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_redman1_down, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr redman1_left, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_redman1_left, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr redman1_right, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_redman1_right, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr redman1_up, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_redman1_up, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr redman2_down, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_redman2_down, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr redman2_left, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_redman2_left, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr redman2_right, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_redman2_right, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr redman2_up, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_redman2_up, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr redman3, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_redman3, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr dazzled_down, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_dazzled_down, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr dazzled_left, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_dazzled_left, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr dazzled_right, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_dazzled_right, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr dazzled_up, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_dazzled_up, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr dazzled_down2, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_dazzled_down2, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr dazzled_left2, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_dazzled_left2, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr dazzled_right2, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_dazzled_right2, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr dazzled_up2, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_dazzled_up2, h_bmp
    invoke DeleteObject, h_bmp


        invoke LoadImage, NULL, addr dead_down, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax  
    invoke SelectObject, h_dc_dead_down, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr dead_left, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_dead_left, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr dead_right, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_dead_right, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr dead_up, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_dead_up, h_bmp
    invoke DeleteObject, h_bmp

    invoke init_map
    ret 
create_background endp

getNum proc uses ebx ecx edx, _i: dword, _j: dword
; ��ȡ��ͼ��(i, j)����Ԫ�أ����Խ���򷵻�Item_Wall
    mov ecx, map_rows
    mov edx, map_cols
    .if (_i >= 0 && _i < ecx) && (_j >= 0 && _j < edx)
        mov eax, _i
        mul dl
        add eax, _j
        mov ebx, offset item_map
        mov eax, [ebx+(size item_map)*eax]
        ret
    .else
        mov eax, Item_Wall
        ret
    .endif
getNum endp


getBorderType proc uses ebx ecx edx esi, _i: dword, _j: dword, _wallNum
; �жϱ߽�����
; ����ֵ��0��ʾ����ǽ�ı߽�, 1��ʾ�Ǵ�ֱ����, 2��ʾ��ˮƽ����
; 3��ʾ����Բ��, 4��ʾ����Բ����5��ʾ����Բ����6��ʾ����Բ��
    local @iSub1, @iAdd1, @jSub1, @jAdd1, @upLeft, @upRight, @downLeft, @downRight, \
        @up, @down, @left, @right
    mov esi, _wallNum
    ; Ϊ@iSub1, @iAdd1, @jSub1, @jAdd1���и�ֵ
    mov ebx, _i
    mov @iSub1, ebx
    dec @iSub1
    mov @iAdd1, ebx
    inc @iAdd1
    mov ecx, _j
    mov @jSub1, ecx
    dec @jSub1
    mov @jAdd1, ecx
    inc @jAdd1

    invoke getNum, ebx, ecx
    .if eax == _wallNum                        ; ��ǰ���ֵΪ1ʱ�ſ���Ϊ�߽�
        invoke getNum, @iSub1, @jSub1
        mov @upLeft, eax
        invoke getNum, @iSub1, ecx
        mov @up, eax
        invoke getNum, @iSub1, @jAdd1
        mov @upRight, eax
        invoke getNum, ebx, @jSub1
        mov @left, eax
        invoke getNum, ebx, @jAdd1
        mov @right, eax
        invoke getNum, @iAdd1, @jSub1
        mov @downLeft, eax
        invoke getNum, @iAdd1, ecx
        mov @down, eax
        invoke getNum, @iAdd1, @jAdd1
        mov @downRight, eax
        ; ��������ܴ���0ʱ���Ǳ߽磬������Ը�Ϊ != 1
        .if @upLeft != esi || @up != esi || @upRight != esi || @left != esi || \
            @right != esi || @downLeft != esi || @down != esi || @downRight != esi
            jmp isABorder
        .endif
    .endif
    xor eax, eax
    ret

isABorder:
    
    .if @right == esi && @down == esi && \
        (@downRight != esi || @upLeft != esi && @left != esi && @up != esi)
        mov eax, Wall_Corner_LeftUp
        ret
    .elseif @left == esi && @down == esi && \
        (@downLeft != esi || @upRight != esi && @up != esi && @right != esi)
        mov eax, Wall_Corner_RightUp
        ret
    .elseif @up == esi && @right == esi && \ 
        (@upRight != esi || @downLeft != esi && @left != esi && @down != esi)
        mov eax, Wall_Corner_LeftDown
        ret
    .elseif @up == esi && @left == esi && \ 
        (@upLeft != esi || @downRight != esi && @down != esi && @right != esi)
        mov eax, Wall_Corner_RightDown
        ret
    .elseif (@left == esi || @right == esi) && (@up != esi || @down != esi)
        mov eax, Wall_Horizontal
        ret
    .elseif (@up == esi || @down == esi) && (@left != esi || @right != esi) 
        mov eax, Wall_Vertical
        ret
    .endif

    xor eax, eax
    ret
getBorderType endp


paintLine proc, _hDc: HDC, _i: dword, _j: dword, _type: dword
; ���ߺ���������_type������ֱ�߻�ˮƽ��
    local @startX: dword, @startY: dword, @endX: dword, @endY: dword
    pushad

    ; ��@startX��@endX��ʼ��Ϊ�������Ͻ�
    mov eax, mapGridWidth

    mov edx, mapX
    mov @startX, edx
    mul byte ptr _j
    add @startX, eax
    mov edx, @startX
    mov @endX, edx

    ; ��@startY��@endY��ʼ��Ϊ�������Ͻ�
    mov eax, mapGridWidth

    mov edx, mapY
    mov @startY, edx
    mul byte ptr _i
    add @startY, eax
    mov edx, @startY
    mov @endY, edx

    ; ecx�д��һ��Ŀ��ȣ�eax��Ű��Ŀ���
    mov eax, mapGridWidth
    mov ecx, eax        ; ecx���һ��Ŀ���
    mov dl, 2
    div dl
    and eax, 000000FFh  ; eax��Ű��Ŀ���


    .if _type == Wall_Vertical      ; ��ֱ��
        add @startX, eax
        add @endX, eax
        add @endY, ecx
    .else                           ; ˮƽ��
        add @startY, eax
        add @endX, ecx
        add @endY, eax
    .endif

    invoke MoveToEx, _hDc, @startX, @startY, NULL
    invoke LineTo, _hDc, @endX, @endY
    popad
    ret
paintLine endp


paintArc proc, _hDc:dword, _i: dword, _j: dword, _type: dword
; ��Բ�ǣ�����_type������ͬ���͵�Բ��
; _typeΪ3��ʾ����Բ��, _typeΪ4��ʾ����Բ����_typeΪ5��ʾ����Բ����_typeΪ6��ʾ����Բ��
    local @nLeftRect: dword, @nTopRect: dword, @nRightRect: dword, @nBottomRect: dword, \
        @nXStartArc: dword, @nYStartArc: dword, @nXEndArc: dword, @nYEndArc: dword
    pushad
    ; ��ʼ��@nLeftRect��@nRightRect��@nXStartArc��@nXEndArc��ʼ��Ϊ���Ͻ�
    mov eax, mapGridWidth

    mov edx, mapX
    mov @nLeftRect, edx
    mul byte ptr _j
    add @nLeftRect, eax
    mov edx, @nLeftRect
    mov @nRightRect, edx
    mov @nXStartArc, edx
    mov @nXEndArc, edx

    ; ��ʼ��@nTopRect��@nBottomRect��@nYStartArc��@nYEndArc��ʼ��Ϊ���Ͻ�
    mov eax, mapGridWidth

    mov edx, mapY
    mov @nTopRect, edx
    mul byte ptr _i
    add @nTopRect, eax
    mov edx, @nTopRect
    mov @nBottomRect, edx
    mov @nYStartArc, edx
    mov @nYEndArc, edx

    ; ecx�д��һ��Ŀ��ȣ�eax��Ű��Ŀ���
    mov eax, mapGridWidth
    mov ecx, eax        ; ecx���һ��Ŀ���
    mov dl, 2
    div dl
    and eax, 000000FFh  ; eax��Ű��Ŀ���

    .if _type == Wall_Corner_LeftUp
        add @nLeftRect, eax
        add @nTopRect, eax
        add @nRightRect, ecx
        add @nRightRect, eax
        add @nBottomRect, ecx
        add @nBottomRect, eax

        add @nXStartArc, ecx
        add @nYStartArc, eax
        add @nXEndArc, eax
        add @nYEndArc, ecx
    .elseif _type == Wall_Corner_RightUp
        sub @nLeftRect, eax
        add @nTopRect, eax
        add @nRightRect, eax
        add @nBottomRect, ecx
        add @nBottomRect, eax

        add @nXStartArc, eax
        add @nYStartArc, ecx
        add @nYEndArc, eax
    .elseif _type == Wall_Corner_LeftDown
        add @nLeftRect, eax
        sub @nTopRect, eax
        add @nRightRect, eax
        add @nRightRect, ecx
        add @nBottomRect, eax

        add @nXStartArc, eax
        add @nXEndArc, ecx
        add @nYEndArc, eax
    .elseif _type == Wall_Corner_RightDown
        sub @nLeftRect, eax
        sub @nTopRect, eax
        add @nRightRect, eax
        add @nBottomRect, eax

        add @nYStartArc, eax
        add @nXEndArc, eax
    .endif
    
    invoke Arc, _hDc, @nLeftRect, @nTopRect, @nRightRect, @nBottomRect, \
        @nXStartArc, @nYStartArc, @nXEndArc, @nYEndArc
    popad
    ret
paintArc endp


paintPoint proc, _hDc:dword, _i: dword, _j: dword, _type: dword
; ���㣬���_typeΪItem_Bean�򻭾��Σ����_typeΪItem_SuperBean��Բ
    local @nLeftRect: dword, @nTopRect: dword, @nRightRect: dword, @nBottomRect: dword
    local @x, @y, @hOldImage, @hImage, @hCDc, @width
    pushad

    ; ��ʼ��@nLeftRect��@nRightRect��ʼ��Ϊ���Ͻ�
    mov eax, mapGridWidth

    mov @width, eax
    mov eax, @width
    mov dx, 2
    mul dx
    mov @width, eax
    sub @width, 4

    mov eax, mapGridWidth
    mov edx, mapX
    mov @nLeftRect, edx
    mul byte ptr _j
    add @nLeftRect, eax
    mov edx, @nLeftRect
    mov @nRightRect, edx
    mov @x, edx

    ; ��ʼ��@nTopRect��@nBottomRect��ʼ��Ϊ���Ͻ�
    mov eax, mapGridWidth

    mov edx, mapY
    mov @nTopRect, edx
    mul byte ptr _i
    add @nTopRect, eax
    mov edx, @nTopRect
    mov @nBottomRect, edx
    mov @y, edx

    ; ecx�д��һ��Ŀ��ȣ�eax��Ű��Ŀ���
    mov eax, mapGridWidth
    mov ecx, eax        ; ecx���һ��Ŀ���
    mov dl, 2
    div dl
    and eax, 000000FFh  ; eax��Ű��Ŀ���

    ; ��@nLeftRect��@nRightRect��@nTopRect��@nBottomRect��ʼ��Ϊ����
    add @nLeftRect, eax
    add @nTopRect, eax
    add @nRightRect, eax
    add @nBottomRect, eax

    .if _type == Item_Bean
        mov edx, beanHalfWidth
        sub @nLeftRect, edx
        sub @nTopRect, edx
        add @nRightRect, edx
        add @nBottomRect, edx 
        
        invoke Rectangle, _hDc, @nLeftRect, @nTopRect, @nRightRect, @nBottomRect
    .elseif _type == Item_SuperBean
        mov edx, superBeanRadius
        sub @nLeftRect, edx
        sub @nTopRect, edx
        add @nRightRect, edx
        add @nBottomRect, edx

        invoke Ellipse, _hDc, @nLeftRect, @nTopRect, @nRightRect, @nBottomRect
    .elseif _type == Item_Portal
        sub @x, eax
        sub @y, eax
        add @x, 2
        add @y, 2

        invoke CreateCompatibleDC, _hDc
        mov  @hCDc, eax
        invoke LoadImage, NULL, addr PortalPath, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
        mov @hImage, eax
        invoke SelectObject, @hCDc, @hImage
        mov @hOldImage, eax

        ; *******************************************************************  ���볣�� **************************************************************
        invoke TransparentBlt, _hDc, @x, @y, @width, @width, @hCDc, 0, 0, Portal_Path_Size, Portal_Path_Size, 0

        invoke SelectObject, @hCDc, @hOldImage
        invoke DeleteObject, @hImage
        invoke DeleteDC, @hCDc
    .elseif _type == Item_FastBean
        sub @x, eax
        sub @y, eax
        ;add @x, 2
        ;add @y, 2

        invoke CreateCompatibleDC, _hDc
        mov  @hCDc, eax
        invoke LoadImage, NULL, addr FastBeanPath, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
        mov @hImage, eax
        invoke SelectObject, @hCDc, @hImage
        mov @hOldImage, eax
        ; *******************************************************************  ���볣�� **************************************************************
        invoke TransparentBlt, _hDc, @x, @y, @width, @width, @hCDc, 0, 0, Fast_Bean_Size, Fast_Bean_Size, 0

        invoke SelectObject, @hCDc, @hOldImage
        invoke DeleteObject, @hImage
        invoke DeleteDC, @hCDc
    .elseif _type == Item_InvisibleBean
        sub @x, eax
        sub @y, eax
        ;add @x, 2
        ;add @y, 2

        invoke CreateCompatibleDC, _hDc
        mov  @hCDc, eax
        invoke LoadImage, NULL, addr InvisibleBeanPath, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
        mov @hImage, eax
        invoke SelectObject, @hCDc, @hImage
        mov @hOldImage, eax
        ; *******************************************************************  ���볣�� **************************************************************
        invoke TransparentBlt, _hDc, @x, @y, @width, @width, @hCDc, 0, 0, 40, 50, 0

        invoke SelectObject, @hCDc, @hOldImage
        invoke DeleteObject, @hImage
        invoke DeleteDC, @hCDc
    .endif
    popad
    ret
paintPoint endp


paintBean proc, _hDc: HDC
; ������
    local @hPen: HPEN, @hOldPen: HPEN, @hBrush: HBRUSH, @hOldBrush: HBRUSH
    pushad

    invoke CreateSolidBrush, superBeanColor
    mov @hBrush, eax
    invoke SelectObject, _hDc, @hBrush
    mov @hOldBrush, eax
    invoke CreatePen, PS_SOLID, 1, superBeanColor
    mov @hPen, eax
    invoke SelectObject, _hDc, @hPen
    mov @hOldPen, eax

    xor ebx, ebx    ; ���ѭ������i
    .while ebx < map_rows
        xor ecx, ecx    ; �ڲ�ѭ������j
        .while ecx < map_cols
            
            invoke getNum, ebx, ecx
            .if eax == Item_SuperBean || eax == Item_Portal || eax ==  Item_FastBean || eax == Item_InvisibleBean
                invoke paintPoint, _hDc, ebx, ecx, eax
            .endif

            inc ecx
        .endw
        inc ebx    
    .endw

    invoke SelectObject, _hDc, @hOldPen
    invoke DeleteObject, @hPen
    invoke SelectObject, _hDc, @hOldBrush
    invoke DeleteObject, @hBrush

    invoke CreateSolidBrush, beahColor
    mov @hBrush, eax
    invoke SelectObject, _hDc, @hBrush
    mov @hOldBrush, eax
    invoke CreatePen, PS_SOLID, 1, beahColor
    mov @hPen, eax
    invoke SelectObject, _hDc, @hPen
    mov @hOldPen, eax

    xor ebx, ebx    ; ���ѭ������i
    .while ebx < map_rows
        xor ecx, ecx    ; �ڲ�ѭ������j
        .while ecx < map_cols
            
            invoke getNum, ebx, ecx
            .if eax == Item_Bean
                invoke paintPoint, _hDc, ebx, ecx, Item_Bean
            .endif

            inc ecx
        .endw
        inc ebx    
    .endw
    
    invoke SelectObject, _hDc, @hOldPen
    invoke DeleteObject, @hPen
    invoke SelectObject, _hDc, @hOldBrush
    invoke DeleteObject, @hBrush

    popad
    ret
paintBean endp


paintMap proc, _hDc: HDC
; ����ͼ
    local @hPen: HPEN, @hOldPen
    pushad

    invoke CreatePen, PS_SOLID, wallWidth, wallColor
    mov @hPen, eax

    invoke SelectObject, _hDc, @hPen
    mov @hOldPen, eax
    
    xor ebx, ebx    ; ���ѭ������i
    .while ebx < map_rows
        xor ecx, ecx    ; �ڲ�ѭ������j
        .while ecx < map_cols
            
            invoke getBorderType, ebx, ecx, Item_Wall
            .if eax == Wall_Horizontal
                invoke paintLine, _hDc, ebx, ecx, Wall_Horizontal
            .elseif eax == Wall_Vertical
                invoke paintLine, _hDc, ebx, ecx, Wall_Vertical
            .elseif eax == Wall_Corner_LeftUp
                invoke paintArc, _hDc, ebx, ecx, Wall_Corner_LeftUp
            .elseif eax == Wall_Corner_RightUp
                invoke paintArc, _hDc, ebx, ecx, Wall_Corner_RightUp
            .elseif eax == Wall_Corner_LeftDown
                invoke paintArc, _hDc, ebx, ecx, Wall_Corner_LeftDown
            .elseif eax == Wall_Corner_RightDown
                invoke paintArc, _hDc, ebx, ecx, Wall_Corner_RightDown
            .endif
            
            inc ecx
        .endw
        inc ebx    
    .endw
    
    invoke SelectObject, _hDc, @hOldPen
    invoke DeleteObject, @hPen

    invoke CreatePen, PS_SOLID, wallWidth, wallSpecialColor
    mov @hPen, eax

    invoke SelectObject, _hDc, @hPen
    mov @hOldPen, eax
    
    xor ebx, ebx    ; ���ѭ������i
    .while ebx < map_rows
        xor ecx, ecx    ; �ڲ�ѭ������j
        .while ecx < map_cols
            
            invoke getBorderType, ebx, ecx, Item_SpecialWall
            .if eax == Wall_Horizontal
                invoke paintLine, _hDc, ebx, ecx, Wall_Horizontal
            .elseif eax == Wall_Vertical
                invoke paintLine, _hDc, ebx, ecx, Wall_Vertical
            .elseif eax == Wall_Corner_LeftUp
                invoke paintArc, _hDc, ebx, ecx, Wall_Corner_LeftUp
            .elseif eax == Wall_Corner_RightUp
                invoke paintArc, _hDc, ebx, ecx, Wall_Corner_RightUp
            .elseif eax == Wall_Corner_LeftDown
                invoke paintArc, _hDc, ebx, ecx, Wall_Corner_LeftDown
            .elseif eax == Wall_Corner_RightDown
                invoke paintArc, _hDc, ebx, ecx, Wall_Corner_RightDown
            .endif
            
            inc ecx
        .endw
        inc ebx    
    .endw
    
    invoke SelectObject, _hDc, @hOldPen
    invoke DeleteObject, @hPen

    popad
    ret
paintMap endp

paintPie proc, _hDc: HDC, _left, _top, _right, _bottom
; ����ͼ���Ӷ�������������ĳԶ���
    local @hPen: HPEN, @hOldPen: HPEN, @hBrush: HBRUSH, @hOldBrush: HBRUSH, @y1, @y2
    pushad

    invoke CreatePen, PS_SOLID, 1, iconColor
    mov @hPen, eax
    invoke SelectObject, _hDc, @hPen
    mov @hOldPen, eax
    invoke CreateSolidBrush, iconColor
    mov @hBrush, eax
    invoke SelectObject, _hDc, @hBrush
    mov @hOldBrush, eax

    mov eax, iconRadius
    sub eax, iconOpenSize
    mov ebx, _top
    mov @y1, ebx
    add @y1, eax
    mov ebx, _bottom
    mov @y2, ebx
    sub @y2, eax

    invoke Pie, _hDc, _left, _top, _right, _bottom, _right, @y1, _right, @y2

    invoke SelectObject, _hDc, @hOldPen
    invoke DeleteObject, @hPen
    invoke SelectObject, _hDc, @hOldBrush
    invoke DeleteObject, @hBrush

    popad
    ret
paintPie endp


paintText proc, _hDc: HDC, _text: ptr sbyte, _xRect, _yRect, _widthRect, _heightRect, _fontWeight, _charSet, \
        _fontName: ptr sbyte, _textColor, _textStyle, _isShow
; ��ʾ�����ֵķ�װ����
    local @hFont: HFONT, @hOldFont: HFONT, @rect: RECT
    pushad

    mov eax, _xRect
    mov ebx, _yRect

    mov @rect.left, eax
    mov @rect.top, ebx
    mov @rect.right, eax
    mov @rect.bottom, ebx

    mov eax, _widthRect
    mov ebx, _heightRect
    add @rect.right, eax
    add @rect.bottom, ebx

    invoke CreateFont, _heightRect, 0, 0, 0, _fontWeight, FALSE, FALSE, FALSE, _charSet, 0, 0, 0, 0, _fontName
    mov @hFont, eax
    invoke SelectObject, _hDc, @hFont
    mov @hOldFont, eax

    .if _isShow == 1
        invoke SetTextColor, _hDc, _textColor
    .else
        invoke SetTextColor, _hDc, TRANSPARENT
    .endif

    invoke SetBkMode, _hDc, TRANSPARENT
    invoke DrawText, _hDc, _text, -1, addr @rect, _textStyle

    invoke SelectObject, _hDc, @hOldFont
    invoke DeleteObject, @hFont
    
    popad
    ret
paintText endp


paintReadyScreen proc uses eax ebx edx, _hDc: HDC
    local @hFont: HFONT, @hOldFont: HFONT, @centerX: dword, @iconLeftRect, @iconTopRect, @iconRightRect, @iconBottomRect, \
        @gameNameRect: RECT, @startTipRect: RECT, @teacherRect: RECT, @authorRect: RECT, @height
    mov ebx, 2
    mov eax, windowWidth
    xor edx, edx
    div ebx
    mov @centerX, eax

    ; ��λ�Զ��˵�λ�þ���
    mov ebx, iconRadius
    mov edx, iconTop

    mov @iconLeftRect, eax
    mov @iconRightRect, eax
    sub @iconLeftRect, ebx
    add @iconRightRect, ebx

    mov @iconTopRect, edx
    mov @iconBottomRect, edx
    add @iconBottomRect, ebx
    add @iconBottomRect, ebx

    ; ÿ�ε��øú���ʱ�ı�iconOpenSize���Ӷ�ʵ�ֳԶ���������춯��
    .if isIconOpening == 1
        mov eax, iconRadius
        .if iconOpenSize >= eax
            mov isIconOpening, 0
        .else
            add iconOpenSize, 4
        .endif
    .elseif
        .if iconOpenSize <= 0
            mov isIconOpening, 1
        .else
            sub iconOpenSize, 4
        .endif
    .endif


    ; ����������ĳԶ���
    invoke paintPie, _hDc, @iconLeftRect, @iconTopRect, @iconRightRect, @iconBottomRect


    ; ��ʾ��Ϸ��
    mov eax, @iconBottomRect
    add eax, gapBetweenIconAndGameName
    invoke paintText, _hDc, addr gameName, 0, eax, windowWidth, gameNameRectHeight, FW_HEAVY, ANSI_CHARSET, \
        addr gameNameFontName, gameNameColor, DT_CENTER, 1
    add eax, gameNameRectHeight
    
    ; ************************************************************************** �� ******************************************************************
    ; ��ʾ��Ϸģʽ
    add eax, gapBetweenGameNameAndGameMode
    .if game_mode == Game_Mode_Single
        invoke paintText, _hDc, addr singleMode, 0, eax, windowWidth, gameModeRectHeight, FW_HEAVY, GB2312_CHARSET, \
            addr gameModeFontName, gameModeSelect, DT_CENTER, textIsShow
    .else
        invoke paintText, _hDc, addr singleMode, 0, eax, windowWidth, gameModeRectHeight, FW_HEAVY, GB2312_CHARSET, \
            addr gameModeFontName, gameModeColor, DT_CENTER, 1
    .endif
    add eax, gameModeRectHeight

    add eax, gapGameMode
    .if game_mode == Game_Mode_Double_Cooperate
        invoke paintText, _hDc, addr doubleCooperateMode, 0, eax, windowWidth, gameModeRectHeight, FW_HEAVY, GB2312_CHARSET, \
            addr gameModeFontName, gameModeSelect, DT_CENTER, textIsShow
    .else
       invoke paintText, _hDc, addr doubleCooperateMode, 0, eax, windowWidth, gameModeRectHeight, FW_HEAVY, GB2312_CHARSET, \
            addr gameModeFontName, gameModeColor, DT_CENTER, 1
    .endif
    add eax, gameModeRectHeight

    add eax, gapGameMode
    .if game_mode == Game_Mode_Double_Chase
        invoke paintText, _hDc, addr doubleChaseMode , 0, eax, windowWidth, gameModeRectHeight, FW_HEAVY, GB2312_CHARSET, \
            addr gameModeFontName, gameModeSelect, DT_CENTER, textIsShow
    .else
        invoke paintText, _hDc, addr doubleChaseMode , 0, eax, windowWidth, gameModeRectHeight, FW_HEAVY, GB2312_CHARSET, \
            addr gameModeFontName, gameModeColor, DT_CENTER, 1
    .endif
    add eax, gameModeRectHeight

    ; ************************************************************************** �� ******************************************************************
    ; ��ʾ��ʼ��Ϸ��ʾ
    add eax, gapBetweenGameModeAndStartTip ; ***************************************************************** �޸����� ************************************************
    invoke paintText, _hDc, addr startTip, 0, eax, windowWidth, startTipRectHeight, FW_HEAVY, ANSI_CHARSET, \
        addr startTipFontName, startTipColor, DT_CENTER, textIsShow
    add eax, startTipRectHeight
    

    ; ��ʾָ����ʦ
    add eax, gapBetweenStartTipAndTeacher
    invoke paintText, _hDc, addr teacher, 0, eax, windowWidth, teacherRectHeight, FW_NORMAL, GB2312_CHARSET, \
        addr teacherFontName, teacherColor, DT_CENTER, 1
    add eax, teacherRectHeight


    ; ��ʾ����
    add eax, gapBetweenTeacherAndAuthor
    invoke paintText, _hDc, addr author, 0, eax, windowWidth, authorRectHeight, FW_NORMAL, GB2312_CHARSET, \
        addr authorFontName, authorColor, DT_CENTER, 1
    add eax, authorRectHeight

    ; TODO����ʾѧУ������

    ret
paintReadyScreen endp


paintRightPanel proc, _hDc: HDC, _isPause
    pushad

    ; ��ʾ**score**
    mov eax, scoreStrTop
    invoke paintText, _hDc, addr scoreStr, panelX, eax, panelWidth, scoreStrRectHeight, FW_HEAVY, ANSI_CHARSET, \
    addr scoreStrFontName, scoreStrColor, DT_LEFT, 1
    add eax, scoreStrRectHeight


    ; ��ʾ�÷�
    add eax, gapBetweenScoreStrAndScoreNum
    push eax
    invoke crt_sprintf, addr scoreNum, addr scoreNumFormat, score
    pop eax
    invoke paintText, _hDc, addr scoreNum, panelX, eax, panelWidth, scoreNumRectHeight, FW_HEAVY, ANSI_CHARSET, \
        addr scoreNumFontName, scoreNumColor, DT_LEFT, 1
    add eax, scoreNumRectHeight


    ; ��ʾ**level**
    add eax, gapBetweenScoreNumAndLevelStr
    invoke paintText, _hDc, addr levelStr, panelX, eax, panelWidth, levelStrRectHeight, FW_HEAVY, ANSI_CHARSET, \
        addr levelStrFontName, levelStrColor, DT_LEFT, 1
    add eax, levelStrRectHeight


    ; ��ʾ�ؿ�
    add eax, gapBetweenLevelStrAndLevelNum
    push eax
    invoke crt_sprintf, addr levelNum, addr levelNumFormat, level
    pop eax
    invoke paintText, _hDc, addr levelNum, panelX, eax, panelWidth, levelNumRectHeight, FW_HEAVY, ANSI_CHARSET, \
        addr levelNumFontName, levelNumColor, DT_LEFT, 1


    ; ��ʾ**Pause**
    add eax, gapBetweenLevelNumAndPauseStr
    .if _isPause == 1
        invoke paintText, _hDc, addr pauseStr, panelX, eax, panelWidth, pauseStrRectHeight, FW_HEAVY, ANSI_CHARSET, \
            addr pauseStrFontName, pauseStrColor, DT_LEFT, textIsShow
    .endif
    add eax, pauseStrRectHeight


    ; ��ʾ**LIFE**
    ;add eax, gapBetweenPauseStrAndLifeStr
    ;invoke paintText, _hDc, addr lifeStr, panelX, eax, panelWidth, lifeStrRectHeight, FW_HEAVY, ANSI_CHARSET, \
        ;addr lifeStrFontName, lifeStrColor, DT_LEFT, 1
    ;add eax, lifeStrRectHeight


    ; ��ʾ����
    ;add eax, gapBetweenLifeStrAndLifeNum
    ;push eax
    ;invoke crt_sprintf, addr lifeNum, addr lifeNumFormat, life
    ;pop eax
    ;invoke paintText, _hDc, addr lifeNum, panelX, eax, panelWidth, lifeNumRectHeight, FW_HEAVY, ANSI_CHARSET, \
    ;   addr lifeNumFontName, lifeNumColor, DT_LEFT, 1


    popad
    ret 
paintRightPanel endp


paintGameOverScreen proc, _hDc: HDC
    ; ��ʾ**game over**
    pushad

    mov eax, gameOverTop
    invoke paintText, _hDc, addr gameOver, 0, eax, windowWidth, gameOverRectHeight, FW_HEAVY, ANSI_CHARSET, \
        addr gameOverFontName, gameOverColor, DT_CENTER, 1
    add eax, gameOverRectHeight

    ; ��ʾ���յ÷�
    add eax, gapBetweenGameOverAndFinalScore
    push eax
    invoke crt_sprintf, addr finalScore, addr finalScoreFormat, score
    pop eax
    invoke paintText, _hDc, addr finalScore, 0, eax, windowWidth, finalScoreRectHeight, FW_HEAVY, ANSI_CHARSET, \
        addr finalScoreFontName, finalScoreColor, DT_CENTER, 1
    add eax, finalScoreRectHeight
    ; ��ʾ�رմ�����ʾ
    add eax, gapBetweenFinalScoreAndCloseTip
    invoke paintText, _hDc, addr closeTip, 0, eax, windowWidth, closeTipRectHeight, FW_HEAVY, ANSI_CHARSET, \
        addr closeTipFontName, closeTipColor, DT_CENTER, textIsShow
    add eax, closeTipRectHeight
    
    popad
    ret
paintGameOverScreen endp

paintGameWinScreen proc, _hDc: HDC
    ; ��ʾ**game win**
    pushad

    mov eax, gameWinTop
    invoke paintText, _hDc, addr gameWin, 0, eax, windowWidth, gameWinRectHeight, FW_HEAVY, ANSI_CHARSET, \
        addr gameWinFontName, gameWinColor, DT_CENTER, 1
    add eax, gameWinRectHeight

    ; ��ʾ���յ÷�
    add eax, gapBetweenGameWinAndFinalScore
    push eax
    invoke crt_sprintf, addr finalScore, addr finalScoreFormat, score
    pop eax
    invoke paintText, _hDc, addr finalScore, 0, eax, windowWidth, finalScoreRectHeight, FW_HEAVY, ANSI_CHARSET, \
        addr finalScoreFontName, finalScoreColor, DT_CENTER, 1
    add eax, finalScoreRectHeight

    ; ��ʾ�رմ�����ʾ
    add eax, gapBetweenFinalScoreAndCloseTip
    invoke paintText, _hDc, addr closeTip, 0, eax, windowWidth, closeTipRectHeight, FW_HEAVY, ANSI_CHARSET, \
        addr closeTipFontName, closeTipColor, DT_CENTER, textIsShow
    add eax, closeTipRectHeight
    
    popad
    ret
paintGameWinScreen endp

paintNxtStageScreen proc, _hDc: HDC
    ; ��ʾ**next stage**
    pushad

    mov eax, gameNxtStageTop
    invoke paintText, _hDc, addr gameNxtStage, 0, eax, windowWidth, gameNxtStageRectHeight, FW_HEAVY, ANSI_CHARSET, \
        addr gameNxtStageFontName, gameNxtStageColor, DT_CENTER, 1
    add eax, gameNxtStageRectHeight

    ; ��ʾ�ؿ��÷�
    add eax, gapBetweenGameNxtStageAndFinalScore
    push eax
    invoke crt_sprintf, addr StageScore, addr StageScoreFormat, score
    pop eax
    invoke paintText, _hDc, addr StageScore, 0, eax, windowWidth, StageScoreRectHeight, FW_HEAVY, ANSI_CHARSET, \
        addr StageScoreFontName, StageScoreColor, DT_CENTER, textIsShow
    
    popad
    ret
paintNxtStageScreen endp


paintInMemoryDc proc

    .if game_state == Game_State_Play
        invoke paintMap, hMemoryDc
        invoke paintBean, hMemoryDc
        invoke paintRightPanel, hMemoryDc, 0
    .elseif game_state == Game_State_Pause
        invoke paintMap, hMemoryDc
        invoke paintBean, hMemoryDc
        invoke paintRightPanel, hMemoryDc, 1
    .elseif game_state == Game_State_Ready
        invoke paintReadyScreen, hMemoryDc
    .elseif game_state == Game_State_Lose
        invoke paintGameOverScreen, hMemoryDc
    .elseif game_state == Game_State_Win
        invoke paintGameWinScreen, hMemoryDc
    .elseif game_state == Game_State_NxtStage
        invoke paintNxtStageScreen, hMemoryDc
    .endif
    
    ;popad
    ret
paintInMemoryDc endp

;��һ�ؿ����涨ʱ�������5��
timer_NextStage proc uses eax edx                     
    local time1:qword,time2:qword,freq:qword                                                   
    invoke QueryPerformanceFrequency, addr freq         ;��ȡ�߾��ȼ�ʱ����Ƶ��
    finit

    loop_nxt_stage:
    ; ��� is_buffer �Ƿ���� 1
    cmp is_buffer, 1
    jne endloop

    ; ��� game_state �Ƿ񲻵��� Game_State_NxtStage
    cmp game_state, Game_State_NxtStage
    jne loop_nxt_stage
    mov is_gamenextstage, 1

    invoke QueryPerformanceCounter,addr time1
    xor eax, eax
    .while eax < gamenextstage_time
        invoke QueryPerformanceCounter,addr time2
        mov eax,dword ptr time1             
        mov edx,dword ptr time1+4
        sub dword ptr time2, eax
        sbb dword ptr time2+4, edx               ;sbb����λ����
        fild time2
        fimul dw1m
        fild freq
        fdiv
        fistp time2 
        mov eax,dword ptr time2                 ;eax = (time1-time2)/freq = time1��time2֮���ʱ����λ:10^-6�룩
                                                ;��ʱ��Ϊ֡��֮֡��Ļ��Ƽ����֡�ʼ��㣩
    .endw

    mov is_gamenextstage, 0

    call init_map

    inc level
    ;mov score, 0

    mov game_state, Game_State_Play
    ; ��������...

    jmp loop_nxt_stage

    endloop:
    ret
timer_NextStage endp

timer_issuper proc uses eax edx                     
    local time1:qword,time2:qword,freq:qword                                                   
    invoke QueryPerformanceFrequency, addr freq         ;��ȡ�߾��ȼ�ʱ����Ƶ��
    finit

    loop_is_super:
    ; ��� is_buffer �Ƿ���� 1
    cmp is_buffer, 1
    jne endloop

    ; ��� game_state �Ƿ񲻵��� Game_State_NxtStage
    cmp is_super_pacman, 1
    jne loop_is_super

    invoke QueryPerformanceCounter,addr time1
    xor eax, eax
    .while eax < superbean_time
        invoke QueryPerformanceCounter,addr time2
        mov eax,dword ptr time1             
        mov edx,dword ptr time1+4
        sub dword ptr time2, eax
        sbb dword ptr time2+4, edx               ;sbb����λ����
        fild time2
        fimul dw1m
        fild freq
        fdiv
        fistp time2 
        mov eax,dword ptr time2                 ;eax = (time1-time2)/freq = time1��time2֮���ʱ����λ:10^-6�룩
                                                ;��ʱ��Ϊ֡��֮֡��Ļ��Ƽ����֡�ʼ��㣩
    .endw

    mov is_super_pacman, 0
    invoke end_frightened

    jmp loop_is_super

    endloop:
    ret
timer_issuper endp

timer_isfast proc uses eax edx                     
    local time1:qword,time2:qword,freq:qword                                                   
    invoke QueryPerformanceFrequency, addr freq         ;��ȡ�߾��ȼ�ʱ����Ƶ��
    finit

    loop_is_fast:
    ; ��� is_buffer �Ƿ���� 1
    cmp is_buffer, 1
    jne endloop

    ; ��� game_state �Ƿ񲻵��� Game_State_NxtStage
    cmp is_fast_pacman, 1
    jne loop_is_fast

    invoke QueryPerformanceCounter,addr time1
    xor eax, eax
    .while eax < fastbean_time
        invoke QueryPerformanceCounter,addr time2
        mov eax,dword ptr time1             
        mov edx,dword ptr time1+4
        sub dword ptr time2, eax
        sbb dword ptr time2+4, edx               ;sbb����λ����
        fild time2
        fimul dw1m
        fild freq
        fdiv
        fistp time2 
        mov eax,dword ptr time2                 ;eax = (time1-time2)/freq = time1��time2֮���ʱ����λ:10^-6�룩
                                                ;��ʱ��Ϊ֡��֮֡��Ļ��Ƽ����֡�ʼ��㣩
    .endw

    mov is_fast_pacman, 0
    invoke speed_down_pacman

    jmp loop_is_fast

    endloop:
    ret
timer_isfast endp

timer_isinvisible proc uses eax edx                     
    local time1:qword,time2:qword,freq:qword                                                   
    invoke QueryPerformanceFrequency, addr freq         ;��ȡ�߾��ȼ�ʱ����Ƶ��
    finit

    loop_is_invisible:
    ; ��� is_buffer �Ƿ���� 1
    cmp is_buffer, 1
    jne endloop

    ; ��� game_state �Ƿ񲻵��� Game_State_NxtStage
    cmp is_invisible_pacman, 1
    jne loop_is_invisible

    invoke QueryPerformanceCounter,addr time1
    xor eax, eax
    .while eax < invisiblebean_time
        invoke QueryPerformanceCounter,addr time2
        mov eax,dword ptr time1             
        mov edx,dword ptr time1+4
        sub dword ptr time2, eax
        sbb dword ptr time2+4, edx               ;sbb����λ����
        fild time2
        fimul dw1m
        fild freq
        fdiv
        fistp time2 
        mov eax,dword ptr time2                 ;eax = (time1-time2)/freq = time1��time2֮���ʱ����λ:10^-6�룩
                                                ;��ʱ��Ϊ֡��֮֡��Ļ��Ƽ����֡�ʼ��㣩
    .endw

    mov is_invisible_pacman, 0
    invoke end_invisible_pacman
    jmp loop_is_invisible

    endloop:
    ret
timer_isinvisible endp

;is_dying��ʱ����4��
timer_isSwitching proc uses eax edx                     
    local time1:qword,time2:qword,freq:qword                                                   
    invoke QueryPerformanceFrequency, addr freq         ;��ȡ�߾��ȼ�ʱ����Ƶ��
    finit

    loop_is_switching:
    ; ��� is_buffer �Ƿ���� 1
    cmp is_buffer, 1
    jne endloop

    cmp game_mode, Game_Mode_Double_Cooperate
    jne loop_is_switching

    mov chase_target, PacMan

    invoke QueryPerformanceCounter,addr time1
    xor eax, eax
    .while eax < switching_time
        invoke QueryPerformanceCounter,addr time2
        mov eax,dword ptr time1             
        mov edx,dword ptr time1+4
        sub dword ptr time2, eax
        sbb dword ptr time2+4, edx               ;sbb����λ����
        fild time2
        fimul dw1m
        fild freq
        fdiv
        fistp time2 
        mov eax,dword ptr time2                 ;eax = (time1-time2)/freq = time1��time2֮���ʱ����λ:10^-6�룩
                                                ;��ʱ��Ϊ֡��֮֡��Ļ��Ƽ����֡�ʼ��㣩
    .endw

    mov chase_target, RedMan
    jmp loop_is_switching

    endloop:
    ret
timer_isSwitching endp

; is_chasing��ʱ���������Ըı����׷��ʽ
timer_ischasing proc uses eax edx                     
    local time1:qword,time2:qword,freq:qword                                                   
    invoke QueryPerformanceFrequency, addr freq         ;��ȡ�߾��ȼ�ʱ����Ƶ��
    finit

    loop_is_chasing:
    ; ��� is_buffer �Ƿ���� 1
    cmp is_buffer, 1
    jne endloop

    mov is_chasing_pacman, 1
    invoke cycle_to_chase

    mov  dword ptr time1, 0
    mov  dword ptr time2, 0
    invoke QueryPerformanceCounter,addr time1
    xor eax, eax
    .while eax < chasing_time
        invoke QueryPerformanceCounter,addr time2
        mov eax,dword ptr time1             
        mov edx,dword ptr time1+4
        sub dword ptr time2, eax
        sbb dword ptr time2+4, edx               ;sbb����λ����
        fild time2
        fimul dw1m
        fild freq
        fdiv
        fistp time2 
        mov eax,dword ptr time2                 ;eax = (time1-time2)/freq = time1��time2֮���ʱ����λ:10^-6�룩
                                                ;��ʱ��Ϊ֡��֮֡��Ļ��Ƽ����֡�ʼ��㣩
    .endw

    mov is_chasing_pacman, 0
    invoke cycle_to_scatter

    mov  dword ptr time1, 0
    mov  dword ptr time2, 0
    invoke QueryPerformanceCounter,addr time1
    xor eax, eax
    .while eax < scatter_time
        invoke QueryPerformanceCounter,addr time2
        mov eax,dword ptr time1             
        mov edx,dword ptr time1+4
        sub dword ptr time2, eax
        sbb dword ptr time2+4, edx               ;sbb����λ����
        fild time2
        fimul dw1m
        fild freq
        fdiv
        fistp time2 
        mov eax,dword ptr time2                 ;eax = (time1-time2)/freq = time1��time2֮���ʱ����λ:10^-6�룩
                                                ;��ʱ��Ϊ֡��֮֡��Ļ��Ƽ����֡�ʼ��㣩
    .endw

    jmp loop_is_chasing

    endloop:
    ret
timer_ischasing endp

timer_Release proc uses eax edx                     
    local time1:qword,time2:qword,freq:qword, @cnt:dword                                              
    invoke QueryPerformanceFrequency, addr freq         ;��ȡ�߾��ȼ�ʱ����Ƶ��
    finit

    loop_release:
    ; ��� is_buffer �Ƿ���� 1
    cmp is_buffer, 1
    jne endloop
    
    cmp release_nxt_ghost, 1
    jne loop_release

    mov @cnt, 0

    mov  dword ptr time1, 0
    mov  dword ptr time2, 0
    invoke QueryPerformanceCounter,addr time1
    xor eax, eax
    .while eax < firstghost_time
        invoke QueryPerformanceCounter,addr time2
        mov eax,dword ptr time1             
        mov edx,dword ptr time1+4
        sub dword ptr time2, eax
        sbb dword ptr time2+4, edx               ;sbb����λ����
        fild time2
        fimul dw1m
        fild freq
        fdiv
        fistp time2 
        mov eax,dword ptr time2                 ;eax = (time1-time2)/freq = time1��time2֮���ʱ����λ:10^-6�룩
                                                ;��ʱ��Ϊ֡��֮֡��Ļ��Ƽ����֡�ʼ��㣩
    .endw

    invoke release_ghost

    .while @cnt < 3
        mov  dword ptr time1, 0
        mov  dword ptr time2, 0
        invoke QueryPerformanceCounter,addr time1
        xor eax, eax
        .while eax < nextghost_time
            invoke QueryPerformanceCounter,addr time2
            mov eax,dword ptr time1             
            mov edx,dword ptr time1+4
            sub dword ptr time2, eax
            sbb dword ptr time2+4, edx               ;sbb����λ����
            fild time2
            fimul dw1m
            fild freq
            fdiv
            fistp time2 
            mov eax,dword ptr time2                 ;eax = (time1-time2)/freq = time1��time2֮���ʱ����λ:10^-6�룩
                                                ;��ʱ��Ϊ֡��֮֡��Ļ��Ƽ����֡�ʼ��㣩
        .endw
        invoke release_ghost
        inc @cnt
    .endw

    mov release_nxt_ghost, 0

    endloop:
    ret
timer_Release endp

;��ʱ�����̶������is_show����Ϊ1
control_frame_rate proc uses eax edx                             ;ͨ������ is_show ������ֵ��������Ⱦ֡�����
    local time1:qword,time2:qword,freq:qword             
    mov is_show, 1                                         
    invoke QueryPerformanceFrequency, addr freq         ;��ȡ�߾��ȼ�ʱ����Ƶ��
    finit
    .while is_buffer == 1
        invoke QueryPerformanceCounter,addr time1       ;��ȡ��ǰ���ܼ������ļ���ֵ���߾��ȵ�ʱ�����
        mov is_show, 1  
        xor eax, eax
        .while eax < fps
            invoke QueryPerformanceCounter,addr time2
            mov eax,dword ptr time1             
            mov edx,dword ptr time1+4
            sub dword ptr time2, eax
            sbb dword ptr time2+4, edx               ;sbb����λ����
            fild time2
            fimul dw1m
            fild freq
            fdiv
            fistp time2 
            mov eax,dword ptr time2                 ;eax = (time1-time2)/freq = time1��time2֮���ʱ����λ:10^-6�룩
                                                    ;��ʱ��Ϊ֡��֮֡��Ļ��Ƽ����֡�ʼ��㣩
        .endw
    .endw
    ret
control_frame_rate endp

;�ڴ����л���ͼ��
draw_window PROC uses eax 
    local h_dc

    main_loop:
        cmp is_buffer, 0
        jz main_loop_end

        .while buffer_cnt == 0 || (!is_show)    ;��黺�����Ƿ����
        .endw                                   ;�� is_show ��־��Ϊ true ʱ�һ�������Ϊ��ʱ��
                                                ;��������ȡ�����ڵ��豸�����Ĳ�ʹ�� BitBlt ��ͼ����ʵ��Ļ��������Ƶ�������
                                                ;����ѭ���ȴ�

        mov eax, buffer_index
        invoke	BitBlt,hDc,0,0,windowWidth,windowHeight,\  ;һ�δ�h_dc_bufferȡ��һ��ͼ�񣨶�����һ�������h_dc�������Ƶ���Ļ�ϣ�
            h_dc_buffer[4*eax],0,0,SRCCOPY

        dec buffer_cnt
        inc buffer_index
        .if buffer_index == buffer_size
            mov buffer_index, 0
        .endif

        mov is_show, 0                          ; is_showΪ0��ʾ��ǰ������������ϣ�Ϊ1��ʾ��Ҫ�������ڴӻ���������һ��ͼ��
        jmp main_loop

    main_loop_end:
        ret
draw_window ENDP

create_buffer proc uses ecx esi edi eax
    local @cnt
    local @drawlist_cnt



    main_loop:
        cmp is_buffer, 0
        jz main_loop_end

    .while buffer_cnt != 0 ;����������Ϊ��ʱ�����������ͼ��ֱ��������Ϊ
    .endw       

    invoke draw_map
    
    .if game_state == Game_State_Lose
        mov play_die_music, 1
    .endif

        .if game_state == Game_State_Ready || game_state == Game_State_Win || game_state == Game_State_Lose || game_state == Game_State_NxtStage
            mov ecx, buffer_size
            mov @cnt, 0
            .while @cnt < ecx
                push ecx
                mov esi, @cnt 
                invoke paintInMemoryDc
                invoke BitBlt,h_dc_buffer[4*esi],0,0,windowWidth,windowHeight,hMemoryDc,0,0,SRCCOPY  
                invoke CreateCompatibleBitmap, hDc, windowWidth, windowHeight
                mov hMemoryBitmap, eax
                invoke SelectObject, hMemoryDc, hMemoryBitmap
                invoke DeleteObject, hMemoryBitmap
                inc buffer_cnt
                inc @cnt
                pop ecx
            .endw
            jmp main_loop
        .elseif game_state == Game_State_Play || game_state == Game_State_Pause
            mov ecx, buffer_size
            mov @cnt, 0
            .while @cnt < ecx
                push ecx
                mov esi, @cnt
                invoke paintInMemoryDc
                invoke BitBlt,h_dc_buffer[4*esi],0,0,windowWidth,windowHeight,hMemoryDc,0,0,SRCCOPY
                invoke CreateCompatibleBitmap, hDc, windowWidth, windowHeight
                mov hMemoryBitmap, eax
                invoke SelectObject, hMemoryDc, hMemoryBitmap
                invoke DeleteObject, hMemoryBitmap
                mov ecx, draw_list_size
                mov @drawlist_cnt, 0
                .while @drawlist_cnt < ecx
                    push ecx
                    mov edi, @drawlist_cnt
                    imul edi, 24
                    invoke draw_item, draw_list[edi], @cnt
                    inc @drawlist_cnt
                    pop ecx
                .endw
                inc buffer_cnt
                inc @cnt
                pop ecx
            .endw
            jmp main_loop
        .endif
    main_loop_end:
        ret
create_buffer endp

close_window PROC uses esi edi
    local @cnt
    mov @cnt, 0
    mov esi, offset h_dc_buffer
    mov edi, offset h_dc_buffer_size
    .while @cnt != buffer_size
        invoke DeleteDC, [esi]
        invoke DeleteObject, [edi]
        add esi, 4
        add edi, 4
        inc @cnt
    .endw

    invoke DeleteDC, h_dc_background
    invoke DeleteDC, h_dc_start_up
    invoke DeleteDC, h_dc_game_over
    invoke DeleteDC, h_dc_map_and_bean
    invoke DeleteDC, h_dc_panel

    invoke DeleteDC, h_dc_pacman1_left
    invoke DeleteDC, h_dc_pacman1_down
    invoke DeleteDC, h_dc_pacman1_right
    invoke DeleteDC, h_dc_pacman1_up

    invoke DeleteDC, h_dc_pacman2_left
    invoke DeleteDC, h_dc_pacman2_down
    invoke DeleteDC, h_dc_pacman2_right
    invoke DeleteDC, h_dc_pacman2_up

    invoke DeleteDC, h_dc_blinky_left
    invoke DeleteDC, h_dc_blinky_down
    invoke DeleteDC, h_dc_blinky_right
    invoke DeleteDC, h_dc_blinky_up
    invoke DeleteDC, h_dc_blinky_left2
    invoke DeleteDC, h_dc_blinky_down2
    invoke DeleteDC, h_dc_blinky_right2
    invoke DeleteDC, h_dc_blinky_up2

    invoke DeleteDC, h_dc_pinky_left
    invoke DeleteDC, h_dc_pinky_down
    invoke DeleteDC, h_dc_pinky_right
    invoke DeleteDC, h_dc_pinky_up
    invoke DeleteDC, h_dc_pinky_left2
    invoke DeleteDC, h_dc_pinky_down2
    invoke DeleteDC, h_dc_pinky_right2
    invoke DeleteDC, h_dc_pinky_up2

    invoke DeleteDC, h_dc_inky_left
    invoke DeleteDC, h_dc_inky_down
    invoke DeleteDC, h_dc_inky_right
    invoke DeleteDC, h_dc_inky_up
    invoke DeleteDC, h_dc_inky_left2
    invoke DeleteDC, h_dc_inky_down2
    invoke DeleteDC, h_dc_inky_right2
    invoke DeleteDC, h_dc_inky_up2

    invoke DeleteDC, h_dc_clyde_left
    invoke DeleteDC, h_dc_clyde_down
    invoke DeleteDC, h_dc_clyde_right
    invoke DeleteDC, h_dc_clyde_up
    invoke DeleteDC, h_dc_clyde_left2
    invoke DeleteDC, h_dc_clyde_down2
    invoke DeleteDC, h_dc_clyde_right2
    invoke DeleteDC, h_dc_clyde_up2

    invoke DeleteDC, h_dc_cindy_left
    invoke DeleteDC, h_dc_cindy_down
    invoke DeleteDC, h_dc_cindy_right
    invoke DeleteDC, h_dc_cindy_up
    invoke DeleteDC, h_dc_cindy_left2
    invoke DeleteDC, h_dc_cindy_down2
    invoke DeleteDC, h_dc_cindy_right2
    invoke DeleteDC, h_dc_cindy_up2

    invoke DeleteDC, h_dc_redman1_down
    invoke DeleteDC, h_dc_redman1_left
    invoke DeleteDC, h_dc_redman1_right
    invoke DeleteDC, h_dc_redman1_up
    invoke DeleteDC, h_dc_redman2_down
    invoke DeleteDC, h_dc_redman2_left
    invoke DeleteDC, h_dc_redman2_right
    invoke DeleteDC, h_dc_redman2_up
    invoke DeleteDC, h_dc_redman3

    invoke DeleteDC, h_dc_dazzled_down
    invoke DeleteDC, h_dc_dazzled_left
    invoke DeleteDC, h_dc_dazzled_right
    invoke DeleteDC, h_dc_dazzled_up
    invoke DeleteDC, h_dc_dazzled_down2
    invoke DeleteDC, h_dc_dazzled_left2
    invoke DeleteDC, h_dc_dazzled_right2
    invoke DeleteDC, h_dc_dazzled_up2

    invoke DeleteDC, h_dc_dead_down
    invoke DeleteDC, h_dc_dead_left
    invoke DeleteDC, h_dc_dead_right
    invoke DeleteDC, h_dc_dead_up

    invoke DeleteDC, h_dc_bmp
    invoke DeleteObject, h_dc_bmp_size
    ret
close_window ENDP

play_music proc
local @die_cnt:dword
mov @die_cnt, 0

music_loop:
    .if play_die_music == 1
        .if @die_cnt < 1
            invoke playDieMusic
            mov play_die_music, 0
            inc @die_cnt
        .elseif 
            ret
        .endif
    .endif
    jmp music_loop
ret
play_music endp

processKeyInput proc, _hWnd: HWND, wParam: WPARAM, lParam: LPARAM
    .if wParam == VK_RETURN ;��Ϸ��ʼ
        .if game_state == Game_State_Ready
            mov game_state, Game_State_Play
            mov release_nxt_ghost, 1
            invoke playMusic, addr music_wake, 1
        .elseif game_state == Game_State_Win || game_state == Game_State_Lose
        ; �رմ���
        invoke SendMessage, _hWnd, WM_CLOSE, 0, 0
        .endif
    .endif
    .if wParam == VK_SPACE ; ��Ϸ��ͣ
        .if game_state == Game_State_Play
            mov game_state, Game_State_Pause
            invoke pauseAllMusic
        .elseif game_state == Game_State_Pause
            mov game_state, Game_State_Play
            invoke resumeAllMusic
        .endif
    .endif
    .if wParam == VK_LEFT || wParam == VK_UP || wParam == VK_RIGHT || wParam == VK_DOWN; ��������������仯
        .if game_state == Game_State_Ready
            .if wParam == VK_UP 
                .if game_mode == Game_Mode_Single
                    mov game_mode , Game_Mode_Double_Chase
                .else
                    dec game_mode 
                .endif
            .elseif wParam == VK_DOWN 
                .if game_mode == Game_Mode_Double_Chase
                    mov game_mode , Game_Mode_Single
                .else
                    inc game_mode 
                .endif
            .endif
        .elseif game_state == Game_State_Play
            ;1-up 2-right 3-down 4-left
            .if wParam == VK_UP 
                mov player_PacMan.NextDir, Dir_Up
            .elseif wParam == VK_DOWN 
                mov player_PacMan.NextDir, Dir_Down
            .elseif wParam == VK_LEFT 
                mov player_PacMan.NextDir, Dir_Left
            .elseif wParam == VK_RIGHT 
                mov player_PacMan.NextDir, Dir_Right
            .endif
        .endif
    .endif
    .if wParam == VK_A || wParam == VK_W || wParam == VK_D || wParam == VK_S; ��������������仯
        .if game_state == Game_State_Play
            .if game_mode == Game_Mode_Double_Cooperate
                .if wParam == VK_A 
                    mov player_RedMan.NextDir, Dir_Left
                .elseif wParam == VK_W
                    mov player_RedMan.NextDir, Dir_Up
                .elseif wParam == VK_D
                    mov player_RedMan.NextDir, Dir_Right
                .elseif wParam == VK_S
                    mov player_RedMan.NextDir, Dir_Down
                .endif
            .elseif game_mode == Game_Mode_Double_Chase
                .if wParam == VK_A 
                    mov player_Cindy.NextDir, Dir_Left
                .elseif wParam == VK_W
                    mov player_Cindy.NextDir, Dir_Up
                .elseif wParam == VK_D
                    mov player_Cindy.NextDir, Dir_Right
                .elseif wParam == VK_S
                    mov player_Cindy.NextDir, Dir_Down
                .endif
            .endif
        .endif
    .endif
    ;����Lose��Win��NextStage����
    .if wParam == VK_L
        .if game_state == Game_State_Play
            mov game_state, Game_State_Lose
        .endif
    .endif
    .if wParam == VK_I
        .if game_state == Game_State_Play
            mov game_state, Game_State_Win
        .endif
    .endif
    .if wParam == VK_N
        .if game_state == Game_State_Play
            mov game_state, Game_State_NxtStage
        .endif
    .endif
    ret
processKeyInput endp


processSizeChange proc uses ebx ecx eax, _lParam: LPARAM
    mov ebx, _lParam
    mov ecx, ebx
    and ebx, 0FFFFh           ; ebx�д�Ŵ��ڱ仯�Ŀ���
    shr ecx, 16              ; ecx�д�Ŵ��ڱ��ĸ߶�
    mov windowWidth, ebx
    mov windowHeight, ecx

    mov eax, ecx
    sub eax, 20                 ; ��ȥ���±߾�
    div map_rows
    mov mapGridWidth, eax
    mov eax, iconRadius
    mov iconOpenSize, eax
    mov isIconOpening, 0

    mov eax, mapGridWidth
    mul map_cols
    add eax, 40
    mov panelX, eax
    ret
processSizeChange endp

.code
init_window proc, _hDc:HDC, hWnd: HWND
    invoke create_background, _hDc                                       ;��������h_dc��ʹ�ú�ɫ������ͼƬ����buffer����ʱbufferΪ������ʼ��gamestateΪready
    invoke playMusic, addr music_theme, 0
    ; �������洴������ʾ�߳�
    invoke CreateThread, NULL, 0, draw_window, NULL, 0, NULL
    invoke CreateThread, NULL, 0, create_buffer, NULL, 0, NULL
    invoke CreateThread, NULL, 0, control_frame_rate, NULL, 0, NULL
    ;������ʱ��
    invoke CreateThread, NULL, 0, timer_NextStage, NULL, 0, NULL

    invoke CreateThread, NULL, 0, timer_issuper, NULL, 0, NULL
    invoke CreateThread, NULL, 0, timer_isfast, NULL, 0, NULL
    invoke CreateThread, NULL, 0, timer_isinvisible, NULL, 0, NULL

    invoke CreateThread, NULL, 0, timer_isSwitching, NULL, 0, NULL
    invoke CreateThread, NULL, 0, timer_ischasing, NULL, 0, NULL

    invoke CreateThread, NULL, 0, timer_Release , NULL, 0, NULL

    ;�������������߳�
    invoke CreateThread, NULL, 0, play_music , NULL, 0, NULL
    ret
init_window endp

WndProc proc, hWnd: HWND, msgID: UINT, wParam: WPARAM, lParam: LPARAM
; ���ڴ�������
    .if msgID == WM_TIMER
        .if wParam == 2
            .if stateSwitch == 0
                add superBeanRadius, 1
                mov stateSwitch, 1
            .else
                sub superBeanRadius, 1
                mov stateSwitch, 0
            .endif
        .elseif wParam == 3
            .if textIsShow == 0
                mov textIsShow, 1
            .else
                mov textIsShow, 0
            .endif
        .endif
	.elseif msgID == WM_DESTROY
        mov is_buffer, 0
        invoke KillTimer, hWnd, 0
        invoke DeleteObject, hMemoryBitmap
        invoke ReleaseDC, hWnd, hDc
        invoke close_window
        invoke ReleaseDC, hWnd, hMemoryDc
		invoke PostQuitMessage, 0

    .elseif msgID == WM_ERASEBKGND  ; ���α���ˢ��
        ret
    .elseif msgID == WM_SIZE        ; ���ڴ�С�����仯ʱ��Ҫ���»���
        invoke processSizeChange, lParam
        ;invoke InvalidateRect, hWnd, NULL, TRUE
    .elseif msgID == WM_KEYDOWN     ; ������Ϣ����
        invoke processKeyInput, hWnd, wParam, lParam
    .elseif msgID == WM_CREATE
        invoke GetDC, hWnd
        mov hDc, eax
        invoke CreateCompatibleDC, hDc
        mov hMemoryDc, eax
        invoke CreateCompatibleBitmap, hDc, windowWidth, windowHeight
        mov hMemoryBitmap, eax
        invoke SelectObject, hMemoryDc, hMemoryBitmap
        invoke DeleteObject, hMemoryBitmap
        invoke init_window, hDc, hWnd
        invoke SetTimer, hWnd, 0, 20, NULL
        invoke SetTimer, hWnd, 1, 10, NULL
        invoke SetTimer, hWnd, 2, 150, NULL
        invoke SetTimer, hWnd, 3, 800, NULL
    ;//��ȡ���ڵĿ��͸�
			;RECT rect;
			;GetClientRect(hWnd,&rect);
	.endif

	invoke DefWindowProc, hWnd, msgID, wParam, lParam
	ret
WndProc endp

random_str_main_caption proc uses esi edi eax edx ecx
    ; �������������
    invoke GetTickCount
    invoke srand, eax

    ; ���������
    invoke rand

    ; �����������ģ���㣬������ [0, 3] ��Χ��
    mov ecx, 8
    div ecx
    mov eax, edx

    cmp eax, 0
    je main_window_title_1
    cmp eax, 1
    je main_window_title_2
    cmp eax, 2
    je main_window_title_3
    cmp eax, 3
    je main_window_title_4
    cmp eax, 4
    je main_window_title_5
    cmp eax, 5
    je main_window_title_6
    cmp eax, 6
    je main_window_title_7
    cmp eax, 7
    je main_window_title_8


main_window_title_1:
    lea esi, [str_main_caption_1]
    lea edi, [str_main_caption]
    mov eax, 0
    jmp copy_str

main_window_title_2:
    lea esi, [str_main_caption_2]
    lea edi, [str_main_caption]
    mov eax, 0
    jmp copy_str

main_window_title_3:
    lea esi, [str_main_caption_3]
    lea edi, [str_main_caption]
    mov eax, 0
    jmp copy_str

main_window_title_4:
    lea esi, [str_main_caption_4]
    lea edi, [str_main_caption]
    mov eax, 0
    jmp copy_str

main_window_title_5:
    lea esi, [str_main_caption_5]
    lea edi, [str_main_caption]
    mov eax, 0
    jmp copy_str

main_window_title_6:
    lea esi, [str_main_caption_6]
    lea edi, [str_main_caption]
    mov eax, 0
    jmp copy_str

main_window_title_7:
    lea esi, [str_main_caption_7]
    lea edi, [str_main_caption]
    mov eax, 0
    jmp copy_str

main_window_title_8:
    lea esi, [str_main_caption_8]
    lea edi, [str_main_caption]
    mov eax, 0

copy_str:                        ;ִ���ַ�������
        mov al, [esi]    
        mov [edi], al     
        inc esi           
        inc edi           
        cmp al, 0         
        jnz copy_str 

    xor eax, eax
    ret
random_str_main_caption endp

WinMain proc
; ������
	local @wc: WNDCLASS, @hIns: HINSTANCE, @hWnd: HWND, @nMsg: MSG
	 ;invoke AllocConsole		; ����Dos���ڣ��������
	 ;invoke GetStdHandle, STD_OUTPUT_HANDLE
	 ;mov stdOutputHandle, eax

	invoke GetModuleHandle, NULL
	mov	@hIns,eax			                ; �õ�Ӧ�ó���ľ��

	mov @wc.cbClsExtra, 0
	mov @wc.cbWndExtra, 0
	mov @wc.hbrBackground, COLOR_WINDOWTEXT	; ��������ɫ���Ϊ��ɫ
	mov @wc.hCursor, NULL	                ; ����ϵͳĬ�������ʽ

    invoke LoadImage, NULL, addr pacman_icon, IMAGE_ICON, 0, 0, LR_LOADFROMFILE or LR_SHARED
	mov @wc.hIcon, eax		                ; ���ô���ͼ����ʽ
	mov edx, @hIns
	mov @wc.hInstance, edx

	mov @wc.lpfnWndProc, offset WndProc		; ��ȡ���ڴ���������ַ
	mov @wc.lpszClassName, offset wndClassName
	mov @wc.lpszMenuName, NULL
	; ע�ᴰ����
	invoke RegisterClass, addr @wc

    ;���ѡ��str_main_caption
    invoke random_str_main_caption

	; ���ڴ��д�������
	invoke CreateWindowEx, 0, addr wndClassName, offset str_main_caption, WS_OVERLAPPEDWINDOW, \
		windowX, windowY, windowWidth, windowHeight, NULL, NULL, @hIns, NULL
	mov @hWnd, eax
			
	; ��ʾ����
	invoke ShowWindow, @hWnd, SW_SHOW
	invoke UpdateWindow, @hWnd

    ; invoke ShowCursor, FALSE                  ; ����ʾ���

	; ��Ϣѭ��
    invoke GetMessage, addr @nMsg, NULL, 0, 0
	.while eax
        invoke TranslateMessage, addr @nMsg
		invoke DispatchMessage, addr @nMsg		; ����Ϣ�������ڴ�������������
        invoke GetMessage, addr @nMsg, NULL, 0, 0
	.endw

	ret
WinMain endp

start:
    call WinMain
    invoke closeAllMusic
    invoke ExitProcess, NULL
    ret
end start