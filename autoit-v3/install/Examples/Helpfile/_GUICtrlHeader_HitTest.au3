#include <GUIConstantsEx.au3>
#include <GuiHeader.au3>

Global $g_idMemo

Example()

Func Example()
	; Create GUI
	Local $hGUI = GUICreate("Header Hit Test (v" & @AutoItVersion & ")", 400, 300)
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

	; Do a hit test on column 2
	Local $aHT = _GUICtrlHeader_HitTest($hHeader, 110, 10)
	MemoWrite("Item index ...................: " & $aHT[0])
	MemoWrite("In client window .............: " & $aHT[1])
	MemoWrite("In control rectangle .........: " & $aHT[2])
	MemoWrite("On divider ...................: " & $aHT[3])
	MemoWrite("On zero width divider ........: " & $aHT[4])
	MemoWrite("Over filter area .............: " & $aHT[5])
	MemoWrite("Over filter button ...........: " & $aHT[6])
	MemoWrite("Above bounding rectangle .....: " & $aHT[7])
	MemoWrite("Below bounding rectangle .....: " & $aHT[8])
	MemoWrite("To right of bounding rectangle: " & $aHT[9])
	MemoWrite("To left of bounding rectangle : " & $aHT[10])

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>Example

; Write a line to the memo control
Func MemoWrite($sMessage)
	GUICtrlSetData($g_idMemo, $sMessage & @CRLF, 1)
EndFunc   ;==>MemoWrite
