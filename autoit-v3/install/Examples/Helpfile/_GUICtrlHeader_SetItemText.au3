#include <GUIConstantsEx.au3>
#include <GuiHeader.au3>

Global $g_idMemo

Example()

Func Example()
	; Create GUI
	Local $hGUI = GUICreate("Header Get/Set Item Text (v" & @AutoItVersion & ")", 400, 300)
	Local $hHeader = _GUICtrlHeader_Create($hGUI)
	_GUICtrlHeader_SetUnicodeFormat($hHeader, True)
	$g_idMemo = GUICtrlCreateEdit("", 2, 24, 396, 274, 0)
	GUICtrlSetFont($g_idMemo, 9, 400, 0, "Courier New")
	GUISetState(@SW_SHOW)

	; Add columns
	_GUICtrlHeader_AddItem($hHeader, "Column 0", 100)
	_GUICtrlHeader_AddItem($hHeader, "Column 1", 100)
	_GUICtrlHeader_AddItem($hHeader, "Column 2", 100)
	_GUICtrlHeader_AddItem($hHeader, "Column 3", 100)

	; Set column 1 text
	_GUICtrlHeader_SetItemText($hHeader, 0, "Column X")

	; Show column 1 text
	MemoWrite("Column 0 text: " & _GUICtrlHeader_GetItemText($hHeader, 0))

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>Example

; Write a line to the memo control
Func MemoWrite($sMessage)
	GUICtrlSetData($g_idMemo, $sMessage & @CRLF, 1)
EndFunc   ;==>MemoWrite
