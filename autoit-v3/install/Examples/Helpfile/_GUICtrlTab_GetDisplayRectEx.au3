#include <GUIConstantsEx.au3>
#include <GuiTab.au3>
#include <MsgBoxConstants.au3>

Example()

Func Example()
	; Create GUI
	GUICreate("Tab Control Get Display RectEx (v" & @AutoItVersion & ")", 400, 300)
	Local $idTab = GUICtrlCreateTab(2, 2, 396, 296)
	GUISetState(@SW_SHOW)

	; Add tabs
	_GUICtrlTab_InsertItem($idTab, 0, "Tab 1")
	_GUICtrlTab_InsertItem($idTab, 1, "Tab 2")
	_GUICtrlTab_InsertItem($idTab, 2, "Tab 3")

	; Get display rectangle
	Local $tRECT = _GUICtrlTab_GetDisplayRectEx(GUICtrlGetHandle($idTab))
	Local $sRect = StringFormat("[%d, %d, %d, %d]", DllStructGetData($tRECT, "Left"), _
			DllStructGetData($tRECT, "Top"), _
			DllStructGetData($tRECT, "Right"), _
			DllStructGetData($tRECT, "Bottom"))
	MsgBox($MB_SYSTEMMODAL, "Information", "Display rectangle: " & $sRect)

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	GUIDelete()
EndFunc   ;==>Example
