#include <GuiButton.au3>
#include <GUIConstantsEx.au3>
#include <GuiImageList.au3>
#include <WindowsConstants.au3>

Global $g_idMemo

Example()

Func Example()
	GUICreate("Button Get/Set ImageList (v" & @AutoItVersion & ")", 510, 400)
	$g_idMemo = GUICtrlCreateEdit("", 119, 10, 376, 374, $WS_VSCROLL)
	GUICtrlSetFont($g_idMemo, 9, 400, 0, "Courier New")
	GUISetState(@SW_SHOW)

	Local $hImage = _GUIImageList_Create(32, 32, 5, 3, 6)
	For $x = 6 To 11
		_GUIImageList_AddIcon($hImage, "shell32.dll", $x, True)
	Next

	Local $a_idBtn[6]
	$a_idBtn[0] = GUICtrlCreateButton("Button1", 10, 10, 90, 50)
	_GUICtrlButton_SetImageList($a_idBtn[0], $hImage)

	Local $y = 70, $iIcon = 125
	For $x = 1 To 5
		$a_idBtn[$x] = GUICtrlCreateButton("Button" & $x + 1, 10, $y, 90, 50)
		_GUICtrlButton_SetImageList($a_idBtn[$x], _GetImageListHandle("shell32.dll", $iIcon + $x, True), $x)
		$y += 60
	Next

	Local $aImageListInfo
	For $x = 0 To 5
		$aImageListInfo = _GUICtrlButton_GetImageList($a_idBtn[$x])
		MemoWrite("Button" & $x + 1 & " Imagelist Info" & @CRLF & "--------------------------------")
		MemoWrite("Image list handle........: " & $aImageListInfo[0])
		MemoWrite("Left margin of the icon..: " & $aImageListInfo[1])
		MemoWrite("Top margin of the icon...: " & $aImageListInfo[2])
		MemoWrite("Right margin of the icon.: " & $aImageListInfo[3])
		MemoWrite("Bottom margin of the icon: " & $aImageListInfo[4])
		MemoWrite("Alignment: " & _ExplainAlignment($aImageListInfo[5]))
		MemoWrite("--------------------------------" & @CRLF)
	Next

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				ExitLoop
		EndSwitch
	WEnd

	Exit
EndFunc   ;==>Example

; Write a line to the memo control
Func MemoWrite($sMessage)
	GUICtrlSetData($g_idMemo, $sMessage & @CRLF, 1)
EndFunc   ;==>MemoWrite

; using image list to set 1 image and have text on button
Func _GetImageListHandle($sFile, $nIconID = 0, $bLarge = False)
	Local $iSize = 16
	If $bLarge Then $iSize = 32

	Local $hImage = _GUIImageList_Create($iSize, $iSize, 5, 3)
	If StringUpper(StringMid($sFile, StringLen($sFile) - 2)) = "BMP" Then
		_GUIImageList_AddBitmap($hImage, $sFile)
	Else
		_GUIImageList_AddIcon($hImage, $sFile, $nIconID, $bLarge)
	EndIf
	Return $hImage
EndFunc   ;==>_GetImageListHandle

Func _ExplainAlignment($iAlign)
	Switch $iAlign
		Case 0
			Return "Image aligned with the left margin."
		Case 1
			Return "Image aligned with the right margin."
		Case 2
			Return "Image aligned with the top margin."
		Case 3
			Return "Image aligned with the bottom margin."
		Case 4
			Return "Image centered."
	EndSwitch
EndFunc   ;==>_ExplainAlignment
