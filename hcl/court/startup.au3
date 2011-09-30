; Press Esc to terminate script, Pause/Break to "pause"


;;This is the UDP Server
;;Start this first

; Start The UDP Services
;==============================================
UDPStartup()

; Register the cleanup function.
OnAutoItExitRegister("Cleanup")

; Bind to a SOCKET
;==============================================
$socket = UDPBind("0.0.0.0", 4504)
If @error <> 0 Then 
	MsgBox(4096,"","UDP error");
	Exit
EndIf

Run("C:\exhibit\player\player.exe");
Run("C:\exhibit\courtTV_cs5\courtTV_cs5.exe");

While 1
    $data = UDPRecv($socket, 50)
    If $data <> "" Then
        MsgBox(0, "UDP DATA", $data, 1)
    EndIf
    sleep(100)
WEnd

Func Cleanup()
    UDPCloseSocket($socket)
    UDPShutdown()
EndFunc





Global $Paused
;;HotKeySet("!p", "TogglePause")
;;HotKeySet("+!x", "Terminate")  ;Shift-Alt-x

;;;; Body of program would go here ;;;;




;;;;;;;;

Func TogglePause()
    $Paused = NOT $Paused
    if $Paused Then
		 ToolTip('Mode Switch"',0,0);
		 hideAll();
		 Gtek();
        sleep(1000);
	else
		ToolTip('Mode Interrupt"',0,0);
		showAll();
		$PID = ProcessExists("IlluminateTracker.exe");
		if $PID Then ProcessClose($PID);
		sleep(1000);
	EndIf
	ToolTip('');
EndFunc

Func Terminate()
	MsgBox(4096,"","Exiting.");
	$PID = ProcessExists("IlluminateTracker.exe");
		if $PID Then ProcessClose($PID);
	$PID = ProcessExists("player.exe");
		if $PID Then ProcessClose($PID);
	$PID = ProcessExists("courtTV_cs5.exe");
		if $PID Then ProcessClose($PID);
Exit 0
	
EndFunc
Func Gtek()
	ToolTip("Opening GestureTek",0,0);
    RunWait("C:\GestureTek\Illuminate\Tracker\IlluminateTracker.exe");
	showAll();
EndFunc
Func hideAll()
	WinSetState("Player","",@SW_HIDE);
	WinSetState("courtTV_cs5","",@SW_HIDE);
EndFunc

Func showAll()
	
	$Paused = NOT $Paused;
	WinSetState("Player","",@SW_SHOW);
	WinSetState("courtTV_cs5","",@SW_SHOW);
EndFunc

Func ShowMessage()
    MsgBox(4096,"","This is a message.")
EndFunc

