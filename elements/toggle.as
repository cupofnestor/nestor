﻿package com.nestor.elements {		import flash.display.MovieClip;	import flash.events.MouseEvent;	import flash.events.Event;		public class toggle extends MovieClip {		public var toggleState:Boolean=false;				public function toggle() {			this.addEventListener(MouseEvent.MOUSE_UP, clicked);		}				public function clicked(m:MouseEvent):void		{			if(!toggleState){				setDOWN();				dispatchEvent(new Event(Event.CHANGE));			}			else			{				setUP();				dispatchEvent(new Event(Event.CHANGE));			}		}				public function setUP(){			toggleState=false;			gotoAndStop("up")		}		public function setDOWN(){			toggleState=true;			gotoAndStop("down")		}			}	}