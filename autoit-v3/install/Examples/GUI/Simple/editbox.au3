; ====================================================
; ================= Example of a GUI =================
; ====================================================
; AutoIt version: 3.0.103
; Language:       English
; Author:         "SlimShady"
;
; ----------------------------------------------------------------------------
; Script Start
; ----------------------------------------------------------------------------

#include <GUIConstantsEx.au3>

_Main()
Exit

Func _Main()
	; Initialize variables
	Local $iGUIWidth = 300, $iGUIHeight = 250
	Local $idEdit_1, $idButton_Ok, $idButton_Cancel, $iMsg

	#forceref $idEdit_1

	; Create window
	GUICreate("New GUI", $iGUIWidth, $iGUIHeight)

	; Create an edit box with no text in it
	$idEdit_1 = GUICtrlCreateEdit("", 10, 10, 280, 190)

	; Create an "OK" button
	$idButton_Ok = GUICtrlCreateButton("OK", 75, 210, 70, 25)

	; Create a "CANCEL" button
	$idButton_Cancel = GUICtrlCreateButton("Cancel", 165, 210, 70, 25)

	; Show window/Make the window visible
	GUISetState(@SW_SHOW)

	; Loop until:
	; - user presses Esc
	; - user presses Alt+F4
	; - user clicks the close button
	While 1
		; After every loop check if the user clicked something in the GUI window
		$iMsg = GUIGetMsg()

		Select

			; Check if user clicked on the close button
			Case $iMsg = $GUI_EVENT_CLOSE
				; Destroy the GUI including the controls
				GUIDelete()
				; Exit the script
				Exit

				; Check if user clicked on the "OK" button
			Case $iMsg = $idButton_Ok
				MsgBox(64, "New GUI", "You clicked on the OK button!")

				; Check if user clicked on the "CANCEL" button
			Case $iMsg = $idButton_Cancel
				MsgBox(64, "New GUI", "You clicked on the Cancel button!")

		EndSelect

	WEnd
EndFunc   ;==>_Main
