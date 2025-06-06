#include <GUIConstantsEx.au3>
#include <GuiImageList.au3>
#include <GuiListView.au3>
#include <MsgBoxConstants.au3>

Example_UDF_Created()

Func Example_UDF_Created()
	Local $hGUI = GUICreate("(UDF Created) ListView Get/Set CallBack Mask (v" & @AutoItVersion & ")", 400, 300)

	Local $hListView = _GUICtrlListView_Create($hGUI, "", 2, 2, 394, 268)
	GUISetState(@SW_SHOW)

	_GUICtrlListView_SetCallBackMask($hListView, 32)
	MsgBox($MB_SYSTEMMODAL, "Information", "CallBackMask: " & _GUICtrlListView_GetCallbackMask($hListView))

	; Load images
	Local $hImage = _GUIImageList_Create()
	_GUIImageList_Add($hImage, _GUICtrlListView_CreateSolidBitMap($hListView, 0xFF0000, 16, 16))
	_GUIImageList_Add($hImage, _GUICtrlListView_CreateSolidBitMap($hListView, 0x00FF00, 16, 16))
	_GUIImageList_Add($hImage, _GUICtrlListView_CreateSolidBitMap($hListView, 0x0000FF, 16, 16))
	_GUIImageList_Add($hImage, _GUICtrlListView_CreateSolidBitMap($hListView, 0xC0C0C0, 16, 16))
	_GUIImageList_Add($hImage, _GUICtrlListView_CreateSolidBitMap($hListView, 0xFF00FF, 16, 16))
	_GUIImageList_Add($hImage, _GUICtrlListView_CreateSolidBitMap($hListView, 0xFFFF00, 16, 16))
	_GUICtrlListView_SetImageList($hListView, $hImage, 1)
	_GUICtrlListView_SetImageList($hListView, $hImage, 2)

	; Add columns
	_GUICtrlListView_AddColumn($hListView, "Column 0", 100)
	_GUICtrlListView_AddColumn($hListView, "Column 1", 100)
	_GUICtrlListView_AddColumn($hListView, "Column 2", 100)

	; Add items with callback for item text
	_GUICtrlListView_AddItem($hListView, "Item 0", 0)
	_GUICtrlListView_AddItem($hListView, "Item 1", 1)
	_GUICtrlListView_AddItem($hListView, "Item 2", 2)

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example_UDF_Created
