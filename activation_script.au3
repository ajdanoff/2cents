#include <AutoItConstants.au3>
#include <MsgBoxConstants.au3>


Local $vTestQAWinExe=$CmdLine[1]
Local $vActEmail=$CmdLine[2]
Run($vTestQAWinExe)
Local $hWnd = WinWaitActive("QA Tests")
Activate($vActEmail)
Func Activate($vActEmail)
    MouseClick($MOUSE_CLICK_LEFT, 215, 78, 1)
    MouseClick($MOUSE_CLICK_LEFT, 284, 100, 1)
    Local $hActForm = WinWaitActive("О программе")
    Sleep(5)
    Local $i = 0
    While $i <= 2
        MouseClick($MOUSE_CLICK_LEFT, 80, 200, 1)
        Send($vActEmail)
        $i = $i + 1
    WEnd
    Sleep(5)
    MouseClick($MOUSE_CLICK_LEFT, 379, 248, 1)
EndFunc

