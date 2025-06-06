#include <GDIPlus.au3>
#include <GuiConstantsEx.au3>
#include <ScreenCapture.au3>
#include <WinAPI.au3>

; ===============================================================================================================================
; Description ...: Shows how to magnify an image
; Author ........: Paul Campbell (PaulIA)
; Notes .........:
; ===============================================================================================================================

_Example()
Exit

Func _Example()
	; Capture top left corner of the screen
	Local $hBMP = _ScreenCapture_Capture("", 0, 0, 400, 300)

	; Create a GUI for the original image
	Local $hGUI1 = GUICreate("Original", 400, 300, 0, 0)
	GUISetState()

	; Create a GUI for the zoomed image
	Local $hGUI2 = GUICreate("Zoomed", 400, 300, 0, 400)
	GUISetState()

	; Initialize GDI+ library and load image
	_GDIPlus_Startup()
	Local $hBitmap = _GDIPlus_BitmapCreateFromHBITMAP($hBMP)

	; Draw original image
	Local $hGraphic1 = _GDIPlus_GraphicsCreateFromHWND($hGUI1)
	_GDIPlus_GraphicsDrawImage($hGraphic1, $hBitmap, 0, 0)

	; Draw 2x zoomed image
	Local $hGraphic2 = _GDIPlus_GraphicsCreateFromHWND($hGUI2)
	_GDIPlus_GraphicsDrawImageRectRect($hGraphic2, $hBitmap, 0, 0, 200, 200, 0, 0, 400, 300)

	; Release resources
	_GDIPlus_GraphicsDispose($hGraphic1)
	_GDIPlus_GraphicsDispose($hGraphic2)
	_GDIPlus_ImageDispose($hBitmap)
	_WinAPI_DeleteObject($hBMP)
	_GDIPlus_Shutdown()

	; Loop until user exits
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
EndFunc   ;==>_Example
