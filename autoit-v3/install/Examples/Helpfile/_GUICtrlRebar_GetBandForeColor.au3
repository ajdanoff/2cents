#include <GUIConstantsEx.au3>
#include <GuiReBar.au3>
#include <GuiToolbar.au3>
#include <WinAPIConstants.au3>
#include <WindowsConstants.au3>

Global $g_idMemo

Example()

Func Example()
	Local $hGui = GUICreate("Rebar Get/Set Band Color (v" & @AutoItVersion & ")", 400, 396, -1, -1, BitOR($WS_MINIMIZEBOX, $WS_CAPTION, $WS_POPUP, $WS_SYSMENU, $WS_MAXIMIZEBOX))

	; create the rebar control
	Local $hReBar = _GUICtrlRebar_Create($hGui, BitOR($CCS_TOP, $WS_BORDER, $RBS_VARHEIGHT, $RBS_AUTOSIZE, $RBS_BANDBORDERS))

	$g_idMemo = GUICtrlCreateEdit("", 2, 30, 396, 320, $WS_VSCROLL)
	GUICtrlSetFont($g_idMemo, 10, 400, 0, "Courier New")

	; create a toolbar to put in the rebar
	Local $hToolbar = _GUICtrlToolbar_Create($hGui, BitOR($TBSTYLE_FLAT, $CCS_NORESIZE, $CCS_NOPARENTALIGN))

	; Add standard system bitmaps
	Switch _GUICtrlToolbar_GetBitmapFlags($hToolbar)
		Case 0
			_GUICtrlToolbar_AddBitmap($hToolbar, 1, -1, $IDB_STD_SMALL_COLOR)
		Case 2
			_GUICtrlToolbar_AddBitmap($hToolbar, 1, -1, $IDB_STD_LARGE_COLOR)
	EndSwitch

	; Add buttons
	Local Enum $e_idNew = 1000, $e_idOpen, $e_idSave, $idHelp
	_GUICtrlToolbar_AddButton($hToolbar, $e_idNew, $STD_FILENEW)
	_GUICtrlToolbar_AddButton($hToolbar, $e_idOpen, $STD_FILEOPEN)
	_GUICtrlToolbar_AddButton($hToolbar, $e_idSave, $STD_FILESAVE)
	_GUICtrlToolbar_AddButtonSep($hToolbar)
	_GUICtrlToolbar_AddButton($hToolbar, $idHelp, $STD_HELP)

	; create a input box to put in the rebar
	Local $idInput = GUICtrlCreateInput("Input control", 0, 0, 120, 20)

	;add band containing the control
	_GUICtrlRebar_AddBand($hReBar, GUICtrlGetHandle($idInput), 120, 200, "Name:")

	; add band containing the control to the beginning of rebar
	_GUICtrlRebar_AddToolBarBand($hReBar, $hToolbar, "", 0)

	_GUICtrlRebar_SetBandBackColor($hReBar, 1, Int(0x00008B))
	_GUICtrlRebar_SetBandForeColor($hReBar, 1, Int(0xFFFFFF))

	For $x = 0 To _GUICtrlRebar_GetBandCount($hReBar) - 1
		MemoWrite("======================")
		MemoWrite("Band Index " & $x)
		MemoWrite("======================")
		MemoWrite("Back Color: " & _GUICtrlRebar_GetBandBackColor($hReBar, $x))
		MemoWrite("Fore Color: " & _GUICtrlRebar_GetBandForeColor($hReBar, $x))
	Next

	Local $idBtnExit = GUICtrlCreateButton("Exit", 150, 360, 100, 25)
	GUICtrlSetState($idBtnExit, $GUI_DEFBUTTON)
	GUICtrlSetState($idBtnExit, $GUI_FOCUS)

	GUISetState(@SW_SHOW)

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $idBtnExit
				Exit
		EndSwitch
	WEnd
EndFunc   ;==>Example

; Write message to memo
Func MemoWrite($sMessage = "")
	GUICtrlSetData($g_idMemo, $sMessage & @CRLF, 1)
EndFunc   ;==>MemoWrite
