#include <GUIConstantsEx.au3>
#include <GuiListBox.au3>
#include <MsgBoxConstants.au3>

Example()

Func Example()
	; Create GUI
	GUICreate("List Box Get/Set Sel (v" & @AutoItVersion & ")", 400, 296)
	Local $idListBox = GUICtrlCreateList("", 2, 2, 396, 296, BitOR($LBS_STANDARD, $LBS_EXTENDEDSEL))
	GUISetState(@SW_SHOW)

	; Add strings
	_GUICtrlListBox_BeginUpdate($idListBox)
	For $iI = 0 To 9
		_GUICtrlListBox_AddString($idListBox, StringFormat("%03d : string", $iI))
	Next
	_GUICtrlListBox_EndUpdate($idListBox)

	; Select a few items
	_GUICtrlListBox_SetSel($idListBox, 3)
	_GUICtrlListBox_SetSel($idListBox, 4)
	_GUICtrlListBox_SetSel($idListBox, 5)

	; Show the item selection state
	MsgBox($MB_SYSTEMMODAL, "Information", "Item 4 Selected: " & _GUICtrlListBox_GetSel($idListBox, 4))

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
