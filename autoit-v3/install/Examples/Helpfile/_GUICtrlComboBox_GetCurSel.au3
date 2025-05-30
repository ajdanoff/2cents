#include <GuiComboBox.au3>
#include <GUIConstantsEx.au3>
#include <MsgBoxConstants.au3>

Example()

Func Example()
	; Create GUI
	GUICreate("ComboBox Get/Set Cur Sel (v" & @AutoItVersion & ")", 400, 296)
	Local $idCombo = GUICtrlCreateCombo("", 2, 2, 396, 296)
	GUISetState(@SW_SHOW)

	; Add files
	_GUICtrlComboBox_BeginUpdate($idCombo)
	_GUICtrlComboBox_AddDir($idCombo, @WindowsDir & "\*.exe")
	_GUICtrlComboBox_EndUpdate($idCombo)

	; Select Item
	_GUICtrlComboBox_SetCurSel($idCombo, 2)

	; Get Cur Sel
	MsgBox($MB_SYSTEMMODAL, "Information", "Cur Sel: " & _GUICtrlComboBox_GetCurSel($idCombo))

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
