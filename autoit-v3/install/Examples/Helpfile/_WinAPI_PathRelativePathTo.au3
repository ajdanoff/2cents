#include <WinAPIShPath.au3>

Local $sPath = _WinAPI_PathRelativePathTo(@ScriptDir, 1, @ScriptDir & "\..", 1)

ConsoleWrite('Relative path: ' & $sPath & @CRLF)

If $sPath Then
	ShellExecute($sPath)
EndIf
