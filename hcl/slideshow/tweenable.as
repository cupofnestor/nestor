﻿package com.nestor.hcl.slideshow {	import com.greensock.TweenLite;	import flash.display.MovieClip;	import flash.events.*;		public class tweenable extends MovieClip{		var t:Number = 0.25;		public function tweenable ()  {			// constructor code		}				public function hide():void		{			mouseEnabled=false;			TweenLite.to(this, t, {alpha:0,onComplete:doneHide});		}				public function show():void		{						TweenLite.to(this, t, {alpha:1,onComplete:doneShow});		}				private function doneShow():void		{			dispatchEvent(new Event(Event.COMPLETE));			mouseEnabled=true;		}				private function doneHide():void		{			dispatchEvent(new Event(Event.COMPLETE));		}	}	}