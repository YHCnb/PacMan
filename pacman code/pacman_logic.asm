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
; define����
public game_state, game_mode, score, need_redraw,draw_list, draw_list_size
public item_map, map_rows, map_cols
public player_PacMan, player_Blinky, player_Pinky, player_Inky, player_Clyde, player_Cindy, player_RedMan
public chase_target
; define����
public init_map,draw_map,get_map_value,get_nxt_pos
public enter_frightened,end_frightened,cycle_to_chase,cycle_to_scatter,speed_down_pacman
public release_ghost,end_invisible_pacman
; extern����
extern is_fast_pacman:dword, is_invisible_pacman:dword, is_super_pacman:dword
; pacman_music�ⲿ����
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

.data 
; ���ֵ
MAX dword 4294967295
; item_map: ��ά���飬���ͼ�� item�����ӡ�ǽ�ȣ�
item_map dword 5000 dup (0)

map_rows dword ? ; ��ͼ����
map_cols dword ? ; ��ͼ����
map_size dword ? ; ��ͼ��С
wallColor dword ?               ; ǽ����ɫ��00_B_G_R
input_str byte 1024 dup(0)
map_path byte "map1.txt", 0              ; ��ͼ�ļ�·��
map_msg_fmt1 byte "%d %d %d %d %x %s", 0     ; ��ͼ�ļ���һ�и�ʽ
map_msg_fmt2 byte "%s", 0ah, 0           ; ��ͼ�ļ��ڶ��и�ʽ       
ans_str_fmt byte "ans:%d", 0ah, 0
ans_str_fmt2 byte "%d", 0
next_line_fmt byte 0ah, 0
read_mode byte "r", 0                    ; ��ģʽ

chase_target dword ? ; ׷��״̬Ŀ��(PacMan����RedMan)
ghost_house_x dword ? ; ���������x
ghost_house_y dword ? ; ���������y
portal1_x dword ? ; ������1x
portal1_y dword ? ; ������1y
portal2_x dword ? ; ������2x
portal2_y dword ? ; ������2y
bean_count dword ? ; ��������
score dword ? ; �÷�
need_redraw dword ? ; �Ƿ���Ҫ�ػ�item

bean_score dword 10 ; ���ӵ÷�
super_bean_score dword 50 ; �������ӵ÷�
fast_bean_score dword 50 ; ���ٶ��ӵ÷�
invisible_ean_score dword 50 ; �����ӵ÷�
ghost_score dword 200 ; ����÷�

game_state dword ? ; ��Ϸ״̬
game_mode dword ? ; ��Ϸģʽ
target_release_ghost dword ? ; Ŀ��ų�����

; �����ά���飬ÿ��Ԫ��ռ�ĸ��ֽڣ�32λ��
coord_offsets   dword -1, -1  ; ����
                dword -1,  0  ; ��
                dword -1,  1  ; ����
                dword  0, -1  ; ��
                dword  0,  1  ; ��
                dword  1, -1  ; ����
                dword  1,  0  ; ��
                dword  1,  1  ; ����

; ����judge_wall_type
value_list dword 0,0,0,0,0,0,0,0
; ����get_random_dir
dirList dword 0,0,0

draw_list draw_struct 500 dup ({})
draw_list_size dword ?

player_PacMan player_struct <24, 10, Dir_Left, Dir_Left, 0, PacMan, PacMan_State_Normal, 0,1>
player_RedMan player_struct <24, 19, Dir_Right, Dir_Right, 0, RedMan, PacMan_State_Normal, 0,1>
player_Blinky player_struct <14, 11, Dir_Right, Dir_Right, 1, Blinky, Ghost_State_Stay, 0,1>
player_Pinky player_struct <16, 11, Dir_Right, Dir_Right, 1, Pinky, Ghost_State_Stay, 0,1>
player_Inky player_struct <14, 16, Dir_Left, Dir_Left, 1, Inky, Ghost_State_Stay, 0,1>
player_Clyde player_struct <16, 16, Dir_Left, Dir_Left, 1, Clyde, Ghost_State_Stay, 0,1>
player_Cindy player_struct <14, 13, Dir_Up, Dir_Up, 0, Cindy, Ghost_State_Chase, 0,1>

.code

; ��ȡplayerָ��
get_player_ptr proc , item:dword
    .if item == PacMan
        mov eax, offset player_PacMan
    .elseif item == RedMan
        mov eax, offset player_RedMan
    .elseif item == Blinky
        mov eax, offset player_Blinky
    .elseif item == Pinky
        mov eax, offset player_Pinky
    .elseif item == Inky
        mov eax, offset player_Inky
    .elseif item == Clyde
        mov eax, offset player_Clyde
    .elseif item == Cindy
        mov eax, offset player_Cindy
    .endif
    ret
get_player_ptr endp

; ���ٳԶ���
speed_up_pacman proc
    ; �ı�Զ����ٶ�
    mov player_PacMan.Speed, 2
    mov player_RedMan.Speed, 2
    mov is_fast_pacman, 1
    ret
speed_up_pacman endp

; ���ٳԶ���
speed_down_pacman proc
    ; �ı�Զ����ٶ�
    mov player_PacMan.Speed, 1
    mov player_RedMan.Speed, 1
    mov is_fast_pacman, 0
    ret
speed_down_pacman endp

; ����Զ���
invisible_pacman proc
    ; �ı�Զ���״̬
    mov player_PacMan.State, PacMan_State_Invisible
    mov player_RedMan.State, PacMan_State_Invisible
    mov is_invisible_pacman, 1
    ret
invisible_pacman endp

; ֹͣ����Զ���
end_invisible_pacman proc
    ; �ı�Զ���״̬
    mov player_PacMan.State, PacMan_State_Normal
    mov player_RedMan.State, PacMan_State_Normal
    mov is_invisible_pacman, 0
    ret
end_invisible_pacman endp

; �ų�ghost��ÿ�ηų�һ����
release_ghost proc
    ; �ж��Ƿ���ghostδ�ų�
    .if target_release_ghost > Clyde
        ret
    .endif
    ; �ų�һ��ghost
    invoke get_player_ptr, target_release_ghost
    mov [eax].player_struct.State, Ghost_State_Chase
    inc target_release_ghost
    ret
release_ghost endp

; �ı���������״̬��changeFrightened�����Ƿ�ı�Frightened״̬)
change_ghost_state proc uses esi ebx, state:dword, changeFrightened:dword
    mov esi, Blinky
    .while esi <= Cindy
        invoke get_player_ptr, esi
        mov ebx,eax
        ; ������Ǳ���״̬���ı�
        mov eax, [ebx].player_struct.State
        .if eax != Ghost_State_Eaten && eax != Ghost_State_Stay
            .if eax == Ghost_State_Frightened && changeFrightened == 0
                ; ʲô������
            .else
                mov eax, state
                mov [ebx].player_struct.State, eax
            .endif
        .endif
        inc esi
    .endw
    ret
change_ghost_state endp

; ����Frightened״̬
enter_frightened proc
    ; �ı���������״̬
    invoke change_ghost_state, Ghost_State_Frightened, 0
    mov is_super_pacman, 1
    ret
enter_frightened endp

; ����Frightened״̬
end_frightened proc
    ; �ı���������״̬
    invoke change_ghost_state, Ghost_State_Chase, 1
    mov is_super_pacman, 0
    ret
end_frightened endp

; ����תΪ׷��״̬
cycle_to_chase proc
    ; �ı���������״̬
    invoke release_ghost
    invoke change_ghost_state, Ghost_State_Chase, 0
    ret
cycle_to_chase endp

; ����תΪɢ��״̬
cycle_to_scatter proc
    ; �ı���������״̬
    invoke release_ghost
    invoke change_ghost_state, Ghost_State_Scatter, 0
    ret
cycle_to_scatter endp

; ��������֮��ľ���
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

; ��ȡ������
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

; ��������һ����0��������Χ�ڣ�value�������������
random proc uses edx ecx,value:dword
	;�����ΧΪ0~value
	invoke	GetTickCount
	xor		edx,edx
	mov		ecx,value
	div		ecx
	mov		eax,edx
	ret
random endp

; ��ȡmapֵ
get_map_value proc uses ebx, x:dword, y:dword
    ; ����Ƿ�Խ��
    mov eax,map_rows
    mov ebx,map_cols
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

; ��ȡmapֵby index
get_map_value_by_index proc , index:dword
    mov eax, index
    mov eax, item_map[eax*4]
    ret
get_map_value_by_index endp

; �������λ��ĳ�������ȡmapֵ
get_map_value_by_offset proc uses esi ebx, x:dword, y:dword, off:dword
    mov esi, off
    imul esi, 2
    mov eax, coord_offsets[esi*4]
    mov ebx, coord_offsets[esi*4+4]
    add eax, x
    add ebx, y
    invoke get_map_value, eax, ebx
    ret
get_map_value_by_offset endp

; �޸�mapֵ
set_map_value proc uses ebx, x:dword, y:dword, value:dword
    ; ����Ƿ�Խ��
    mov eax,map_rows
    mov ebx,map_cols
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

; �ж�codeֵ
judge_code proc uses esi edi, off1:dword, off2:dword, off3:dword, off4:dword, off5:dword
    local counter:dword
    mov eax,off1
    mov esi, value_list[eax*4]
    .if esi == Item_Wall
        ; ����һ������������¼ʣ��4��off����Item_Wall�ĸ���
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
        ; �������4
        .if counter < 4
            mov eax, 1
            ret
        .endif
    .endif
    mov eax, 0
    ret
judge_code endp

; �ж�ǽ������
judge_wall_type proc uses esi edi, x:dword, y:dword
    local code1:dword
    local code2:dword
    local code3:dword
    local code4:dword
    local counter:dword
    mov counter,0
    ; ���������wall
    invoke get_map_value, x, y
    .if eax != Item_Wall
        mov eax, Item_Empty
        ret
    .endif
    ; ��ȡ��Χ8�������ֵ���浽value_list��
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
    ; �ж�counter
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

; ��ȡ��һ��λ��(eax,ebx�����µ����꣬eax=-1��ʾײǽ)
get_nxt_pos proc uses esi ecx edi, x:dword, y:dword, dir:dword, item:dword
    ;����dir������һ��λ��
    mov esi, x
    mov edi, y
    .if dir == Dir_Up
        dec esi
        .if esi == MAX
            mov eax,map_rows
            dec eax
            mov esi, eax
        .endif
    .elseif dir == Dir_Down
        inc esi
        .if esi >= map_rows
            mov esi, 0
        .endif
    .elseif dir == Dir_Left
        dec edi
        .if edi == MAX
            mov eax,map_cols
            dec eax
            mov edi, eax
        .endif
    .elseif dir == Dir_Right
        inc edi
        .if edi >= map_cols
            mov edi, 0
        .endif
    .endif
    ; �ж��Ƿ�ײǽ
    invoke get_map_value, esi, edi
    .if eax == Item_Wall || eax == Item_SpecialWall
        mov eax, -1
        ret
    .endif
    .if eax == Item_GhostHouse
        .if item == PacMan || item == RedMan
            mov eax, -1
            ret
        .else
            invoke get_map_value,x,y
            ; �ڹ������Ҳ��Ǳ���״̬����Ϊǽ
            .if eax != Item_GhostHouse
                invoke get_player_ptr , item
                .if [eax].player_struct.State != Ghost_State_Eaten
                    mov eax, -1
                    ret
                .endif
            .endif
        .endif
    .endif

    mov eax, esi
    mov ebx, edi
    ret
get_nxt_pos endp

; ��ȡ�����NextDir
get_random_dir proc uses esi ecx ebx, nowX:dword, nowY:dword, nowDir:dword, item:dword
    local dirListSize:dword     ; ��ѡDir������
    local reverseDir:dword      ; ������
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
    ; �����ĸ�����
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
    ; ���һ������
    invoke random, dirListSize
    mov eax, dirList[eax*4]
    ret
get_random_dir endp

; player�ƶ�(eax,ebx�����µ�����)
player_move proc uses ecx, item:dword
    invoke get_player_ptr, item
    mov ecx, eax
    invoke get_nxt_pos, [ecx].player_struct.X, [ecx].player_struct.Y, [ecx].player_struct.Dir, item
    .if eax != -1
        mov [ecx].player_struct.X, eax
        mov [ecx].player_struct.Y, ebx
        ;mov [ecx].player_struct.IsOnCross, 0
        invoke get_map_value, eax, ebx
        .if eax == Item_GhostHouse && item != PacMan && item != RedMan
            ; State��ΪGhost_State_Stay
            .if [ecx].player_struct.State != Ghost_State_Stay
                mov [ecx].player_struct.State, Ghost_State_Chase
            .endif
        .endif
    .endif
    ret
player_move endp

; ����������Ʒ
judge_eat proc uses esi edi, item:dword
    .if item == PacMan
        ; ��ȡPacMan��ǰλ�õ�ͼֵ
        mov esi, player_PacMan.X
        mov edi, player_PacMan.Y
    .elseif item == RedMan
        ; ��ȡRedMan��ǰλ�õ�ͼֵ
        mov esi, player_RedMan.X
        mov edi, player_RedMan.Y
    .else
        ret
    .endif
    invoke get_map_value, esi, edi
    ; �ж��Ƿ��Ƕ���
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
        ; �޸�����״̬
        invoke enter_frightened
        ; ��������
        invoke playPowerpillMusic
        mov need_redraw,1
    .elseif eax == Item_FastBean
        dec bean_count
        invoke set_map_value, esi, edi, Item_Empty
        mov eax,fast_bean_score
        add score,eax
        ; �޸ĳԶ����ٶ�
        invoke speed_up_pacman
        ; ��������

        mov need_redraw,1
    .elseif eax == Item_InvisibleBean
        dec bean_count
        invoke set_map_value, esi, edi, Item_Empty
        mov eax,invisible_ean_score
        add score,eax
        ; �޸ĳԶ���״̬
        invoke invisible_pacman
        ; ��������

        mov need_redraw,1
    .elseif eax == Item_Portal
        ; �ж����ĸ�������
        .if esi == portal1_x && edi == portal1_y
            mov esi, portal2_x
            mov edi, portal2_y
        .elseif esi == portal2_x && edi == portal2_y
            mov esi, portal1_x
            mov edi, portal1_y
        .else
            ret
        .endif
        ; �޸�playerλ��
        .if item == PacMan
            mov player_PacMan.X, esi
            mov player_PacMan.Y, edi
        .elseif item == RedMan
            mov player_RedMan.X, esi
            mov player_RedMan.Y, edi
        .endif
    .endif
    ; �ж��Ƿ���궹��
    .if bean_count == 0
        mov game_state, Game_State_Win
    .endif
    ret
judge_eat endp

; ��������
judge_meet proc uses esi edi ebx ecx edx, item:dword
    local x:dword
    local y:dword
    .if item == PacMan
        ; ��ȡPacMan��ǰλ�õ�ͼֵ
        mov esi, player_PacMan.X
        mov edi, player_PacMan.Y
        mov x, esi
        mov y, edi
    .elseif item == RedMan
        ; ��ȡRedMan��ǰλ�õ�ͼֵ
        mov esi, player_RedMan.X
        mov edi, player_RedMan.Y
        mov x, esi
        mov y, edi
    .else
        ret
    .endif
    ; ����4������
    mov esi, Blinky
    .while esi <= Cindy
        invoke get_player_ptr, esi
        mov edi, eax
        ; �ж��Ƿ�����
        mov eax,x
        mov ebx,y
        mov ecx,[edi].player_struct.X
        mov edx,[edi].player_struct.Y
        .if eax == ecx && ebx == edx
            ; �ж�����״̬
            mov eax, [edi].player_struct.State
            .if eax == Ghost_State_Frightened
                ; ���鱻��
                invoke playEatghostMusic
                mov [edi].player_struct.State, Ghost_State_Eaten
                mov eax,ghost_score
                add score, eax
            .elseif eax == Ghost_State_Eaten
                ; ʲô������
            .else
                ; �����������״̬������
                invoke get_player_ptr , item
                .if [eax].player_struct.State != PacMan_State_Invisible
                    mov game_state, Game_State_Lose
                .endif
            .endif
        .endif
        inc esi
    .endw
    ret
judge_meet endp

; ����target��ѡ����ȷ��NextDir
get_nxt_dir_by_target proc uses esi ebx,nowDir:dword, nowX:dword, nowY:dword, targetX:dword, targetY:dword, item:dword
    local chooseDir:dword           ; ѡ��ķ���
    local shortestDistance:dword    ; ��̾���
    local reverseDir:dword          ; ������
    mov eax, MAX
    mov shortestDistance, eax
    invoke get_reverse_dir, nowDir
    mov reverseDir, eax
    ; �����ĸ�����    
    mov esi, Dir_Up
    .while esi <= Dir_Right
        .if esi != reverseDir
            mov eax, nowX
            mov ebx, nowY
            invoke get_nxt_pos, eax, ebx, esi, item
            .if eax != -1
                ; �������
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

; ����Blinky��NextDir
nxt_dir_Blinky proc uses esi ebx
    local targetX:dword
    local targetY:dword
    ; �ж�Blinky��״̬
    invoke get_map_value, player_Blinky.X, player_Blinky.Y
    mov esi, player_Blinky.State
    .if esi == Ghost_State_Eaten
        ; Ŀ��goast house
        mov eax,ghost_house_x
        mov targetX, eax
        mov eax,ghost_house_y
        mov targetY, eax
    .elseif esi == Ghost_State_Stay
        ; Ŀ��ԭ��
        mov eax, 14
        mov targetX, eax
        mov eax, 11
        mov targetY, eax
    .elseif eax == Item_GhostHouse
        ; Ŀ�������
        mov eax,ghost_house_x
        dec eax
        mov targetX, eax
        mov eax,ghost_house_y
        mov targetY, eax
    .elseif esi == Ghost_State_Chase
        ; Ŀ��chase_target
        .if chase_target == PacMan
            mov eax, player_PacMan.X
            mov ebx, player_PacMan.Y       
        .elseif chase_target == RedMan
            mov eax, player_RedMan.X
            mov ebx, player_RedMan.Y
        .endif
        mov targetX, eax
        mov targetY, ebx
    .elseif esi == Ghost_State_Scatter
        ; Ŀ���Թ����Ͻ�
        mov targetX, 0
        mov eax, map_cols
        dec eax
        mov targetY, eax
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

; ����Pinky��NextDir
nxt_dir_Pinky proc uses esi ebx ecx
    local targetX:dword
    local targetY:dword
    ; �ж�Pinky��״̬
    invoke get_map_value, player_Pinky.X, player_Pinky.Y
    mov esi, player_Pinky.State
    .if esi == Ghost_State_Eaten
        ; Ŀ��goast house
        mov eax,ghost_house_x
        mov targetX, eax
        mov eax,ghost_house_y
        mov targetY, eax
    .elseif esi == Ghost_State_Stay
        ; Ŀ��ԭ��
        mov eax, 16
        mov targetX, eax
        mov eax, 11
        mov targetY, eax
    .elseif eax == Item_GhostHouse
        ; Ŀ�������
        mov eax,ghost_house_x
        dec eax
        mov targetX, eax
        mov eax,ghost_house_y
        mov targetY, eax
    .elseif esi == Ghost_State_Chase
        ; Ŀ��chase_targetǰ���ĸ�����
        .if chase_target == PacMan
            mov eax, player_PacMan.X
            mov ebx, player_PacMan.Y
            mov ecx, player_PacMan.Dir
        .elseif chase_target == RedMan
            mov eax, player_RedMan.X
            mov ebx, player_RedMan.Y
            mov ecx, player_RedMan.Dir
        .endif
        mov targetX, eax
        mov targetY, ebx
        ; ����chase_target�ķ��򣬼���Ŀ��λ��
        .if ecx == Dir_Up
            sub targetY, 4
        .elseif ecx == Dir_Down
            add targetY, 4
        .elseif ecx == Dir_Left
            sub targetX, 4
        .elseif ecx == Dir_Right
            add targetX, 4
        .endif
    .elseif esi == Ghost_State_Scatter
        ; Ŀ���Թ����Ͻ�
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

; ����Inky��NextDir
nxt_dir_Inky proc uses esi ebx ecx
    local targetX:dword
    local targetY:dword
    ; �ж�Inky��״̬
    invoke get_map_value, player_Inky.X, player_Inky.Y
    mov esi, player_Inky.State
    .if esi == Ghost_State_Eaten
        ; Ŀ��goast house
        mov eax,ghost_house_x
        mov targetX, eax
        mov eax,ghost_house_y
        mov targetY, eax
    .elseif esi == Ghost_State_Stay
        ; Ŀ��ԭ��
        mov eax, 14
        mov targetX, eax
        mov eax, 16
        mov targetY, eax
    .elseif eax == Item_GhostHouse
        ; Ŀ�������
        mov eax,ghost_house_x
        dec eax
        mov targetX, eax
        mov eax,ghost_house_y
        mov targetY, eax
    .elseif esi == Ghost_State_Chase
        ; ��λchase_targetǰ����������
        .if chase_target == PacMan
            mov eax, player_PacMan.X
            mov ebx, player_PacMan.Y
            mov ecx, player_PacMan.Dir       
        .elseif chase_target == RedMan
            mov eax, player_RedMan.X
            mov ebx, player_RedMan.Y
            mov ecx, player_RedMan.Dir
        .endif
        mov targetX, eax
        mov targetY, ebx
        ; ����chase_target�ķ��򣬼���Ŀ��λ��
        .if ecx == Dir_Up
            sub targetY, 2
        .elseif ecx == Dir_Down
            add targetY, 2
        .elseif ecx == Dir_Left
            sub targetX, 2
        .elseif ecx == Dir_Right
            add targetX, 2
        .endif
        ; ��λBlinky��λ�ã����߷�ת180��
        mov eax, player_Blinky.X
        sub eax, targetX
        sub targetX, eax
        mov eax, player_Blinky.Y
        sub eax, targetY
        sub targetY, eax
    .elseif esi == Ghost_State_Scatter
        ; Ŀ���Թ����½�
        mov eax,map_rows
        dec eax
        mov targetX, eax
        mov eax,map_cols
        dec eax
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

; ����Clyde��NextDir
nxt_dir_Clyde proc uses esi
    local targetX:dword
    local targetY:dword
    ; �ж�Clyde��״̬
    invoke get_map_value, player_Clyde.X, player_Clyde.Y
    mov esi, player_Clyde.State
    .if esi == Ghost_State_Eaten
        ; Ŀ��goast house
        mov eax,ghost_house_x
        mov targetX, eax
        mov eax,ghost_house_y
        mov targetY, eax
    .elseif esi == Ghost_State_Stay
        ; Ŀ��ԭ��
        mov eax, 16
        mov targetX, eax
        mov eax, 16
        mov targetY, eax
    .elseif eax == Item_GhostHouse
        ; Ŀ�������
        mov eax,ghost_house_x
        dec eax
        mov targetX, eax
        mov eax,ghost_house_y
        mov targetY, eax
    .elseif esi == Ghost_State_Chase
        ; �ж�Clyde��PacMan�ľ���
        invoke get_distance, player_Clyde.X, player_Clyde.Y, player_PacMan.X, player_PacMan.Y
        .if eax < 64
            ; Ŀ���Թ����½�
            mov eax,map_rows
            dec eax
            mov targetX, eax
            mov targetY, 0
        .else
            ; Ŀ��chase_target
            .if chase_target == PacMan
                mov eax, player_PacMan.X
                mov ebx, player_PacMan.Y       
            .elseif chase_target == RedMan
                mov eax, player_RedMan.X
                mov ebx, player_RedMan.Y
            .endif
            mov targetX, eax
            mov targetY, ebx
        .endif
    .elseif esi == Ghost_State_Scatter
        ; Ŀ���Թ����½�
        mov eax,map_rows
        dec eax
        mov targetX, eax
        mov targetY, 0
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

; ����Cindy��NextDir
nxt_dir_Cindy proc
    mov eax, player_Cindy.NextDir
    mov player_Cindy.Dir, eax
    ret
nxt_dir_Cindy endp

; ����PacMan��NextDir
nxt_dir_PacMan proc
    mov eax, player_PacMan.NextDir
    mov player_PacMan.Dir, eax
    ret
nxt_dir_PacMan endp

; ����RedMan��NextDir
nxt_dir_RedMan proc
    mov eax, player_RedMan.NextDir
    mov player_RedMan.Dir, eax
    ret
nxt_dir_RedMan endp

; ��ȡplayer��NextDir
get_nxt_dir proc , item:dword
    .if item == PacMan
        invoke nxt_dir_PacMan
    .elseif item == RedMan
        invoke nxt_dir_RedMan
    .elseif item == Blinky
        invoke nxt_dir_Blinky
    .elseif item == Pinky
        invoke nxt_dir_Pinky
    .elseif item == Inky
        invoke nxt_dir_Inky
    .elseif item == Clyde
        invoke nxt_dir_Clyde
    .elseif item == Cindy
        invoke nxt_dir_Cindy
    .endif
    ret
get_nxt_dir endp

; ����draw_item����ѹ��draw_list
create_draw_item proc uses edx ecx, x:dword,y:dword, prio:dword, item:dword, dir:dword
    ; ����ƫ����
    mov ecx, draw_list_size
    imul ecx, 24
    ; ѹ��draw_list
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

; �������
;draw_player proc , item:dword,isOnCross:dword
draw_player proc , item:dword
    ;.if isOnCross == 1
        ;invoke player_move, item
        ;invoke get_nxt_dir, item
    ;.endif
    invoke get_player_ptr, item
    invoke create_draw_item , [eax].player_struct.X, [eax].player_struct.Y, 1, item, [eax].player_struct.Dir
    ret
draw_player endp

; ���Ƶ�ͼ
draw_map proc
    local index:dword
    local x:dword
    local y:dword

    invoke judge_meet, PacMan
    .if game_mode == Game_Mode_Double_Cooperate
        invoke judge_meet,RedMan
    .endif

    mov draw_list_size, 0
    ; ���ƽ�ɫ
    ;.if player_PacMan.IsOnCross
        ;invoke draw_player, PacMan, player_PacMan.IsOnCross
        ;invoke judge_eat, PacMan
    ;.else
        ;invoke draw_player, PacMan, player_PacMan.IsOnCross
        invoke draw_player, PacMan
    ;.endif
    .if game_mode == Game_Mode_Double_Cooperate
        ;.if player_RedMan.IsOnCross
            ;invoke draw_player, RedMan, player_RedMan.IsOnCross
            ;invoke judge_eat, RedMan
        ;.else
            ;invoke draw_player, RedMan, player_RedMan.IsOnCross
            invoke draw_player, RedMan
        ;.endif
    .endif
    ;invoke draw_player, Blinky, player_Blinky.IsOnCross
    ;invoke draw_player, Pinky, player_Pinky.IsOnCross
    ;invoke draw_player, Inky, player_Inky.IsOnCross
    ;invoke draw_player, Clyde, player_Clyde.IsOnCross
    invoke draw_player, Blinky
    invoke draw_player, Pinky
    invoke draw_player, Inky
    invoke draw_player, Clyde

    .if game_mode == Game_Mode_Double_Chase
        ;invoke draw_player, Cindy, player_Cindy.IsOnCross
        invoke draw_player, Cindy
    .endif


    ; ����item_map�����Ƶ�ͼ
    ; mov index, 0
    ; .while index < map_rows*map_cols
    ;     ; ����x,y
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

; ��ȡ��ͼ
read_map proc uses esi edi
    local counter:dword
    local index:dword
    local len:dword
    local file_ptr:dword
    ; ���ļ���ȡ��ͼ��map_rows��map_cols��wallColor���Կո�ָ�
    invoke fopen, offset map_path, offset read_mode
    mov file_ptr, eax
    invoke fscanf, file_ptr, offset map_msg_fmt1, offset map_rows, offset map_cols, offset ghost_house_x, offset ghost_house_y, offset wallColor, offset map_path
    ; ȥ�����з�
    invoke fgets , offset input_str, 1024, file_ptr
    invoke strlen, offset input_str
    mov len, eax
    invoke memset, offset input_str, 0, len
    ; ����map_size
    mov eax, map_rows
    imul eax, map_cols
    mov map_size, eax
    ; ��ȡ��ͼ
    mov ebx, 0
    mov counter, 0
    mov index, 0
    .while ebx < map_rows
        ; ��ȡһ��
        invoke fgets , offset input_str, 1024, file_ptr
        invoke strlen, offset input_str
        mov len, eax
        ; ����һ��
        mov ecx,len
        mov esi, offset input_str
        .while ecx > 0
            ; ��ȡһ���ַ�
            movzx eax, byte ptr [esi]
            ; ���Ż��߻��У�����
            .if eax == 0ah || eax == 20h || eax == 2ch || eax == 0ah
                ; ����

            .else
                ; ת��������
                sub eax, 30h
                ; ����mapֵ
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

    ; ���Զ�ȡ���
    ; invoke printf, offset map_msg_fmt1, map_rows, map_cols, ghost_house_x, ghost_house_y, wallColor, offset map_path
    ; invoke printf, offset next_line_fmt
    ; mov esi, 0
    ; mov counter, 0
    ; .while esi < map_size
    ;     invoke  get_map_value_by_index, esi
    ;     invoke printf, offset ans_str_fmt2, eax
    ;     inc esi
    ;     inc counter
    ;     mov eax,map_cols
    ;     .if counter == eax
    ;         invoke printf, offset next_line_fmt
    ;         mov counter, 0
    ;     .endif
    ; .endw
    ret
read_map endp

; ��ʼ����ͼ
init_map proc uses esi edi
    local x:dword
    local y:dword
    mov score, 0
    mov chase_target, PacMan
    mov target_release_ghost,Blinky
    mov portal1_x, 0
    mov portal1_y, 0
    mov portal2_x, 0
    mov portal2_y, 0

    mov game_mode, Game_Mode_Single

    ; ���ȡ���Զ�
    ; invoke get_player_ptr , player1Id
    ; mov [eax].player_struct.IsAuto, 0
    ; invoke get_player_ptr , player2Id
    ; mov [eax].player_struct.IsAuto, 0

    ; ��ȡ��ͼ
    invoke read_map

    ; ���㶹������
    mov bean_count, 0
    mov esi, 0

    .while esi < map_size
        invoke  get_map_value_by_index, esi
        .if eax == Item_Bean || eax == Item_SuperBean || eax == Item_FastBean || eax == Item_InvisibleBean
            inc bean_count
        .elseif eax == Item_Portal
            ; ����x,y
            xor edx,edx
            mov eax, esi
            mov ecx, map_cols
            div ecx
            ; ����portal
            .if portal1_x == 0 && portal1_y == 0
                mov portal1_x, eax
                mov portal1_y, edx
            .else
                mov portal2_x, eax
                mov portal2_y, edx
            .endif
        .endif
        inc esi
    .endw

    mov game_state, Game_State_Ready
    ret
init_map endp

; main��������
main proc
    local ans : dword
    ; ����get_map_value
    invoke init_map
    invoke get_map_value, 31, 27
    invoke printf, offset ans_str_fmt, eax
    ret
    main endp
end