#include <GUIConstantsEx.au3>
#include <GuiListView.au3>
#include <MsgBoxConstants.au3>

Example()

Func Example()
	GUICreate("ListView Justify  (v" & @AutoItVersion & ")", 400, 300)
	Local $idListview = GUICtrlCreateListView("", 2, 2, 394, 268)
	GUISetState(@SW_SHOW)

	; Set ANSI format
;~     _GUICtrlListView_SetUnicodeFormat($idListview, False)

	; Add columns
	_GUICtrlListView_AddColumn($idListview, "Column 1", 100)
	_GUICtrlListView_AddColumn($idListview, "Column 2", 100)
	_GUICtrlListView_AddColumn($idListview, "Column 3", 100)

	; Change column
	Local $aInfo = _GUICtrlListView_GetColumn($idListview, 0)
	MsgBox($MB_SYSTEMMODAL, "Information", "Column 1 Justification: " & $aInfo[0])
	_GUICtrlListView_JustifyColumn($idListview, 0, 2)
	$aInfo = _GUICtrlListView_GetColumn($idListview, 0)
	MsgBox($MB_SYSTEMMODAL, "Information", "Column 1 Justification: " & $aInfo[0])

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
