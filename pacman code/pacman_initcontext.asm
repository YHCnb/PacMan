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

.data
; 声明外部变量
extern windowX:dword
extern windowY:dword
extern windowWidth:dword
extern windowHeight:dword

extern h_dc_background:dword
extern h_dc_start_up:dword
extern h_dc_game_over:dword
extern h_dc_map_and_bean:dword
extern h_dc_panel:dword

extern h_dc_bmp:dword
extern h_dc_bmp_size:dword
extern h_dc_buffer:dword
extern h_dc_buffer_size:dword

extern h_dc_pacman1_left:dword
extern h_dc_pacman2_left:dword
extern h_dc_pacman1_down:dword
extern h_dc_pacman2_down:dword
extern h_dc_pacman1_right:dword
extern h_dc_pacman2_right:dword
extern h_dc_pacman1_up:dword
extern h_dc_pacman2_up:dword
extern h_dc_blinky_left:dword
extern h_dc_blinky_down:dword
extern h_dc_blinky_right:dword
extern h_dc_blinky_up:dword
extern h_dc_blinky_left2:dword
extern h_dc_blinky_down2:dword
extern h_dc_blinky_right2:dword
extern h_dc_blinky_up2:dword
extern h_dc_pinky_left:dword
extern h_dc_pinky_down:dword
extern h_dc_pinky_right:dword
extern h_dc_pinky_up:dword
extern h_dc_pinky_left2:dword
extern h_dc_pinky_down2:dword
extern h_dc_pinky_right2:dword
extern h_dc_pinky_up2:dword
extern h_dc_clyde_left:dword
extern h_dc_clyde_down:dword
extern h_dc_clyde_right:dword
extern h_dc_clyde_up:dword
extern h_dc_clyde_left2:dword
extern h_dc_clyde_down2:dword
extern h_dc_clyde_right2:dword
extern h_dc_clyde_up2:dword
extern h_dc_inky_left:dword
extern h_dc_inky_down:dword
extern h_dc_inky_right:dword
extern h_dc_inky_up:dword
extern h_dc_inky_left2:dword
extern h_dc_inky_down2:dword
extern h_dc_inky_right2:dword
extern h_dc_inky_up2:dword
extern h_dc_dazzled_down:dword
extern h_dc_dazzled_left:dword
extern h_dc_dazzled_right:dword
extern h_dc_dazzled_up:dword
extern h_dc_dazzled_down2:dword
extern h_dc_dazzled_left2:dword
extern h_dc_dazzled_right2:dword
extern h_dc_dazzled_up2:dword
extern h_dc_dead_left:dword
extern h_dc_dead_down:dword
extern h_dc_dead_right:dword
extern h_dc_dead_up:dword
extern h_dc_cindy_left:dword
extern h_dc_cindy_down:dword
extern h_dc_cindy_right:dword
extern h_dc_cindy_up:dword
extern h_dc_cindy_left2:dword
extern h_dc_cindy_down2:dword
extern h_dc_cindy_right2:dword
extern h_dc_cindy_up2:dword
extern h_dc_redman1_down:dword
extern h_dc_redman1_left:dword
extern h_dc_redman1_right:dword
extern h_dc_redman1_up:dword
extern h_dc_redman2_down:dword
extern h_dc_redman2_left:dword
extern h_dc_redman2_right:dword
extern h_dc_redman2_up:dword
extern h_dc_redman3:dword

.data
; 定义图片路径
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

redman1_down byte './assert/redman1_down.bmp', 0
redman1_left byte './assert/redman1_left.bmp', 0
redman1_right byte './assert/redman1_right.bmp', 0 
redman1_up byte './assert/redman1_up.bmp', 0
redman2_down byte './assert/redman2_down.bmp', 0
redman2_left byte './assert/redman2_left.bmp', 0
redman2_right byte './assert/redman2_right.bmp', 0
redman2_up byte './assert/redman2_up.bmp', 0
redman3 byte './assert/redman3.bmp', 0

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

cindy_left byte './assert/cindy_left.bmp', 0
cindy_down byte './assert/cindy_down.bmp', 0
cindy_right byte './assert/cindy_right.bmp', 0
cindy_up byte './assert/cindy_up.bmp', 0
cindy_left2 byte './assert/cindy_left2.bmp', 0
cindy_down2 byte './assert/cindy_down2.bmp', 0
cindy_right2 byte './assert/cindy_right2.bmp', 0
cindy_up2 byte './assert/cindy_up2.bmp', 0

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

.code
; 定义外部函数
init_map PROTO

.code
; 创建图形上下文
initialize_graphics_context proc uses esi edi eax, h_dc:HDC
    local @cnt:dword
    local h_bmp
    local screen_width:dword, screen_height:dword

    ; 获取屏幕的宽度和高度
    invoke GetDC, NULL
    mov h_bmp, eax
    invoke GetDeviceCaps, h_bmp, HORZRES
    mov screen_width, eax
    invoke GetDeviceCaps, h_bmp, VERTRES
    mov screen_height, eax

    ; 创建一个设备环境（Device Context，DC）缓冲区，用于存储预渲染的图像 
    mov @cnt, 0
    mov esi, offset h_dc_buffer
    mov edi, offset h_dc_buffer_size
    .while @cnt != buffer_size
        invoke	CreateCompatibleDC, h_dc
        mov	[esi], eax
        invoke CreateCompatibleBitmap, h_dc, screen_width, screen_height
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
    invoke  SelectObject, h_dc_bmp, h_dc_bmp_size
    invoke  SetStretchBltMode, h_dc_bmp, COLORONCOLOR
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

    invoke CreateCompatibleDC, h_dc
    mov h_dc_cindy_left, eax
    invoke CreateCompatibleDC, h_dc
    mov h_dc_cindy_down, eax
    invoke CreateCompatibleDC, h_dc
    mov h_dc_cindy_right, eax
    invoke CreateCompatibleDC, h_dc
    mov h_dc_cindy_up, eax
    invoke CreateCompatibleDC, h_dc
    mov h_dc_cindy_left2, eax
    invoke CreateCompatibleDC, h_dc
    mov h_dc_cindy_down2, eax
    invoke CreateCompatibleDC, h_dc
    mov h_dc_cindy_right2, eax
    invoke CreateCompatibleDC, h_dc
    mov h_dc_cindy_up2, eax

    invoke CreateCompatibleDC, h_dc
    mov h_dc_redman1_down, eax
    invoke CreateCompatibleDC, h_dc
    mov h_dc_redman1_left, eax
    invoke CreateCompatibleDC, h_dc
    mov h_dc_redman1_right, eax
    invoke CreateCompatibleDC, h_dc
    mov h_dc_redman1_up, eax
    invoke CreateCompatibleDC, h_dc
    mov h_dc_redman2_down, eax 
    invoke CreateCompatibleDC, h_dc 
    mov h_dc_redman2_left, eax
    invoke CreateCompatibleDC, h_dc
    mov h_dc_redman2_right, eax
    invoke CreateCompatibleDC, h_dc
    mov h_dc_redman2_up, eax

    invoke CreateCompatibleDC, h_dc
    mov h_dc_redman3, eax

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

    invoke LoadImage, NULL, addr cindy_left, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED 
    mov h_bmp, eax
    invoke SelectObject, h_dc_cindy_left, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr cindy_down, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_cindy_down, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr cindy_right, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_cindy_right, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr cindy_up, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_cindy_up, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr cindy_left2, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_cindy_left2, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr cindy_down2, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_cindy_down2, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr cindy_right2, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_cindy_right2, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr cindy_up2, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_cindy_up2, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr redman1_down, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_redman1_down, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr redman1_left, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_redman1_left, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr redman1_right, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_redman1_right, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr redman1_up, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_redman1_up, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr redman2_down, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_redman2_down, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr redman2_left, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_redman2_left, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr redman2_right, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_redman2_right, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr redman2_up, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_redman2_up, h_bmp
    invoke DeleteObject, h_bmp

    invoke LoadImage, NULL, addr redman3, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE or LR_SHARED
    mov h_bmp, eax
    invoke SelectObject, h_dc_redman3, h_bmp
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
initialize_graphics_context endp

end