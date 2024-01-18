.386
.model flat, stdcall
option casemap: none


; 导入库
includelib user32.lib
includelib gdi32.lib
includelib kernel32.lib
includelib msimg32.lib
includelib msvcrt.lib

; 导入文件
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
; 外部变量声明
extern draw_list:draw_struct
extern draw_list_size:dword
extern game_state:dword                 ; 游戏状态
extern need_redraw:dword
extern player_PacMan:player_struct
extern player_RedMan:player_struct
extern player_Cindy:player_struct                   
extern score:dword                       ; 游戏得分
extern game_mode:dword                   ; 设定游戏模式
extern chase_target:dword                ; 多人模式中设置幽灵追逐目标
extern map_cols:dword                    ; 地图的宽度
extern map_rows:dword                    ; 地图的高度
extern mapX:dword                        ; 地图的左上角X坐标
extern mapY:dword                        ; 地图的左上角Y坐标

.data
; 定义窗口标题（运行时随机选择显示）
str_main_caption   byte 200 dup(0)
str_main_caption_1 byte 'Pac-Man is currently searching for dots... Have fun!', 0
str_main_caption_2 byte 'Monsters are approaching you, stay vigilant!', 0
str_main_caption_3 byte 'Which way to go at the next corner? Think calmly!', 0
str_main_caption_4 byte 'Whats the use of bigger dots? Give it a try!', 0
str_main_caption_5 byte 'Collected all the dots to pass this level! Come on!', 0
str_main_caption_6 byte 'Watch out for the flashing monsters! They can still hurt you!', 0
str_main_caption_7 byte 'You have earned an extra life! How far can you go?', 0
str_main_caption_8 byte 'You have entered a bonus stage! Collect the fruits for extra points!', 0

; 定义图片路径
pacman_icon byte './assert/PACMAN.ico', 0
background byte './assert/background.bmp', 0

; 定义音乐文件
music_die sbyte '.\music\die.mp3', 0
music_eatghost sbyte '.\music\eatghost.mp3', 0
music_powerpill sbyte '.\music\powerpill.mp3', 0
music_theme sbyte '.\music\theme.mp3', 0
music_wake sbyte '.\music\wake.mp3', 0

.data
;in control_frame_rate draw_window
is_show dword 0         ; is_show控制是否在窗口绘制帧
is_buffer dword 1       ; is_buffer是否继续向缓冲区填充帧
frame_time dword 20000  ; frame_time用于控制显示帧的时间间隔
dw1m dword 1000000      ; frame_time/dwlm=每n秒刷新一次,设置为每0.02秒刷新一次(帧率=50帧/s)
;in draw_window and create_buffer
buffer_index dword 0
buffer_cnt dword 0      ; 定义缓冲区计数器

; 附加道具及状态定义，time/dwlm=n(秒)时间间隔
is_super_pacman dword 0                     
superbean_time dword 10000000                ; 超级豆时间：10秒
is_fast_pacman dword 0
fastbean_time dword 10000000                 ; 快速豆时间：10秒
is_invisible_pacman dword 0
invisiblebean_time dword 10000000            ; 隐身豆时间：10秒

switching_time dword 15000000                ; 在双人模式中，每15秒切换一次幽灵追逐目标
is_chasing_pacman dword 0

; 潮汐式追逐吃豆人，幽灵在追逐和散开状态之间反复切换
chasing_time dword 20000000                  ; 单次连续追逐吃豆人时间：20秒
scatter_time dword 8000000                   ; 单次连续分散时间：8秒

; 播放音乐开关定义
play_die_music dword 0
play_eatghost_music dword 0
play_power_pill_music dword 0
play_theme_music dword 0
play_wake_music dword 0

; 下一关卡显示界面自动关闭时间
is_gamenextstage dword 0
gamenextstage_time dword 5000000            ; 下一关卡显示界面自动关闭时间：5秒

; 间隔从笼中释放幽灵
release_nxt_ghost dword 0
firstghost_time dword 1000000               ; 关卡开始1秒后释放第一个幽灵                   
nextghost_time dword 3000000                ; 每隔3秒释放一个幽灵

.data
; 窗口及参数定义
wndClassName sbyte 'PacMan', 0			; 窗口类名
titleBarName sbyte 'Pac Man', 0			; 标题栏名
windowX dword 200						; 窗口X位置
windowY dword 100						; 窗口Y位置
windowWidth dword 900					; 窗口宽度
windowHeight dword 700					; 窗口高度

mapGridWidth dword 20                   ; 地图一格的宽度

stateSwitch dword 0                     ; 吃豆人或幽灵的动态切换
textIsShow dword 1                      ; 控制文字闪烁效果

superBeanRadius dword 5                 ; 圆形豆的半径

; 启动界面相关配置
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

; 游戏模式：单人模式，双人合作模式，双人追逐模式
singleMode sbyte '单人模式', 0
doubleCooperateMode sbyte '双人合作模式', 0
doubleChaseMode sbyte '双人追逐模式', 0
gapGameMode dword 10
gapBetweenGameNameAndGameMode dword 20
gameModeFontName sbyte '黑体', 0
gameModeRectHeight dword 20
gameModeColor dword 00FFFFFFh
gameModeSelect dword 000000FFh

; 开始游戏提示
gapBetweenGameModeAndStartTip dword 10
startTip sbyte 'Press [Enter] to Start', 0
startTipFontName sbyte 'Courier', 0
startTipRectHeight dword 20
startTipColor dword 00CCCCCCh

;关闭窗口提示
gapBetweenFinalScoreAndCloseTip dword 40
closeTip sbyte 'Press [Enter] to Quit', 0
closeTipFontName sbyte 'Courier', 0
closeTipRectHeight dword 20
closeTipColor dword 00CCCCCCh

gapBetweenStartTipAndTeacher dword 80
teacher sbyte '指导教师：张华平', 0
teacherFontName sbyte '华文行楷', 0
teacherRectHeight dword 30
teacherColor dword 0091FEFFh

gapBetweenTeacherAndAuthor dword 20
author sbyte '小组成员：王英泰 陈钰豪 黄睿勤 龚方南', 0
authorFontName sbyte '方正姚体', 0
authorRectHeight dword 20
authorColor dword 00FFFFFFh

; 右侧面板相关参数
panelX dword 600
panelWidth dword 300
level dword 1
life dword 4
; score为EXTERN变量

; 右侧面板相关配置
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


; 结束界面相关配置
gameOverTop dword 150
gameOver sbyte 'GAME OVER', 0
gameOverFontName sbyte 'Courier', 0
gameOverRectHeight dword 60
gameOverColor dword 00FFFFFFh

; 胜利界面相关配置
gameWinTop dword 150
gameWin sbyte 'GRATS! YOU WIN', 0
gameWinFontName sbyte 'Courier', 0
gameWinRectHeight dword 60
gameWinColor dword 00FFFFFFh

; 下一关卡界面相关配置
gameNxtStageTop dword 150
gameNxtStage sbyte 'GRATS! NEXT STAGE', 0
gameNxtStageFontName sbyte 'Courier', 0
gameNxtStageRectHeight dword 60
gameNxtStageColor dword 00FFFFFFh

; 本关得分相关设置
gapBetweenGameNxtStageAndFinalScore dword 50
StageScoreFormat sbyte 'STAGE SCORE: %d', 0
StageScore sbyte 20 dup(0)
StageScoreFontName sbyte 'Courier', 0
StageScoreRectHeight dword 40
StageScoreColor dword 00FFFFFFh

; 最终得分相关配置
gapBetweenGameOverAndFinalScore dword 50
gapBetweenGameWinAndFinalScore dword 50
finalScoreFormat sbyte 'FINAL SCORE: %d', 0
finalScore sbyte 20 dup(0)
finalScoreFontName sbyte 'Courier', 0
finalScoreRectHeight dword 40
finalScoreColor dword 00FFFFFFh

.data?
; 未初始化变量声明
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
; 公共变量定义
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
;定义外部函数
;C标准库函数
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
; 画饼图，从而绘制启动界面的吃豆人
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
; 显示单行字的封装函数
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

    ; 定位吃豆人的位置矩形
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

    ; 每次调用该函数时改变iconOpenSize，从而实现吃豆人张嘴闭嘴动画
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


    ; 画启动界面的吃豆人
    invoke paintPie, _hDc, @iconLeftRect, @iconTopRect, @iconRightRect, @iconBottomRect


    ; 显示游戏名
    mov eax, @iconBottomRect
    add eax, gapBetweenIconAndGameName
    invoke paintText, _hDc, addr gameName, 0, eax, windowWidth, gameNameRectHeight, FW_HEAVY, ANSI_CHARSET, \
        addr gameNameFontName, gameNameColor, DT_CENTER, 1
    add eax, gameNameRectHeight
    
    ; ************************************************************************** 新 ******************************************************************
    ; 显示游戏模式
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

    ; ************************************************************************** 新 ******************************************************************
    ; 显示开始游戏提示
    add eax, gapBetweenGameModeAndStartTip ; ***************************************************************** 修改名字 ************************************************
    invoke paintText, _hDc, addr startTip, 0, eax, windowWidth, startTipRectHeight, FW_HEAVY, ANSI_CHARSET, \
        addr startTipFontName, startTipColor, DT_CENTER, textIsShow
    add eax, startTipRectHeight
    

    ; 显示指导教师
    add eax, gapBetweenStartTipAndTeacher
    invoke paintText, _hDc, addr teacher, 0, eax, windowWidth, teacherRectHeight, FW_NORMAL, GB2312_CHARSET, \
        addr teacherFontName, teacherColor, DT_CENTER, 1
    add eax, teacherRectHeight


    ; 显示作者
    add eax, gapBetweenTeacherAndAuthor
    invoke paintText, _hDc, addr author, 0, eax, windowWidth, authorRectHeight, FW_NORMAL, GB2312_CHARSET, \
        addr authorFontName, authorColor, DT_CENTER, 1
    add eax, authorRectHeight

    ret
paintReadyScreen endp


paintRightPanel proc, _hDc: HDC, _isPause
    pushad

    ; 显示**score**
    mov eax, scoreStrTop
    invoke paintText, _hDc, addr scoreStr, panelX, eax, panelWidth, scoreStrRectHeight, FW_HEAVY, ANSI_CHARSET, \
    addr scoreStrFontName, scoreStrColor, DT_LEFT, 1
    add eax, scoreStrRectHeight


    ; 显示得分
    add eax, gapBetweenScoreStrAndScoreNum
    push eax
    invoke crt_sprintf, addr scoreNum, addr scoreNumFormat, score
    pop eax
    invoke paintText, _hDc, addr scoreNum, panelX, eax, panelWidth, scoreNumRectHeight, FW_HEAVY, ANSI_CHARSET, \
        addr scoreNumFontName, scoreNumColor, DT_LEFT, 1
    add eax, scoreNumRectHeight


    ; 显示**level**
    add eax, gapBetweenScoreNumAndLevelStr
    invoke paintText, _hDc, addr levelStr, panelX, eax, panelWidth, levelStrRectHeight, FW_HEAVY, ANSI_CHARSET, \
        addr levelStrFontName, levelStrColor, DT_LEFT, 1
    add eax, levelStrRectHeight


    ; 显示关卡
    add eax, gapBetweenLevelStrAndLevelNum
    push eax
    invoke crt_sprintf, addr levelNum, addr levelNumFormat, level
    pop eax
    invoke paintText, _hDc, addr levelNum, panelX, eax, panelWidth, levelNumRectHeight, FW_HEAVY, ANSI_CHARSET, \
        addr levelNumFontName, levelNumColor, DT_LEFT, 1


    ; 显示**Pause**
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
    ; 显示**game over**
    pushad

    mov eax, gameOverTop
    invoke paintText, _hDc, addr gameOver, 0, eax, windowWidth, gameOverRectHeight, FW_HEAVY, ANSI_CHARSET, \
        addr gameOverFontName, gameOverColor, DT_CENTER, 1
    add eax, gameOverRectHeight

    ; 显示最终得分
    add eax, gapBetweenGameOverAndFinalScore
    push eax
    invoke crt_sprintf, addr finalScore, addr finalScoreFormat, score
    pop eax
    invoke paintText, _hDc, addr finalScore, 0, eax, windowWidth, finalScoreRectHeight, FW_HEAVY, ANSI_CHARSET, \
        addr finalScoreFontName, finalScoreColor, DT_CENTER, 1
    add eax, finalScoreRectHeight
    ; 显示关闭窗口提示
    add eax, gapBetweenFinalScoreAndCloseTip
    invoke paintText, _hDc, addr closeTip, 0, eax, windowWidth, closeTipRectHeight, FW_HEAVY, ANSI_CHARSET, \
        addr closeTipFontName, closeTipColor, DT_CENTER, textIsShow
    add eax, closeTipRectHeight
    
    popad
    ret
paintGameOverScreen endp

paintGameWinScreen proc, _hDc: HDC
    ; 显示**game win**
    pushad

    mov eax, gameWinTop
    invoke paintText, _hDc, addr gameWin, 0, eax, windowWidth, gameWinRectHeight, FW_HEAVY, ANSI_CHARSET, \
        addr gameWinFontName, gameWinColor, DT_CENTER, 1
    add eax, gameWinRectHeight

    ; 显示最终得分
    add eax, gapBetweenGameWinAndFinalScore
    push eax
    invoke crt_sprintf, addr finalScore, addr finalScoreFormat, score
    pop eax
    invoke paintText, _hDc, addr finalScore, 0, eax, windowWidth, finalScoreRectHeight, FW_HEAVY, ANSI_CHARSET, \
        addr finalScoreFontName, finalScoreColor, DT_CENTER, 1
    add eax, finalScoreRectHeight

    ; 显示关闭窗口提示
    add eax, gapBetweenFinalScoreAndCloseTip
    invoke paintText, _hDc, addr closeTip, 0, eax, windowWidth, closeTipRectHeight, FW_HEAVY, ANSI_CHARSET, \
        addr closeTipFontName, closeTipColor, DT_CENTER, textIsShow
    add eax, closeTipRectHeight
    
    popad
    ret
paintGameWinScreen endp

paintNxtStageScreen proc, _hDc: HDC
    ; 显示**next stage**
    pushad

    mov eax, gameNxtStageTop
    invoke paintText, _hDc, addr gameNxtStage, 0, eax, windowWidth, gameNxtStageRectHeight, FW_HEAVY, ANSI_CHARSET, \
        addr gameNxtStageFontName, gameNxtStageColor, DT_CENTER, 1
    add eax, gameNxtStageRectHeight

    ; 显示关卡得分
    add eax, gapBetweenGameNxtStageAndFinalScore
    push eax
    invoke crt_sprintf, addr StageScore, addr StageScoreFormat, score
    pop eax
    invoke paintText, _hDc, addr StageScore, 0, eax, windowWidth, StageScoreRectHeight, FW_HEAVY, ANSI_CHARSET, \
        addr StageScoreFontName, StageScoreColor, DT_CENTER, textIsShow
    
    popad
    ret
paintNxtStageScreen endp

; 绘制地图，豆子，面板，win/lose/nextstage界面
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

;下一关卡界面定时器
timer_NextStage proc uses eax edx                     
    local time1:qword,time2:qword,freq:qword                                                   
    invoke QueryPerformanceFrequency, addr freq         ;获取高精度计时器的频率
    finit

    loop_nxt_stage:
    ; 检查 is_buffer 是否等于 1
    cmp is_buffer, 1
    jne endloop

    ; 检查 game_state 是否不等于 Game_State_NxtStage
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
        sbb dword ptr time2+4, edx               ;sbb带进位除法
        fild time2
        fimul dw1m
        fild freq
        fdiv
        fistp time2 
        mov eax,dword ptr time2                 ;eax = (time1-time2)/freq = time1和time2之间的时间差（单位:10^-6秒）
                                                ;该时间差即为帧与帧之间的绘制间隔（帧率计算）
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

; 超级豆定时器
timer_issuper proc uses eax edx                     
    local time1:qword,time2:qword,freq:qword                                                   
    invoke QueryPerformanceFrequency, addr freq         ;获取高精度计时器的频率
    finit

    loop_is_super:
    ; 检查 is_buffer 是否等于 1
    cmp is_buffer, 1
    jne endloop

    ; 检查 game_state 是否不等于 Game_State_NxtStage
    cmp is_super_pacman, 1
    jne loop_is_super

    invoke QueryPerformanceCounter,addr time1
    xor eax, eax
    .while eax < superbean_time
        invoke QueryPerformanceCounter,addr time2
        mov eax,dword ptr time1             
        mov edx,dword ptr time1+4
        sub dword ptr time2, eax
        sbb dword ptr time2+4, edx               ;sbb带进位除法
        fild time2
        fimul dw1m
        fild freq
        fdiv
        fistp time2 
        mov eax,dword ptr time2                 ;eax = (time1-time2)/freq = time1和time2之间的时间差（单位:10^-6秒）
                                                ;该时间差即为帧与帧之间的绘制间隔（帧率计算）
    .endw

    mov is_super_pacman, 0
    invoke end_frightened

    jmp loop_is_super

    endloop:
    ret
timer_issuper endp

; 快速豆定时器
timer_isfast proc uses eax edx                     
    local time1:qword,time2:qword,freq:qword                                                   
    invoke QueryPerformanceFrequency, addr freq         ;获取高精度计时器的频率
    finit

    loop_is_fast:
    ; 检查 is_buffer 是否等于 1
    cmp is_buffer, 1
    jne endloop

    ; 检查 game_state 是否不等于 Game_State_NxtStage
    cmp is_fast_pacman, 1
    jne loop_is_fast

    invoke QueryPerformanceCounter,addr time1
    xor eax, eax
    .while eax < fastbean_time
        invoke QueryPerformanceCounter,addr time2
        mov eax,dword ptr time1             
        mov edx,dword ptr time1+4
        sub dword ptr time2, eax
        sbb dword ptr time2+4, edx               ;sbb带进位除法
        fild time2
        fimul dw1m
        fild freq
        fdiv
        fistp time2 
        mov eax,dword ptr time2                 ;eax = (time1-time2)/freq = time1和time2之间的时间差（单位:10^-6秒）
                                                ;该时间差即为帧与帧之间的绘制间隔（帧率计算）
    .endw

    mov is_fast_pacman, 0
    invoke speed_down_pacman

    jmp loop_is_fast

    endloop:
    ret
timer_isfast endp

; 隐身豆定时器
timer_isinvisible proc uses eax edx                     
    local time1:qword,time2:qword,freq:qword                                                   
    invoke QueryPerformanceFrequency, addr freq         ;获取高精度计时器的频率
    finit

    loop_is_invisible:
    ; 检查 is_buffer 是否等于 1
    cmp is_buffer, 1
    jne endloop

    ; 检查 game_state 是否不等于 Game_State_NxtStage
    cmp is_invisible_pacman, 1
    jne loop_is_invisible

    invoke QueryPerformanceCounter,addr time1
    xor eax, eax
    .while eax < invisiblebean_time
        invoke QueryPerformanceCounter,addr time2
        mov eax,dword ptr time1             
        mov edx,dword ptr time1+4
        sub dword ptr time2, eax
        sbb dword ptr time2+4, edx               ;sbb带进位除法
        fild time2
        fimul dw1m
        fild freq
        fdiv
        fistp time2 
        mov eax,dword ptr time2                 ;eax = (time1-time2)/freq = time1和time2之间的时间差（单位:10^-6秒）
                                                ;该时间差即为帧与帧之间的绘制间隔（帧率计算）
    .endw

    mov is_invisible_pacman, 0
    invoke end_invisible_pacman
    jmp loop_is_invisible

    endloop:
    ret
timer_isinvisible endp

; 双人模式中切换幽灵追逐目标定时器
timer_isSwitching proc uses eax edx                     
    local time1:qword,time2:qword,freq:qword                                                   
    invoke QueryPerformanceFrequency, addr freq         ;获取高精度计时器的频率
    finit

    loop_is_switching:
    ; 检查 is_buffer 是否等于 1
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
        sbb dword ptr time2+4, edx               ;sbb带进位除法
        fild time2
        fimul dw1m
        fild freq
        fdiv
        fistp time2 
        mov eax,dword ptr time2                 ;eax = (time1-time2)/freq = time1和time2之间的时间差（单位:10^-6秒）
                                                ;该时间差即为帧与帧之间的绘制间隔（帧率计算）
    .endw

    mov chase_target, RedMan
    jmp loop_is_switching

    endloop:
    ret
timer_isSwitching endp

; is_chasing定时器，周期性改变怪物追逐方式
timer_ischasing proc uses eax edx                     
    local time1:qword,time2:qword,freq:qword                                                   
    invoke QueryPerformanceFrequency, addr freq         ;获取高精度计时器的频率
    finit

    loop_is_chasing:
    ; 检查 is_buffer 是否等于 1
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
        sbb dword ptr time2+4, edx               ;sbb带进位除法
        fild time2
        fimul dw1m
        fild freq
        fdiv
        fistp time2 
        mov eax,dword ptr time2                 ;eax = (time1-time2)/freq = time1和time2之间的时间差（单位:10^-6秒）
                                                ;该时间差即为帧与帧之间的绘制间隔（帧率计算）
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
        sbb dword ptr time2+4, edx               ;sbb带进位除法
        fild time2
        fimul dw1m
        fild freq
        fdiv
        fistp time2 
        mov eax,dword ptr time2                 ;eax = (time1-time2)/freq = time1和time2之间的时间差（单位:10^-6秒）
                                                ;该时间差即为帧与帧之间的绘制间隔（帧率计算）
    .endw

    jmp loop_is_chasing

    endloop:
    ret
timer_ischasing endp

; 从笼中间隔释放幽灵定时器
timer_Release proc uses eax edx                     
    local time1:qword,time2:qword,freq:qword, @cnt:dword                                              
    invoke QueryPerformanceFrequency, addr freq         ;获取高精度计时器的频率
    finit

    loop_release:
    ; 检查 is_buffer 是否等于 1
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
        sbb dword ptr time2+4, edx               ;sbb带进位除法
        fild time2
        fimul dw1m
        fild freq
        fdiv
        fistp time2 
        mov eax,dword ptr time2                 ;eax = (time1-time2)/freq = time1和time2之间的时间差（单位:10^-6秒）
                                                ;该时间差即为帧与帧之间的绘制间隔（帧率计算）
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
            sbb dword ptr time2+4, edx               ;sbb带进位除法
            fild time2
            fimul dw1m
            fild freq
            fdiv
            fistp time2 
            mov eax,dword ptr time2                 ;eax = (time1-time2)/freq = time1和time2之间的时间差（单位:10^-6秒）
                                                ;该时间差即为帧与帧之间的绘制间隔（帧率计算）
        .endw
        invoke release_ghost
        inc @cnt
    .endw

    mov release_nxt_ghost, 0

    endloop:
    ret
timer_Release endp

;帧数定时器，固定间隔将is_show设置为1以控制显示帧率
control_frame_rate proc uses eax edx                             ;通过控制 is_show 变量的值来控制渲染帧的输出
    local time1:qword,time2:qword,freq:qword             
    mov is_show, 1                                         
    invoke QueryPerformanceFrequency, addr freq         ;获取高精度计时器的频率
    finit
    .while is_buffer == 1
        invoke QueryPerformanceCounter,addr time1       ;获取当前性能计数器的计数值（高精度的时间戳）
        mov is_show, 1  
        xor eax, eax
        .while eax < frame_time
            invoke QueryPerformanceCounter,addr time2
            mov eax,dword ptr time1             
            mov edx,dword ptr time1+4
            sub dword ptr time2, eax
            sbb dword ptr time2+4, edx               ;sbb带进位除法
            fild time2
            fimul dw1m
            fild freq
            fdiv
            fistp time2 
            mov eax,dword ptr time2                 ;eax = (time1-time2)/freq = time1和time2之间的时间差（单位:10^-6秒）
                                                    ;该时间差即为帧与帧之间的绘制间隔（帧率计算）
        .endw
    .endw
    ret
control_frame_rate endp

;在窗口中绘制图像
draw_window PROC uses eax 
    local h_dc

    main_loop:
        cmp is_buffer, 0
        jz main_loop_end

        .while buffer_cnt == 0 || (!is_show)    ;检查缓冲区是否可用
        .endw                                   ;当 is_show 标志变为 true 时且缓冲区不为空时，
                                                ;函数将获取主窗口的设备上下文并使用 BitBlt 将图像从适当的缓冲区复制到窗口上
                                                ;否则循环等待

        mov eax, buffer_index
        invoke	BitBlt,hDc,0,0,windowWidth,windowHeight,\  ;一次从h_dc_buffer取出一张图像（而不是一个物体的h_dc）并绘制到屏幕上）
            h_dc_buffer[4*eax],0,0,SRCCOPY

        dec buffer_cnt
        inc buffer_index
        
        push eax
        mov eax, mapGridWidth
        .if buffer_index == eax
            mov buffer_index, 0
        .endif
        pop eax

        mov is_show, 0                          ; is_show为0标示当前缓冲区绘制完毕，为1标示将要或者正在从缓冲区加载一张图像
        jmp main_loop

    main_loop_end:
        ret
draw_window ENDP

; 向缓冲区中填充图像
create_buffer proc uses ecx esi edi eax
    local @cnt
    local @drawlist_cnt

    main_loop:
        cmp is_buffer, 0
        jz main_loop_end

    .while buffer_cnt != 0 ;当缓冲区不为空时，不向内填充图像，直到缓冲区为
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

; 关闭窗口，释放资源
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

; (死亡)音乐播放线程
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
    .if wParam == VK_RETURN ;游戏开始
        .if game_state == Game_State_Ready
            mov game_state, Game_State_Play
            mov release_nxt_ghost, 1
            invoke playMusic, addr music_wake, 1
        .elseif game_state == Game_State_Win || game_state == Game_State_Lose
        ; 关闭窗口
        invoke SendMessage, _hWnd, WM_CLOSE, 0, 0
        .endif
    .endif
    .if wParam == VK_SPACE ; 游戏暂停
        .if game_state == Game_State_Play
            mov game_state, Game_State_Pause
            invoke pauseAllMusic
        .elseif game_state == Game_State_Pause
            mov game_state, Game_State_Play
            invoke resumeAllMusic
        .endif
    .endif
    .if wParam == VK_LEFT || wParam == VK_UP || wParam == VK_RIGHT || wParam == VK_DOWN; 方向输入引起方向变化
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
    .if wParam == VK_A || wParam == VK_W || wParam == VK_D || wParam == VK_S; 方向输入引起方向变化
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
    ;debug模式下，测试Lose，Win，NextStage窗口
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

; 处理窗口缩放函数
processSizeChange proc uses ebx ecx eax, _lParam: LPARAM
    mov ebx, _lParam
    mov ecx, ebx
    and ebx, 0FFFFh           ; ebx中存放窗口变化的宽度
    shr ecx, 16              ; ecx中存放窗口便后的高度
    mov windowWidth, ebx
    mov windowHeight, ecx

    mov eax, ecx
    sub eax, 20                 ; 减去上下边距
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

; 初始化窗口，创建线程
init_window proc, _hDc:HDC, hWnd: HWND
    invoke initialize_graphics_context, _hDc                                       ;创建所有h_dc，使用黑色空区域图片填满buffer，此时buffer为满，初始化gamestate为ready
    invoke playMusic, addr music_theme, 0
    ; 创建画面创建及显示线程
    invoke CreateThread, NULL, 0, draw_window, NULL, 0, NULL
    invoke CreateThread, NULL, 0, create_buffer, NULL, 0, NULL
    ;创建定时器
        ; 帧数控制定时器，用于控制显示帧数
    invoke CreateThread, NULL, 0, control_frame_rate, NULL, 0, NULL
        ; 界面显示定时器
    invoke CreateThread, NULL, 0, timer_NextStage, NULL, 0, NULL
        ; 道具时间定时器
    invoke CreateThread, NULL, 0, timer_issuper, NULL, 0, NULL
    invoke CreateThread, NULL, 0, timer_isfast, NULL, 0, NULL
    invoke CreateThread, NULL, 0, timer_isinvisible, NULL, 0, NULL
        ; 幽灵追逐模式和追逐目标定时器
    invoke CreateThread, NULL, 0, timer_isSwitching, NULL, 0, NULL
    invoke CreateThread, NULL, 0, timer_ischasing, NULL, 0, NULL
        ; 间隔释放幽灵定时器
    invoke CreateThread, NULL, 0, timer_Release , NULL, 0, NULL

    ;创建播放音乐线程
    invoke CreateThread, NULL, 0, play_music , NULL, 0, NULL    ; play_music主要的存在原因是存在一个bug
                                                                ; 当pacman在静止的情况下死亡时（比如说死亡前怼在墙上等），死亡的音乐会被无数次重新创建播放
                                                                ; 因为此时logic层或者drawmap层将无数次判定pacman与幽灵相遇了，或者无数次判断game_state为Lose
    ret
init_window endp

; 处理窗口消息函数
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

    .elseif msgID == WM_ERASEBKGND  ; 屏蔽背景刷新
        ret
    .elseif msgID == WM_SIZE        ; 窗口大小发生变化时需要重新绘制
        invoke processSizeChange, lParam
        ;invoke InvalidateRect, hWnd, NULL, TRUE
    .elseif msgID == WM_KEYDOWN     ; 按键消息处理
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

; 随机选择主窗口标题函数
random_str_main_caption proc uses esi edi eax edx ecx
    ; 设置随机数种子
    invoke GetTickCount
    invoke srand, eax

    ; 生成随机数
    invoke rand

    ; 对随机数进行模运算，限制在 [0, 3] 范围内
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

copy_str:                        ;执行字符串复制
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
    ; 窗口主函数
	local @wc: WNDCLASS, @hIns: HINSTANCE, @hWnd: HWND, @nMsg: MSG

	invoke GetModuleHandle, NULL
	mov	@hIns,eax			                ; 得到应用程序的句柄

	mov @wc.cbClsExtra, 0
	mov @wc.cbWndExtra, 0
	mov @wc.hbrBackground, COLOR_WINDOWTEXT	; 将背景颜色填充为黑色
	mov @wc.hCursor, NULL	                ; 采用系统默认鼠标样式

    invoke LoadImage, NULL, addr pacman_icon, IMAGE_ICON, 0, 0, LR_LOADFROMFILE or LR_SHARED
	mov @wc.hIcon, eax		                ; 设置窗口图标样式
	mov edx, @hIns
	mov @wc.hInstance, edx

	mov @wc.lpfnWndProc, offset WndProc		; 获取窗口处理函数地址
	mov @wc.lpszClassName, offset wndClassName
	mov @wc.lpszMenuName, NULL
	; 注册窗口类
	invoke RegisterClass, addr @wc

    ;随机选择主窗口标题
    invoke random_str_main_caption

	; 在内存中创建窗口
	invoke CreateWindowEx, 0, addr wndClassName, offset str_main_caption, WS_OVERLAPPEDWINDOW, \
		windowX, windowY, windowWidth, windowHeight, NULL, NULL, @hIns, NULL
	mov @hWnd, eax
			
	; 显示窗口
	invoke ShowWindow, @hWnd, SW_SHOW
	invoke UpdateWindow, @hWnd

	; 消息循环，处理窗口消息
    invoke GetMessage, addr @nMsg, NULL, 0, 0
	.while eax
        invoke TranslateMessage, addr @nMsg
		invoke DispatchMessage, addr @nMsg		; 将消息交给窗口处理函数来处理
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