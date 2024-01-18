;mode define
.386
.model flat,stdcall
option casemap:none

invoke get_nxt_pos, index_x, index_y, dir, PacMan
.if eax == -1
.else

;include libs and declarations
include		windows.inc
include		user32.inc
includelib	user32.lib
include		kernel32.inc
includelib	kernel32.lib
include		Gdi32.inc
includelib	Gdi32.lib
include     winmm.inc
includelib  winmm.lib
include     Msimg32.inc
includelib  Msimg32.lib
includelib  msvcrt.lib

include pacman_define.inc

extern \
h_dc_buffer:dword,\
h_dc_bmp:dword,\
mapCol:dword, \
mapRow:dword, \
;cell_size:dword, \
mapX:dword, \                    ; ��ͼ�ڴ����е�λ��
mapY:dword

extern\
h_dc_pacman1_left:dword, \   
h_dc_pacman2_left:dword, \
h_dc_pacman1_down:dword, \   
h_dc_pacman2_down:dword, \
h_dc_pacman1_right:dword, \   
h_dc_pacman2_right:dword, \
h_dc_pacman1_up:dword, \   
h_dc_pacman2_up:dword

extern\
h_dc_blinky_left:dword, \
h_dc_blinky_left2:dword, \
h_dc_blinky_down:dword, \
h_dc_blinky_down2:dword, \
h_dc_blinky_right:dword, \
h_dc_blinky_right2:dword, \
h_dc_blinky_up:dword, \
h_dc_blinky_up2:dword

extern\
h_dc_pinky_left:dword,\
h_dc_pinky_left2:dword,\
h_dc_pinky_down:dword, \
h_dc_pinky_down2:dword, \
h_dc_pinky_right:dword, \
h_dc_pinky_right2:dword, \
h_dc_pinky_up:dword,\
h_dc_pinky_up2:dword

extern\
h_dc_inky_left:dword, \
h_dc_inky_left2:dword, \
h_dc_inky_down:dword, \
h_dc_inky_down2:dword, \
h_dc_inky_right:dword, \
h_dc_inky_right2:dword, \
h_dc_inky_up:dword, \
h_dc_inky_up2:dword

extern\
h_dc_clyde_left:dword, \
h_dc_clyde_left2:dword, \
h_dc_clyde_down:dword, \
h_dc_clyde_down2:dword, \
h_dc_clyde_right:dword, \
h_dc_clyde_right2:dword, \
h_dc_clyde_up:dword, \
h_dc_clyde_up2:dword

extern\
h_dc_dazzled_left:dword,\
h_dc_dazzled_left2:dword,\
h_dc_dazzled_down:dword,\
h_dc_dazzled_down2:dword,\
h_dc_dazzled_right:dword,\
h_dc_dazzled_right2:dword,\
h_dc_dazzled_up:dword, \
h_dc_dazzled_up2:dword

extern\
h_dc_dead_left:dword,\
h_dc_dead_down:dword,\
h_dc_dead_right:dword,\
h_dc_dead_up:dword

extern\
player_PacMan:player_struct,\
player_Blinky:player_struct,\
player_Pinky:player_struct,\
player_Inky:player_struct,\
player_Clyde:player_struct

.code

draw_PacMan PROC uses esi edi ecx eax ebx edx, index_x:dword, index_y:dword, dir:dword, frame_time:dword
    local \
    @player_x,\
    @player_y, \
    @Speed, \
    @steps, \
    @dis, \
    @h_dc, \
    @move_state

    assume edi:ptr player_struct

    ;�������player��ָ�븳��edi�������ֻ��һ������player��ȫ�֣�����Ҫ���״̬
    mov edi, offset player_PacMan   

    .if dir == Dir_Stop 
        ret
    .endif

    ;�����߽����
    mov eax, mapCol
    dec eax
    mov ebx, mapRow
    dec ebx
    .if (index_x == ebx && dir == Dir_Down) || (index_y == eax && dir == Dir_Right) || (index_x == 0 && dir == Dir_Up) || (index_y == 0 && dir == Dir_Left)
        mov [edi].IsOnCross,1
        ret
    .endif

    ;ȷ���������������ͨ�ÿ�
    mov ecx, index_x
    imul ecx, cell_size ;ȷ��x����ࣩ����
    mov @player_y, ecx
    mov ecx, index_y
    imul ecx, cell_size
    mov @player_x, ecx  ;ȷ��y���ϲࣩ����

    ;�ӽṹ��õ��ٶ�
    mov ecx, [edi].Speed 
    mov @Speed, ecx

    ;buffer_size/Speed=steps(���ٲ�����һ�񣬹涨Ϊ��������һ���ܳ���)
    xor edx, edx ; ���EDX�Ĵ�������Ϊ��32λ�����У�EDX:EAX�Ǳ�����
    mov eax, buffer_size
    div @Speed 
    mov @steps, eax ;���������eax��

    ;frame_time%steps ����frame_time��ʹƫ���������������ŵ�һ��Χ֮��
    xor edx, edx ; ���EDX�Ĵ�������Ϊ��32λ�����У�EDX:EAX�Ǳ�����
    mov eax, frame_time
    div @steps 
    mov @dis, edx ;����������edx��
    add @dis, 1 ;������1��ʹ�����һ���������0

    ;�����߼��㣬�����ж��Ƿ񵽴�·��
    mov eax, @dis
    mov ebx, @steps
    .if eax == ebx
        mov [edi].IsOnCross,1
    .endif

    ;�����֡ƫ��������ecx�У��Ż�Ϊ����*һ���ľ���
    xor edx, edx
    mov eax, cell_size
    div @steps ;�����eax�д��һ���ľ���
    mul @dis ;����һ���ľ���*���ٲ��������eax��
    mov ecx, eax

    ;ȷ���������в�֡���õ����ջ�������
    .if dir == Dir_Left 
        neg ecx
        add @player_x, ecx  ;-x left
    .elseif dir == Dir_Down
        add @player_y, ecx  ;+y down
    .elseif dir == Dir_Right
        add @player_x, ecx  ;+x right
    .elseif dir == Dir_Up
        neg ecx
        add @player_y, ecx  ;-y up
    .endif

    ;���ϵ�ͼƫ��
    xor ecx,ecx
    mov ecx, @player_x
    add ecx,mapX
    mov @player_x,ecx
    mov ecx, @player_y
    add ecx,mapY
    mov @player_y,ecx

    ;��Ҫ�жϼ����ĸ���̬ͼƬ��������Ҫ�ߵĲ���/2���õ��жϼ���ͼƬ�ı�׼
    mov eax, @steps 
    xor edx, edx 
    mov ecx,2
    div ecx
    mov @move_state,eax

    .if dir == Dir_Left ;ȷ���������ڼ���ͼƬ
        mov eax, h_dc_pacman1_left    ;���ض�Ӧ��hdc
        mov ebx, h_dc_pacman2_left    ;���ض�Ӧ��hdc
    .elseif dir == Dir_Down
        mov eax, h_dc_pacman1_down    ;���ض�Ӧ��hdc
        mov ebx, h_dc_pacman2_down    ;���ض�Ӧ��hdc
    .elseif dir == Dir_Right
        mov eax, h_dc_pacman1_right    ;���ض�Ӧ��hdc
        mov ebx, h_dc_pacman2_right    ;���ض�Ӧ��hdc
    .elseif dir == Dir_Up
        mov eax, h_dc_pacman1_up    ;���ض�Ӧ��hdc
        mov ebx, h_dc_pacman2_up    ;���ض�Ӧ��hdc
    .endif
    
    ;��Ҫ�жϼ����ĸ���̬ͼƬ
    mov ecx, @dis
    .if ecx < @move_state
    mov @h_dc, eax  ;�þֲ���������
    .else
    mov @h_dc, ebx  ;�þֲ���������
    .endif

    ;����һ֡��ͨ�ÿ�
    ;���ŵ�h_dc_bmp��ʱͼƬ��
    ;StretchBlt hdcDest xDest yDest cxDest cyDest hdcSrc xSrc ySrc cxSrc cySrc dwRop
    invoke StretchBlt,h_dc_bmp,0,0,cell_size, cell_size,@h_dc,0,0,pacman_size,pacman_size,SRCCOPY
    
    ;����transparentColor���������ڽ���ɫ��Ϊ͸��
    mov eax, 000000h
    ;frametime����buffer���±�
    mov esi, frame_time 
    ;��������͸���ŵ�h_dc_buffer[4*frametime]����֡��,��4����Ϊdword
    ;TransparentBlt hdcDest xDest yDest cxDest cyDest hdcSrc xSrc ySrc cxSrc cySrc transparentColor 
    invoke TransparentBlt,h_dc_buffer[4*esi],@player_x,@player_y,cell_size, cell_size,h_dc_bmp,0,0,cell_size,cell_size,eax
    ;invoke TransparentBlt,h_dc_buffer[4*esi],@player_x,@player_y,cell_size, cell_size,h_dc_bmp,0,0,pacman_size,pacman_size,eax

    assume edi:nothing
    ret
draw_PacMan ENDP



draw_Ghost PROC uses esi edi ecx eax ebx edx, player:dword, index_x:dword, index_y:dword, dir:dword, frame_time:dword
    local \
    @player_x,\
    @player_y, \
    @Speed, \
    @steps, \
    @dis, \
    @h_dc, \
    @move_state

    ;�������player��ָ�븳��edi�������ֻ��һ������player��ȫ�֣�����Ҫ���״̬��д���Ƿ���·��
    assume edi:ptr player_struct

    .if player == Blinky
        mov edi, offset player_Blinky
    .elseif player == Pinky
        mov edi, offset player_Pinky
    .elseif player == Inky
        mov edi, offset player_Inky
    .elseif player == Clyde
        mov edi, offset player_Clyde
    .endif

    ;�����߽����
    xor eax,eax
    xor ebx,ebx
    mov eax, mapCol
    dec eax
    mov ebx, mapRow
    dec ebx
    .if (index_x == ebx && dir == Dir_Down) || (index_y == eax && dir == Dir_Right) || (index_x == 0 && dir == Dir_Up) || (index_y == 0 && dir == Dir_Left)
        mov [edi].IsOnCross,1
        ret
    .endif

    ;ȷ���������������ͨ�ÿ�
    xor ecx,ecx
    mov ecx, index_x
    imul ecx, cell_size ;ȷ��x����ࣩ����
    mov @player_y, ecx
    mov ecx, index_y
    imul ecx, cell_size
    mov @player_x, ecx  ;ȷ��y���ϲࣩ����

    ;�ӽṹ��õ��ٶ�
    xor ecx,ecx
    mov ecx, [edi].Speed 
    mov @Speed, ecx

    ;buffer_size/Speed=steps(���ٲ�����һ�񣬹涨Ϊ��������һ���ܳ���)
    xor edx, edx ; ���EDX�Ĵ�������Ϊ��32λ�����У�EDX:EAX�Ǳ�����
    mov eax, buffer_size
    div @Speed 
    mov @steps, eax ;���������eax��

    ;frame_time%steps ����frame_time��ʹƫ���������������ŵ�һ��Χ֮��
    xor edx, edx ; ���EDX�Ĵ�������Ϊ��32λ�����У�EDX:EAX�Ǳ�����
    mov eax, frame_time
    div @steps 
    mov @dis, edx ;����������edx��
    add @dis, 1 ;������1��ʹ�����һ���������0

    ;�����߼��㣬�����ж��Ƿ񵽴�·��
    mov eax, @dis
    mov ebx, @steps
    .if eax == ebx
        mov [edi].IsOnCross,1
    .endif

    ;�����֡ƫ��������ecx�У��Ż�Ϊ����*һ���ľ���
    xor edx, edx
    mov eax, cell_size
    div @steps ;�����eax�д��һ���ľ���
    mul @dis ;����һ���ľ���*���ٲ��������eax�д��ƫ����
    mov ecx, eax

    ;ȷ���������в�֡���õ����ջ�������
    .if dir == Dir_Left 
        neg ecx
        add @player_x, ecx  ;-x left
    .elseif dir == Dir_Down
        add @player_y, ecx  ;+y down
    .elseif dir == Dir_Right
        add @player_x, ecx  ;+x right
    .elseif dir == Dir_Up
        neg ecx
        add @player_y, ecx  ;-y up
    .endif

    ;���ϵ�ͼƫ��
    xor ecx,ecx
    mov ecx, @player_x
    add ecx,mapX
    mov @player_x,ecx
    mov ecx, @player_y
    add ecx,mapY
    mov @player_y,ecx

    ;��Ҫ�жϼ����ĸ���̬ͼƬ��������Ҫ�ߵĲ���/2���õ��жϼ���ͼƬ�ı�׼
    mov eax, @steps 
    xor edx, edx 
    mov ecx,2
    div ecx
    mov @move_state,eax

    ;��������״̬��ͼƬ
    .if [edi].State == Ghost_State_Eaten
        .if dir == Dir_Left 
            mov eax, h_dc_dead_left
        .elseif dir == Dir_Down
            mov eax, h_dc_dead_down
        .elseif dir == Dir_Right
            mov eax, h_dc_dead_right
        .elseif dir == Dir_Up
            mov eax, h_dc_dead_up
        .endif
    .elseif [edi].State == Ghost_State_Frightened
        .if dir == Dir_Left 
            mov eax, h_dc_dazzled_left
            mov ebx, h_dc_dazzled_left2
        .elseif dir == Dir_Down
            mov eax, h_dc_dazzled_down
            mov ebx, h_dc_dazzled_down2
        .elseif dir == Dir_Right
            mov eax, h_dc_dazzled_right
            mov ebx, h_dc_dazzled_right2
        .elseif dir == Dir_Up
            mov eax, h_dc_dazzled_up
            mov ebx, h_dc_dazzled_up2
        .endif
    .else
        ;���ػ���״̬��ͼƬ
        .if player == Blinky
            ;ȷ���������ڼ���ͼƬ
            .if dir == Dir_Left 
                mov eax, h_dc_blinky_left
                mov ebx, h_dc_blinky_left2
            .elseif dir == Dir_Down
                mov eax, h_dc_blinky_down
                mov ebx, h_dc_blinky_down2
            .elseif dir == Dir_Right
                mov eax, h_dc_blinky_right
                mov ebx, h_dc_blinky_right2
            .elseif dir == Dir_Up
                mov eax, h_dc_blinky_up
                mov ebx, h_dc_blinky_up2
            .endif
        .elseif player == Pinky
                ;ȷ���������ڼ���ͼƬ
            .if dir == Dir_Left 
                mov eax, h_dc_pinky_left
                mov ebx, h_dc_pinky_left2
            .elseif dir == Dir_Down
                mov eax, h_dc_pinky_down
                mov ebx, h_dc_pinky_down2
            .elseif dir == Dir_Right
                mov eax, h_dc_pinky_right
                mov ebx, h_dc_pinky_right2
            .elseif dir == Dir_Up
                mov eax, h_dc_pinky_up
                mov ebx, h_dc_pinky_up2
            .endif
        .elseif player == Inky
                ;ȷ���������ڼ���ͼƬ
            .if dir == Dir_Left 
                mov eax, h_dc_inky_left
                mov ebx, h_dc_inky_left2
            .elseif dir == Dir_Down
                mov eax, h_dc_inky_down
                mov ebx, h_dc_inky_down2
            .elseif dir == Dir_Right
                mov eax, h_dc_inky_right
                mov ebx, h_dc_inky_right2
            .elseif dir == Dir_Up
                mov eax, h_dc_inky_up
                mov ebx, h_dc_inky_up2
            .endif
        .elseif player == Clyde
                ;ȷ���������ڼ���ͼƬ
            .if dir == Dir_Left 
                mov eax, h_dc_clyde_left
                mov ebx, h_dc_clyde_left2
            .elseif dir == Dir_Down
                mov eax, h_dc_clyde_down
                mov ebx, h_dc_clyde_down2
            .elseif dir == Dir_Right
                mov eax, h_dc_clyde_right
                mov ebx, h_dc_clyde_right2
            .elseif dir == Dir_Up
                mov eax, h_dc_clyde_up
                mov ebx, h_dc_clyde_up2
            .endif
        .endif
    .endif

    ;��Ҫ�жϼ����ĸ���̬ͼƬ
    mov ecx, @dis
    .if ecx < @move_state
    mov @h_dc, eax  ;�þֲ���������
    .else
    mov @h_dc, ebx  ;�þֲ���������
    .endif

    ;����һ֡��ͨ�ÿ�
    ;���ŵ�h_dc_bmp��ʱͼƬ��
    ;StretchBlt hdcDest xDest yDest cxDest cyDest hdcSrc xSrc ySrc cxSrc cySrc dwRop
    invoke StretchBlt,h_dc_bmp,0,0,cell_size, cell_size,@h_dc,0,0,ghost_size,ghost_size,SRCCOPY
    
    ;����transparentColor���������ڽ���ɫ��Ϊ͸��
    mov eax, 000000h
    ;frametime����buffer���±�
    mov esi, frame_time 
    ;��������͸���ŵ�h_dc_buffer[4*frametime]����֡��,��4����Ϊdword
    ;TransparentBlt hdcDest xDest yDest cxDest cyDest hdcSrc xSrc ySrc cxSrc cySrc transparentColor 
    invoke TransparentBlt,h_dc_buffer[4*esi],@player_x,@player_y,cell_size, cell_size,h_dc_bmp,0,0,cell_size,cell_size,eax
    ;invoke TransparentBlt,h_dc_buffer[4*esi],@player_x,@player_y,cell_size, cell_size,h_dc_bmp,0,0,ghost_size,ghost_size,eax

    assume edi:nothing
    ret
draw_Ghost ENDP

draw_item PROC item:draw_struct,frame_time:dword
    .if item.Item == PacMan
        invoke draw_PacMan,item.X, item.Y, item.Dir, frame_time
    .elseif item.Item == Blinky
        invoke draw_Ghost,Blinky, item.X, item.Y, item.Dir, frame_time
    .elseif item.Item == Pinky
        invoke draw_Ghost,Pinky, item.X, item.Y, item.Dir, frame_time
    .elseif item.Item == Inky
        invoke draw_Ghost,Inky, item.X, item.Y, item.Dir, frame_time
    .elseif item.Item == Clyde
        invoke draw_Ghost,Clyde, item.X, item.Y, item.Dir, frame_time
    .endif
    ret
draw_item ENDP

end

