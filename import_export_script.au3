#include <AutoItConstants.au3>
#include <MsgBoxConstants.au3>
#include <import_script.au3>

Local $vTestQAWinExe=$CmdLine[1]
Local $vActEmail=$CmdLine[2]

; export to csv
Sleep(5)
$i = 0
While $i <= 2
    MouseClick($MOUSE_CLICK_LEFT, 180, 75, 1)
    MouseClick($MOUSE_CLICK_LEFT, 210, 95, 1)
    $i = $i + 1
    Sleep(1)
WEnd
Sleep(5)

; export to json
Sleep(5)
$i = 0
While $i <= 2
    MouseClick($MOUSE_CLICK_LEFT, 180, 75, 1)
    MouseClick($MOUSE_CLICK_LEFT, 200, 115, 1)
    $i = $i + 1
    Sleep(1)
WEnd
Sleep(5)

$exp2JSON = WinWaitActive("Export_to_JSON")
WinClose("QA Tests")