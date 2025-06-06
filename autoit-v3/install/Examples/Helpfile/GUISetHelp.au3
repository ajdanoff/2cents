#include <GUIConstantsEx.au3>

Example()

Func Example()
	; X64 running support
	Local $sWow64 = ""
	If @AutoItX64 Then $sWow64 = "\Wow6432Node"

	Local $hGUI = GUICreate("Example")

	Local $sAutoItInstallDir = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE" & $sWow64 & "\AutoIt v3\AutoIt", "InstallDir")
	If Not @error Then
		GUISetHelp('hh.exe "' & $sAutoItInstallDir & '\AutoIt.chm"')
	EndIf

	; Display the GUI.
	GUISetState(@SW_SHOW, $hGUI)

	; Loop until the user exits.
	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				ExitLoop

		EndSwitch
	WEnd

	GUIDelete()
EndFunc   ;==>Example
