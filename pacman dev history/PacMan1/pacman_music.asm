.386
.model flat, stdcall
option casemap: none

includelib msvcrt.lib
includelib winmm.lib

; ********************************** 函数导出 ***********************************
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

; ********************************** 类型定义 ************************************
LPCTSTR typedef ptr word
UINT typedef dword
LPTSTR typedef ptr word
HANDLE typedef dword


; ********************************** 函数声明 *************************************
; MCIERROR mciSendString(
;   LPCTSTR lpszCommand, // 命令字符串
;   LPTSTR lpszReturnString, // 接受返回信息的字符串
;   UINT cchReturn, // 返回字符串的大小      
;   HANDLE hwndCallback // 回调窗口句柄
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
; 定义音乐文件
music_die sbyte '.\music\die.mp3', 0
music_eatghost sbyte '.\music\eatghost.mp3', 0
music_powerpill sbyte '.\music\powerpill.mp3', 0
music_theme sbyte '.\music\theme.mp3', 0
music_wake sbyte '.\music\wake.mp3', 0


.code
playMusic proc, _musicName: ptr sbyte, _isRepeat: dword
; playMusic: 播放音乐
; 参数: _musicName, 音频文件路径名; _isRepeat, 是否循环播放，0表示不循环播放，否则表示循环播放
; 返回值: eax, 播放音乐的id，从0开始
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
; closeMusic: 关闭音乐
; 参数: _musicIndex, 音乐的id
; 返回值: 无
    invoke sprintf, offset command, offset closeCommand, _musicIndex
    invoke mciSendStringA, offset command, 0, 0, 0
    ret
closeMusic endp

pauseMusic proc, _musicIndex: dword
; pauseMusic: 暂停音乐播放
; 参数: _musicIndex, 音乐的id
; 返回值: 无
    invoke sprintf, offset command, offset pauseCommand, _musicIndex
    invoke mciSendStringA, offset command, 0, 0, 0
    ret
pauseMusic endp

resumeMusic proc, _musicIndex: dword
; resumeMusic: 继续音乐播放
; 参数: _musicIndex, 音乐的id
; 返回值: 无
    invoke sprintf, offset command, offset resumeCommand, _musicIndex
    invoke mciSendStringA, offset command, 0, 0, 0
    ret
resumeMusic endp

setAudioMusic proc, _musicIndex: dword, _audio: dword
; setAudioMusic: 调整音乐音量
; 参数: _musicIndex, 音乐的id; _audio, 音量0~1000
; 返回值: 无
    invoke sprintf, offset command, offset setAudioCommand, _musicIndex, _audio
    invoke mciSendStringA, offset command, 0, 0, 0
    ret
setAudioMusic endp

pauseAllMusic proc uses ecx
; pauseAllMusic: 暂停所有音乐
; 参数: 无
; 返回值: 无
    mov ecx, musicCounter
    dec ecx
    test ecx, ecx
    je fin
L1:
    push ecx
    invoke pauseMusic, ecx ; 该函数会修改ecx
    pop ecx
    loop L1

fin:
    invoke pauseMusic, 0
    ret
pauseAllMusic endp

resumeAllMusic proc uses ecx
; resumeAllMusic: 继续所有音乐
; 参数: 无
; 返回值: 无
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
; setAudioAllMusic: 调整所有音乐音量
; 参数:  _audio, 音量0~1000
; 返回值: 无
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

; 必须关闭所有音乐文件后才能退出程序
closeAllMusic proc uses ecx
; closeAllMusic: 关闭所有音乐
; 参数: 无
; 返回值: 无
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

; 播放die音乐
playDieMusic proc
    invoke playMusic, offset music_die, 0
    ret
playDieMusic endp

; 播放eatghost音乐
playEatghostMusic proc
    invoke playMusic, offset music_eatghost, 0
    ret
playEatghostMusic endp

; 播放powerpill音乐
playPowerpillMusic proc
    invoke playMusic, offset music_powerpill, 0
    ret
playPowerpillMusic endp

; 播放theme音乐
playThemeMusic proc
    invoke playMusic, offset music_theme, 1
    ret
playThemeMusic endp

; 播放wake音乐
playWakeMusic proc
    invoke playMusic, offset music_wake, 1
    ret
playWakeMusic endp


end