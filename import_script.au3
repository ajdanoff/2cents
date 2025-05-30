#include <AutoItConstants.au3>
#include <MsgBoxConstants.au3>
#include <activation_script.au3>

Local $vTestQAWinExe=$CmdLine[1]
Local $vActEmail=$CmdLine[2]

; import PacketEPD
Sleep(5)
Local $i = 0
While $i <= 2
    MouseClick($MOUSE_CLICK_LEFT, 138, 78, 1)
    MouseClick($MOUSE_CLICK_LEFT, 165, 98, 1)
    $i = $i + 1
WEnd
Sleep(5)

; Local $sTxt = WinGetText("QA Tests")
; ConsoleWrite($sTxt & @CRLF)
