#include <GUIConstantsEx.au3>
#include <GuiListView.au3>
#include <MsgBoxConstants.au3>

Example()

Func Example()
	GUICreate("ListView Get/Set Unicode Format (v" & @AutoItVersion & ")", 400, 300)
	Local $idListview = GUICtrlCreateListView("", 2, 2, 394, 268)
	GUISetState(@SW_SHOW)

	; Add columns
	_GUICtrlListView_AddColumn($idListview, "Items", 100)

	; Set Unicode format
	_GUICtrlListView_SetUnicodeFormat($idListview, False)
	MsgBox($MB_SYSTEMMODAL, "Information", "Unicode: " & _GUICtrlListView_GetUnicodeFormat($idListview))
	_GUICtrlListView_SetUnicodeFormat($idListview, True)
	MsgBox($MB_SYSTEMMODAL, "Information", "Unicode: " & _GUICtrlListView_GetUnicodeFormat($idListview))

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
