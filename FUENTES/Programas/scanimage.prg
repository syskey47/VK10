LOCAL lcFile, lnImageHandle, lnReply
lcFile = "c:\testtest_image.bmp"
SET STEP ON 
IF	TWAIN_SelectImageSource(0) = 0
	MESSAGEBOX('No hay dispositivos TWAIN')
ELSE
	* Captura la imágen
	lnImageHandle = TWAIN_AcquireNative(0,0)
	* copia la imagen a un archivo
	lnReply = TWAIN_WriteNativeToFilename(lnImageHandle,lcFile)
	* Libera la memoria del manejador de la imágen
	TWAIN_FreeNative(lnImageHandle)
	* Chequear errores
	IF lnReply = 0
		? MESSAGEBOX('OK')
	  * imagen fue exitosamente grabada
	ELSE
		? MESSAGEBOX('ERROR')
	  * algo no estuvo bien
	ENDIF
ENDIF