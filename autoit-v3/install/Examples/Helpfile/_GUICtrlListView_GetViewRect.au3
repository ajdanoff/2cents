#include <GUIConstantsEx.au3>
#include <GuiListView.au3>
#include <MsgBoxConstants.au3>

Example()

Func Example()
	GUICreate("ListView Get View Rect (v" & @AutoItVersion & ")", 400, 300)
	Local $idListview = GUICtrlCreateListView("", 2, 2, 394, 268)
	GUISetState(@SW_SHOW)

	; Set ANSI format
;~     _GUICtrlListView_SetUnicodeFormat($idListview, False)

	; Add columns
	_GUICtrlListView_AddColumn($idListview, "Items", 100)

	; Add items
	_GUICtrlListView_BeginUpdate($idListview)
	For $iI = 1 To 10
		_GUICtrlListView_AddItem($idListview, "Item " & $iI)
	Next
	_GUICtrlListView_EndUpdate($idListview)

	; Set view
	_GUICtrlListView_SetView($idListview, 3)

	; Get view rectangle
	Local $aRect = _GUICtrlListView_GetViewRect($idListview)
	MsgBox($MB_SYSTEMMODAL, "Information", StringFormat("View Tile: [%d, %d, %d, %d]", $aRect[0], $aRect[1], $aRect[2], $aRect[3]))

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
