﻿package{	import flash.display.*;	import flash.events.*;	import caurina.transitions.*; 	public class  waterButton extends MovieClip	{		private var par:Object;		public function waterButton():void		{							addEventListener(Event.ADDED_TO_STAGE, birth);		}				private function birth(e:Event):void		{			par=this.parent;						removeEventListener(Event.ADDED_TO_STAGE, birth);						trace("waterButton added by"+par+", name: "+this+this.name);			this.scaleX=0;			this.scaleY=0;			this.alpha=0;			Tweener.addTween( this, { scaleX:1,scaleY:1, alpha:1, time:1, transition:"easeOutBack" } );		}				public function kill():void		{			var suicide:Function = function suicide():void			{				trace("graph suicide");				var par:Object = this.parent;				par.removeChild(this);			}			trace("graph killed");			Tweener.addTween( this, { scaleX:0,scaleY:0, alpha:0, time:1, transition:"easeOut" } );		}			}}