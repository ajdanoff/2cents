#include <GUIConstantsEx.au3>
#include <GuiTreeView.au3>
#include <MsgBoxConstants.au3>
#include <WindowsConstants.au3>

Example()

Func Example()
	GUICreate("TreeView Get Selection (v" & @AutoItVersion & ")", 400, 300)

	Local $iStyle = BitOR($TVS_EDITLABELS, $TVS_HASBUTTONS, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_DISABLEDRAGDROP, $TVS_SHOWSELALWAYS, $TVS_CHECKBOXES)
	Local $idTreeView = GUICtrlCreateTreeView(2, 2, 396, 268, $iStyle, $WS_EX_CLIENTEDGE)
	GUISetState(@SW_SHOW)

	_GUICtrlTreeView_BeginUpdate($idTreeView)
	Local $aidItem[10]
	For $x = 0 To 9
		$aidItem[$x] = GUICtrlCreateTreeViewItem(StringFormat("[%02d] New Item", $x), $idTreeView)
		For $y = 1 To Random(2, 10, 1)
			GUICtrlCreateTreeViewItem(StringFormat("[%02d] New Child", $y), $aidItem[$x])
		Next
	Next
	_GUICtrlTreeView_EndUpdate($idTreeView)

	Local $iRand = Random(0, 9, 1)
	_GUICtrlTreeView_SelectItem($idTreeView, $aidItem[$iRand])
	MsgBox($MB_SYSTEMMODAL, "Information", "Selection? " & _GUICtrlTreeView_GetSelection($idTreeView))

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
