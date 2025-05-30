; == Example 2 direct use with icon file

#include <GUIConstantsEx.au3>
#include <GuiStatusBar.au3>
#include <WindowsConstants.au3>

Global $g_idMemo

Example()

Func Example()
	; Create GUI
	Local $hGUI = GUICreate("StatusBar Get Tip Text (v" & @AutoItVersion & ")", 400, 300)
	Local $hStatus = _GUICtrlStatusBar_Create($hGUI, -1, "", $SBARS_TOOLTIPS)

	; Create memo control
	$g_idMemo = GUICtrlCreateEdit("", 2, 2, 396, 274, $WS_VSCROLL)
	GUICtrlSetFont($g_idMemo, 9, 400, 0, "Courier New")
	GUISetState(@SW_SHOW)

	; Set parts
	Local $aParts[4] = [75, 150, 300, 400]
	_GUICtrlStatusBar_SetParts($hStatus, $aParts)
	_GUICtrlStatusBar_SetText($hStatus, "Force tip to be shown when text is more than fits in the box", 1)

	; Set icon
	_GUICtrlStatusBar_SetIcon($hStatus, 0, 23, "shell32.dll")

	; Set text tips
	_GUICtrlStatusBar_SetTipText($hStatus, 0, "Tip works when only icon in part or text exceeds part")
	_GUICtrlStatusBar_SetTipText($hStatus, 1, "Force tip to be shown when text is more than fits in the box")

	MemoWrite("Hold Mouse Cursor over part to see tip." & @CRLF)

	; Show text tips
	MemoWrite("Text tip 0 .: " & _GUICtrlStatusBar_GetTipText($hStatus, 0) & @CRLF)
	MemoWrite("Text tip 1 .: " & _GUICtrlStatusBar_GetTipText($hStatus, 1))

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example

; Write message to memo
Func MemoWrite($sMessage = "")
	GUICtrlSetData($g_idMemo, $sMessage & @CRLF, 1)
EndFunc   ;==>MemoWrite
