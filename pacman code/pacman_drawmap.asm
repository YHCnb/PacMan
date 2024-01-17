.386
.model flat, stdcall
option casemap: none

; �����
includelib user32.lib
includelib gdi32.lib
includelib kernel32.lib
includelib msimg32.lib
includelib msvcrt.lib

; �����ļ�
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
includelib  msvcrt.lib
include     winmm.inc
includelib  winmm.lib

.data
; �����ⲿ����
extern draw_list:draw_struct, draw_list_size:dword
extern game_state:dword
extern need_redraw:dword
extern player_PacMan:player_struct
extern player_RedMan:player_struct
extern player_Cindy:player_struct
extern item_map:dword 
extern score:dword
extern game_mode:dword
extern chase_target:dword
extern map_cols:dword                    ; ��ͼ�Ŀ��
extern map_rows:dword                    ; ��ͼ�ĸ߶�
extern mapGridWidth:dword                ; ��ͼ��ÿ�����ӵĿ��
extern superBeanRadius:dword             ; Բ�ζ��İ뾶

.code
mapX dword 10                           ; ��ͼ�ڴ����е�λ��
mapY dword 10

wallWidth dword 2                       ; ǽ�Ŀ��
wallColor dword 00FF9900h               ; ǽ����ɫ��00_B_G_R
wallSpecialColor dword 0000FF00h        ; ����ǽ����ɫ��00_B_G_R

beanHalfWidth dword 3                   ; ���鶹�Ŀ�ȵ�**һ��**
beahColor dword 0000FFFFh               ; ���鶹����ɫ
superBeanColor dword 00FFFFFFh          ; Բ�ζ�����ɫ

.code
; ͼƬ·������
FastBeanPath sbyte './assert/fastbean.bmp', 0
PortalPath sbyte './assert/portal.bmp', 0
InvisibleBeanPath sbyte './assert/invisiblebean.bmp', 0

.code
; ������������
public mapX, mapY

.code
getNum proc uses ebx ecx edx, _i: dword, _j: dword
; ��ȡ��ͼ��(i, j)����Ԫ�أ����Խ���򷵻�Item_Wall
    mov ecx, map_rows
    mov edx, map_cols
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


getBorderType proc uses ebx ecx edx esi, _i: dword, _j: dword, _wallNum
; �жϱ߽�����
; ����ֵ��0��ʾ����ǽ�ı߽�, 1��ʾ�Ǵ�ֱ����, 2��ʾ��ˮƽ����
; 3��ʾ����Բ��, 4��ʾ����Բ����5��ʾ����Բ����6��ʾ����Բ��
    local @iSub1, @iAdd1, @jSub1, @jAdd1, @upLeft, @upRight, @downLeft, @downRight, \
        @up, @down, @left, @right
    mov esi, _wallNum
    ; Ϊ@iSub1, @iAdd1, @jSub1, @jAdd1���и�ֵ
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
    .if eax == _wallNum                        ; ��ǰ���ֵΪ1ʱ�ſ���Ϊ�߽�
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
        ; ��������ܴ���0ʱ���Ǳ߽磬������Ը�Ϊ != 1
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
; ���ߺ���������_type������ֱ�߻�ˮƽ��
    local @startX: dword, @startY: dword, @endX: dword, @endY: dword
    pushad

    ; ��@startX��@endX��ʼ��Ϊ�������Ͻ�
    mov eax, mapGridWidth

    mov edx, mapX
    mov @startX, edx
    mul byte ptr _j
    add @startX, eax
    mov edx, @startX
    mov @endX, edx

    ; ��@startY��@endY��ʼ��Ϊ�������Ͻ�
    mov eax, mapGridWidth

    mov edx, mapY
    mov @startY, edx
    mul byte ptr _i
    add @startY, eax
    mov edx, @startY
    mov @endY, edx

    ; ecx�д��һ��Ŀ�ȣ�eax��Ű��Ŀ��
    mov eax, mapGridWidth
    mov ecx, eax        ; ecx���һ��Ŀ��
    mov dl, 2
    div dl
    and eax, 000000FFh  ; eax��Ű��Ŀ��


    .if _type == Wall_Vertical      ; ��ֱ��
        add @startX, eax
        add @endX, eax
        add @endY, ecx
    .else                           ; ˮƽ��
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
; ��Բ�ǣ�����_type������ͬ���͵�Բ��
; _typeΪ3��ʾ����Բ��, _typeΪ4��ʾ����Բ����_typeΪ5��ʾ����Բ����_typeΪ6��ʾ����Բ��
    local @nLeftRect: dword, @nTopRect: dword, @nRightRect: dword, @nBottomRect: dword, \
        @nXStartArc: dword, @nYStartArc: dword, @nXEndArc: dword, @nYEndArc: dword
    pushad
    ; ��ʼ��@nLeftRect��@nRightRect��@nXStartArc��@nXEndArc��ʼ��Ϊ���Ͻ�
    mov eax, mapGridWidth

    mov edx, mapX
    mov @nLeftRect, edx
    mul byte ptr _j
    add @nLeftRect, eax
    mov edx, @nLeftRect
    mov @nRightRect, edx
    mov @nXStartArc, edx
    mov @nXEndArc, edx

    ; ��ʼ��@nTopRect��@nBottomRect��@nYStartArc��@nYEndArc��ʼ��Ϊ���Ͻ�
    mov eax, mapGridWidth

    mov edx, mapY
    mov @nTopRect, edx
    mul byte ptr _i
    add @nTopRect, eax
    mov edx, @nTopRect
    mov @nBottomRect, edx
    mov @nYStartArc, edx
    mov @nYEndArc, edx

    ; ecx�д��һ��Ŀ�ȣ�eax��Ű��Ŀ��
    mov eax, mapGridWidth
    mov ecx, eax        ; ecx���һ��Ŀ��
    mov dl, 2
    div dl
    and eax, 000000FFh  ; eax��Ű��Ŀ��

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
; ���㣬���_typeΪItem_Bean�򻭾��Σ����_typeΪItem_SuperBean��Բ
    local @nLeftRect: dword, @nTopRect: dword, @nRightRect: dword, @nBottomRect: dword
    local @x, @y, @hOldImage, @hImage, @hCDc, @width
    pushad

    ; ��ʼ��@nLeftRect��@nRightRect��ʼ��Ϊ���Ͻ�
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

    ; ��ʼ��@nTopRect��@nBottomRect��ʼ��Ϊ���Ͻ�
    mov eax, mapGridWidth

    mov edx, mapY
    mov @nTopRect, edx
    mul byte ptr _i
    add @nTopRect, eax
    mov edx, @nTopRect
    mov @nBottomRect, edx
    mov @y, edx

    ; ecx�д��һ��Ŀ�ȣ�eax��Ű��Ŀ��
    mov eax, mapGridWidth
    mov ecx, eax        ; ecx���һ��Ŀ��
    mov dl, 2
    div dl
    and eax, 000000FFh  ; eax��Ű��Ŀ��

    ; ��@nLeftRect��@nRightRect��@nTopRect��@nBottomRect��ʼ��Ϊ����
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

        ; *******************************************************************  ���볣�� **************************************************************
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
        ; *******************************************************************  ���볣�� **************************************************************
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
        ; *******************************************************************  ���볣�� **************************************************************
        invoke TransparentBlt, _hDc, @x, @y, @width, @width, @hCDc, 0, 0, 40, 50, 0

        invoke SelectObject, @hCDc, @hOldImage
        invoke DeleteObject, @hImage
        invoke DeleteDC, @hCDc
    .endif
    popad
    ret
paintPoint endp


paintBean proc, _hDc: HDC
; ������
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

    xor ebx, ebx    ; ���ѭ������i
    .while ebx < map_rows
        xor ecx, ecx    ; �ڲ�ѭ������j
        .while ecx < map_cols
            
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

    xor ebx, ebx    ; ���ѭ������i
    .while ebx < map_rows
        xor ecx, ecx    ; �ڲ�ѭ������j
        .while ecx < map_cols
            
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


paintMap proc, _hDc:HDC
; ����ͼ
    local @hPen: HPEN, @hOldPen
    pushad

    invoke CreatePen, PS_SOLID, wallWidth, wallColor
    mov @hPen, eax

    invoke SelectObject, _hDc, @hPen
    mov @hOldPen, eax
    
    xor ebx, ebx    ; ���ѭ������i
    .while ebx < map_rows
        xor ecx, ecx    ; �ڲ�ѭ������j
        .while ecx < map_cols
            
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
    
    xor ebx, ebx    ; ���ѭ������i
    .while ebx < map_rows
        xor ecx, ecx    ; �ڲ�ѭ������j
        .while ecx < map_cols
            
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

end