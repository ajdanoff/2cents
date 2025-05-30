#include <GUIConstantsEx.au3>
#include <GuiListView.au3>
#include <MsgBoxConstants.au3>
#include <WindowsConstants.au3>

Example()

Func Example()
	GUICreate("ListView Get Item Rectangle Ex (v" & @AutoItVersion & ")", 400, 300)
	Local $idListview = GUICtrlCreateListView("", 2, 2, 394, 268)
	GUISetState(@SW_SHOW)

	; Set ANSI format
;~     _GUICtrlListView_SetUnicodeFormat($idListview, False)

	; Add columns
	_GUICtrlListView_AddColumn($idListview, "Items", 100)

	; Add items
	_GUICtrlListView_AddItem($idListview, "Item 1")
	_GUICtrlListView_AddItem($idListview, "Item 2")
	_GUICtrlListView_AddItem($idListview, "Item 3")

	; Get item 2 rectangle
	Local $tRECT = _GUICtrlListView_GetItemRectEx($idListview, 1)
	MsgBox($MB_SYSTEMMODAL, "Information", StringFormat("Item 2 Rectangle : [%d, %d, %d, %d]", DllStructGetData($tRECT, "Left"), _
			DllStructGetData($tRECT, "Top"), DllStructGetData($tRECT, "Right"), DllStructGetData($tRECT, "Bottom")))

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
