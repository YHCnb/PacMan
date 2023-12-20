.386
.model flat, stdcall
option casemap: none

includelib msvcrt.lib
includelib winmm.lib

; ********************************** �������� ***********************************
public playMusic
public closeMusic
public pauseMusic
public resumeMusic
public setAudioMusic
public pauseAllMusic
public resumeAllMusic
public setAudioAllMusic
public closeAllMusic
public playDieMusic
public playEatghostMusic
public playPowerpillMusic
public playThemeMusic
public playWakeMusic

; ********************************** ���Ͷ��� ************************************
LPCTSTR typedef ptr word
UINT typedef dword
LPTSTR typedef ptr word
HANDLE typedef dword


; ********************************** �������� *************************************
; MCIERROR mciSendString(
;   LPCTSTR lpszCommand, // �����ַ���
;   LPTSTR lpszReturnString, // ���ܷ�����Ϣ���ַ���
;   UINT cchReturn, // �����ַ����Ĵ�С      
;   HANDLE hwndCallback // �ص����ھ��
; );
mciSendStringA proto stdcall lpszCommand: LPCTSTR, lpszReturnString: LPTSTR, cchReturn: UINT, hwndCallback: HANDLE

sprintf proto C s: ptr sbyte, format: ptr sbyte, params: vararg


.data
musicCounter dword 0
command sbyte 100 dup(0)
openCommand sbyte 'open %s alias music%d', 0
closeCommand sbyte 'close music%d', 0
playCommand sbyte 'play music%d', 0
playRepeatCommand sbyte 'play music%d repeat', 0
pauseCommand sbyte 'pause music%d', 0
resumeCommand sbyte 'resume music%d', 0
setAudioCommand sbyte 'setaudio music%d volume to %d', 0
; ���������ļ�
music_die sbyte '.\music\die.mp3', 0
music_eatghost sbyte '.\music\eatghost.mp3', 0
music_powerpill sbyte '.\music\powerpill.mp3', 0
music_theme sbyte '.\music\theme.mp3', 0
music_wake sbyte '.\music\wake.mp3', 0


.code
playMusic proc, _musicName: ptr sbyte, _isRepeat: dword
; playMusic: ��������
; ����: _musicName, ��Ƶ�ļ�·����; _isRepeat, �Ƿ�ѭ�����ţ�0��ʾ��ѭ�����ţ������ʾѭ������
; ����ֵ: eax, �������ֵ�id����0��ʼ
    invoke sprintf, offset command, offset openCommand, _musicName, musicCounter
    invoke mciSendStringA, offset command, 0, 0, 0

    cmp _isRepeat, 0
    jne repeatPlay
    invoke sprintf, offset command, offset playCommand, musicCounter
    invoke mciSendStringA, offset command, 0, 0, 0
    jmp fin

repeatPlay:
    invoke sprintf, offset command, offset playRepeatCommand, musicCounter
    invoke mciSendStringA, offset command, 0, 0, 0

fin:
    mov eax, musicCounter
    inc dword ptr musicCounter
    ret
playMusic endp

closeMusic proc, _musicIndex: dword
; closeMusic: �ر�����
; ����: _musicIndex, ���ֵ�id
; ����ֵ: ��
    invoke sprintf, offset command, offset closeCommand, _musicIndex
    invoke mciSendStringA, offset command, 0, 0, 0
    ret
closeMusic endp

pauseMusic proc, _musicIndex: dword
; pauseMusic: ��ͣ���ֲ���
; ����: _musicIndex, ���ֵ�id
; ����ֵ: ��
    invoke sprintf, offset command, offset pauseCommand, _musicIndex
    invoke mciSendStringA, offset command, 0, 0, 0
    ret
pauseMusic endp

resumeMusic proc, _musicIndex: dword
; resumeMusic: �������ֲ���
; ����: _musicIndex, ���ֵ�id
; ����ֵ: ��
    invoke sprintf, offset command, offset resumeCommand, _musicIndex
    invoke mciSendStringA, offset command, 0, 0, 0
    ret
resumeMusic endp

setAudioMusic proc, _musicIndex: dword, _audio: dword
; setAudioMusic: ������������
; ����: _musicIndex, ���ֵ�id; _audio, ����0~1000
; ����ֵ: ��
    invoke sprintf, offset command, offset setAudioCommand, _musicIndex, _audio
    invoke mciSendStringA, offset command, 0, 0, 0
    ret
setAudioMusic endp

pauseAllMusic proc uses ecx
; pauseAllMusic: ��ͣ��������
; ����: ��
; ����ֵ: ��
    mov ecx, musicCounter
    dec ecx
    test ecx, ecx
    je fin
L1:
    push ecx
    invoke pauseMusic, ecx ; �ú������޸�ecx
    pop ecx
    loop L1

fin:
    invoke pauseMusic, 0
    ret
pauseAllMusic endp

resumeAllMusic proc uses ecx
; resumeAllMusic: ������������
; ����: ��
; ����ֵ: ��
    mov ecx, musicCounter
    dec ecx
    test ecx, ecx
    je fin

L1:
    push ecx
    invoke resumeMusic, ecx
    pop ecx
    loop L1
    
fin:
    invoke resumeMusic, 0
    ret
resumeAllMusic endp

setAudioAllMusic proc uses ecx, _audio: dword
; setAudioAllMusic: ����������������
; ����:  _audio, ����0~1000
; ����ֵ: ��
    mov ecx, musicCounter
    dec ecx
    test ecx, ecx
    je fin

L1:
    push ecx
    invoke setAudioMusic, ecx, _audio
    pop ecx
    loop L1
    
fin:
    invoke setAudioMusic, 0, _audio
    ret
setAudioAllMusic endp

; ����ر����������ļ�������˳�����
closeAllMusic proc uses ecx
; closeAllMusic: �ر���������
; ����: ��
; ����ֵ: ��
    mov ecx, musicCounter
    dec ecx
    test ecx, ecx
    je fin

L1:
    push ecx
    invoke closeMusic, ecx
    pop ecx
    loop L1
    
fin:
    invoke closeMusic, 0
    ret
closeAllMusic endp

; ����die����
playDieMusic proc
    invoke playMusic, offset music_die, 0
    ret
playDieMusic endp

; ����eatghost����
playEatghostMusic proc
    invoke playMusic, offset music_eatghost, 0
    ret
playEatghostMusic endp

; ����powerpill����
playPowerpillMusic proc
    invoke playMusic, offset music_powerpill, 0
    ret
playPowerpillMusic endp

; ����theme����
playThemeMusic proc
    invoke playMusic, offset music_theme, 0
    ret
playThemeMusic endp

; ����wake����
playWakeMusic proc
    invoke playMusic, offset music_wake, 1
    ret
playWakeMusic endp


end