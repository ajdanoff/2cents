#AutoIt3Wrapper_UseX64=Y
#include <GUIConstantsEx.au3>
#include <GuiImageList.au3>
#include <GuiListView.au3>
#include <GuiTreeView.au3>
#include <MsgBoxConstants.au3>
#include <WindowsConstants.au3>

Global $g_hImage, $g_hStateImage

Example()

Func Example()
	GUICreate("TreeView Get/Set Text (v" & @AutoItVersion & ")", 400, 300)

	Local $iStyle = BitOR($TVS_EDITLABELS, $TVS_HASBUTTONS, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_DISABLEDRAGDROP, $TVS_SHOWSELALWAYS, $TVS_CHECKBOXES)
	Local $idTreeView = GUICtrlCreateTreeView(2, 2, 396, 268, $iStyle, $WS_EX_CLIENTEDGE)
	GUISetState(@SW_SHOW)

	; Set ANSI format
;~     _GUICtrlListView_SetUnicodeFormat($idListview, False)

	_CreateNormalImageList()
	_GUICtrlTreeView_SetNormalImageList($idTreeView, $g_hImage)

	_CreateStateImageList()
	_GUICtrlTreeView_SetStateImageList($idTreeView, $g_hStateImage)

	_GUICtrlTreeView_BeginUpdate($idTreeView)
	Local $ahItem[10], $aidChildItem[30], $iYItem = 0
	For $x = 0 To 9
		$ahItem[$x] = _GUICtrlTreeView_Add($idTreeView, 0, StringFormat("[%02d] New Item", $x), 4, 5)
		_GUICtrlTreeView_SetStateImageIndex($idTreeView, $ahItem[$x], 1)
		For $y = 1 To 3
			$aidChildItem[$iYItem] = _GUICtrlTreeView_AddChild($idTreeView, $ahItem[$x], StringFormat("[%02d] New Child", $y), 0, 3)
			_GUICtrlTreeView_SetStateImageIndex($idTreeView, $aidChildItem[$iYItem], 1)
			$iYItem += 1
		Next
	Next
	_GUICtrlTreeView_EndUpdate($idTreeView)

	_GUICtrlTreeView_SelectItem($idTreeView, $ahItem[0])
	_GUICtrlTreeView_SetStateImageIndex($idTreeView, $ahItem[0], 2)

	Local $iRand = 6 ; Random(0, 9, 1)
	_GUICtrlTreeView_SetText($idTreeView, $ahItem[$iRand], "This text has been Set")
	MsgBox($MB_SYSTEMMODAL, "Information", StringFormat("Text for Item %d: %s", $iRand, _GUICtrlTreeView_GetText($idTreeView, $ahItem[$iRand])))
	_GUICtrlTreeView_SelectItem($idTreeView, $ahItem[$iRand])

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example

Func _CreateNormalImageList()
	$g_hImage = _GUIImageList_Create(16, 16, 5, 3)
	_GUIImageList_AddIcon($g_hImage, "shell32.dll", 110)
	_GUIImageList_AddIcon($g_hImage, "shell32.dll", 131)
	_GUIImageList_AddIcon($g_hImage, "shell32.dll", 165)
	_GUIImageList_AddIcon($g_hImage, "shell32.dll", 168)
	_GUIImageList_AddIcon($g_hImage, "shell32.dll", 137)
	_GUIImageList_AddIcon($g_hImage, "shell32.dll", 146)
EndFunc   ;==>_CreateNormalImageList

Func _CreateStateImageList()
	$g_hStateImage = _GUIImageList_Create(16, 16, 5, 3)
	_GUIImageList_AddIcon($g_hStateImage, "shell32.dll", 3)
	_GUIImageList_AddIcon($g_hStateImage, "shell32.dll", 4)
EndFunc   ;==>_CreateStateImageList
