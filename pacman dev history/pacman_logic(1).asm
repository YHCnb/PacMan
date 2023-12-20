.386
.model flat,stdcall
option casemap:none

; include
include     pacman_define.inc
include		windows.inc
include		user32.inc
include		kernel32.inc
include		Gdi32.inc
include     winmm.inc
; includelib
includelib	user32.lib
includelib	kernel32.lib
includelib	Gdi32.lib
includelib  winmm.lib
includelib  msvcrt.lib
playWakeMusic PROTO STDCALL
playPowerpillMusic PROTO STDCALL
printf PROTO C :ptr sbyte, :VARARG	
scanf PROTO C :ptr sbyte, :VARARG
strlen PROTO C :ptr sbyte, :VARARG
fscanf PROTO C :ptr sbyte, :VARARG
fopen PROTO C :ptr sbyte, :ptr sbyte
fclose PROTO C :ptr sbyte
fgetc PROTO C :ptr sbyte
fgets PROTO C :ptr sbyte, :dword, :ptr sbyte
memset PROTO C :ptr sbyte, :dword, :dword
GetTickCount PROTO STDCALL
; define
public game_state, score, need_redraw,draw_list, draw_list_size, item_map, map_rows, map_cols, player_PacMan, player_Blinky, player_Pinky, player_Inky, player_Clyde

public init_map,draw_map,get_map_value,get_map_value_by_index

.data 
; 最大值
MAX dword 4294967295
; item_map: 二维数组，存地图的 item（豆子、墙等）
item_map dword 5000 dup (0)

map_rows dword ? ; 地图行数
map_cols dword ? ; 地图列数
map_size dword ? ; 地图大小
wallColor dword ?               ; 墙的颜色：00_B_G_R
input_str byte 1024 dup(0)
map_path byte "map1.txt", 0              ; 地图文件路径
map_msg_fmt1 byte "%d %d %d %d %x %s", 0     ; 地图文件第一行格式
map_msg_fmt2 byte "%s", 0ah, 0           ; 地图文件第二行格式       
ans_str_fmt byte "ans:%d", 0ah, 0
ans_str_fmt2 byte "%d", 0
next_line_fmt byte 0ah, 0
read_mode byte "r", 0                    ; 读模式

ghost_house_x dword ? ; 幽灵出生点x
ghost_house_y dword ? ; 幽灵出生点y
bean_count dword ? ; 豆子数量
score dword ? ; 得分
need_redraw dword ? ; 是否需要重绘item

bean_score dword 10 ; 豆子得分
super_bean_score dword 50 ; 超级豆子得分
ghost_score dword 200 ; 幽灵得分


game_state dword ? ; 游戏状态

; 定义二维数组，每个元素占四个字节（32位）
coord_offsets   dword -1, -1  ; 左上
                dword -1,  0  ; 上
                dword -1,  1  ; 右上
                dword  0, -1  ; 左
                dword  0,  1  ; 右
                dword  1, -1  ; 左下
                dword  1,  0  ; 下
                dword  1,  1  ; 右下

; 用于judge_wall_type
value_list dword 0,0,0,0,0,0,0,0
; 用于get_random_dir
dirList dword 0,0,0

draw_list draw_struct 500 dup ({})
draw_list_size dword ?

player_PacMan player_struct <23, 13, Dir_Left, Dir_Left, 1, PacMan, 0, 0,1>
player_Blinky player_struct <13, 11, Dir_Up, Dir_Up, 1, Blinky, Ghost_State_Chase, 0,1>
player_Pinky player_struct <11, 14, Dir_Up, Dir_Up, 1, Pinky, Ghost_State_Chase, 0,1>
player_Inky player_struct <13, 14, Dir_Up, Dir_Up, 1, Inky, Ghost_State_Chase, 0,1>
player_Clyde player_struct <15, 14, Dir_Up, Dir_Up, 1, Clyde, Ghost_State_Chase, 0,1>

.code

; 获取player指针
get_player_ptr proc , item:dword
    .if item == PacMan
        mov eax, offset player_PacMan
    .elseif item == Blinky
        mov eax, offset player_Blinky
    .elseif item == Pinky
        mov eax, offset player_Pinky
    .elseif item == Inky
        mov eax, offset player_Inky
    .elseif item == Clyde
        mov eax, offset player_Clyde
    .endif
    ret
get_player_ptr endp

; 计算两点之间的距离
get_distance PROC uses ebx ecx edx, x1:dword, y1:dword, x2:dword, y2:dword
    mov eax, x1
    mov ebx, y1
    mov ecx, x2
    mov edx, y2
    sub eax, ecx
    sub ebx, edx
    imul eax, eax
    imul ebx, ebx
    add eax, ebx
    ret
get_distance endp

; 获取反方向
get_reverse_dir proc uses esi edi, dir:dword
    local reverseDir:dword
    mov esi, dir
    .if esi == Dir_Up
        mov reverseDir, Dir_Down
    .elseif esi == Dir_Down
        mov reverseDir, Dir_Up
    .elseif esi == Dir_Left
        mov reverseDir, Dir_Right
    .elseif esi == Dir_Right
        mov reverseDir, Dir_Left
    .else
        mov reverseDir, -1
    .endif
    mov eax, reverseDir
    ret
get_reverse_dir endp

; 用于生成一个在0到给定范围内（value参数）的随机数
random proc uses edx ecx,value:dword
	;随机范围为0~value
	invoke	GetTickCount
	xor		edx,edx
	mov		ecx,value
	div		ecx
	mov		eax,edx
	ret
random endp

; 获取map值
get_map_value proc , x:dword, y:dword
    ; 检查是否越界
    mov eax,map_cols
    mov ebx,map_rows
    .if x < 0 || x >= eax || y < 0 || y >= ebx
        mov eax, Item_Wall
        ret
    .endif
    mov eax, x
    imul eax, map_cols
    add eax, y
    mov eax, item_map[eax*4]
    ret
get_map_value endp

; 获取map值by index
get_map_value_by_index proc , index:dword
    mov eax, index
    mov eax, item_map[eax*4]
    ret
get_map_value_by_index endp

; 相对中心位置某个方向获取map值
get_map_value_by_offset proc uses esi, x:dword, y:dword, off:dword
    mov esi, off
    imul esi, 2
    mov eax, coord_offsets[esi*4]
    mov ebx, coord_offsets[esi*4+4]
    add eax, x
    add ebx, y
    invoke get_map_value, eax, ebx
    ret
get_map_value_by_offset endp

; 修改map值
set_map_value proc , x:dword, y:dword, value:dword
    ; 检查是否越界
    mov eax,map_cols
    mov ebx,map_rows
    .if x < 0 || x >= eax || y < 0 || y >= ebx
        ret
    .endif
    mov eax, x
    imul eax, map_cols
    add eax, y
    mov ebx,value
    mov item_map[eax*4], ebx
    ret
set_map_value endp

; 判断code值
judge_code proc uses esi edi, off1:dword, off2:dword, off3:dword, off4:dword, off5:dword
    local counter:dword
    mov eax,off1
    mov esi, value_list[eax*4]
    .if esi == Item_Wall
        ; 设置一个计数器，记录剩下4个off中是Item_Wall的个数
        mov counter, 0
        mov eax,off2
        mov esi, value_list[eax*4]
        .if esi == Item_Wall
            inc counter
        .endif
        mov eax,off3
        mov esi, value_list[eax*4]
        .if esi == Item_Wall
            inc counter
        .endif
        mov eax,off4
        mov esi, value_list[eax*4]
        .if esi == Item_Wall
            inc counter
        .endif
        mov eax,off5
        mov esi, value_list[eax*4]
        .if esi == Item_Wall
            inc counter
        .endif
        ; 如果少于4
        .if counter < 4
            mov eax, 1
            ret
        .endif
    .endif
    mov eax, 0
    ret
judge_code endp

; 判断墙的类型
judge_wall_type proc uses esi edi, x:dword, y:dword
    local code1:dword
    local code2:dword
    local code3:dword
    local code4:dword
    local counter:dword
    mov counter,0
    ; 如果本身不是wall
    invoke get_map_value, x, y
    .if eax != Item_Wall
        mov eax, Item_Empty
        ret
    .endif
    ; 获取周围8个方块的值，存到value_list中
    mov esi, 0
    .while esi < 8
        invoke get_map_value_by_offset, x, y, esi
        mov value_list[esi*4], eax
        inc esi
    .endw
    invoke judge_code, 6, 3, 4, 5, 7
    mov code1, eax
    add counter, eax
    invoke judge_code, 4, 1, 2, 6, 7
    mov code2, eax
    add counter, eax
    invoke judge_code, 1, 0, 2, 3, 4
    mov code3, eax
    add counter, eax
    invoke judge_code, 3, 0, 1, 5, 6
    mov code4, eax
    add counter, eax
    ; 判断counter
    .if counter >=1
        .if code1 == 1 && code2 == 1 && code3 == 0 && code4 == 0
            mov eax, Wall_Corner_LeftUp
            ret
        .elseif code1 == 0 && code2 == 1 && code3 == 1 && code4 == 0
            mov eax, Wall_Corner_LeftDown
            ret
        .elseif code1 == 0 && code2 == 0 && code3 == 1 && code4 == 1
            mov eax, Wall_Corner_RightDown
            ret
        .elseif code1 == 1 && code2 == 0 && code3 == 0 && code4 == 1
            mov eax, Wall_Corner_RightUp
            ret
        .elseif code1 == 1 && code3 ==1
            mov eax, Wall_Vertical
            ret
        .elseif code2 == 1 && code4 == 1
            mov eax, Wall_Horizontal
            ret
        .endif
    .endif
    mov eax, Item_Empty
    ret 
judge_wall_type endp

; 获取下一个位置(eax,ebx返回新的坐标，eax=-1表示撞墙)
get_nxt_pos proc uses esi edi, x:dword, y:dword, dir:dword, item:dword
    ;根据dir计算下一个位置
    mov esi, x
    mov edi, y
    .if dir == Dir_Up
        dec esi
        .if esi < 0
            mov esi, map_rows-1
        .endif
    .elseif dir == Dir_Down
        inc esi
        .if esi >= map_rows
            mov esi, 0
        .endif
    .elseif dir == Dir_Left
        dec edi
        .if edi < 0
            mov edi, map_cols-1
        .endif
    .elseif dir == Dir_Right
        inc edi
        .if edi >= map_cols
            mov edi, 0
        .endif
    .endif
    ; 判断是否撞墙
    invoke get_player_ptr , item
    mov ecx,eax
    invoke get_map_value, esi, edi
    .if eax == 1 || (eax == 2 && item == PacMan) || (eax == 2 && [ecx].player_struct.State != Ghost_State_Eaten)
        mov eax, -1
        ret
    .endif
    mov eax, esi
    mov ebx, edi
    ret
get_nxt_pos endp

; 获取随机的NextDir
get_random_dir proc uses esi edi, nowX:dword, nowY:dword, nowDir:dword, item:dword
    local dirListSize:dword     ; 候选Dir的数量
    local reverseDir:dword      ; 反方向
    mov esi, nowDir
    .if esi == Dir_Up
        mov reverseDir, Dir_Down
    .elseif esi == Dir_Down
        mov reverseDir, Dir_Up
    .elseif esi == Dir_Left
        mov reverseDir, Dir_Right
    .elseif esi == Dir_Right
        mov reverseDir, Dir_Left
    .endif
    ; 遍历四个方向
    mov dirListSize, 0
    mov esi, Dir_Up
    .while esi <= Dir_Right
        .if esi != reverseDir
            mov ebx, nowX
            mov ecx, nowY
            invoke get_nxt_pos, ebx, ecx, esi, item
            .if eax != -1
                mov eax,dirListSize
                mov dirList[eax*4], esi
                inc dirListSize
            .endif
        .endif
        inc esi
    .endw
    ; 随机一个方向
    invoke random, dirListSize
    mov eax, dirList[eax*4]
    ret
get_random_dir endp

; player移动(eax,ebx返回新的坐标)
player_move proc uses ecx, item:dword
    invoke get_player_ptr, item
    mov ecx, eax
    
    invoke get_nxt_pos, [ecx].player_struct.X, [ecx].player_struct.Y, [ecx].player_struct.Dir, item
    .if eax != -1
        mov [ecx].player_struct.X, eax
        mov [ecx].player_struct.Y, ebx
        mov [ecx].player_struct.IsOnCross, 0
        invoke get_map_value, eax, ebx
        .if eax == Item_GhostHouse && item != PacMan
            mov [ecx].player_struct.State, Ghost_State_Chase
        .endif
    .endif
    ret
player_move endp

; 处理遇到物品
judge_eat proc uses esi edi
    ; 获取PacMan当前位置地图值
    mov esi, player_PacMan.X
    mov edi, player_PacMan.Y
    invoke get_map_value, esi, edi
    ; 判断是否是豆子
    .if eax == Item_Bean
        dec bean_count
        invoke set_map_value, esi, edi, Item_Empty
        mov eax,bean_score
        add score, eax

        mov need_redraw,1
    .elseif eax == Item_SuperBean
        dec bean_count
        invoke set_map_value, esi, edi, Item_Empty
        mov eax,super_bean_score
        add score,eax
        ; 修改幽灵状态
        mov player_Blinky.State, Ghost_State_Frightened
        mov player_Pinky.State, Ghost_State_Frightened
        mov player_Inky.State, Ghost_State_Frightened
        mov player_Clyde.State, Ghost_State_Frightened

        mov need_redraw,1
    .endif
    ret
judge_eat endp

; 处理相遇
judge_meet proc uses esi edi
    ; 遍历4个幽灵
    mov esi, Blinky
    .while esi <= Clyde
        invoke get_player_ptr, esi
        mov ebx, eax
        ; 判断是否相遇
        mov ecx,[ebx].player_struct.X
        mov edx,[ebx].player_struct.Y
        .if player_PacMan.X == ecx && player_PacMan.Y == edx
            ; 判断幽灵状态
            mov eax, [ebx].player_struct.State
            .if eax == Ghost_State_Frightened
                ; 幽灵被吃,反向
                mov [ebx].player_struct.State, Ghost_State_Eaten
                mov eax, [ebx].player_struct.Dir
                invoke get_reverse_dir, eax
                mov [ebx].player_struct.Dir, eax
                mov eax,ghost_score
                add score, eax
            .elseif eax == Ghost_State_Eaten
                ; 什么都不做
            .else
                ; PacMan被吃
                mov game_state, Game_State_Lose
            .endif
        .endif
        inc esi
    .endw
    ret
judge_meet endp

; 根据target，选择正确的NextDir
get_nxt_dir_by_target proc ,nowDir:dword, nowX:dword, nowY:dword, targetX:dword, targetY:dword, item:dword
    local chooseDir:dword           ; 选择的方向
    local shortestDistance:dword    ; 最短距离
    local reverseDir:dword          ; 反方向
    mov eax, MAX
    mov shortestDistance, eax
    invoke get_reverse_dir, nowDir
    mov reverseDir, eax
    ; 遍历四个方向
    mov esi, Dir_Up
    .while esi <= Dir_Right
        .if esi != reverseDir
            mov eax, nowX
            mov ebx, nowY
            invoke get_nxt_pos, eax, ebx, esi, item
            .if eax != -1
                ; 计算距离
                invoke get_distance, eax, ebx, targetX, targetY
                .if eax < shortestDistance
                    mov shortestDistance, eax
                    mov chooseDir, esi
                .endif
            .endif
        .endif
        inc esi
    .endw
    mov eax, chooseDir
    ret
get_nxt_dir_by_target endp

; 更新Blinky的NextDir
nxt_dir_Blinky proc uses esi
    local targetX:dword
    local targetY:dword
    ; 判断Blinky的状态
    invoke get_map_value, player_Blinky.X, player_Blinky.Y
    mov esi, player_Blinky.State
    .if esi == Ghost_State_Eaten
        ; 目标goast house
        mov eax,ghost_house_x
        mov targetX, eax
        mov eax,ghost_house_y
        mov targetY, eax
    .elseif eax == Item_GhostHouse
        ; 目标鬼屋外
        mov eax,ghost_house_x-1
        mov targetX, eax
        mov eax,ghost_house_y
        mov targetY, eax
    .elseif esi == Ghost_State_Chase
        ; 目标PacMan
        mov eax, player_PacMan.X
        mov targetX, eax
        mov eax, player_PacMan.Y
        mov targetY, eax
    .elseif esi == Ghost_State_Scatter
        ; 目标迷宫右上角
        mov eax,map_cols-1
        mov targetX, eax
        mov targetY, 0
    .elseif esi == Ghost_State_Frightened
        invoke get_random_dir, player_Blinky.X, player_Blinky.Y, player_Blinky.Dir, Blinky
        mov player_Blinky.NextDir, eax
        mov player_Blinky.Dir, eax
        ret
    .endif
    invoke get_nxt_dir_by_target, player_Blinky.Dir, player_Blinky.X, player_Blinky.Y, targetX, targetY, Blinky
    mov player_Blinky.NextDir, eax
    mov player_Blinky.Dir, eax
    ret
nxt_dir_Blinky endp

; 更新Pinky的NextDir
nxt_dir_Pinky proc uses esi
    local targetX:dword
    local targetY:dword
    ; 判断Pinky的状态
    invoke get_map_value, player_Pinky.X, player_Pinky.Y
    mov esi, player_Pinky.State
    .if esi == Ghost_State_Eaten
        ; 目标goast house
        mov eax,ghost_house_x
        mov targetX, eax
        mov eax,ghost_house_y
        mov targetY, eax
    .elseif eax == Item_GhostHouse
        ; 目标鬼屋外
        mov eax,ghost_house_x-1
        mov targetX, eax
        mov eax,ghost_house_y
        mov targetY, eax
    .elseif esi == Ghost_State_Chase
        ; 目标PacMan前方四个方块
        mov ebx, player_PacMan.X
        mov targetX, ebx
        mov ebx, player_PacMan.Y
        mov targetY, ebx
        ; 根据PacMan的方向，计算目标位置
        .if player_PacMan.Dir == Dir_Up
            sub targetY, 4
        .elseif player_PacMan.Dir == Dir_Down
            add targetY, 4
        .elseif player_PacMan.Dir == Dir_Left
            sub targetX, 4
        .elseif player_PacMan.Dir == Dir_Right
            add targetX, 4
        .endif
    .elseif esi == Ghost_State_Scatter
        ; 目标迷宫左上角
        mov targetX, 0
        mov targetY, 0
    .elseif esi == Ghost_State_Frightened
        invoke get_random_dir, player_Pinky.X, player_Pinky.Y, player_Pinky.Dir, Pinky
        mov player_Pinky.NextDir, eax
        mov player_Pinky.Dir, eax
        ret
    .endif
    invoke get_nxt_dir_by_target, player_Pinky.Dir, player_Pinky.X, player_Pinky.Y, targetX, targetY, Pinky
    mov player_Pinky.NextDir, eax
    mov player_Pinky.Dir, eax
    ret
nxt_dir_Pinky endp

; 更新Inky的NextDir
nxt_dir_Inky proc uses esi
    local targetX:dword
    local targetY:dword
    ; 判断Inky的状态
    invoke get_map_value, player_Inky.X, player_Inky.Y
    mov esi, player_Inky.State
    .if esi == Ghost_State_Eaten
        ; 目标goast house
        mov eax,ghost_house_x
        mov targetX, eax
        mov eax,ghost_house_y
        mov targetY, eax
    .elseif eax == Item_GhostHouse
        ; 目标鬼屋外
        mov eax,ghost_house_x-1
        mov targetX, eax
        mov eax,ghost_house_y
        mov targetY, eax
    .elseif esi == Ghost_State_Chase
        ; 定位PacMan前方两个方块
        mov ebx, player_PacMan.X
        mov targetX, ebx
        mov ebx, player_PacMan.Y
        mov targetY, ebx
        ; 根据PacMan的方向，计算目标位置
        .if player_PacMan.Dir == Dir_Up
            sub targetY, 2
        .elseif player_PacMan.Dir == Dir_Down
            add targetY, 2
        .elseif player_PacMan.Dir == Dir_Left
            sub targetX, 2
        .elseif player_PacMan.Dir == Dir_Right
            add targetX, 2
        .endif
        ; 定位Blinky的位置，连线翻转180度
        mov ebx, player_Blinky.X
        sub ebx, targetX
        sub targetX, ebx
        mov ebx, player_Blinky.Y
        sub ebx, targetY
        sub targetY, ebx
    .elseif esi == Ghost_State_Scatter
        ; 目标迷宫右下角
        mov eax,map_cols-1
        mov targetX, eax
        mov eax,map_rows-1
        mov targetY, eax
    .elseif esi == Ghost_State_Frightened
        invoke get_random_dir, player_Inky.X, player_Inky.Y, player_Inky.Dir, Inky
        mov player_Inky.NextDir, eax
        mov player_Inky.Dir, eax
        ret
    .endif
    invoke get_nxt_dir_by_target, player_Inky.Dir, player_Inky.X, player_Inky.Y, targetX, targetY, Inky
    mov player_Inky.NextDir, eax
    mov player_Inky.Dir, eax
    ret
nxt_dir_Inky endp

; 更新Clyde的NextDir
nxt_dir_Clyde proc uses esi
    local targetX:dword
    local targetY:dword
    ; 判断Clyde的状态
    invoke get_map_value, player_Clyde.X, player_Clyde.Y
    mov esi, player_Clyde.State
    .if esi == Ghost_State_Eaten
        ; 目标goast house
        mov eax,ghost_house_x
        mov targetX, eax
        mov eax,ghost_house_y
        mov targetY, eax
    .elseif eax == Item_GhostHouse
        ; 目标鬼屋外
        mov eax,ghost_house_x-1
        mov targetX, eax
        mov eax,ghost_house_y
        mov targetY, eax
    .elseif esi == Ghost_State_Chase
        ; 判断Clyde与PacMan的距离
        invoke get_distance, player_Clyde.X, player_Clyde.Y, player_PacMan.X, player_PacMan.Y
        .if eax < 64
            ; 目标迷宫左下角
            mov targetX, 0
            mov eax,map_rows-1
            mov targetY, eax
        .else
            ; 目标PacMan
            mov eax, player_PacMan.X
            mov targetX, eax
            mov eax, player_PacMan.Y
            mov targetY, eax
        .endif
    .elseif esi == Ghost_State_Scatter
        ; 目标迷宫左下角
        mov targetX, 0
        mov eax,map_rows-1
        mov targetY, eax
    .elseif esi == Ghost_State_Frightened
        invoke get_random_dir, player_Clyde.X, player_Clyde.Y, player_Clyde.Dir, Clyde
        mov player_Clyde.NextDir, eax
        mov player_Clyde.Dir, eax
        ret
    .endif
    invoke get_nxt_dir_by_target, player_Clyde.Dir, player_Clyde.X, player_Clyde.Y, targetX, targetY, Clyde
    mov player_Clyde.NextDir, eax
    mov player_Clyde.Dir, eax
    ret
nxt_dir_Clyde endp

; 更新PacMan的NextDir
nxt_dir_PacMan proc
    mov eax, player_PacMan.NextDir
    mov player_PacMan.Dir, eax
    ret
nxt_dir_PacMan endp

; 获取player的NextDir
get_nxt_dir proc , item:dword
    .if item == PacMan
        invoke nxt_dir_PacMan
    .elseif item == Blinky
        invoke nxt_dir_Blinky
    .elseif item == Pinky
        invoke nxt_dir_Pinky
    .elseif item == Inky
        invoke nxt_dir_Inky
    .elseif item == Clyde
        invoke nxt_dir_Clyde
    .endif
    ret
get_nxt_dir endp

; 生成draw_item，并压入draw_list
create_draw_item proc uses edx ecx, x:dword,y:dword, prio:dword, item:dword, dir:dword
    ; 计算偏移量
    mov ecx, draw_list_size
    imul ecx, 24
    ; 压入draw_list
    mov eax, x
    mov draw_list[ecx].draw_struct.X, eax
    mov eax, y
    mov draw_list[ecx].draw_struct.Y, eax
    mov eax, prio
    mov draw_list[ecx].draw_struct.Prio, eax
    mov eax, item
    mov draw_list[ecx].draw_struct.Item, eax
    mov eax, dir
    mov draw_list[ecx].draw_struct.Dir, eax
    inc draw_list_size
    ret
create_draw_item endp

; 绘制玩家
draw_player proc , item:dword,isOnCross:dword
    local player_ptr:dword
    .if isOnCross == 1
        invoke player_move, item
        invoke get_nxt_dir, item
    .endif
    invoke get_player_ptr, item
    invoke create_draw_item , [eax].player_struct.X, [eax].player_struct.Y, 3, item, [eax].player_struct.Dir
    ret
draw_player endp

; 绘制地图
draw_map proc
    local index:dword
    local x:dword
    local y:dword

    invoke judge_meet
    mov draw_list_size, 0
    ; 绘制角色
    .if player_PacMan.IsOnCross
        invoke judge_eat
    .endif
    invoke draw_player, PacMan, player_PacMan.IsOnCross
    invoke draw_player, Blinky, player_Blinky.IsOnCross
    invoke draw_player, Pinky, player_Pinky.IsOnCross
    invoke draw_player, Inky, player_Inky.IsOnCross
    invoke draw_player, Clyde, player_Clyde.IsOnCross

    ; 遍历item_map，绘制地图
    ; mov index, 0
    ; .while index < map_rows*map_cols
    ;     ; 计算x,y
    ;     xor edx,edx
    ;     mov eax, index
    ;     mov ecx, map_cols
    ;     div ecx
    ;     mov x,eax
    ;     mov y,edx
    ;     invoke get_map_value, x, y
    ;     .if eax == Item_Wall
    ;         invoke create_draw_item, x, y, 1, Item_Wall, 0
    ;     .elseif eax == Item_GhostHouse
    ;         invoke create_draw_item, x, y, 1, Item_GhostHouse, 0
    ;     .elseif eax == Item_Bean
    ;         invoke create_draw_item, x, y, 2, Item_Bean, 0
    ;     .elseif eax == Item_SuperBean
    ;         invoke create_draw_item, x, y, 2, Item_SuperBean, 0
    ;     .endif
    ;     inc index
    ; .endw

    ret
draw_map endp

; 读取地图
read_map proc uses esi edi
    local counter:dword
    local index:dword
    local len:dword
    local file_ptr:dword
    ; 从文件读取地图，map_rows、map_cols、wallColor，以空格分隔
    invoke fopen, offset map_path, offset read_mode
    mov file_ptr, eax
    invoke fscanf, file_ptr, offset map_msg_fmt1, offset map_rows, offset map_cols, offset ghost_house_x, offset ghost_house_y, offset wallColor, offset map_path
    ; 去除换行符
    invoke fgets , offset input_str, 1024, file_ptr
    invoke strlen, offset input_str
    mov len, eax
    invoke memset, offset input_str, 0, len
    ; 计算map_size
    mov eax, map_rows
    imul eax, map_cols
    mov map_size, eax
    ; 读取地图
    mov ebx, 0
    mov counter, 0
    mov index, 0
    .while ebx < map_rows
        ; 读取一行
        invoke fgets , offset input_str, 1024, file_ptr
        invoke strlen, offset input_str
        mov len, eax
        ; 遍历一行
        mov ecx,len
        mov esi, offset input_str
        .while ecx > 0
            ; 获取一个字符
            movzx eax, byte ptr [esi]
            ; 逗号或者换行，跳过
            .if eax == 0ah || eax == 20h || eax == 2ch || eax == 0ah
                ; 跳过

            .else
                ; 转换成数字
                sub eax, 30h
                ; 设置map值
                mov edi, index
                mov item_map[edi*4], eax
                inc index
            .endif
            inc esi
            dec ecx
        .endw
        invoke memset, offset input_str, 0, len
        inc ebx
    .endw
    
    invoke fclose, file_ptr

    ; 测试读取结果
    invoke printf, offset map_msg_fmt1, map_rows, map_cols, ghost_house_x, ghost_house_y, wallColor, offset map_path
    invoke printf, offset next_line_fmt
    mov esi, 0
    mov counter, 0
    .while esi < map_size
        invoke  get_map_value_by_index, esi
        invoke printf, offset ans_str_fmt2, eax
        inc esi
        inc counter
        mov eax,map_cols
        .if counter == eax
            invoke printf, offset next_line_fmt
            mov counter, 0
        .endif
    .endw
    ret
read_map endp

; 初始化地图
init_map proc uses esi edi
    local x:dword
    local y:dword
    mov score, 0

    ; 玩家取消自动
    ; invoke get_player_ptr , player1Id
    ; mov [eax].player_struct.IsAuto, 0
    ; invoke get_player_ptr , player2Id
    ; mov [eax].player_struct.IsAuto, 0

    ; 读取地图
    invoke read_map

    ; 计算豆子数量
    mov bean_count, 0
    mov esi, 0

    .while esi < map_size
        invoke  get_map_value_by_index, esi
        .if eax == Item_Bean || eax == Item_SuperBean
            inc bean_count
        .elseif eax == Item_Wall
            ; 计算x,y
            xor edx,edx
            mov eax, esi
            mov ecx, map_cols
            div ecx
            mov x,eax
            mov y,edx
            ; invoke judge_wall_type, x, y
            ; ; 绘制对应类型的墙
            ; invoke printf, offset ans_str_fmt, eax
        .endif
        inc esi
    .endw

    mov game_state, Game_State_Ready
    ret
init_map endp

; main函数测试
main proc
    local ans : dword
    ; 测试get_map_value
    invoke init_map
    invoke get_map_value, 31, 27
    invoke printf, offset ans_str_fmt, eax
    ret
    main endp
end