#include <AutoItConstants.au3>
#include <MsgBoxConstants.au3>


Local $vTestQAWinExe=$CmdLine[1]
Run($vTestQAWinExe)
Local $hWnd = WinWaitActive("QA Tests")

Sleep(5)
MouseClick($MOUSE_CLICK_LEFT, 90, 75, 1)
MouseClick($MOUSE_CLICK_LEFT, 100, 115, 1)
Sleep(5)