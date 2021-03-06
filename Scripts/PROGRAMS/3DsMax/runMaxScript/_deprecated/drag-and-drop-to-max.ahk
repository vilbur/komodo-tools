#SingleInstance force

/**
 */
killOldDialogs()
{
	GroupAdd, $win_group, ahk_exe 3dsmax.exe ahk_class #32770,,, MAXScript Listener
	
	WinClose, ahk_group $win_group
}

/**
 */
bringMaxWindowsToFront()
{
	GroupAdd, $win_group, ahk_exe 3dsmax.exe
	
	WinSet, AlwaysOnTop, On,  ahk_group $win_group
	WinSet, AlwaysOnTop, Off, ahk_group $win_group
}


/**	Simulate drag & drop of files into window
 *	Works with 3Ds Max 2016 
 *
 *	 https://autohotkey.com/board/topic/109578-simulating-drag-and-drop-file-on-to-program/#post_id_651231
 *
 * @example DropFiles( "ahk_class Notepad", "C:\SomeName.txt" ) 
 *
 */
DropFiles(window, files*)
{
	for k,v in files
	  memRequired+=StrLen(v)+1
	hGlobal := DllCall("GlobalAlloc", "uint", 0x42, "ptr", memRequired+21)
	dropfiles := DllCall("GlobalLock", "ptr", hGlobal)
	NumPut(offset := 20, dropfiles+0, 0, "uint")
	for k,v in files
	  StrPut(v, dropfiles+offset, "utf-8"), offset+=StrLen(v)+1
	DllCall("GlobalUnlock", "ptr", hGlobal)
	PostMessage, 0x233, hGlobal, 0,, %window%
	
	if ErrorLevel
	  DllCall("GlobalFree", "ptr", hGlobal)
}


/** Send filein script to Max mini listener
  *
  * Work with 3Ds Max 2019
  *
 */
sendFileInToMax( $file )
{
	$filein = filein "%$file%"

	ControlSetText,	MXS_Scintilla2, %$filein%, ahk_class Qt5QWindowIcon
	sleep, 100
	ControlFocus 	MXS_Scintilla2, ahk_class Qt5QWindowIcon
	sleep, 100
	;Send,	{NumpadEnter}
	ControlSend, MXS_Scintilla2,	{NumpadEnter}, ahk_class Qt5QWindowIcon
}

/*---------------------------------------
	RUN DropFiles() BY CALL OF THIS FILE
-----------------------------------------
*/
$file	= %1%

;killOldDialogs()
DropFiles("ahk_class 3DSMAX", $file )	; Max 2016
;sendFileInToMax($file)	; Max 2019

;bringMaxWindowsToFront()

