﻿package  com.nestor.hcl.lab {		import flash.display.MovieClip;	import flash.events.*;	import flash.net.*;	import flash.display.StageDisplayState;	include "includes/quickfix_imports.as";		public class slave1 extends MovieClip {		var cfg:XML;		var cfgFile:String;		var url:URLRequest;		var cfgLoader:URLLoader = new URLLoader();				public function slave1() {			cfgFile="ss_conf.xml";			url=new URLRequest(cfgFile);			cfgLoader.load(url);			cfgLoader.addEventListener(Event.COMPLETE, cfgLoaded);								}				private function cfgLoaded(e:Event):void		{			cfg = new XML(e.target.data);			var port:int= int(cfg.slave1.port);			var server:String = cfg.slave1.server;			trace("Slave1, listening on: "+server+port);			var myRec:UDPreceiver=new UDPreceiver(server,port);						addChild(myRec);			myRec.addEventListener("nextSlide", nextHandler);			myRec.addEventListener("firstSlide", topHandler);			myRec.addEventListener("suspend", nextHandler);			myRec.addEventListener("resume", topHandler);			stage.nativeWindow.x=cfg.slave1.windowX;			trace(cfg.slave1.windowX);			if (cfg.full=="true"){				include "includes/quickfix.as";			}		}				private function nextHandler(e:Event):void		{			trace("NextSlide");			this.play();		}				private function topHandler(e:Event):void		{			trace("top");			this.gotoAndStop(1);		}						private function resume(e:Event):void		{			stage.nativeWindow.orderToFront();		}				private function suspend():void		{			stage.nativeWindow.orderToBack();		}			}	}