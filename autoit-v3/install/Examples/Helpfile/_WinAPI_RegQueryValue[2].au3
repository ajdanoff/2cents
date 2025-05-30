; == Example 2 Running in X64 Mode (should be run under Full SciTE4AutoIt)

#AutoIt3Wrapper_UseX64=Y

#include <APIRegConstants.au3>
#include <Debug.au3>
#include <WinAPIError.au3>
#include <WinAPIReg.au3>

_DebugSetup(Default, True)

Example()

Func Example()
	Local $hKey = _WinAPI_RegOpenKey($HKEY_LOCAL_MACHINE, 'SOFTWARE\AutoIt v3\AutoIt', BitOR($KEY_QUERY_VALUE, $KEY_WOW64_32KEY))
	If @error Then
		_DebugReport("! RegOpenKey @error =" & @error & @TAB & _WinAPI_GetErrorMessage(@extended) & @CRLF)
		Exit
	EndIf

	Local $tData = DllStructCreate('wchar[260]')
	_WinAPI_RegQueryValue($hKey, 'InstallDir', $tData)
	_WinAPI_RegCloseKey($hKey)

	_DebugReport(DllStructGetData($tData, 1) & @CRLF)

EndFunc   ;==>Example
