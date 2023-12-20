.386

.model flat,stdcall ; ?????????stdcall???????
option casemap:none ; ??§³§Υ????????

include     pacman_define.inc
include		windows.inc
include		user32.inc
includelib	user32.lib
include		kernel32.inc
includelib	kernel32.lib
include		Gdi32.inc
includelib	Gdi32.lib
include     winmm.inc
includelib  winmm.lib

includelib msvcrt.lib


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

.data

;????????
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

;in control_frame_rate draw_window
is_show dword 0         
is_buffer dword 1
fps dword 20000         ;!!!?????fps???????????!!!
dw1m dword 1000000      ;fps/dwlm=?n????????,??????0.02????????(???=50?/s)
;in draw_window
buffer_index dword 0
buffer_cnt dword 0
;check_operation
pacman_dir dword 2
pacman_now_dir dword 2

windowWidth dword 900					; ???????
windowHeight dword 680					; ??????

; h_dc_????
.data?

h_window_main dword ?
h_dc_background dword ?

h_dc_bmp dword ?
h_dc_bmp_size dword ?

h_dc_buffer dword buffer_size dup (?)
h_dc_buffer_size dword buffer_size dup(?)

;h_dc_num dword ?

;h_dc_begin dword ?
;h_dc_begin_mask dword ?

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

;??????????
extern draw_list:draw_struct, draw_list_size:dword
extern game_state:dword
extern need_redraw:dword
extern player_PacMan:player_struct

.code
;??????????

;C???????
printf PROTO C :dword, :vararg
srand PROTO C :dword
rand PROTO C

;pacman_animation.asm
draw_item PROTO :draw_struct,:dword

;pacman_logic.asm
draw_map PROTO   
init_map PROTO

;pacman_drawmap.asm
paintReadyScreen PROTO :dword
paintGameOverScreen PROTO :dword
paintMap PROTO :dword
paintBean PROTO :dword
paintRightPanel PROTO :dword, :dword


create_background proc uses esi edi eax, h_dc:HDC
    local @cnt:dword
    local h_bmp

    ;??¦Δ????????????????υτ??????Device Context??DC??????????????›¥?????????
    ;?????????????????????????§Ή?????????????υτ??????¦Λ???
    ;?????????????????????????????GDI?????????????????????????????
    ;??????????¨®????????????????????????????????????????
    mov @cnt, 0
    mov esi, offset h_dc_buffer
    mov edi, offset h_dc_buffer_size
    .while @cnt != buffer_size
        invoke	CreateCompatibleDC, h_dc
        mov	[esi], eax
        invoke CreateCompatibleBitmap, h_dc, windowWidth, windowHeight
        mov [edi], eax
        invoke	SelectObject,[esi],[edi]
        invoke SetStretchBltMode,[esi],HALFTONE ;HALFTONE ?? Windows GDI??????υτ?????§Φ????¦Λ???????
        add esi, 4
        add edi, 4
        inc @cnt
    .endw

    invoke	CreateCompatibleDC, h_dc    ;??????h_dc?????????υτ??????,????????υτ?????????
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

    ; ???????¦Λ??????????????????????????
    invoke	CreateCompatibleDC, h_dc
	mov	h_dc_bmp, eax
    invoke CreateCompatibleBitmap, h_dc, windowWidth, windowHeight
    mov h_dc_bmp_size, eax
    invoke  SelectObject,h_dc_bmp,h_dc_bmp_size
    invoke  SetStretchBltMode,h_dc_bmp,COLORONCOLOR
    ;????¦Λ????????????????¦Λ?????????????????υτ??????????????????I??
    ;???????????????????¦Λ?????????µµ

    ;?????????????¦Λ????????????????????????????
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

    invoke ReleaseDC,h_window_main,h_dc 
    invoke init_map
    ret 
create_background endp

;???????????????is_show?????1
control_frame_rate proc uses eax edx                             ;??????? is_show ??????????????????????
    local time1:qword,time2:qword,freq:qword             
    mov is_show, 1                                         
    invoke QueryPerformanceFrequency, addr freq         ;?????????????????
    finit
    .while is_buffer == 1
        invoke QueryPerformanceCounter,addr time1       ;???????????????????????????????????
        mov is_show, 1  
        xor eax, eax
        .while eax < fps
            invoke QueryPerformanceCounter,addr time2
            mov eax,dword ptr time1             
            mov edx,dword ptr time1+4
            sub dword ptr time2, eax
            sbb dword ptr time2+4, edx               ;sbb????¦Λ????
            fild time2
            fimul dw1m
            fild freq
            fdiv
            fistp time2 
            mov eax,dword ptr time2                 ;eax = (time1-time2)/freq = time1??time2??????????¦Λ:10^-6??
                                                    ;????????????????????????????
        .endw
    .endw
    ret
control_frame_rate endp

;??????§έ??????
draw_window PROC uses eax 
    local h_dc

    main_loop:
        cmp is_buffer, 0
        jz main_loop_end

        .while buffer_cnt == 0 || (!is_show)    ;??όv??????????
        .endw                                   ;?? is_show ?????? true ????????????????
                                                ;?????????????????υτ?????????? BitBlt ???????????????????????????
                                                ;??????????

        invoke GetDC, h_window_main
        mov	h_dc,eax

        mov eax, buffer_index
        invoke	BitBlt,h_dc,0,0,windowWidth,windowHeight,\  ;??¦Δ?h_dc_buffer??????????????????????h_dc???????????????
            h_dc_buffer[4*eax],0,0,SRCCOPY
        invoke ReleaseDC,h_window_main,h_dc 

        dec buffer_cnt
        inc buffer_index
        .if buffer_index == buffer_size
            mov buffer_index, 0
        .endif

        mov is_show, 0                          ; is_show?0?????????????????????1??????????????????????????????
        jmp main_loop

    main_loop_end:
        ret
draw_window ENDP

create_buffer proc uses ecx esi
    local @cnt
    local @cnt_1

    main_loop:
        cmp is_buffer, 0
        jz main_loop_end

        .while buffer_cnt != 0 ;??????????????????????????????????????
        .endw       

        invoke draw_map

        .if game_state == Game_State_Ready
            mov ecx, buffer_size
            mov @cnt, 0
            .while @cnt < ecx
                push ecx
                mov esi, @cnt
                invoke paintReadyScreen, h_dc_start_up
                invoke BitBlt,h_dc_buffer[4*esi],0,0,windowWidth,windowHeight,h_dc_start_up,0,0,SRCCOPY    
                inc buffer_cnt
                inc @cnt
                pop ecx
            .endw
            jmp main_loop
        .elseif game_state == Game_State_Play
            mov ecx, buffer_size
            mov @cnt, 0
            .while @cnt < ecx
                push ecx
                mov esi, @cnt
                .if need_redraw == 1
                    invoke paintMap, h_dc_map_and_bean
                    invoke paintBean, h_dc_map_and_bean
                    mov need_redraw, 0
                .endif
                invoke paintRightPanel, h_dc_panel, 0
                invoke BitBlt,h_dc_buffer[4*esi],0,0,windowWidth,windowHeight,h_dc_panel,0,0,SRCCOPY
                invoke BitBlt,h_dc_buffer[4*esi],0,0,windowWidth,windowHeight,h_dc_map_and_bean,0,0,SRCPAINT
                mov ecx, draw_list_size
                draw_loop_1:
                    push ecx
                    dec ecx
                    imul ecx, 20
                    invoke draw_item, draw_list[ecx], @cnt
                    pop ecx
                    loop draw_loop_1
                inc buffer_cnt
                inc @cnt
                pop ecx
            .endw
            jmp main_loop
        .elseif game_state == Game_State_Pause
            mov ecx, buffer_size
            mov @cnt, 0
            .while @cnt < ecx
                push ecx
                mov esi, @cnt
                .if need_redraw == 1
                    invoke paintMap, h_dc_map_and_bean
                    invoke paintBean, h_dc_map_and_bean
                    mov need_redraw, 0
                .endif
                invoke paintRightPanel, h_dc_panel, 1
                invoke BitBlt,h_dc_buffer[4*esi],0,0,windowWidth,windowHeight,h_dc_panel,0,0,SRCCOPY
                invoke BitBlt,h_dc_buffer[4*esi],0,0,windowWidth,windowHeight,h_dc_map_and_bean,0,0,SRCCOPY
                mov ecx, draw_list_size
                draw_loop_2:
                    push ecx
                    dec ecx
                    imul ecx, 20
                    invoke draw_item, draw_list[ecx], @cnt
                    pop ecx
                    loop draw_loop_2
                inc buffer_cnt
                inc @cnt
                pop ecx
            .endw
            jmp main_loop
        .elseif game_state == Game_State_Lose
            mov ecx, 
            mov @cnt, 0
            .while @cnt < ecx
                mov esi, @cnt
                invoke paintGameOverScreen, h_dc_game_over
                invoke BitBlt,h_dc_buffer[4*esi],0,0,windowWidth,windowHeight,h_dc_game_over,0,0,SRCCOPY  
                inc buffer_cnt
                inc @cnt
            .endw
            jmp main_loop
        .elseif game_state == Game_State_Win
        ;????¦Δ?????????????—¨??????????????????????????
            mov ecx, 5
            mov @cnt, 0
            .while @cnt < ecx
                mov esi, @cnt
                invoke paintGameOverScreen, h_dc_game_over
                invoke BitBlt,h_dc_buffer[4*esi],0,0,windowWidth,windowHeight,h_dc_game_over,0,0,SRCCOPY  
                inc buffer_cnt
                inc @cnt
            .endw
            jmp main_loop
        .endif
    main_loop_end:
        ret
create_buffer endp

init_window proc
    call create_background                                              ;????????h_dc????¨²??????????????buffer?????buffer??????????gamestate?ready
    invoke CreateThread, NULL, 0, draw_window, NULL, 0, NULL
    invoke CreateThread, NULL, 0, create_buffer, NULL, 0, NULL
    invoke CreateThread, NULL, 0, control_frame_rate, NULL, 0, NULL
    ret
init_window endp

check_operation proc _hWnd: HWND, wParam: WPARAM, lParam: LPARAM; ???????????????????
    .if eax == key_enter ;??????
        .if game_state == Game_State_Ready
        mov game_state, Game_State_Play
        .endif
    .endif
    .if (eax == key_enter) || (eax == key_p) ; ??????
        .if game_state == Game_State_Play
        mov game_state, Game_State_Pause
        .endif
    .endif
    .if eax == key_up || eax == key_down || eax == key_left || eax == key_right ; ??????????????£
        ;1-up 2-right 3-down 4-left
        .if eax == key_up && pacman_now_dir != Dir_Down
            mov player_PacMan.NextDir, Dir_Up
        .elseif eax == key_down &&  player_PacMan.Dir != Dir_Up
            mov player_PacMan.NextDir, Dir_Down
        .elseif eax == key_left &&  player_PacMan.Dir != Dir_Right
            mov player_PacMan.NextDir, Dir_Left
        .elseif eax == key_right &&  player_PacMan.Dir != Dir_Left
            mov player_PacMan.NextDir, Dir_Right
        .endif
    .endif
    ret
check_operation endp

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

window_procedure PROC uses eax ebx edi esi, h_window:HWND, u_msg:UINT, wParam:WPARAM, lParam:LPARAM
    local st_ps:PAINTSTRUCT
    local h_dc

    mov eax, u_msg

    .if eax == WM_CREATE
        push h_window
        pop h_window_main
        invoke init_window
    .elseif eax == WM_KEYDOWN
        invoke check_operation, h_window, wParam, lParam
    .elseif eax == WM_CLOSE
        mov is_buffer, 0
        call close_window
        invoke DestroyWindow, h_window
        invoke PostQuitMessage, NULL
    .else
        invoke DefWindowProc, h_window, u_msg, wParam, lParam
        ret
    .endif
    xor eax, eax
    ret
window_procedure endp

random_str_main_caption proc uses eax ecx edx esi edi
    ; ?????????????
    invoke GetTickCount
    invoke srand, eax

    ; ?????????
    invoke rand

    ; ?????????????????????? [0, 3] ??¦¶??
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

copy_str:                        ;????????????
        mov al, [esi]    
        mov [edi], al     
        inc esi           
        inc edi           
        cmp al, 0         
        jnz copy_str 

    xor eax, eax
    ret
random_str_main_caption endp

main_window proc
    local st_window_class:WNDCLASSEX
    local st_msg:MSG
    local h_instance:HINSTANCE

    invoke	GetModuleHandle,NULL ; ?????????????
    mov	h_instance,eax ; ???????????????›¥?? h_instance ??????

    invoke	RtlZeroMemory,addr st_window_class,sizeof st_window_class ; ?????

    invoke LoadImage, NULL, addr pacman_icon, IMAGE_ICON, 0, 0, LR_LOADFROMFILE or LR_SHARED ; ??????¨®??????
    mov	st_window_class.hIcon,eax
    mov	st_window_class.hIconSm,eax

    invoke LoadCursor, 0, IDC_ARROW ; ?????????
    mov st_window_class.hCursor, eax 

    ; ???????????
    push h_instance 
    pop st_window_class.hInstance
    mov st_window_class.cbSize, sizeof WNDCLASSEX
    mov st_window_class.style, CS_HREDRAW or CS_VREDRAW; ????????????§³?????£??????????????
    mov st_window_class.lpfnWndProc, offset window_procedure
    mov st_window_class.hbrBackground, COLOR_WINDOW+1 ; ????????????COLOR_WINDOW?????????????????GetSysColorBrush???????NULL
    mov st_window_class.lpszClassName, offset str_class_name
    
    ; ???????
    invoke RegisterClassEx, addr st_window_class

    ;??????str_main_caption
    invoke random_str_main_caption

    ; ??????????
    invoke CreateWindowEx, 0, offset str_class_name, offset str_main_caption, WS_CAPTION or WS_SYSMENU or WS_MINIMIZEBOX xor WS_BORDER, 270, 80, windowWidth, windowHeight, NULL, NULL, h_instance, NULL
    mov h_window_main, eax

    ; WS_CAPTION: ??????????§Ò???????????
    ; WS_SYSMENU: ???????????????????????????????§³????????????????
    ; WS_MINIMIZEBOX: ??????????§³????????????????????
    ; WS_BORDER: ????????§Ò???????
    ; ??? xor ????????????? WS_BORDER ?????????????????

    ; 220: ????????????? x ????
    ; 50: ????????????? y ????
    ; 900: ????????????
    ; 680: ???????????

    ; ??????????????
    invoke ShowWindow, h_window_main, SW_SHOWNORMAL
    invoke UpdateWindow, h_window_main

    ; ?????????????????????????????WM_QUIT??
    ;.while TRUE
        ;invoke GetMessage, addr st_msg, NULL, 0, 0
        ;.break .if eax == 0
        ;invoke TranslateMessage, addr st_msg
        ;invoke DispatchMessage, addr st_msg
    ;.endw

    invoke GetMessage, addr st_msg, NULL, 0, 0
    .while eax
        invoke TranslateMessage, addr st_msg
        invoke DispatchMessage, addr st_msg
        invoke GetMessage, addr st_msg, NULL, 0, 0
    .endw

    ret
main_window endp

start:
    call main_window
    invoke ExitProcess, NULL
    ret
end start
