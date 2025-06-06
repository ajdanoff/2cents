#include <GUIConstantsEx.au3>
#include <GuiImageList.au3>
#include <GuiListView.au3>
#include <MsgBoxConstants.au3>

Example()

Func Example()
	GUICreate("ListView Get/Set Image List (v" & @AutoItVersion & ")", 400, 300)
	Local $idListview = GUICtrlCreateListView("", 2, 2, 394, 268)
	GUISetState(@SW_SHOW)

	; Load images
	Local $hImage = _GUIImageList_Create()
	_GUIImageList_Add($hImage, _GUICtrlListView_CreateSolidBitMap($idListview, 0xFF0000, 16, 16))
	_GUIImageList_Add($hImage, _GUICtrlListView_CreateSolidBitMap($idListview, 0x00FF00, 16, 16))
	_GUIImageList_Add($hImage, _GUICtrlListView_CreateSolidBitMap($idListview, 0x0000FF, 16, 16))
	Local $hPrevImageList = _GUICtrlListView_SetImageList($idListview, $hImage, 1)

	MsgBox($MB_SYSTEMMODAL, "Information", "Previous Image List Handle: 0x" & Hex($hPrevImageList) & @CRLF & _
			"IsPtr = " & IsPtr($hPrevImageList) & " IsHWnd = " & IsHWnd($hPrevImageList))

	; Add columns
	_GUICtrlListView_AddColumn($idListview, "Column 0", 100)
	_GUICtrlListView_AddColumn($idListview, "Column 1", 100)
	_GUICtrlListView_AddColumn($idListview, "Column 2", 100)

	; Add items
	_GUICtrlListView_AddItem($idListview, "Item 0", 0)
	_GUICtrlListView_AddItem($idListview, "Item 1", 1)
	_GUICtrlListView_AddItem($idListview, "Item 2", 2)

	; Get image list handle
	MsgBox($MB_SYSTEMMODAL, "Information", "Image List Handle: 0x" & Hex(_GUICtrlListView_GetImageList($idListview, 1)))

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
