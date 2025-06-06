#include <SQLite.au3>
#include <SQLite.dll.au3>

Local $hQuery
_SQLite_Startup()
ConsoleWrite("_SQLite_LibVersion=" & _SQLite_LibVersion() & @CRLF)
_SQLite_Open()

; Without $sCallback it's a resultless statement
_SQLite_Exec(-1, "Create table tblTest (a,b int,c single not null);" & _
		"Insert into tblTest values ('1',2,3);" & _
		"Insert into tblTest values (Null,5,6);")

Local $d = _SQLite_Exec(-1, "Select rowid,* From tblTest", "_cb") ; _cb will be called for each row

_SQLite_Close()
_SQLite_Shutdown()

; Output:
;rowid	a	b	c
; 1		1	2	3
; 2			5	6

Func _cb($aResult)
	For $s In $aResult
		ConsoleWrite($s & @TAB)
	Next
	ConsoleWrite(@CRLF)
	; Return $SQLITE_ABORT ; Would Abort the process and trigger an @error in _SQLite_Exec()
EndFunc   ;==>_cb
