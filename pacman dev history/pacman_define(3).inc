; 地图item
Item_Empty equ 0
Item_Wall equ 1
Item_GhostHouse equ 2
Item_Bean equ 3
Item_SuperBean equ 4
; 游戏状态
Game_State_Ready equ 10
Game_State_Play equ 11
Game_State_Win equ 12
Game_State_Lose equ 13
Game_State_Pause equ 14
; 定义键盘输入
key_w equ 57h
key_s equ 53h
key_a equ 41h
key_d equ 44h
key_up equ 26h
key_down equ 28h
key_left equ 25h
key_right equ 27h
key_enter equ 6ch
key_p equ 50h
; 方向
Dir_Up equ 21
Dir_Left equ 22
Dir_Down equ 23
Dir_Right equ 24
; 玩家id
PacMan equ 100
Blinky equ 101
Pinky equ 102
Inky equ 103
Clyde equ 104
; 墙的类型
Wall_Corner_LeftUp equ 110
Wall_Corner_RightUp equ 111
Wall_Corner_LeftDown equ 112
Wall_Corner_RightDown equ 113
Wall_Horizontal equ 114
Wall_Vertical equ 115
; 玩家状态（仅限幽灵）Chase、Scatter、Frightened、Eaten
Ghost_State_Chase equ 200
Ghost_State_Scatter equ 201
Ghost_State_Frightened equ 202
Ghost_State_Eaten equ 203

;显示单元大小
cell_size  equ 20

;图片大小
ghost_size equ 250
pacman_size equ 833

buffer_size equ 20

draw_struct STRUCT
    X dword ?
    Y dword ?
    Prio dword ?
    Item dword ?
    Dir dword ?
draw_struct ENDS

player_struct STRUCT
    X dword ?
    Y dword ?
    Dir dword ?
    NextDir dword ?
    IsAuto dword ?
    Item dword ?
    State dword ?
    IsOnCross dword ?
    Speed dword ?
player_struct ENDS