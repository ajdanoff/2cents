#include <GUIConstantsEx.au3>
#include <GuiImageList.au3>
#include <GuiListView.au3>
#include <MsgBoxConstants.au3>

Example()

Func Example()
	GUICreate("ListView Get Group Info (v" & @AutoItVersion & ")", 400, 300)

	Local $idListview = GUICtrlCreateListView("", 2, 2, 394, 268)
	GUISetState(@SW_SHOW)

	; Set ANSI format
;~     _GUICtrlListView_SetUnicodeFormat($idListview, False)

	; Load images
	Local $hImage = _GUIImageList_Create()
	_GUIImageList_Add($hImage, _GUICtrlListView_CreateSolidBitMap(GUICtrlGetHandle($idListview), 0xFF0000, 16, 16))
	_GUIImageList_Add($hImage, _GUICtrlListView_CreateSolidBitMap(GUICtrlGetHandle($idListview), 0x00FF00, 16, 16))
	_GUIImageList_Add($hImage, _GUICtrlListView_CreateSolidBitMap(GUICtrlGetHandle($idListview), 0x0000FF, 16, 16))
	_GUICtrlListView_SetImageList($idListview, $hImage, 1)

	; Add columns
	_GUICtrlListView_AddColumn($idListview, "Column 1", 100)
	_GUICtrlListView_AddColumn($idListview, "Column 2", 100)
	_GUICtrlListView_AddColumn($idListview, "Column 3", 100)

	; Add items
	_GUICtrlListView_AddItem($idListview, "Row 1: Col 1", 0)
	_GUICtrlListView_AddSubItem($idListview, 0, "Row 1: Col 2", 1)
	_GUICtrlListView_AddSubItem($idListview, 0, "Row 1: Col 3", 2)
	_GUICtrlListView_AddItem($idListview, "Row 2: Col 1", 1)
	_GUICtrlListView_AddSubItem($idListview, 1, "Row 2: Col 2", 1)
	_GUICtrlListView_AddItem($idListview, "Row 3: Col 1", 2)

	; Build groups
	_GUICtrlListView_EnableGroupView($idListview)
	_GUICtrlListView_InsertGroup($idListview, -1, 1, "Group 1", 1)
	_GUICtrlListView_InsertGroup($idListview, -1, 2, "Group 2")
	_GUICtrlListView_SetItemGroupID($idListview, 0, 1)
	_GUICtrlListView_SetItemGroupID($idListview, 1, 2)
	_GUICtrlListView_SetItemGroupID($idListview, 2, 2)

	; Get rect of Group ID 2
	Local $aInfo = _GUICtrlListView_GetGroupRect($idListview, 2)
	MsgBox($MB_SYSTEMMODAL, "Information", "Rect: " & @CRLF & _
			@TAB & "Left..: " & $aInfo[0] & @CRLF & _
			@TAB & "Top...: " & $aInfo[1] & @CRLF & _
			@TAB & "Right.: " & $aInfo[2] & @CRLF & _
			@TAB & "Bottom: " & $aInfo[3])

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE

	GUIDelete()
EndFunc   ;==>Example
