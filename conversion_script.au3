#include <AutoItConstants.au3>
#include <MsgBoxConstants.au3>
#include <activation_script.au3>

Local $vTestQAWinExe=$CmdLine[1]
Local $vActEmail=$CmdLine[2]
Local $vED807File=$CmdLine[3]

Sleep(5)
MouseClick($MOUSE_CLICK_LEFT, 90, 75, 1)
MouseClick($MOUSE_CLICK_LEFT, 200, 95, 1)
$hFC = WinWaitActive("Please select ED807 file")
Send($vED807File)
Send("{ENTER}")
Sleep(5)
Local $hBox = WinWaitActive("ConvertXMLED807toPacketEPD")
Send("{ENTER}")
WinClose("QA Tests")