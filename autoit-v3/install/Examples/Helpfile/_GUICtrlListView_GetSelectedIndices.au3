#include <GUIConstantsEx.au3>
#include <GuiListView.au3>
#include <MsgBoxConstants.au3>

Example()

Func Example()
	Local $idListview

	GUICreate("ListView Get Selected Indices", 400, 300)
	$idListview = GUICtrlCreateListView("", 2, 2, 394, 268, BitOR($LVS_SHOWSELALWAYS, $LVS_REPORT))
	GUISetState(@SW_SHOW)

	; Add columns
	_GUICtrlListView_AddColumn($idListview, "Column 1", 100)

	; Add items
	_GUICtrlListView_AddItem($idListview, "Item 0")
	_GUICtrlListView_AddItem($idListview, "Item 1")
	_GUICtrlListView_AddItem($idListview, "Item 2")

	; Select multiple items
	_GUICtrlListView_SetItemSelected($idListview, 0)
	_GUICtrlListView_SetItemSelected($idListview, 2)
	MsgBox($MB_SYSTEMMODAL, "Information", "Selected Indices: " & _GUICtrlListView_GetSelectedIndices($idListview))

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
