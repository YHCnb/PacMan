;mode define
.386
.model flat,stdcall
option casemap:none

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

get_nxt_pos PROTO :DWORD,:DWORD,:DWORD,:DWORD
draw_map PROTO  
judge_meet PROTO :DWORD 
player_move PROTO :DWORD
get_nxt_dir PROTO :DWORD
judge_eat PROTO :DWORD

extern \
    h_dc_buffer:dword,\
    h_dc_bmp:dword,\
    game_state:dword,\
    map_cols:dword, \
    map_rows:dword, \
    mapGridWidth:dword, \
    mapX:dword, \                    ; 地图在窗口中的位置
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
    h_dc_redman1_left:dword, \
    h_dc_redman2_left:dword, \
    h_dc_redman1_down:dword, \
    h_dc_redman2_down:dword, \
    h_dc_redman1_right:dword, \
    h_dc_redman2_right:dword, \
    h_dc_redman1_up:dword, \
    h_dc_redman2_up:dword

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
    h_dc_cindy_left:dword, \
    h_dc_cindy_left2:dword, \
    h_dc_cindy_down:dword, \
    h_dc_cindy_down2:dword, \
    h_dc_cindy_right:dword, \
    h_dc_cindy_right2:dword, \
    h_dc_cindy_up:dword, \
    h_dc_cindy_up2:dword

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
    player_RedMan:player_struct,\
    player_Blinky:player_struct,\
    player_Pinky:player_struct,\
    player_Inky:player_struct,\
    player_Clyde:player_struct,\
    player_Cindy:player_struct



.code

draw_PacMan PROC uses esi edi ecx eax ebx edx, player:dword, index_x:dword, index_y:dword, dir:dword, frame_time:dword
    local \
    @player_x,\
    @player_y, \
    @Speed, \
    @steps, \
    @dis, \
    @h_dc, \
    @move_state,\
    @double_width

    assume edi:ptr player_struct

    ;将传入的player的指针赋给edi（传入的只是一个数，player在全局），需要获得状态
    .if player == PacMan
        mov edi, offset player_PacMan 
    .elseif player == RedMan
        mov edi, offset player_RedMan
    .endif

    ;处理边界情况
    mov eax, map_cols
    dec eax
    mov ebx, map_rows
    dec ebx
    .if (index_x == ebx && dir == Dir_Down) || (index_y == eax && dir == Dir_Right) || (index_x == 0 && dir == Dir_Up) || (index_y == 0 && dir == Dir_Left)
        ;mov [edi].IsOnCross,1
        invoke player_move, player
        invoke get_nxt_dir, player
        invoke judge_eat, player
        invoke judge_meet, player

        invoke draw_map
        ret
    .endif

    ;确定基础绘制坐标的通用块
    mov ecx, [edi].X
    imul ecx, mapGridWidth ;确定x（左侧）坐标
    mov @player_y, ecx
    mov ecx, [edi].Y
    imul ecx, mapGridWidth
    mov @player_x, ecx  ;确定y（上侧）坐标

    ;从结构体得到速度
    mov ecx, [edi].Speed 
    mov @Speed, ecx

    ;mapGridWidth/Speed=steps(多少步走完一格，规定为公倍数，一定能除尽)
    xor edx, edx ; 清空EDX寄存器，因为在32位除法中，EDX:EAX是被除数
    mov eax, mapGridWidth
    div @Speed 
    mov @steps, eax ;结果保存在eax中

    ;frame_time%steps 缩放frame_time，使偏移量（步数）缩放到一格范围之内
    xor edx, edx ; 清空EDX寄存器，因为在32位除法中，EDX:EAX是被除数
    mov eax, frame_time
    div @steps 
    mov @dis, edx ;余数保存在edx中
    add @dis, 1 ;余数加1，使得最后一步不会出现0

    
    ;传回逻辑层，用于判断是否到达格点
    mov eax, @dis
    mov ebx, @steps
    .if game_state != Game_State_Pause
        .if eax == ebx
            ;mov [edi].IsOnCross,1
            invoke player_move, player
            invoke get_nxt_dir, player
            invoke judge_eat, player
            invoke judge_meet, player

            invoke draw_map
        ;隐身效果（闪烁）
        .endif
        shr ebx,1
        .if eax > ebx && [edi].State == PacMan_State_Invisible
            ret
        .endif
    .endif

    ;计算插帧偏移量存在ecx中，优化为步数*一步的距离
    mov eax,@Speed;eax中存放一步的距离
    mul @dis ;计算一步的距离*多少步，计算后eax中
    mov ecx, eax ;存在ecx中备用

    invoke get_nxt_pos, index_x, index_y, dir, PacMan
    .if eax == -1
    .elseif game_state == Game_State_Pause
    .elseif game_state == Game_State_Win
    .elseif game_state == Game_State_Lose
    .else
    ;确定方向后进行插帧，得到最终绘制坐标
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
    .endif

    ;加上地图偏移
    xor ecx,ecx
    mov ecx, @player_x
    add ecx,mapX
    mov @player_x,ecx
    mov ecx, @player_y
    add ecx,mapY
    mov @player_y,ecx

    ;为了绘制双倍的大小，需要减去一半的宽度
    xor ecx,ecx
    mov ecx, mapGridWidth
    shr ecx,1
    sub ecx,4
    sub @player_x, ecx
    sub @player_y, ecx

    ;需要判断加载哪个动态图片，将总需要走的步数/2，得到判断加载图片的标准
    mov eax, @steps 
    xor edx, edx 
    mov ecx,2
    div ecx
    mov @move_state,eax

    .if player == PacMan
        .if dir == Dir_Left ;确定方向用于加载图片
            mov eax, h_dc_pacman1_left    ;加载对应的hdc
            mov ebx, h_dc_pacman2_left    ;加载对应的hdc
        .elseif dir == Dir_Down
            mov eax, h_dc_pacman1_down    ;加载对应的hdc
            mov ebx, h_dc_pacman2_down    ;加载对应的hdc
        .elseif dir == Dir_Right
            mov eax, h_dc_pacman1_right    ;加载对应的hdc
            mov ebx, h_dc_pacman2_right    ;加载对应的hdc
        .elseif dir == Dir_Up
            mov eax, h_dc_pacman1_up    ;加载对应的hdc
            mov ebx, h_dc_pacman2_up    ;加载对应的hdc
        .endif
    .elseif player == RedMan
        .if dir == Dir_Left ;确定方向用于加载图片
            mov eax, h_dc_redman1_left    ;加载对应的hdc
            mov ebx, h_dc_redman2_left    ;加载对应的hdc
        .elseif dir == Dir_Down
            mov eax, h_dc_redman1_down    ;加载对应的hdc
            mov ebx, h_dc_redman2_down    ;加载对应的hdc
        .elseif dir == Dir_Right
            mov eax, h_dc_redman1_right    ;加载对应的hdc
            mov ebx, h_dc_redman2_right    ;加载对应的hdc
        .elseif dir == Dir_Up
            mov eax, h_dc_redman1_up    ;加载对应的hdc
            mov ebx, h_dc_redman2_up    ;加载对应的hdc
        .endif
    .endif
    
    ;需要判断加载哪个动态图片
    mov ecx, @dis
    .if ecx < @move_state
    mov @h_dc, eax  ;用局部变量保存
    .else
    mov @h_dc, ebx  ;用局部变量保存
    .endif

    ;得到双倍的宽度，存在@double_width
    xor ecx,ecx
    mov ecx, mapGridWidth
    shl ecx,1
    sub ecx,8
    mov @double_width, ecx
    
    ;传入transparentColor参数，用于将黑色变为透明
    mov eax, 000000h
    ;frametime用作buffer的下标
    mov esi, frame_time 
    ;将背景变透明放到h_dc_buffer[4*frametime]画面帧中,乘4是因为dword
    ;TransparentBlt hdcDest xDest yDest cxDest cyDest hdcSrc xSrc ySrc cxSrc cySrc transparentColor 
    invoke TransparentBlt,h_dc_buffer[4*esi],@player_x,@player_y,@double_width, @double_width,@h_dc,0,0,pacman_size,pacman_size,eax

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
    @move_state, \
    @double_width

    ;将传入的player的指针赋给edi（传入的只是一个数，player在全局），需要获得状态并写回是否在路口
    assume edi:ptr player_struct

    .if player == Blinky
        mov edi, offset player_Blinky
    .elseif player == Pinky
        mov edi, offset player_Pinky
    .elseif player == Inky
        mov edi, offset player_Inky
    .elseif player == Clyde
        mov edi, offset player_Clyde
    .elseif player == Cindy
        mov edi, offset player_Cindy
    .endif

    ;处理边界情况
    xor eax,eax
    xor ebx,ebx
    mov eax, map_cols
    dec eax
    mov ebx, map_rows
    dec ebx
    .if (index_x == ebx && dir == Dir_Down) || (index_y == eax && dir == Dir_Right) || (index_x == 0 && dir == Dir_Up) || (index_y == 0 && dir == Dir_Left)
        ;mov [edi].IsOnCross,1
        invoke player_move, player
        invoke get_nxt_dir, player
        invoke judge_meet, player

        invoke draw_map

        ret
    .endif

    ;确定基础绘制坐标的通用块
    xor ecx,ecx
    mov ecx, index_x
    imul ecx, mapGridWidth ;确定x（左侧）坐标
    mov @player_y, ecx
    mov ecx, index_y
    imul ecx, mapGridWidth
    mov @player_x, ecx  ;确定y（上侧）坐标

    ;从结构体得到速度
    xor ecx,ecx
    mov ecx, [edi].Speed 
    mov @Speed, ecx

    ;mapGridWidth/Speed=steps(多少步走完一格，规定为公倍数，一定能除尽)
    xor edx, edx ; 清空EDX寄存器，因为在32位除法中，EDX:EAX是被除数
    mov eax, mapGridWidth
    div @Speed 
    mov @steps, eax ;结果保存在eax中

    ;frame_time%steps 缩放frame_time，使偏移量（步数）缩放到一格范围之内
    xor edx, edx ; 清空EDX寄存器，因为在32位除法中，EDX:EAX是被除数
    mov eax, frame_time
    div @steps 
    mov @dis, edx ;余数保存在edx中
    add @dis, 1 ;余数加1，使得最后一步不会出现0

    ;传回逻辑层，用于判断是否到达路口
    mov eax, @dis
    mov ebx, @steps
    .if game_state != Game_State_Pause
        .if eax == ebx
            ;mov [edi].IsOnCross,1
            invoke player_move, player
            invoke get_nxt_dir, player
            invoke judge_meet, player

            invoke draw_map

        .endif
    .endif

    ;计算插帧偏移量存在ecx中，优化为步数*一步的距离
    mov eax,@Speed;eax中存放一步的距离
    mul @dis ;计算一步的距离*多少步，计算后eax中存放偏移量
    mov ecx, eax

    .if player == Cindy
        invoke get_nxt_pos, index_x, index_y, dir, Cindy
    .else
        mov eax,0
    .endif
    .if eax == -1
    .elseif game_state == Game_State_Pause
    .elseif game_state == Game_State_Win
    .elseif game_state == Game_State_Lose
    .else
        ;确定方向后进行插帧，得到最终绘制坐标
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
    .endif

    ;加上地图偏移
    xor ecx,ecx
    mov ecx, @player_x
    add ecx,mapX
    mov @player_x,ecx
    mov ecx, @player_y
    add ecx,mapY
    mov @player_y,ecx

    ;为了绘制双倍的大小，需要减去一半的宽度
    xor ecx,ecx
    mov ecx, mapGridWidth
    shr ecx,1
    sub ecx,4
    sub @player_x, ecx
    sub @player_y, ecx

    ;需要判断加载哪个动态图片，将总需要走的步数/2，得到判断加载图片的标准
    mov eax, @steps 
    xor edx, edx 
    mov ecx,2
    div ecx
    mov @move_state,eax

    ;加载特殊状态的图片
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
        ;加载基础状态的图片
        .if player == Blinky
            ;确定方向用于加载图片
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
                ;确定方向用于加载图片
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
                ;确定方向用于加载图片
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
                ;确定方向用于加载图片
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
        .elseif player == Cindy
                ;确定方向用于加载图片
            .if dir == Dir_Left
                mov eax, h_dc_cindy_left
                mov ebx, h_dc_cindy_left2 
            .elseif dir == Dir_Down
                mov eax, h_dc_cindy_down
                mov ebx, h_dc_cindy_down2
            .elseif dir == Dir_Right
                mov eax, h_dc_cindy_right
                mov ebx, h_dc_cindy_right2
            .elseif dir == Dir_Up
                mov eax, h_dc_cindy_up
                mov ebx, h_dc_cindy_up2
            .endif
        .endif
    .endif

    ;需要判断加载哪个动态图片
    mov ecx, @dis
    .if ecx < @move_state
    mov @h_dc, eax  ;用局部变量保存
    .else
    mov @h_dc, ebx  ;用局部变量保存
    .endif

    ;得到双倍的宽度，存在@double_width
    xor ecx,ecx
    mov ecx, mapGridWidth
    shl ecx,1
    sub ecx,8
    mov @double_width, ecx
    
    ;传入transparentColor参数，用于将白色变为透明
    mov eax, 000000h
    ;frametime用作buffer的下标
    mov esi, frame_time 
    ;将背景变透明放到h_dc_buffer[4*frametime]画面帧中,乘4是因为dword
    ;TransparentBlt hdcDest xDest yDest cxDest cyDest hdcSrc xSrc ySrc cxSrc cySrc transparentColor 
    invoke TransparentBlt,h_dc_buffer[4*esi],@player_x,@player_y,@double_width, @double_width,@h_dc,0,0,ghost_size,ghost_size,eax

    assume edi:nothing
    ret
draw_Ghost ENDP

draw_item PROC item:draw_struct,frame_time:dword
    .if item.Item == PacMan
        invoke draw_PacMan,PacMan,item.X, item.Y, item.Dir, frame_time
    .elseif item.Item == RedMan
        invoke draw_PacMan,RedMan, item.X, item.Y, item.Dir, frame_time
    .elseif item.Item == Blinky
        invoke draw_Ghost,Blinky, item.X, item.Y, item.Dir, frame_time
    .elseif item.Item == Pinky
        invoke draw_Ghost,Pinky, item.X, item.Y, item.Dir, frame_time
    .elseif item.Item == Inky
        invoke draw_Ghost,Inky, item.X, item.Y, item.Dir, frame_time
    .elseif item.Item == Clyde
        invoke draw_Ghost,Clyde, item.X, item.Y, item.Dir, frame_time
    .elseif item.Item == Cindy
        invoke draw_Ghost,Cindy, item.X, item.Y, item.Dir, frame_time
    .endif
    ret
draw_item ENDP

end

