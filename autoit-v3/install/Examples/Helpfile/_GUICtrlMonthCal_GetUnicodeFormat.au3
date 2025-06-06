#include <GUIConstantsEx.au3>
#include <GuiMonthCal.au3>
#include <WindowsConstants.au3>

Global $g_idMemo

Example()

Func Example()
	; Create GUI
	GUICreate("Month Calendar Get/Set Unicode Format (v" & @AutoItVersion & ")", 440, 300)
	Local $idMonthCal = GUICtrlCreateMonthCal("", 4, 4, -1, -1, $WS_BORDER, 0x00000000)

	; Create memo control
	$g_idMemo = GUICtrlCreateEdit("", 4, 168, 432, 128, 0)
	GUICtrlSetFont($g_idMemo, 9, 400, 0, "Courier New")
	GUISetState(@SW_SHOW)

	; Get/Set Unicode setting
	_GUICtrlMonthCal_SetUnicodeFormat($idMonthCal, False)
	MemoWrite("Unicode: " & _GUICtrlMonthCal_GetUnicodeFormat($idMonthCal))
	_GUICtrlMonthCal_SetUnicodeFormat($idMonthCal, True)
	MemoWrite("Unicode: " & _GUICtrlMonthCal_GetUnicodeFormat($idMonthCal))

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example

; Write message to memo
Func MemoWrite($sMessage)
	GUICtrlSetData($g_idMemo, $sMessage & @CRLF, 1)
EndFunc   ;==>MemoWrite
