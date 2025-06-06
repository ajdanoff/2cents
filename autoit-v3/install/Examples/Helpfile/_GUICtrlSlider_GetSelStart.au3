#include <GUIConstantsEx.au3>
#include <GuiSlider.au3>
#include <MsgBoxConstants.au3>

Example()

Func Example()
	; Create GUI
	GUICreate("Slider Get/Set Sel Start (v" & @AutoItVersion & ")", 400, 296)
	Local $idSlider = GUICtrlCreateSlider(2, 2, 396, 20, BitOR($TBS_TOOLTIPS, $TBS_AUTOTICKS, $TBS_ENABLESELRANGE))
	GUISetState(@SW_SHOW)

	; Set Sel Start
	_GUICtrlSlider_SetSelStart($idSlider, 10)

	; Get Sel Start
	MsgBox($MB_SYSTEMMODAL, "Information", "Sel Start: " & _GUICtrlSlider_GetSelStart($idSlider))

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
