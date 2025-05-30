#include <Constants.au3>

;
; AutoIt Version: 3.0
; Language:       English
; Platform:       Win9x/NT
; Author:         Jonathan Bennett (jon at autoitscript dot com)
; Modified:       mLipok
;
; Script Function:
;   Demo of using functions
;

_Example()
MsgBox($MB_SYSTEMMODAL, "AutoIt Example", "Finished!")
Exit
; Finished!

Func _Example()
	; Prompt the user to run the script - use a Yes/No prompt with the flag parameter set at 4 (see the help file for more details)
	Local $iAnswer = MsgBox(BitOR($MB_YESNO, $MB_SYSTEMMODAL), "AutoIt Example", "This script will call a couple of example functions.  Do you want to run it?")

	; Check the user's answer to the prompt (see the help file for MsgBox return values)
	; If "No" was clicked ($IDNO = 7) then exit the example function
	If $iAnswer = $IDNO Then
		MsgBox($MB_SYSTEMMODAL, "AutoIt", "OK.  Bye!")
		Return
	EndIf

	; Run TestFunc1
	TestFunc1()

	; Run TestFunc2
	TestFunc2(20)
EndFunc   ;==>_Example

; TestFunc1
Func TestFunc1()
	MsgBox($MB_SYSTEMMODAL, "AutoIt Example", "Inside TestFunc1()")
EndFunc   ;==>TestFunc1

; TestFunc2
Func TestFunc2($vVar)
	MsgBox($MB_SYSTEMMODAL, "AutoIt Example", "Inside TestFunc2() - $vVar is: " & $vVar)
EndFunc   ;==>TestFunc2
