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
includelib  msvcrt.lib
include     winmm.inc
includelib  winmm.lib


.data
; �ⲿ��������
extern draw_list:draw_struct
extern draw_list_size:dword
extern game_state:dword                 ; ��Ϸ״̬
extern need_redraw:dword
extern player_PacMan:player_struct
extern player_RedMan:player_struct
extern player_Cindy:player_struct                   
extern score:dword                       ; ��Ϸ�÷�
extern game_mode:dword                   ; �趨��Ϸģʽ
extern chase_target:dword                ; ����ģʽ����������׷��Ŀ��
extern map_cols:dword                    ; ��ͼ�Ŀ��
extern map_rows:dword                    ; ��ͼ�ĸ߶�
extern mapX:dword                        ; ��ͼ�����Ͻ�X����
extern mapY:dword                        ; ��ͼ�����Ͻ�Y����

.data
; ���崰�ڱ��⣨����ʱ���ѡ����ʾ��
str_main_caption   byte 200 dup(0)
str_main_caption_1 byte 'Pac-Man is currently searching for dots... Have fun!', 0
str_main_caption_2 byte 'Monsters are approaching you, stay vigilant!', 0
str_main_caption_3 byte 'Which way to go at the next corner? Think calmly!', 0
str_main_caption_4 byte 'Whats the use of bigger dots? Give it a try!', 0
str_main_caption_5 byte 'Collected all the dots to pass this level! Come on!', 0
str_main_caption_6 byte 'Watch out for the flashing monsters! They can still hurt you!', 0
str_main_caption_7 byte 'You have earned an extra life! How far can you go?', 0
str_main_caption_8 byte 'You have entered a bonus stage! Collect the fruits for extra points!', 0

; ����ͼƬ·��
pacman_icon byte './assert/PACMAN.ico', 0
background byte './assert/background.bmp', 0

; ���������ļ�
music_die sbyte '.\music\die.mp3', 0
music_eatghost sbyte '.\music\eatghost.mp3', 0
music_powerpill sbyte '.\music\powerpill.mp3', 0
music_theme sbyte '.\music\theme.mp3', 0
music_wake sbyte '.\music\wake.mp3', 0

.data
;in control_frame_rate draw_window
is_show dword 0         ; is_show�����Ƿ��ڴ��ڻ���֡
is_buffer dword 1       ; is_buffer�Ƿ�����򻺳������֡
frame_time dword 20000  ; frame_time���ڿ�����ʾ֡��ʱ����
dw1m dword 1000000      ; frame_time/dwlm=ÿn��ˢ��һ��,����Ϊÿ0.02��ˢ��һ��(֡��=50֡/s)
;in draw_window and create_buffer
buffer_index dword 0
buffer_cnt dword 0      ; ���建����������

; ���ӵ��߼�״̬���壬time/dwlm=n(��)ʱ����
is_super_pacman dword 0                     
superbean_time dword 10000000                ; ������ʱ�䣺10��
is_fast_pacman dword 0
fastbean_time dword 10000000                 ; ���ٶ�ʱ�䣺10��
is_invisible_pacman dword 0
invisiblebean_time dword 10000000            ; ����ʱ�䣺10��

switching_time dword 15000000                ; ��˫��ģʽ�У�ÿ15���л�һ������׷��Ŀ��
is_chasing_pacman dword 0

; ��ϫʽ׷��Զ��ˣ�������׷���ɢ��״̬֮�䷴���л�
chasing_time dword 20000000                  ; ��������׷��Զ���ʱ�䣺20��
scatter_time dword 8000000                   ; ����������ɢʱ�䣺8��

; �������ֿ��ض���
play_die_music dword 0
play_eatghost_music dword 0
play_power_pill_music dword 0
play_theme_music dword 0
play_wake_music dword 0

; ��һ�ؿ���ʾ�����Զ��ر�ʱ��
is_gamenextstage dword 0
gamenextstage_time dword 5000000            ; ��һ�ؿ���ʾ�����Զ��ر�ʱ�䣺5��

; ����������ͷ�����
release_nxt_ghost dword 0
firstghost_time dword 1000000               ; �ؿ���ʼ1����ͷŵ�һ������                   
nextghost_time dword 3000000                ; ÿ��3���ͷ�һ������

.data
; ���ڼ���������
wndClassName sbyte 'PacMan', 0			; ��������
titleBarName sbyte 'Pac Man', 0			; ��������
windowX dword 200						; ����Xλ��
windowY dword 100						; ����Yλ��
windowWidth dword 900					; ���ڿ��
windowHeight dword 700					; ���ڸ߶�

mapGridWidth dword 20                   ; ��ͼһ��Ŀ��

stateSwitch dword 0                     ; �Զ��˻�����Ķ�̬�л�
textIsShow dword 1                      ; ����������˸Ч��

superBeanRadius dword 5                 ; Բ�ζ��İ뾶

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

.data?
; δ��ʼ����������
h_dc_background dword ?
h_dc_buffer dword buffer_size dup(?)
h_dc_buffer_size dword buffer_size dup(?)
h_dc_bmp dword ?
h_dc_bmp_size dword ?

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

hDc HDC ?
hMemoryDc HDC ?
hMemoryBitmap HBITMAP ?

.code
; ������������
public is_super_pacman, is_fast_pacman, is_invisible_pacman
public is_chasing_pacman
public windowX 
public windowY 
public windowWidth 
public windowHeight 
public h_dc_buffer
public h_dc_buffer_size

public mapGridWidth

public superBeanRadius

public h_dc_background
public h_dc_start_up
public h_dc_game_over
public h_dc_map_and_bean
public h_dc_panel

public h_dc_bmp
public h_dc_bmp_size

public h_dc_pacman1_left, h_dc_pacman1_down, h_dc_pacman1_right, h_dc_pacman1_up
public h_dc_pacman2_left, h_dc_pacman2_down, h_dc_pacman2_right, h_dc_pacman2_up
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

.code
;�����ⲿ����
;C��׼�⺯��
printf PROTO C :dword, :vararg
srand PROTO C :dword
rand PROTO C

;pacman_initcontext.asm
initialize_graphics_context PROTO :HDC

;pacman_animation.asm
draw_item PROTO :draw_struct,:dword

;pacman_logic.asm
draw_map PROTO   
speed_down_pacman PROTO
enter_frightened PROTO
end_frightened PROTO
cycle_to_chase PROTO
cycle_to_scatter PROTO
release_ghost PROTO
end_invisible_pacman PROTO
init_map PROTO

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

;pacman_drawmap.asm
paintBean PROTO :HDC
paintMap PROTO :HDC

.code
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

; ���Ƶ�ͼ�����ӣ���壬win/lose/nextstage����
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
    ret
paintInMemoryDc endp

;��һ�ؿ����涨ʱ��
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

    mov score, 0
    mov is_gamenextstage, 0

    call init_map

    inc level

    mov game_state, Game_State_Play

    jmp loop_nxt_stage

    endloop:
    ret
timer_NextStage endp

; ��������ʱ��
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

; ���ٶ���ʱ��
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

; ������ʱ��
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

; ˫��ģʽ���л�����׷��Ŀ�궨ʱ��
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

; �����м���ͷ����鶨ʱ��
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

;֡����ʱ�����̶������is_show����Ϊ1�Կ�����ʾ֡��
control_frame_rate proc uses eax edx                             ;ͨ������ is_show ������ֵ��������Ⱦ֡�����
    local time1:qword,time2:qword,freq:qword             
    mov is_show, 1                                         
    invoke QueryPerformanceFrequency, addr freq         ;��ȡ�߾��ȼ�ʱ����Ƶ��
    finit
    .while is_buffer == 1
        invoke QueryPerformanceCounter,addr time1       ;��ȡ��ǰ���ܼ������ļ���ֵ���߾��ȵ�ʱ�����
        mov is_show, 1  
        xor eax, eax
        .while eax < frame_time
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
        
        push eax
        mov eax, mapGridWidth
        .if buffer_index == eax
            mov buffer_index, 0
        .endif
        pop eax

        mov is_show, 0                          ; is_showΪ0��ʾ��ǰ������������ϣ�Ϊ1��ʾ��Ҫ�������ڴӻ���������һ��ͼ��
        jmp main_loop

    main_loop_end:
        ret
draw_window ENDP

; �򻺳��������ͼ��
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
            mov ecx, mapGridWidth
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
            mov ecx, mapGridWidth
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

; �رմ��ڣ��ͷ���Դ
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

; (����)���ֲ����߳�
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
    ;debugģʽ�£�����Lose��Win��NextStage����
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

; ���������ź���
processSizeChange proc uses ebx ecx eax, _lParam: LPARAM
    mov ebx, _lParam
    mov ecx, ebx
    and ebx, 0FFFFh           ; ebx�д�Ŵ��ڱ仯�Ŀ��
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

; ��ʼ�����ڣ������߳�
init_window proc, _hDc:HDC, hWnd: HWND
    invoke initialize_graphics_context, _hDc                                       ;��������h_dc��ʹ�ú�ɫ������ͼƬ����buffer����ʱbufferΪ������ʼ��gamestateΪready
    invoke playMusic, addr music_theme, 0
    ; �������洴������ʾ�߳�
    invoke CreateThread, NULL, 0, draw_window, NULL, 0, NULL
    invoke CreateThread, NULL, 0, create_buffer, NULL, 0, NULL
    ;������ʱ��
        ; ֡�����ƶ�ʱ�������ڿ�����ʾ֡��
    invoke CreateThread, NULL, 0, control_frame_rate, NULL, 0, NULL
        ; ������ʾ��ʱ��
    invoke CreateThread, NULL, 0, timer_NextStage, NULL, 0, NULL
        ; ����ʱ�䶨ʱ��
    invoke CreateThread, NULL, 0, timer_issuper, NULL, 0, NULL
    invoke CreateThread, NULL, 0, timer_isfast, NULL, 0, NULL
    invoke CreateThread, NULL, 0, timer_isinvisible, NULL, 0, NULL
        ; ����׷��ģʽ��׷��Ŀ�궨ʱ��
    invoke CreateThread, NULL, 0, timer_isSwitching, NULL, 0, NULL
    invoke CreateThread, NULL, 0, timer_ischasing, NULL, 0, NULL
        ; ����ͷ����鶨ʱ��
    invoke CreateThread, NULL, 0, timer_Release , NULL, 0, NULL

    ;�������������߳�
    invoke CreateThread, NULL, 0, play_music , NULL, 0, NULL    ; play_music��Ҫ�Ĵ���ԭ���Ǵ���һ��bug
                                                                ; ��pacman�ھ�ֹ�����������ʱ������˵����ǰ���ǽ�ϵȣ������������ֻᱻ���������´�������
                                                                ; ��Ϊ��ʱlogic�����drawmap�㽫�������ж�pacman�����������ˣ������������ж�game_stateΪLose
    ret
init_window endp

; ��������Ϣ����
WndProc proc, hWnd: HWND, msgID: UINT, wParam: WPARAM, lParam: LPARAM
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
	.endif

	invoke DefWindowProc, hWnd, msgID, wParam, lParam
	ret
WndProc endp

; ���ѡ�������ڱ��⺯��
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
    ; ����������
	local @wc: WNDCLASS, @hIns: HINSTANCE, @hWnd: HWND, @nMsg: MSG

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

	mov @wc.lpfnWndProc, offset WndProc		; ��ȡ���ڴ�������ַ
	mov @wc.lpszClassName, offset wndClassName
	mov @wc.lpszMenuName, NULL
	; ע�ᴰ����
	invoke RegisterClass, addr @wc

    ;���ѡ�������ڱ���
    invoke random_str_main_caption

	; ���ڴ��д�������
	invoke CreateWindowEx, 0, addr wndClassName, offset str_main_caption, WS_OVERLAPPEDWINDOW, \
		windowX, windowY, windowWidth, windowHeight, NULL, NULL, @hIns, NULL
	mov @hWnd, eax
			
	; ��ʾ����
	invoke ShowWindow, @hWnd, SW_SHOW
	invoke UpdateWindow, @hWnd

	; ��Ϣѭ������������Ϣ
    invoke GetMessage, addr @nMsg, NULL, 0, 0
	.while eax
        invoke TranslateMessage, addr @nMsg
		invoke DispatchMessage, addr @nMsg		; ����Ϣ�������ڴ�����������
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