#include <GUIConstantsEx.au3>
#include <GuiListView.au3>
#include <MsgBoxConstants.au3>

Example()

Func Example()
	GUICreate("ListView Find Item (v" & @AutoItVersion & ")", 400, 300)
	Local $idListview = GUICtrlCreateListView("", 2, 2, 394, 268)
	GUISetState(@SW_SHOW)

	; Set ANSI format
;~     _GUICtrlListView_SetUnicodeFormat($idListview, False)

	; Add columns
	_GUICtrlListView_AddColumn($idListview, "Items", 100)

	; Add items
	_GUICtrlListView_BeginUpdate($idListview)
	Local $iI
	For $iI = 1 To 100
		_GUICtrlListView_AddItem($idListview, "Item " & $iI)
	Next
	_GUICtrlListView_EndUpdate($idListview)

	; Set item 50 parameter value
	_GUICtrlListView_SetItemParam($idListview, 49, 1234)

	; Search for target item
	Local $tInfo = DllStructCreate($tagLVFINDINFO)
	DllStructSetData($tInfo, "Flags", $LVFI_PARAM)
	DllStructSetData($tInfo, "Param", 1234)
	$iI = _GUICtrlListView_FindItem($idListview, -1, $tInfo)
	MsgBox($MB_SYSTEMMODAL, "Information", "Target Item Index: " & $iI)
	_GUICtrlListView_EnsureVisible($idListview, $iI)

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
