#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>

Example()

Func Example()
	; Load an image
	Local $sFile = FileOpenDialog("Select an image", "", "Image (*.jpg;*.png;*.bmp;*.gif;*.tif)")
	If @error Then Exit MsgBox($MB_ICONWARNING, "Waring", "No image was selected! Exiting script...")

	_GDIPlus_Startup()
	Local $hBitmap = _GDIPlus_ImageLoadFromFile($sFile)
	Local $aDim = _GDIPlus_ImageGetDimension($hBitmap)
	Local $hBitmap_Resized = _GDIPlus_ImageResize($hBitmap, $aDim[0] / 6, $aDim[1] / 6) ;resize image

	Local $hGUI = GUICreate("GDI+ test", $aDim[0] / 6, $aDim[1] / 6, -1, -1) ;create a test gui to display the resized image
	GUISetState(@SW_SHOW)

	Local $hGraphics = _GDIPlus_GraphicsCreateFromHWND($hGUI) ;create a graphics object from a window handle
	_GDIPlus_GraphicsDrawImage($hGraphics, $hBitmap_Resized, 0, 0) ;display scaled image

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				ExitLoop
		EndSwitch
	WEnd

	;cleanup resources
	_GDIPlus_GraphicsDispose($hGraphics)
	_GDIPlus_BitmapDispose($hBitmap)
	_GDIPlus_BitmapDispose($hBitmap_Resized)
	_GDIPlus_Shutdown()
	GUIDelete($hGUI)
EndFunc   ;==>Example
