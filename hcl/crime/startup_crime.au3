; Press Esc to terminate script, Pause/Break to "pause"

Global $Paused
HotKeySet("!p", "TogglePause")
HotKeySet("+!x", "Terminate")  ;Shift-Alt-x

;;;; Body of program would go here ;;;;
Run("C:\exhibit\Crime_slave1\Crime_slave1.exe");
Run("C:\exhibit\Crime_slave2\Crime_slave2.exe");
Run("C:\exhibit\Crime_Backwall\Crime_Backwall.exe");

While 1
    Sleep(100)
WEnd
;;;;;;;;

Func TogglePause()
    $Paused = NOT $Paused
    if $Paused Then
		 ToolTip('Mode Switch"',0,0);
		 hideAll();
		 Quiz();
        sleep(1000);
	else
		ToolTip('Mode Interrupt"',0,0);
		showAll();
		$PID = ProcessExists("quizMain.exe");
		if $PID Then ProcessClose($PID);
		sleep(1000);
	EndIf
	ToolTip('');
EndFunc

Func Terminate()
	MsgBox(4096,"","Exiting.");
	$PID = ProcessExists("quizMain.exe");
		if $PID Then ProcessClose($PID);
	$PID = ProcessExists("Crime_Backwall.exe");
		if $PID Then ProcessClose($PID);
	$PID = ProcessExists("Crime_slave1.exe");
		if $PID Then ProcessClose($PID);
	$PID = ProcessExists("Crime_slave2.exe");
		if $PID Then ProcessClose($PID);
    Exit 0
	
EndFunc
Func Quiz()
	ToolTip("Opening Quiz",0,0);
    RunWait("C:\exhibit\quizMain\quizMain.exe");
	showAll();
EndFunc
Func hideAll()
	WinSetState("Crime_slave1","",@SW_HIDE);
	WinSetState("Crime_slave2","",@SW_HIDE);
	WinSetState("Crime_Backwall","",@SW_HIDE);
EndFunc
Func showAll()
	
	$Paused = NOT $Paused;
	WinSetState("Crime_slave1","",@SW_SHOW);
	WinSetState("Crime_slave2","",@SW_SHOW);
	WinSetState("Crime_Backwall","",@SW_SHOW);	
EndFunc

Func ShowMessage()
    MsgBox(4096,"","This is a message.")
EndFunc

