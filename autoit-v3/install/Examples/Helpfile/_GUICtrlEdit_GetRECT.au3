#include <GUIConstantsEx.au3>
#include <GuiEdit.au3>
#include <GuiStatusBar.au3>
#include <WindowsConstants.au3>

Example()

Func Example()
	Local $sWow64 = ""
	If @AutoItX64 Then $sWow64 = "\Wow6432Node"
	Local $sFile = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE" & $sWow64 & "\AutoIt v3\AutoIt", "InstallDir") & "\include\_ReadMe_.txt"

	; Create GUI
	Local $hGUI = GUICreate("Edit Get/Set RECT (v" & @AutoItVersion & ")", 400, 300)
	Local $idEdit = GUICtrlCreateEdit("", 2, 2, 394, 268, BitOR($ES_WANTRETURN, $WS_VSCROLL))
	Local $aPartRightSide[6] = [50, 75, 75, 75, 75, -1]
	Local $hStatusBar = _GUICtrlStatusBar_Create($hGUI, $aPartRightSide)
	_GUICtrlStatusBar_SetIcon($hStatusBar, 5, 97, "shell32.dll")
	_GUICtrlStatusBar_SetText($hStatusBar, "Rect")
	GUISetState(@SW_SHOW)

	; Get Rect
	Local $aRect = _GUICtrlEdit_GetRECT($idEdit)
	$aRect[0] += 10
	$aRect[1] += 10
	$aRect[2] -= 10
	$aRect[3] -= 10

	; Set Rect
	_GUICtrlEdit_SetRECT($idEdit, $aRect)

	; Add Text
	_GUICtrlEdit_AppendText($idEdit, FileRead($sFile))
	_GUICtrlEdit_LineScroll($idEdit, 0, _GUICtrlEdit_GetLineCount($idEdit) * -1)

	; Get Rect
	$aRect = _GUICtrlEdit_GetRECT($idEdit)
	_GUICtrlStatusBar_SetText($hStatusBar, "Left: " & $aRect[0], 1)
	_GUICtrlStatusBar_SetText($hStatusBar, "Top: " & $aRect[1], 2)
	_GUICtrlStatusBar_SetText($hStatusBar, "Right: " & $aRect[2], 3)
	_GUICtrlStatusBar_SetText($hStatusBar, "Bottom: " & $aRect[3], 4)

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
