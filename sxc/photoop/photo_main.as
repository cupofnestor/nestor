﻿package com.nestor.sxc.photoop  {	import flash.events.MouseEvent;	import flash.events.Event;	import flash.display.MovieClip;	import flash.net.NetConnection;	import flash.net.Responder;	import com.nestor.elements.kiosk;		public class photo_main extends  MovieClip{		var gw:NetConnection = new NetConnection();		var host:String = "http://192.168.13.138";		var gatewayPath:String = "/amfphp/gateway.php"		var imgPath:String="/img_tmp/";		var image:String;		var gateway:String = host+gatewayPath;  //set in cfg		var snapRes:Responder;						public function photo_main() {			gw.connect(gateway);			netSetup();			initUI();		}				private function netSetup():void		{			 snapRes = new Responder(onSnapResult,onFault);		}				function onSnapResult(_r:Object):void{			trace("suxcess");			showPhoto(String(_r));		}				function onFault(_r:Object):void{			for(var i in _r)trace(_r[i]);		}						private function initUI():void		{			knobby.addEventListener(MouseEvent.MOUSE_UP, three);		}				private function three(e:Event){			knobby.removeEventListener(MouseEvent.MOUSE_UP, three);			trace("THREE");			if(windw.onStage)windw.killImg();			count3.addEventListener(Event.COMPLETE, two);			count3.blink();		}				private function two(e:Event){			trace("knob pushed");			count3.removeEventListener(Event.COMPLETE, two);			count2.addEventListener(Event.COMPLETE, one);			count2.blink();		}		private function one(e:Event){			trace("knob pushed");			count2.removeEventListener(Event.COMPLETE, two);			count1.addEventListener(Event.COMPLETE, go);			gw.call("take.snap",snapRes);			count1.flash();					}				private function go(e:Event){			trace("GO!");			count1.removeEventListener(Event.COMPLETE, go);					}				private function showPhoto(photo:String):void		{			image=imgPath+photo;			windw.loadImg(host+image);			windw.addEventListener(Event.COMPLETE, sendEmailOn);		}		private function sendEmailOn(e:Event):void		{			windw.removeEventListener(Event.COMPLETE, sendEmailOn);			email.onStage();			shadow.aChange(1);		}					}	}