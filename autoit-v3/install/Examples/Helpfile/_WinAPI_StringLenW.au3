#include <MsgBoxConstants.au3>
#include <WinAPIMisc.au3>

_Example()

Func _Example()
	; Make the string buffer. It's "wchar" type structure. Choosing the size of 64 characters.
	Local $tStringBuffer = DllStructCreate("wchar Data[64]")
	; Fill it with some data
	DllStructSetData($tStringBuffer, "Data", "Gongoozle")

	MsgBox($MB_SYSTEMMODAL, "_WinAPI_StringLenW", "Length of a string inside the buffer is " & _WinAPI_StringLenW($tStringBuffer) & " characters.")
EndFunc   ;==>_Example
