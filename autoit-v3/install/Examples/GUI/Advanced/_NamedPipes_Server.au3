#include <GuiConstantsEx.au3>
#include <NamedPipes.au3>
#include <WinAPI.au3>
#include <WindowsConstants.au3>

; ===============================================================================================================================
; Description ...: This is the server side of the pipe demo
; Author ........: Paul Campbell (PaulIA)
; Notes .........:
; ===============================================================================================================================

; ===============================================================================================================================
; Global constants
; ===============================================================================================================================

Global Const $DEBUGGING = False
Global Const $BUFSIZE = 4096
Global Const $PIPE_NAME = "\\.\\pipe\\AutoIt3"
Global Const $TIMEOUT = 5000
Global Const $WAIT_TIMEOUT = 258
Global Const $ERROR_IO_PENDING = 997
Global Const $ERROR_PIPE_CONNECTED = 535

; ===============================================================================================================================
; Global variables
; ===============================================================================================================================

Global $g_hEvent, $g_idMemo, $g_pOverlap, $g_tOverlap, $g_hPipe, $g_hReadPipe, $g_iState, $g_iToWrite

; ===============================================================================================================================
; Main
; ===============================================================================================================================

CreateGUI()
InitPipe()
MsgLoop()

; ===============================================================================================================================
; Creates a GUI for the server
; ===============================================================================================================================
Func CreateGUI()
	Local $hGUI = GUICreate("Pipe Server", 500, 400, -1, -1, $WS_SIZEBOX)
	$g_idMemo = GUICtrlCreateEdit("", 0, 0, _WinAPI_GetClientWidth($hGUI), _WinAPI_GetClientHeight($hGUI))
	GUICtrlSetFont($g_idMemo, 9, 400, 0, "Courier New")
	GUISetState()
EndFunc   ;==>CreateGUI

; ===============================================================================================================================
; This function creates an instance of a named pipe
; ===============================================================================================================================
Func InitPipe()
	; Create an event object for the instance
	$g_tOverlap = DllStructCreate($tagOVERLAPPED)
	$g_pOverlap = DllStructGetPtr($g_tOverlap)
	$g_hEvent = _WinAPI_CreateEvent()
	If $g_hEvent = 0 Then
		LogError("InitPipe ..........: API_CreateEvent failed")
		Return
	EndIf
	DllStructSetData($g_tOverlap, "hEvent", $g_hEvent)

	; Create a named pipe
	$g_hPipe = _NamedPipes_CreateNamedPipe($PIPE_NAME, _ ; Pipe name
			2, _ ; The pipe is bi-directional
			2, _ ; Overlapped mode is enabled
			0, _ ; No security ACL flags
			1, _ ; Data is written to the pipe as a stream of messages
			1, _ ; Data is read from the pipe as a stream of messages
			0, _ ; Blocking mode is enabled
			1, _ ; Maximum number of instances
			$BUFSIZE, _ ; Output buffer size
			$BUFSIZE, _ ; Input buffer size
			$TIMEOUT, _ ; Client time out
			0) ; Default security attributes
	If $g_hPipe = -1 Then
		LogError("InitPipe ..........: _NamedPipes_CreateNamedPipe failed")
	Else
		; Connect pipe instance to client
		ConnectClient()
	EndIf
EndFunc   ;==>InitPipe

; ===============================================================================================================================
; This function loops waiting for a connection event or the GUI to close
; ===============================================================================================================================
Func MsgLoop()
	Local $iEvent

	Do
		$iEvent = _WinAPI_WaitForSingleObject($g_hEvent, 0)
		If $iEvent < 0 Then
			LogError("MsgLoop ...........: _WinAPI_WaitForSingleObject failed")
			Exit
		EndIf
		If $iEvent = $WAIT_TIMEOUT Then ContinueLoop
		Debug("MsgLoop ...........: Instance signaled")

		Switch $g_iState
			Case 0
				CheckConnect()
			Case 1
				ReadRequest()
			Case 2
				CheckPending()
			Case 3
				RelayOutput()
		EndSwitch
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>MsgLoop

; ===============================================================================================================================
; Checks to see if the pending client connection has finished
; ===============================================================================================================================
Func CheckConnect()
	Local $iBytes

	; Was the operation successful?
	If Not _WinAPI_GetOverlappedResult($g_hPipe, $g_pOverlap, $iBytes, False) Then
		LogError("CheckConnect ......: Connection failed")
		ReconnectClient()
	Else
		LogMsg("CheckConnect ......: Connected")
		$g_iState = 1
	EndIf
EndFunc   ;==>CheckConnect

; ===============================================================================================================================
; This function reads a request message from the client
; ===============================================================================================================================
Func ReadRequest()
	Local $pBuffer, $tBuffer, $iRead, $bSuccess

	$tBuffer = DllStructCreate("char Text[" & $BUFSIZE & "]")
	$pBuffer = DllStructGetPtr($tBuffer)
	$bSuccess = _WinAPI_ReadFile($g_hPipe, $pBuffer, $BUFSIZE, $iRead, $g_pOverlap)

	If $bSuccess And ($iRead <> 0) Then
		; The read operation completed successfully
		Debug("ReadRequest .......: Read success")
	Else
		; Wait for read Buffer to complete
		If Not _WinAPI_GetOverlappedResult($g_hPipe, $g_pOverlap, $iRead, True) Then
			LogError("ReadRequest .......: _WinAPI_GetOverlappedResult failed")
			ReconnectClient()
			Return
		Else
			; Read the command from the pipe
			$bSuccess = _WinAPI_ReadFile($g_hPipe, $pBuffer, $BUFSIZE, $iRead, $g_pOverlap)
			If Not $bSuccess Or ($iRead = 0) Then
				LogError("ReadRequest .......: _WinAPI_ReadFile failed")
				ReconnectClient()
				Return
			EndIf
		EndIf
	EndIf

	; Execute the console command
	If Not ExecuteCmd(DllStructGetData($tBuffer, "Text")) Then
		ReconnectClient()
		Return
	EndIf

	; Relay console output back to the client
	$g_iState = 3
EndFunc   ;==>ReadRequest

; ===============================================================================================================================
; This function relays the console output back to the client
; ===============================================================================================================================
Func CheckPending()
	Local $bSuccess, $iWritten

	$bSuccess = _WinAPI_GetOverlappedResult($g_hPipe, $g_pOverlap, $iWritten, False)
	If Not $bSuccess Or ($iWritten <> $g_iToWrite) Then
		Debug("CheckPending ......: Write reconnecting")
		ReconnectClient()
	Else
		Debug("CheckPending ......: Write complete")
		$g_iState = 3
	EndIf
EndFunc   ;==>CheckPending

; ===============================================================================================================================
; This function relays the console output back to the client
; ===============================================================================================================================
Func RelayOutput()
	Local $pBuffer, $tBuffer, $sLine, $iRead, $bSuccess, $iWritten

	$tBuffer = DllStructCreate("char Text[" & $BUFSIZE & "]")
	$pBuffer = DllStructGetPtr($tBuffer)
	; Read data from console pipe
	_WinAPI_ReadFile($g_hReadPipe, $pBuffer, $BUFSIZE, $iRead)
	If $iRead = 0 Then
		LogMsg("RelayOutput .......: Write done")
		_WinAPI_CloseHandle($g_hReadPipe)
		_WinAPI_FlushFileBuffers($g_hPipe)
		ReconnectClient()
		Return
	EndIf

	; Get the data and strip out the extra carriage returns
	$sLine = StringLeft(DllStructGetData($tBuffer, "Text"), $iRead)
	$sLine = StringReplace($sLine, @CR & @CR, @CR)
	$g_iToWrite = StringLen($sLine)
	DllStructSetData($tBuffer, "Text", $sLine)
	; Relay the data back to the client
	$bSuccess = _WinAPI_WriteFile($g_hPipe, $pBuffer, $g_iToWrite, $iWritten, $g_pOverlap)
	If $bSuccess And ($iWritten = $g_iToWrite) Then
		Debug("RelayOutput .......: Write success")
	Else
		If Not $bSuccess And (_WinAPI_GetLastError() = $ERROR_IO_PENDING) Then
			Debug("RelayOutput .......: Write pending")
			$g_iState = 2
		Else
			; An error occurred, disconnect from the client
			LogError("RelayOutput .......: Write failed")
			ReconnectClient()
		EndIf
	EndIf
EndFunc   ;==>RelayOutput

; ===============================================================================================================================
; This function is called to start an overlapped connection operation
; ===============================================================================================================================
Func ConnectClient()
	$g_iState = 0
	; Start an overlapped connection
	If _NamedPipes_ConnectNamedPipe($g_hPipe, $g_pOverlap) Then
		LogError("ConnectClient .....: ConnectNamedPipe 1 failed")
	Else
		Switch @error
			; The overlapped connection is in progress
			Case $ERROR_IO_PENDING
				Debug("ConnectClient .....: Pending")
				; Client is already connected, so signal an event
			Case $ERROR_PIPE_CONNECTED
				LogMsg("ConnectClient .....: Connected")
				$g_iState = 1
				If Not _WinAPI_SetEvent(DllStructGetData($g_tOverlap, "hEvent")) Then
					LogError("ConnectClient .....: SetEvent failed")
				EndIf
				; Error occurred during the connection event
			Case Else
				LogError("ConnectClient .....: ConnectNamedPipe 2 failed")
		EndSwitch
	EndIf
EndFunc   ;==>ConnectClient

; ===============================================================================================================================
; Dumps debug information to the screen
; ===============================================================================================================================
Func Debug($sMessage)
	If $DEBUGGING Then LogMsg($sMessage)
EndFunc   ;==>Debug

; ===============================================================================================================================
; Executes a command and returns the results
; ===============================================================================================================================
Func ExecuteCmd($sCmd)
	Local $tProcess, $tSecurity, $tStartup, $hWritePipe

	; Set up security attributes
	$tSecurity = DllStructCreate($tagSECURITY_ATTRIBUTES)
	DllStructSetData($tSecurity, "Length", DllStructGetSize($tSecurity))
	DllStructSetData($tSecurity, "InheritHandle", True)

	; Create a pipe for the child process's STDOUT
	If Not _NamedPipes_CreatePipe($g_hReadPipe, $hWritePipe, $tSecurity) Then
		LogError("ExecuteCmd ........: _NamedPipes_CreatePipe failed")
		Return False
	EndIf

	; Create child process
	$tProcess = DllStructCreate($tagPROCESS_INFORMATION)
	$tStartup = DllStructCreate($tagSTARTUPINFO)
	DllStructSetData($tStartup, "Size", DllStructGetSize($tStartup))
	DllStructSetData($tStartup, "Flags", BitOR($STARTF_USESTDHANDLES, $STARTF_USESHOWWINDOW))
	DllStructSetData($tStartup, "StdOutput", $hWritePipe)
	DllStructSetData($tStartup, "StdError", $hWritePipe)
	If Not _WinAPI_CreateProcess("", $sCmd, 0, 0, True, 0, 0, "", DllStructGetPtr($tStartup), DllStructGetPtr($tProcess)) Then
		LogError("ExecuteCmd ........: _WinAPI_CreateProcess failed")
		_WinAPI_CloseHandle($g_hReadPipe)
		_WinAPI_CloseHandle($hWritePipe)
		Return False
	EndIf
	_WinAPI_CloseHandle(DllStructGetData($tProcess, "hProcess"))
	_WinAPI_CloseHandle(DllStructGetData($tProcess, "hThread"))

	; Close the write end of the pipe so that we can read from the read end
	_WinAPI_CloseHandle($hWritePipe)

	LogMsg("ExecuteCommand ....: " & $sCmd)
	Return True
EndFunc   ;==>ExecuteCmd

; ===============================================================================================================================
; Logs an error message to the display
; ===============================================================================================================================
Func LogError($sMessage)
	$sMessage &= " (" & _WinAPI_GetLastErrorMessage() & ")"
	ConsoleWrite($sMessage & @LF)
EndFunc   ;==>LogError

; ===============================================================================================================================
; Logs a message to the display
; ===============================================================================================================================
Func LogMsg($sMessage)
	GUICtrlSetData($g_idMemo, $sMessage & @CRLF, 1)
EndFunc   ;==>LogMsg

; ===============================================================================================================================
; This function is called when an error occurs or when the client closes its handle to the pipe
; ===============================================================================================================================
Func ReconnectClient()
	; Disconnect the pipe instance
	If Not _NamedPipes_DisconnectNamedPipe($g_hPipe) Then
		LogError("ReconnectClient ...: DisonnectNamedPipe failed")
		Return
	EndIf

	; Connect to a new client
	ConnectClient()
EndFunc   ;==>ReconnectClient
