﻿package com.nestor.elements  {	import flash.display.Stage;	import flash.display.NativeWindow;	import flash.display.StageDisplayState;	import flash.desktop.NativeApplication;	import flash.ui.Mouse;	import flash.events.*;	import flash.display.*;	public class kiosk extends MovieClip{		public var mState:Boolean = true;		public var wide:Number;		public var high:Number;		public var centerX:Number;		public var centerY:Number;		public var time:Number;		public var nativeApp:NativeApplication = NativeApplication.nativeApplication;				public function kiosk() {						this.addEventListener(Event.ADDED_TO_STAGE,init); 		 			}				public function enableTimeout():void		{			nativeApp.addEventListener(Event.USER_IDLE, timeoutHandler);		}				public function disableTimeout():void		{			nativeApp.removeEventListener(Event.USER_IDLE, timeoutHandler);		}				public function timeoutSet(_time:int = 300):void		{			nativeApp.idleThreshold = _time;		}						public function init(e:Event):void		{						stage.addEventListener(KeyboardEvent.KEY_UP,shortcuts);			hideMouse();						trace("added");			wide=stage.stageWidth;			high=stage.stageHeight;			centerX=wide/2;			centerY=high/2;			//stage.nativeWindow.x=0;			//stage.nativeWindow.y=0;			/*if(e.target.onTop)goOnTop();			if(e.target.fullscreen)goFull();			if(!e.target.mouse)hideMouse();*/					}		public function timeoutHandler(e:Event):void		{					}		private function notSoFast(e:Event):void		{			trace("Cahanggaa");			stage.nativeWindow.orderToFront();			stage.nativeWindow.activate();					}				private function goOnTop():void		{						stage.nativeWindow.alwaysInFront = true;			stage.addEventListener(FullScreenEvent.FULL_SCREEN, resetTop);					}				private function goOffTop():void		{			stage.nativeWindow.alwaysInFront = false;			stage.removeEventListener(FullScreenEvent.FULL_SCREEN, resetTop);					}				private function resetTop(e:Event):void		{						stage.nativeWindow.alwaysInFront = false;			stage.nativeWindow.alwaysInFront = true;								}		public function goFull():void		{						stage.displayState = StageDisplayState.FULL_SCREEN;			stage.nativeWindow.alwaysInFront = true;		}		public function hideMouse():void		{			stage.nativeWindow.activate();			stage.nativeWindow.orderToBack();			stage.nativeWindow.orderToFront();			Mouse.hide();		}				public function showMouse():void		{			stage.nativeWindow.activate();			stage.nativeWindow.orderToBack();			stage.nativeWindow.orderToFront();			Mouse.show();		}				private function shortcuts(k:KeyboardEvent):void		{			//109 = m, 102 = f			switch (k.charCode)			{				case 102://'f'//					goFull();				break;								case 109: //'m'//				trace("MouseCommand");				if(mState){					mState=false;					hideMouse();				}				else {					mState=true;					showMouse();				}				break;																case 116://'t'//					if(stage.nativeWindow.alwaysInFront)goOffTop();										else goOnTop();				break;								case 120://'x'//					dispatchEvent(new Event("debugEvent"));				break;								case 114://'r'//					reset();				break;							}			trace(k.charCode);		}				public function reset():void{};	}	}