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
include user32.inc
include windows.inc
include gdi32.inc
include kernel32.inc
include msimg32.inc
include msvcrt.inc

;TransparentBlt proto stdcall :HDC, :dword, :dword, :dword, :dword, :HDC, :dword, :dword, :dword, :dword, :UINT
; include paintmap.asm

; 常量定义
; 地图item
Item_Empty equ 0
Item_Wall equ 1
Item_GhostHouse equ 2
Item_Bean equ 3
Item_SuperBean equ 4
; ******************************************************************* 新 ***************************************************************
Item_SpecialWall equ 9
Item_FastBean equ 5
Item_Portal equ 6
Item_InvisibleBean equ 7
Fast_Bean_Size equ 100
Portal_Path_Size equ 514
InvisibleBean_Size equ 50
; ******************************************************************* 新 ***************************************************************

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
; ******************************************************************* 新 ***************************************************************
; 游戏模式
Game_Mode_Single equ 20
Game_Mode_Double_Cooperate equ 21
Game_Mode_Double_Chase equ 22

; ******************************************************************* 新 ***************************************************************
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
windowHeight dword 680					; 窗口高度
windowIconPath sbyte 'E:/Assets/1.ico', 0

FastBeanPath sbyte 'E:/Assets/2.bmp', 0
InvisibleBeanPath sbyte 'E:/Assets/4.bmp', 0
PortalPath sbyte 'E:/Assets/3.bmp', 0
playerX dword 100
playerY dword 100

mapCol dword 37                         ; 地图的宽度
mapRow dword 34                         ; 地图的高度
mapGridWidth dword 20                   ; 地图一格的宽度
mapX dword 10                           ; 地图在窗口中的位置
mapY dword 10

wallWidth dword 2                       ; 墙的宽度
wallColor dword 00FF9900h               ; 墙的颜色：00_B_G_R
; ********************************************************************* 新 *************************************************************
wallSpecialColor dword 0000FF00h        ; 特殊墙的颜色：00_B_G_R
; ********************************************************************* 新 *************************************************************

beanHalfWidth dword 3                   ; 方块豆的宽度的**一半**
beahColor dword 0000FFFFh               ; 方块豆的颜色
superBeanRadius dword 5                 ; 圆形豆的半径
superBeanColor dword 00FFFFFFh          ; 圆形豆的颜色

map dword 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
    dword 1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1
    dword 1,3,1,1,1,1,1,3,9,9,9,9,9,9,9,9,3,9,9,9,3,9,9,9,9,9,9,9,9,9,3,1,1,1,1,3,1
    dword 1,3,1,1,1,1,1,3,9,9,9,9,9,9,9,9,3,9,9,9,3,9,9,9,9,9,9,9,9,9,3,1,1,1,1,3,1
    dword 1,3,1,1,1,1,1,3,9,9,9,0,0,9,9,9,3,9,9,9,3,9,9,9,9,9,9,9,9,9,3,1,1,1,1,3,1
    dword 1,3,1,1,1,1,1,3,9,9,9,0,0,9,9,9,3,9,9,9,3,3,3,3,9,9,9,3,3,3,3,1,1,1,1,3,1
    dword 1,3,3,3,3,3,3,3,9,9,9,9,9,9,9,9,3,9,9,9,3,3,3,3,9,9,9,3,1,1,1,1,1,1,1,3,1
    dword 1,3,1,1,1,1,1,3,9,9,9,9,9,9,9,3,3,9,9,9,3,3,3,3,9,9,9,3,1,1,1,1,1,1,1,3,1
    dword 1,3,1,1,1,1,1,3,9,9,9,9,9,9,9,9,3,9,9,9,3,3,3,3,9,9,9,3,1,1,1,1,1,1,1,3,1
    dword 1,3,1,1,1,1,1,3,9,9,9,9,9,9,9,9,3,9,9,9,3,3,3,3,9,9,9,3,1,1,1,1,1,1,1,3,1
    dword 1,3,3,3,3,3,3,3,9,9,9,0,0,9,9,9,3,9,9,9,3,3,3,3,9,9,9,3,3,3,3,7,3,3,3,3,1
    dword 1,1,1,1,1,1,1,3,9,9,9,0,0,9,9,9,3,9,9,9,3,3,3,3,9,9,9,3,1,1,1,1,1,1,1,1,1
    dword 1,1,1,1,1,1,1,3,9,9,9,9,9,9,9,9,3,9,9,9,3,3,3,3,9,9,9,3,1,1,1,1,1,1,1,1,1
    dword 1,1,1,1,1,1,1,3,9,9,9,9,9,9,9,9,3,9,9,9,3,3,3,3,9,9,9,3,1,1,1,1,1,1,1,1,1
    dword 1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1
    dword 1,1,1,1,1,1,1,3,1,1,1,1,1,1,3,1,1,2,2,2,1,1,3,1,1,1,1,1,1,3,1,1,1,1,1,1,1
    dword 1,1,1,1,1,1,1,3,1,1,1,1,1,1,3,1,2,2,2,2,2,1,3,1,1,1,1,1,1,5,1,1,1,1,1,1,1
    dword 1,1,1,1,1,1,1,3,1,1,1,1,1,1,3,1,2,2,2,2,2,1,3,1,1,1,1,1,1,3,1,1,1,1,1,1,1
    dword 1,1,1,1,1,1,1,3,1,1,1,1,1,1,3,1,1,1,1,1,1,1,3,1,1,1,1,1,1,3,1,1,1,1,1,1,1
    dword 1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1
    dword 1,1,1,1,1,1,3,1,1,3,9,9,9,9,9,9,9,9,3,9,9,9,9,9,9,9,9,3,1,1,3,1,1,1,1,1,1
    dword 1,1,1,1,1,1,3,1,1,3,9,9,9,9,9,9,9,9,3,9,9,9,9,9,9,9,9,3,1,1,3,1,1,1,1,1,1
    dword 1,1,1,1,1,1,3,1,1,3,9,9,9,9,9,9,9,9,3,9,9,9,9,9,9,9,9,3,1,1,3,1,1,1,1,1,1
    dword 1,3,3,6,3,3,3,1,1,3,9,9,9,3,3,3,3,3,3,9,9,9,3,3,3,3,3,3,1,1,3,3,3,3,3,3,1
    dword 1,3,1,1,1,1,3,1,1,3,9,9,9,3,3,3,3,3,3,9,9,9,3,3,3,3,3,3,1,1,3,1,1,1,1,3,1
    dword 1,3,1,1,1,1,3,1,1,3,9,9,9,3,3,3,3,3,3,9,9,9,9,9,9,9,9,3,1,1,3,1,1,1,1,3,1
    dword 1,3,1,1,1,1,3,3,3,3,9,9,9,3,3,3,3,3,3,9,9,9,9,9,9,9,9,3,3,3,3,1,1,1,1,3,1
    dword 1,3,1,1,1,1,3,1,1,3,9,9,9,3,3,3,3,3,3,9,9,9,9,9,9,9,9,3,1,1,3,1,1,1,1,3,1
    dword 1,3,1,1,1,1,3,1,1,3,9,9,9,3,3,3,3,3,3,3,3,3,3,3,9,9,9,3,1,1,3,1,1,1,1,3,1
    dword 1,3,3,3,3,3,3,1,1,3,9,9,9,9,9,9,9,9,3,9,9,9,9,9,9,9,9,3,1,1,3,3,3,3,3,3,1
    dword 1,3,1,1,1,1,1,1,1,3,9,9,9,9,9,9,9,9,3,9,9,9,9,9,9,9,9,3,1,1,1,1,1,1,1,3,1
    dword 1,3,1,1,1,1,1,1,1,3,9,9,9,9,9,9,9,9,3,9,9,9,9,9,9,9,9,3,1,1,1,1,1,1,1,3,1
    dword 1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1
    dword 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1


gameState dword Game_State_Ready
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

; ********************************************************************* 新 *************************************************************
; 游戏模式：单人模式，双人合作模式，双人追逐模式
gameMode dword Game_Mode_Single                         ; 游戏模式
singleMode sbyte '单人模式', 0
doubleCooperateMode sbyte '双人合作模式', 0
doubleChaseMode sbyte '双人追逐模式', 0
gapGameMode dword 10
gapBetweenGameNameAndGameMode dword 20
gameModeFontName sbyte '黑体', 0
gameModeRectHeight dword 20
gameModeColor dword 00FFFFFFh
gameModeSelect dword 000000FFh
; ********************************************************************* 新 *************************************************************

gapBetweenGameModeAndStartTip dword 10 ; *********************************************修改名字*********************************************
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
scoreStrFontName sbyte 'Stencil', 0
scoreStrRectHeight dword 40
scoreStrColor dword 000000FFh

gapBetweenScoreStrAndScoreNum dword 20
scoreNumFormat sbyte ' %d', 0
scoreNum sbyte 20 dup(0)
scoreNumFontName sbyte 'Stencil', 0
scoreNumRectHeight dword 35
scoreNumColor dword 00FFFFFFh

gapBetweenScoreNumAndLevelStr dword 20
levelStr sbyte 'LEVEL', 0
levelStrFontName sbyte 'Stencil', 0
levelStrRectHeight dword 40
levelStrColor dword 000000FFh

gapBetweenLevelStrAndLevelNum dword 20
levelNumFormat sbyte ' %d', 0
levelNum sbyte 20 dup(0)
levelNumFontName sbyte 'Stencil', 0
levelNumRectHeight dword 35
levelNumColor dword 00FFFFFFh

gapBetweenLevelNumAndPauseStr dword 100
pauseStr sbyte 'PAUSE', 0
pauseStrFontName sbyte 'Stencil', 0
pauseStrRectHeight dword 40
pauseStrColor dword 00FFFFFFh

gapBetweenPauseStrAndLifeStr dword 20
lifeStr sbyte 'LIFE', 0
lifeStrFontName sbyte 'Stencil', 0
lifeStrRectHeight dword 40
lifeStrColor dword 000000FFh

gapBetweenLifeStrAndLifeNum dword 20
lifeNumFormat sbyte ' %d', 0
lifeNum sbyte 20 dup(0)
lifeNumFontName sbyte 'Stencil', 0
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


.code
getNum proc uses ebx ecx edx, _i: dword, _j: dword
; 获取地图在(i, j)处的元素；如果越界则返回Item_Wall
    mov ecx, mapRow
    mov edx, mapCol
    .if (_i >= 0 && _i < ecx) && (_j >= 0 && _j < edx)
        mov eax, _i
        mul dl
        add eax, _j
        mov ebx, offset map
        mov eax, [ebx+(size map)*eax]
        ret
    .else
        mov eax, Item_Wall
        ret
    .endif
getNum endp


getBorderType proc uses ebx ecx edx esi, _i: dword, _j: dword, _wallNum
; 判断边界类型
; 返回值：0表示不是墙的边界, 1表示是垂直类型, 2表示是水平类型
; 3表示左上圆弧, 4表示右上圆弧，5表示左下圆弧，6表示右下圆弧
    local @iSub1, @iAdd1, @jSub1, @jAdd1, @upLeft, @upRight, @downLeft, @downRight, \
        @up, @down, @left, @right
    mov esi, _wallNum
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
    .if eax == _wallNum                        ; 当前点的值为1时才可能为边界
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
        @nXStartArc: dword, @nYStartArc: dword, @nXEndArc: dword, @nYEndArc: dword, @hCDc
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
    local @x, @y, @hOldImage, @hImage, @hCDc, @width
    pushad

    ; 初始化@nLeftRect、@nRightRect初始化为左上角
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

    ; 初始化@nTopRect、@nBottomRect初始化为左上角
    mov eax, mapGridWidth

    mov edx, mapY
    mov @nTopRect, edx
    mul byte ptr _i
    add @nTopRect, eax
    mov edx, @nTopRect
    mov @nBottomRect, edx
    mov @y, edx

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

        ; *******************************************************************  引入常量 **************************************************************
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
        ; *******************************************************************  引入常量 **************************************************************
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
        ; *******************************************************************  引入常量 **************************************************************
        invoke TransparentBlt, _hDc, @x, @y, @width, @width, @hCDc, 0, 0, 40, 50, 0

        invoke SelectObject, @hCDc, @hOldImage
        invoke DeleteObject, @hImage
        invoke DeleteDC, @hCDc
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
    
    xor ebx, ebx    ; 外层循环变量i
    .while ebx < mapRow
        xor ecx, ecx    ; 内层循环变量j
        .while ecx < mapCol
            
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
    
    ; ************************************************************************** 新 ******************************************************************
    ; 显示游戏模式
    add eax, gapBetweenGameNameAndGameMode
    .if gameMode == Game_Mode_Single
        invoke paintText, _hDc, addr singleMode, 0, eax, windowWidth, gameModeRectHeight, FW_HEAVY, GB2312_CHARSET, \
            addr gameModeFontName, gameModeSelect, DT_CENTER, textIsShow
    .else
        invoke paintText, _hDc, addr singleMode, 0, eax, windowWidth, gameModeRectHeight, FW_HEAVY, GB2312_CHARSET, \
            addr gameModeFontName, gameModeColor, DT_CENTER, 1
    .endif
    add eax, gameModeRectHeight

    add eax, gapGameMode
    .if gameMode == Game_Mode_Double_Cooperate
        invoke paintText, _hDc, addr doubleCooperateMode, 0, eax, windowWidth, gameModeRectHeight, FW_HEAVY, GB2312_CHARSET, \
            addr gameModeFontName, gameModeSelect, DT_CENTER, textIsShow
    .else
       invoke paintText, _hDc, addr doubleCooperateMode, 0, eax, windowWidth, gameModeRectHeight, FW_HEAVY, GB2312_CHARSET, \
            addr gameModeFontName, gameModeColor, DT_CENTER, 1
    .endif
    add eax, gameModeRectHeight

    add eax, gapGameMode
    .if gameMode == Game_Mode_Double_Chase
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


paintInMemoryDc proc, _hWnd: HWND
    
    .if gameState == Game_State_Play
        invoke paintMap, hMemoryDc
        invoke paintBean, hMemoryDc
        invoke paintPlayer, hMemoryDc, addr FastBeanPath, addr FastBeanPath, playerX, playerY, 30, 30
        invoke paintRightPanel, hMemoryDc, 0
    .elseif gameState == Game_State_Pause
        invoke paintMap, hMemoryDc
        invoke paintBean, hMemoryDc
        invoke paintPlayer, hMemoryDc, addr FastBeanPath, addr FastBeanPath, playerX, playerY, 30, 30
        invoke paintRightPanel, hMemoryDc, 1
    .elseif gameState == Game_State_Ready
        invoke paintReadyScreen, hMemoryDc
    .elseif gameState == Game_State_Lose
        invoke paintGameOverScreen, hMemoryDc
    .endif
    
    ;popad
    ret
paintInMemoryDc endp


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
    .if wParam == VK_LEFT || wParam == VK_A         ; 按下向左方向键
        sub playerX, 10
    .elseif wParam == VK_UP || wParam == VK_W       ; 按下向上方向键
    ; *****************************************************************************************************************************
        .if gameState == Game_State_Ready
            .if gameMode == Game_Mode_Single
                mov gameMode, Game_Mode_Double_Chase
            .else
                dec gameMode
            .endif
        .endif
        ; *****************************************************************************************************************************
        sub playerY, 10
    .elseif wParam == VK_RIGHT || wParam == VK_D    ; 按下向右方向键
        add playerX, 10
    .elseif wParam == VK_DOWN || wParam == VK_S     ; 按下向下方向键
        ; *****************************************************************************************************************************
        .if gameState == Game_State_Ready
            .if gameMode == Game_Mode_Double_Chase
                mov gameMode, Game_Mode_Single
            .else
                inc gameMode
            .endif
        .endif
        ; *****************************************************************************************************************************
        add playerY, 10
    .elseif wParam == VK_RETURN || wParam == VK_SPACE   ; 游戏状态转换
        .if gameState == Game_State_Ready
            mov gameState, Game_State_Play
        .elseif gameState == Game_State_Play
            mov gameState, Game_State_Pause
        .elseif gameState == Game_State_Pause
            mov gameState, Game_State_Play
        .endif
    .elseif wParam == VK_ESCAPE
        mov gameState, Game_State_Lose
    .endif
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
    mov mapGridWidth, eax
    mov eax, iconRadius
    mov iconOpenSize, eax
    mov isIconOpening, 0

    ret
processSizeChange endp

.code
WndProc proc, hWnd: HWND, msgID: UINT, wParam: WPARAM, lParam: LPARAM
; 窗口处理函数
    .if msgID == WM_TIMER
        .if wParam == 0
            invoke paintFromMemoryDcToScreen
        .elseif wParam == 1
            invoke paintInMemoryDc, hWnd
        .elseif wParam == 2
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
        invoke KillTimer, hWnd, 0
        invoke DeleteObject, hMemoryBitmap
        invoke ReleaseDC, hWnd, hDc
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
        invoke SetTimer, hWnd, 0, 20, NULL
        invoke SetTimer, hWnd, 1, 10, NULL
        invoke SetTimer, hWnd, 2, 150, NULL
        invoke SetTimer, hWnd, 3, 500, NULL
    ;//获取窗口的宽和高
			;RECT rect;
			;GetClientRect(hWnd,&rect);
	.endif

	invoke DefWindowProc, hWnd, msgID, wParam, lParam
	ret
WndProc endp


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

    invoke LoadImage, NULL, addr windowIconPath, IMAGE_ICON, 0, 0, LR_LOADFROMFILE or LR_SHARED
	mov @wc.hIcon, eax		                ; 设置窗口图标样式
	mov edx, @hIns
	mov @wc.hInstance, edx

	mov @wc.lpfnWndProc, offset WndProc		; 获取窗口处理函数地址
	mov @wc.lpszClassName, offset wndClassName
	mov @wc.lpszMenuName, NULL
	; 注册窗口类
	invoke RegisterClass, addr @wc

	; 在内存中创建窗口
	invoke CreateWindowEx, 0, addr wndClassName, addr titleBarName, WS_OVERLAPPEDWINDOW, \
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
	invoke WinMain
	invoke ExitProcess, NULL
end start