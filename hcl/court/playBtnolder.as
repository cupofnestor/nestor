﻿package  {	import caurina.transitions.*;	import flash.display.MovieClip;	import flash.events.Event;	public class playBtn extends MovieClip	{		public function playBtn(initAlpha:Number=1) {			this.alpha=initAlpha;					}				public function opacity(set:Number):void		{			Tweener.addTween(this, {alpha:set, time:1, transition:"easeOutSine", onComplete:dispatcher});		}				private function dispatcher():void		{			dispatchEvent(new Event("doneOpacityChange",true));		}			}	}