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
includelib msvcrt.lib
include     winmm.inc
includelib  winmm.lib

;TransparentBlt proto stdcall :HDC, :dword, :dword, :dword, :dword, :HDC, :dword, :dword, :dword, :dword, :UINT
; include paintmap.asm

; 常量定义
; 地图item
Item_Empty equ 0
Item_Wall equ 1
Item_GhostHouse equ 2
Item_Bean equ 3
Item_SuperBean equ 4
; 墙的类型
Wall_Corner_LeftUp equ 110
Wall_Corner_RightUp equ 111
Wall_Corner_LeftDown equ 112
Wall_Corner_RightDown equ 113
Wall_Horizontal equ 114
Wall_Vertical equ 115
; 游戏状态
Game_State_Ready equ 10
Game_State_Play equ 11
Game_State_Win equ 12
Game_State_Lose equ 13
Game_State_Pause equ 14

public mapRow,mapCol, mapX, mapY, mapGridWidth

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
public is_super_pacman, is_fast_pacman, is_invisible_pacman, is_chasing_pacman

.data
;窗口类名
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

.data
;in control_frame_rate draw_window
is_show dword 0         
is_buffer dword 1
fps dword 20000         ;!!!这里的fps并不代表帧率!!!
dw1m dword 1000000      ;fps/dwlm=每n秒刷新一次,设置为每0.02秒刷新一次(帧率=50帧/s)
;in draw_window
buffer_index dword 0
buffer_cnt dword 0
;check_operation
pacman_dir dword 2
pacman_now_dir dword 2

.data
is_super_pacman dword 0
superbean_time dword 2000000
is_fast_pacman dword 0
fastbean_time dword 2000000
is_invisible_pacman dword 0
invisiblebean_time dword 2000000
is_chasing_pacman dword 1
chasing_time dword 2000000


.data
message sbyte 100 dup(0)
stdOutputHandle dword 0
format sbyte 'address %d', 0


.data
wndClassName sbyte 'PacMan', 0			; 窗口类名
titleBarName sbyte 'Pac Man', 0			; 标题栏名
windowX dword 200						; 窗口X位置
windowY dword 100						; 窗口Y位置
windowWidth dword 900					; 窗口宽度
windowHeight dword 700					; 窗口高度

playerX dword 100
playerY dword 100

mapCol dword 28                         ; 地图的宽度
mapRow dword 32                         ; 地图的高度
mapGridWidth dword 20                   ; 地图一格的宽度
mapX dword 10                           ; 地图在窗口中的位置
mapY dword 10

wallWidth dword 2                       ; 墙的宽度
wallColor dword 00FF9900h               ; 墙的颜色：00_B_G_R

beanHalfWidth dword 3                   ; 方块豆的宽度的**一半**
beahColor dword 0000FFFFh               ; 方块豆的颜色
superBeanRadius dword 5                 ; 圆形豆的半径
superBeanColor dword 00FFFFFFh          ; 圆形豆的颜色

hDc HDC ?
hMemoryDc HDC ?
hMemoryBitmap HBITMAP ?
stateSwitch dword 0                         ; 用于显示吃豆人或幽灵的动态切换

textIsShow dword 1                          ; 所有文字闪烁效果通过该变量控制

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

gapBetweenGameNameAndStartTip dword 10
startTip sbyte 'Press [Enter] to Start', 0
startTipFontName sbyte 'Courier', 0
startTipRectHeight dword 20
startTipColor dword 00CCCCCCh

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
level dword 12
score dword 100
life dword 4

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
gameOverRectHeight dword 100
gameOverColor dword 00FFFFFFh


gapBetweenGameOverAndFinalScore dword 50
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

;外部变量声明
extern draw_list:draw_struct, draw_list_size:dword
extern game_state:dword
extern need_redraw:dword
extern player_PacMan:player_struct
extern item_map:dword 
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
;定义外部函数
;C标准库函数
printf PROTO C :dword, :vararg
srand PROTO C :dword
rand PROTO C

;pacman_animation.asm
draw_item PROTO :draw_struct,:dword

;pacman_logic.asm
draw_map PROTO   
init_map PROTO

.code
create_background proc uses esi edi eax, h_dc:HDC
    local @cnt:dword
    local h_bmp

    ;这段代码的目的是创建一个设备环境（Device Context，DC）缓冲区，用于存储预渲染的图像。
    ;这样做的好处是可以提高图像绘制的效率。通过预先创建设备环境和位图，
    ;可以避免在绘制图像时频繁地创建和删除GDI对象，从而提高性能。这种技术通常用于图
    ;形密集型的应用程序，如游戏或者动画，其中需要快速连续地绘制图像。
    mov @cnt, 0
    mov esi, offset h_dc_buffer
    mov edi, offset h_dc_buffer_size
    .while @cnt != buffer_size
        invoke	CreateCompatibleDC, h_dc
        mov	[esi], eax
        invoke CreateCompatibleBitmap, h_dc, windowWidth, windowHeight
        mov [edi], eax
        invoke	SelectObject,[esi],[edi]
        invoke SetStretchBltMode,[esi],HALFTONE ;HALFTONE 是 Windows GDI（图形设备接口）中的一种位图拉伸模式
        add esi, 4
        add edi, 4
        inc @cnt
    .endw

    invoke	CreateCompatibleDC, h_dc    ;创建与h_dc兼容的内存设备上下文,返回内存设备上下文的句柄
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

    ; 加载背景位图，并加载到指定的进程上下文中
    invoke	CreateCompatibleDC, h_dc
	mov	h_dc_bmp, eax
    invoke CreateCompatibleBitmap, h_dc, windowWidth, windowHeight
    mov h_dc_bmp_size, eax
    invoke  SelectObject,h_dc_bmp,h_dc_bmp_size
    invoke  SetStretchBltMode,h_dc_bmp,COLORONCOLOR
    ;拉伸位图时，将删除被拉伸的位图的颜色，并使用目标设备环境中最接近的颜色来替换。
    ;这种模式适用于减少拉伸位图时的颜色失真。

    ;加载吃豆人和怪物的位图资源，并加载到指定进程上下文中
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
; 获取地图在(i, j)处的元素；如果越界则返回Item_Wall
    mov ecx, mapRow
    mov edx, mapCol
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


getBorderType proc uses ebx ecx edx, _i: dword, _j: dword
; 判断边界类型
; 返回值：0表示不是墙的边界, 1表示是垂直类型, 2表示是水平类型
; 3表示左上圆弧, 4表示右上圆弧，5表示左下圆弧，6表示右下圆弧
    local @iSub1, @iAdd1, @jSub1, @jAdd1, @upLeft, @upRight, @downLeft, @downRight, \
        @up, @down, @left, @right
    
    ; 为@iSub1, @iAdd1, @jSub1, @jAdd1进行赋值
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
    .if eax == Item_Wall                        ; 当前点的值为1时才可能为边界
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
        ; 当点的四周存在0时才是边界，这里可以改为 != 1
        .if @upLeft != Item_Wall || @up != Item_Wall || @upRight != Item_Wall || @left != Item_Wall || \
            @right != Item_Wall || @downLeft != Item_Wall || @down != Item_Wall || @downRight != Item_Wall
            jmp isABorder
        .endif
    .endif
    xor eax, eax
    ret

isABorder:
    
    .if @right == Item_Wall && @down == Item_Wall && \
        (@downRight != Item_Wall || @upLeft != Item_Wall && @left != Item_Wall && @up != Item_Wall)
        mov eax, Wall_Corner_LeftUp
        ret
    .elseif @left == Item_Wall && @down == Item_Wall && \
        (@downLeft != Item_Wall || @upRight != Item_Wall && @up != Item_Wall && @right != Item_Wall)
        mov eax, Wall_Corner_RightUp
        ret
    .elseif @up == Item_Wall && @right == Item_Wall && \ 
        (@upRight != Item_Wall || @downLeft != Item_Wall && @left != Item_Wall && @down != Item_Wall)
        mov eax, Wall_Corner_LeftDown
        ret
    .elseif @up == Item_Wall && @left == Item_Wall && \ 
        (@upLeft != Item_Wall || @downRight != Item_Wall && @down != Item_Wall && @right != Item_Wall)
        mov eax, Wall_Corner_RightDown
        ret
    .elseif (@left == Item_Wall || @right == Item_Wall) && (@up != Item_Wall || @down != Item_Wall)
        mov eax, Wall_Horizontal
        ret
    .elseif (@up == Item_Wall || @down == Item_Wall) && (@left != Item_Wall || @right != Item_Wall) 
        mov eax, Wall_Vertical
        ret
    .endif

    xor eax, eax
    ret
getBorderType endp


paintLine proc, _hDc: HDC, _i: dword, _j: dword, _type: dword
; 画线函数，根据_type来画垂直线或水平线
    local @startX: dword, @startY: dword, @endX: dword, @endY: dword
    pushad

    ; 将@startX、@endX初始化为方格左上角
    mov eax, mapGridWidth

    mov edx, mapX
    mov @startX, edx
    mul byte ptr _j
    add @startX, eax
    mov edx, @startX
    mov @endX, edx

    ; 将@startY、@endY初始化为方格左上角
    mov eax, mapGridWidth

    mov edx, mapY
    mov @startY, edx
    mul byte ptr _i
    add @startY, eax
    mov edx, @startY
    mov @endY, edx

    ; ecx中存放一格的宽度，eax存放半格的宽度
    mov eax, mapGridWidth
    mov ecx, eax        ; ecx存放一格的宽度
    mov dl, 2
    div dl
    and eax, 000000FFh  ; eax存放半格的宽度


    .if _type == Wall_Vertical      ; 垂直线
        add @startX, eax
        add @endX, eax
        add @endY, ecx
    .else                           ; 水平线
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
; 画圆角，根据_type来画不同类型的圆弧
; _type为3表示左上圆弧, _type为4表示右上圆弧，_type为5表示左下圆弧，_type为6表示右下圆弧
    local @nLeftRect: dword, @nTopRect: dword, @nRightRect: dword, @nBottomRect: dword, \
        @nXStartArc: dword, @nYStartArc: dword, @nXEndArc: dword, @nYEndArc: dword
    pushad
    ; 初始化@nLeftRect、@nRightRect、@nXStartArc、@nXEndArc初始化为左上角
    mov eax, mapGridWidth

    mov edx, mapX
    mov @nLeftRect, edx
    mul byte ptr _j
    add @nLeftRect, eax
    mov edx, @nLeftRect
    mov @nRightRect, edx
    mov @nXStartArc, edx
    mov @nXEndArc, edx

    ; 初始化@nTopRect、@nBottomRect、@nYStartArc、@nYEndArc初始化为左上角
    mov eax, mapGridWidth

    mov edx, mapY
    mov @nTopRect, edx
    mul byte ptr _i
    add @nTopRect, eax
    mov edx, @nTopRect
    mov @nBottomRect, edx
    mov @nYStartArc, edx
    mov @nYEndArc, edx

    ; ecx中存放一格的宽度，eax存放半格的宽度
    mov eax, mapGridWidth
    mov ecx, eax        ; ecx存放一格的宽度
    mov dl, 2
    div dl
    and eax, 000000FFh  ; eax存放半格的宽度

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
; 画点，如果_type为Item_Bean则画矩形，如果_type为Item_SuperBean则画圆
    local @nLeftRect: dword, @nTopRect: dword, @nRightRect: dword, @nBottomRect: dword
    pushad

    ; 初始化@nLeftRect、@nRightRect初始化为左上角
    mov eax, mapGridWidth

    mov edx, mapX
    mov @nLeftRect, edx
    mul byte ptr _j
    add @nLeftRect, eax
    mov edx, @nLeftRect
    mov @nRightRect, edx

    ; 初始化@nTopRect、@nBottomRect初始化为左上角
    mov eax, mapGridWidth

    mov edx, mapY
    mov @nTopRect, edx
    mul byte ptr _i
    add @nTopRect, eax
    mov edx, @nTopRect
    mov @nBottomRect, edx

    ; ecx中存放一格的宽度，eax存放半格的宽度
    mov eax, mapGridWidth
    mov ecx, eax        ; ecx存放一格的宽度
    mov dl, 2
    div dl
    and eax, 000000FFh  ; eax存放半格的宽度

    ; 将@nLeftRect、@nRightRect、@nTopRect、@nBottomRect初始化为中心
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
    .endif
    popad
    ret
paintPoint endp


paintBean proc, _hDc: HDC
; 画豆子
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

    xor ebx, ebx    ; 外层循环变量i
    .while ebx < mapRow
        xor ecx, ecx    ; 内层循环变量j
        .while ecx < mapCol
            
            invoke getNum, ebx, ecx
            .if eax == Item_SuperBean
                invoke paintPoint, _hDc, ebx, ecx, Item_SuperBean
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

    xor ebx, ebx    ; 外层循环变量i
    .while ebx < mapRow
        xor ecx, ecx    ; 内层循环变量j
        .while ecx < mapCol
            
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
; 画地图
    local @hPen: HPEN, @hOldPen
    pushad

    invoke CreatePen, PS_SOLID, wallWidth, wallColor
    mov @hPen, eax

    invoke SelectObject, _hDc, @hPen
    mov @hOldPen, eax
    
    xor ebx, ebx    ; 外层循环变量i
    .while ebx < mapRow
        xor ecx, ecx    ; 内层循环变量j
        .while ecx < mapCol
            
            invoke getBorderType, ebx, ecx
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


paintPlayer proc, _hDc: HDC, _playerBmpPath0: ptr sbyte, _playerBmpPath1: ptr sbyte, _x: dword, _y: dword, _width: dword, _height: dword
    local @hCDc: HDC, @hImage: HANDLE, @hOldImage: HANDLE
    ; **************************************************************************
    invoke CreateCompatibleDC, hDc
    mov @hCDc, eax
    .if stateSwitch == 0
        invoke LoadImage, NULL, _playerBmpPath0, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED 
        mov @hImage, eax
    .elseif
        invoke LoadImage, NULL, _playerBmpPath1, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED 
        mov @hImage, eax
    .endif
    invoke SelectObject, @hCDc, @hImage
    mov @hOldImage, eax
    ; TODO： 位图大小需要制定
    invoke TransparentBlt, _hDc, _x, _y, _width, _height, @hCDc, 0, 0, 833, 833, 0

    invoke SelectObject, @hCDc, @hOldImage
    invoke DeleteObject, @hImage
    invoke DeleteDC, @hCDc

    ret
paintPlayer endp


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
    

    ; 显示开始游戏提示
    add eax, gapBetweenGameNameAndStartTip
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

    ; TODO：显示学校？？？

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


    ; 显示**LIFE**
    add eax, gapBetweenPauseStrAndLifeStr
    invoke paintText, _hDc, addr lifeStr, panelX, eax, panelWidth, lifeStrRectHeight, FW_HEAVY, ANSI_CHARSET, \
        addr lifeStrFontName, lifeStrColor, DT_LEFT, 1
    add eax, lifeStrRectHeight


    ; 显示生命
    add eax, gapBetweenLifeStrAndLifeNum
    push eax
    invoke crt_sprintf, addr lifeNum, addr lifeNumFormat, life
    pop eax
    invoke paintText, _hDc, addr lifeNum, panelX, eax, panelWidth, lifeNumRectHeight, FW_HEAVY, ANSI_CHARSET, \
        addr lifeNumFontName, lifeNumColor, DT_LEFT, 1


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
        addr finalScoreFontName, finalScoreColor, DT_CENTER, textIsShow
    
    popad
    ret
paintGameOverScreen endp


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
    .endif
    
    ;popad
    ret
paintInMemoryDc endp



;定时器，固定间隔将is_show设置为1
control_frame_rate proc uses eax edx                             ;通过控制 is_show 变量的值来控制渲染帧的输出
    local time1:qword,time2:qword,freq:qword             
    mov is_show, 1                                         
    invoke QueryPerformanceFrequency, addr freq         ;获取高精度计时器的频率
    finit
    .while is_buffer == 1
        invoke QueryPerformanceCounter,addr time1       ;获取当前性能计数器的计数值（高精度的时间戳）
        mov is_show, 1  
        xor eax, eax
        .while eax < fps
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
        .if buffer_index == buffer_size
            mov buffer_index, 0
        .endif

        mov is_show, 0                          ; is_show为0标示当前缓冲区绘制完毕，为1标示将要或者正在从缓冲区加载一张图像
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

        .while buffer_cnt != 0 ;当缓冲区不为空时，不向内填充图像，直到缓冲区为
        .endw       

        invoke draw_map
        
        .if game_state == Game_State_Ready
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
                invoke DeleteObject, eax
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
                ;.if need_redraw == 1
                    ;invoke paintMap, h_dc_map_and_bean
                    ;invoke paintBean, h_dc_map_and_bean
                    ;mov need_redraw, 0
                ;.endif
                ;invoke paintRightPanel, h_dc_panel, 0
                invoke BitBlt,h_dc_buffer[4*esi],0,0,windowWidth,windowHeight,hMemoryDc,0,0,SRCCOPY
                invoke CreateCompatibleBitmap, hDc, windowWidth, windowHeight
                mov hMemoryBitmap, eax
                invoke SelectObject, hMemoryDc, hMemoryBitmap
                invoke DeleteObject, eax
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
        .elseif game_state == Game_State_Lose
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
                invoke DeleteObject, eax
                inc buffer_cnt
                inc @cnt
                pop ecx
            .endw
            jmp main_loop
        .elseif game_state == Game_State_Win
        ;目前还未制作游戏胜利界面，游戏胜利和游戏结束使用同一个界面
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
                invoke DeleteObject, eax
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

paintFromMemoryDcToScreen proc
; 从内存DC中复制内容到屏幕，并清除内存DC中的内容
    invoke BitBlt, hDc, 0, 0, windowWidth, windowHeight, hMemoryDc, 0, 0, SRCCOPY
    invoke CreateCompatibleBitmap, hDc, windowWidth, windowHeight
    mov hMemoryBitmap, eax
    invoke SelectObject, hMemoryDc, hMemoryBitmap
    invoke DeleteObject, eax
    ret
paintFromMemoryDcToScreen endp


processKeyInput proc, _hWnd: HWND, wParam: WPARAM, lParam: LPARAM
    .if wParam == VK_RETURN ;游戏开始
        .if game_state == Game_State_Ready
        mov game_state, Game_State_Play
        .endif
    .endif
    .if wParam == VK_SPACE ; 游戏暂停
        .if game_state == Game_State_Play
        mov game_state, Game_State_Pause
        .elseif game_state == Game_State_Pause
        mov game_state, Game_State_Play
        .endif
    .endif
    .if wParam == VK_LEFT || wParam == VK_UP || wParam == VK_RIGHT || wParam == VK_DOWN; 方向输入引起方向变化
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
    ;.if wParam == VK_DOWN
        ;.if game_state == Game_State_Play
            ;mov game_state, Game_State_Lose
        ;.endif
    ;.endif
    ret
processKeyInput endp


processSizeChange proc uses ebx ecx eax, _lParam: LPARAM
    mov ebx, _lParam
    mov ecx, ebx
    and ebx, 0FFFFh           ; ebx中存放窗口变化的宽度
    shr ecx, 16              ; ecx中存放窗口便后的高度
    mov windowWidth, ebx
    mov windowHeight, ecx
    mov eax, ecx
    sub eax, 20                 ; 减去上下边距
    div mapRow
    ;mov mapGridWidth, eax
    mov eax, iconRadius
    mov iconOpenSize, eax
    mov isIconOpening, 0

    ret
processSizeChange endp

.code
init_window proc, _hDc:HDC, hWnd: HWND
    invoke create_background, _hDc                                       ;创建所有h_dc，使用黑色空区域图片填满buffer，此时buffer为满，初始化gamestate为ready
    invoke CreateThread, NULL, 0, draw_window, NULL, 0, NULL
    invoke CreateThread, NULL, 0, create_buffer, NULL, 0, NULL
    invoke CreateThread, NULL, 0, control_frame_rate, NULL, 0, NULL
    ;invoke CreateThread, NULL, 0, timer, NULL, 0, NULL
    ret
init_window endp

WndProc proc, hWnd: HWND, msgID: UINT, wParam: WPARAM, lParam: LPARAM
; 窗口处理函数
    .if msgID == WM_TIMER
        ;.if wParam == 0
            ;invoke paintFromMemoryDcToScreen
        ;.elseif wParam == 1
            ;invoke paintInMemoryDc
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
        invoke init_window, hDc, hWnd
        invoke SetTimer, hWnd, 0, 20, NULL
        invoke SetTimer, hWnd, 1, 10, NULL
        invoke SetTimer, hWnd, 2, 150, NULL
        invoke SetTimer, hWnd, 3, 800, NULL
    ;//获取窗口的宽和高
			;RECT rect;
			;GetClientRect(hWnd,&rect);
	.endif

	invoke DefWindowProc, hWnd, msgID, wParam, lParam
	ret
WndProc endp

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
; 主函数
	local @wc: WNDCLASS, @hIns: HINSTANCE, @hWnd: HWND, @nMsg: MSG
	 ;invoke AllocConsole		; 引入Dos窗口，方便调试
	 ;invoke GetStdHandle, STD_OUTPUT_HANDLE
	 ;mov stdOutputHandle, eax

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

    ;随机选择str_main_caption
    invoke random_str_main_caption

	; 在内存中创建窗口
	invoke CreateWindowEx, 0, addr wndClassName, offset str_main_caption, WS_OVERLAPPEDWINDOW, \
		windowX, windowY, windowWidth, windowHeight, NULL, NULL, @hIns, NULL
	mov @hWnd, eax
			
	; 显示窗口
	invoke ShowWindow, @hWnd, SW_SHOW
	invoke UpdateWindow, @hWnd

    ; invoke ShowCursor, FALSE                  ; 不显示鼠标

	; 消息循环
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
    invoke ExitProcess, NULL
    ret
end start