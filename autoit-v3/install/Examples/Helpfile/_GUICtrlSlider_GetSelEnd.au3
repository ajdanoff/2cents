#include <GUIConstantsEx.au3>
#include <GuiSlider.au3>
#include <MsgBoxConstants.au3>

Example()

Func Example()
	; Create GUI
	GUICreate("Slider Get/Set Sel End (v" & @AutoItVersion & ")", 400, 296)
	Local $idSlider = GUICtrlCreateSlider(2, 2, 396, 20, BitOR($TBS_TOOLTIPS, $TBS_AUTOTICKS, $TBS_ENABLESELRANGE))
	GUISetState(@SW_SHOW)

	; Set Sel End
	_GUICtrlSlider_SetSelEnd($idSlider, 50)

	; Get Sel End
	MsgBox($MB_SYSTEMMODAL, "Information", "Sel End: " & _GUICtrlSlider_GetSelEnd($idSlider))

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
