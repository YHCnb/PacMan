; ???item
Item_Empty equ 0
Item_Wall equ 1
Item_GhostHouse equ 2
Item_Bean equ 3
Item_SuperBean equ 4

Item_SpecialWall equ 9
Item_FastBean equ 5
Item_Portal equ 6
Item_InvisibleBean equ 7

; ?????
Game_State_Ready equ 10
Game_State_Play equ 11
Game_State_Win equ 12
Game_State_Lose equ 13
Game_State_Pause equ 14
Game_State_NxtStage equ 15

; ???????????
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
; ????
Dir_Up equ 21
Dir_Left equ 22
Dir_Down equ 23
Dir_Right equ 24
; ???id
PacMan equ 100
Blinky equ 101
Pinky equ 102
Inky equ 103
Clyde equ 104
Cindy equ 105
RedMan equ 106
; ???????
Wall_Corner_LeftUp equ 110
Wall_Corner_RightUp equ 111
Wall_Corner_LeftDown equ 112
Wall_Corner_RightDown equ 113
Wall_Horizontal equ 114
Wall_Vertical equ 115
; ??????????????�Chase??Scatter??Frightened??Eaten
Ghost_State_Chase equ 200
Ghost_State_Scatter equ 201
Ghost_State_Frightened equ 202
Ghost_State_Eaten equ 203
Ghost_State_Stay equ 204
PacMan_State_Normal equ 205
PacMan_State_Invisible equ 206


;????????��
cell_size  equ 20

;????��
ghost_size equ 250
pacman_size equ 833
Fast_Bean_Size equ 514
Portal_Path_Size equ 100
InvisibleBean_Size equ 50

; ????????��
buffer_size equ 100

; ?????
Game_Mode_Single equ 20
Game_Mode_Double_Cooperate equ 21
Game_Mode_Double_Chase equ 22

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