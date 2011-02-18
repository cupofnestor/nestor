﻿package com.nestor.sxc.imap{	import flash.events.Event;	import flash.events.TimerEvent;	import flash.events.IOErrorEvent;	import flash.events.SecurityErrorEvent;	import flash.events.DatagramSocketDataEvent;	import flash.utils.Timer;	import flash.errors.IOError;		import flash.events.EventDispatcher;	import flash.events.MouseEvent;	import flash.display.MovieClip;	import flash.net.DatagramSocket;	import flash.utils.ByteArray;	public class UDPController extends MovieClip {		public var copTop:Number=100;		public var copTime:Number=1000;		public var stopTop:Number=100;		public var stopTime:Number=2000;				public var msg:String;		private var udpHost:String;		private var udpSendPort:int;		private var udpRecPort:int;		public var speedLimit:Number = 10;		private var lastW:Array = new Array();		private var avgI:Number = 4;		private var avg:Number = 0;		//Setup two sockets, one for send, one for receive.		private var outlet:DatagramSocket = new DatagramSocket();		private var inlet:DatagramSocket = new DatagramSocket();		public var deltaWheel:Number; //Wheel Speed and direction.  -30 ~ 30		public var wheelValue:Number=0;						public function UDPController(host:String, tx:int, rx:int) {						udpHost = host; //Please set these with a config file			udpSendPort = tx;    //Please set these with a config file			udpRecPort = rx;    //Please set these with a config file									addEventListener("wheelChanged",cop);			initUDP();		}						public function setBrake(drag:Number):void {			trace("setBrake( "+drag+" )");			var wheelCmd:String = "brake;"+drag.toString();			sendCmd(wheelCmd);		}				public function initUDP():void {			trace("initUDP");			inlet.addEventListener(DatagramSocketDataEvent.DATA, dataHandler);       		inlet.addEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler);      		inlet.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);			       		inlet.bind(udpRecPort, "0.0.0.0");			trace("Inlet bound to "+udpRecPort);			//datagramSocket.receive();			inlet.receive();			trace("UDP Inlet: waiting for connection");		}				public function setLed(LEDState:Number):void {			trace("setLed( LEDState: "+LEDState+" )");			var ledCmd:String = "led;"+LEDState.toString();			sendCmd(ledCmd);		}				public function setYear(Year:Number):void {			trace("setYear( Year: "+Year+" )");			var yrCmd:String = "year;"+Year.toString();			sendCmd(yrCmd);		}				public function setImg(olId:Number,imgId:Number):void {			trace("setImg( olId: "+olId+" imgId: "+imgId+" )");			var imgCmd:String = "oled;"+olId.toString()+";"+imgId.toString();			sendCmd(imgCmd);		}								//accepts a (hopefully)well-formed message and sends it as UTF Bytes, appending EOL char.		public function sendCmd(cmd:String):void {			var EOL:String = "\n"; //Newline			//var EOL:String = "\r"; //Carriage Return			trace("Sending :"+cmd+"on "+udpHost+":"+udpSendPort);			var bytes:ByteArray=new ByteArray();			bytes.writeUTFBytes(cmd+EOL);			outlet.send(bytes,0,0,udpHost,udpSendPort);		}										private function dataHandler(e:DatagramSocketDataEvent) : void {			trace("dataHandler( "+e+" )");			var dEOL:String="\n"			//var dEOL:String="\r"							msg = e.data.readUTFBytes(e.data.length);				msg = msg.split(dEOL).join("");				dispatchEvent(new Event("hello"));				var cmd:Array = msg.split(";");  //Field separator for messages is ";"												switch (cmd[0]) {//sort commands by "domain"									case "sw":					swHandler(cmd[1], cmd[2]);					break;										case "wheel":					wheelHandler(cmd[1])										break;									}		}									private function IOErrorHandler(event:IOErrorEvent) : void {			trace("IOErrorHandler( "+event+" )");			//trace(event);		}				private function securityErrorHandler(event:SecurityErrorEvent) : void {			trace("securityErrorHandler( "+event+" )");			//trace(event);		}						private function wheelHandler(w:String){			deltaWheel=Number(w);			wheelValue+=deltaWheel;			dispatchEvent(new Event("wheelChanged",false,true));		}				private function cop(w:Event):void		{			avg=0;			var end:Number = lastW.push(deltaWheel);		    trace("End ="+end+", array: "+lastW);			if(end > avgI){				lastW.shift();				trace("shifted, array: "+lastW);			}									for each(var i:Number in lastW){				avg+=Math.abs(i);			}			avg/=avgI;			trace("Wheel Average speed ="+avg);			if(avg>speedLimit)			{				lastW.splice(0,lastW.length);				bump(copTop,copTime);			}					}				public function stopLeft():void		{			trace("StopLeft");			removeEventListener("wheelChanged",cop);			addEventListener("wheelChanged", stopLeftHandler);		}				private function stopLeftHandler(e:Event):void		{			e.stopImmediatePropagation();			if (deltaWheel < 0){				bump(stopTop,stopTime);				trace("Left Extent Pushed, bumping");			}						else{				addEventListener("wheelChanged",cop);				removeEventListener("wheelChanged", stopLeftHandler);			}		}				public function stopRight():void		{			trace("StopRight");			removeEventListener("wheelChanged",cop);			addEventListener("wheelChanged", stopRightHandler);		}				private function stopRightHandler(e:Event):void		{			e.stopImmediatePropagation();			if (deltaWheel > 0) 			{				bump(stopTop,stopTime);				trace("Right Extent Pushed, bumping");			}			else{				addEventListener("wheelChanged",cop);				removeEventListener("wheelChanged", stopRightHandler);			}		}																public function bump( _a:Number = 50, _p:Number = 500){			var r:Function = function(_t:TimerEvent):void			{				setBrake(0);				_t.target.stop();				_t.target.removeEventListener(TimerEvent.TIMER_COMPLETE,r);			}			var t:Timer=new Timer(_p,1);			t.addEventListener(TimerEvent.TIMER_COMPLETE,r);			setBrake(_a);			t.start();		}				//Parses out the rest of the sw;x;x command		private function swHandler(id:String, swState:String) {			trace("swHandler( id: "+Number(id)+", swState:"+Number(swState)+")");						//			var btnState:String;    //.substr(0,1) strips hidden line break after first character in btnState string -- param 0 starts at beginning of string and param'1' is how many characters			//Line below should be deprecated, as trailing EOL was dealt with in dataHandler above			//if (swState.substr(0,1)=="0") btnState="Up" else btnState="Down";			var adj:Number = Number(id);						if(swState=="0" && adj < 4){				adj+=1 //add one for 1-indexed oled Events for Peter				var btnEvent:String="oled"+adj+"up";				dispatchEvent(new Event(btnEvent));				trace("BTNEVENT:"+btnEvent);			}						else if(swState=="0"){				dispatchEvent(new Event("backIsup"));			}				/*var btnFunction:String="remoteBtn"+id+btnState;				trace("Calling function: "+btnFunction+"()");*/				//this[btnFunction]();		}					}	}