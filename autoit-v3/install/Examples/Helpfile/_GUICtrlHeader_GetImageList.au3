#include <GUIConstantsEx.au3>
#include <GuiHeader.au3>
#include <GuiImageList.au3>
#include <WinAPIGdi.au3>

Global $g_idMemo

Example()

Func Example()
	; Create GUI
	Local $hGUI = GUICreate("Header Get/Set ImageList (v" & @AutoItVersion & ")", 400, 300)
	Local $hHeader = _GUICtrlHeader_Create($hGUI)
	_GUICtrlHeader_SetUnicodeFormat($hHeader, True)
	$g_idMemo = GUICtrlCreateEdit("", 2, 24, 396, 274, 0)
	GUICtrlSetFont($g_idMemo, 9, 400, 0, "Courier New")
	GUISetState(@SW_SHOW)

	; Create an image list with images
	Local $hImage = _GUIImageList_Create(11, 11)
	_GUIImageList_Add($hImage, _WinAPI_CreateSolidBitmap($hGUI, 0xFF0000, 11, 11))
	_GUIImageList_Add($hImage, _WinAPI_CreateSolidBitmap($hGUI, 0x00FF00, 11, 11))
	_GUIImageList_Add($hImage, _WinAPI_CreateSolidBitmap($hGUI, 0x0000FF, 11, 11))
	Local $hPrevImageList = _GUICtrlHeader_SetImageList($hHeader, $hImage)

	MemoWrite("Previous Image list handle ....: " & "0x" & Hex($hPrevImageList))
	MemoWrite("IsPtr = " & IsPtr($hPrevImageList) & " IsHWnd = " & IsHWnd($hPrevImageList))

	; Add columns
	_GUICtrlHeader_AddItem($hHeader, "Column 0", 100, 0, 0)
	_GUICtrlHeader_AddItem($hHeader, "Column 1", 100, 0, 1)
	_GUICtrlHeader_AddItem($hHeader, "Column 2", 100, 0, 2)
	_GUICtrlHeader_AddItem($hHeader, "Column 3", 100)

	; Show header information
	MemoWrite("Image list handle ....: " & "0x" & Hex(_GUICtrlHeader_GetImageList($hHeader)))
	MemoWrite("IsPtr = " & IsPtr(_GUICtrlHeader_GetImageList($hHeader)) & " IsHWnd = " & IsHWnd(_GUICtrlHeader_GetImageList($hHeader)))

	; Loop until the user exits.
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>Example

; Write a line to the memo control
Func MemoWrite($sMessage)
	GUICtrlSetData($g_idMemo, $sMessage & @CRLF, 1)
EndFunc   ;==>MemoWrite
