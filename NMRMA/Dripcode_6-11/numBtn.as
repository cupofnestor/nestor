﻿package {	import flash.display.*;	import flash.events.*;	public class numBtn extends MovieClip	{		var par:Object;		var keyVal:String;		var def:String;		public function numBtn():void		{				buttonMode = true;			useHandCursor = true;			par = this.parent.parent.parent;			keyVal = name;			var result:Array = keyVal.split("_");			keyVal = result[1];			addEventListener(MouseEvent.MOUSE_UP,pressed)		}				private function pressed(e:MouseEvent):void		{			trace(par+".loadReg");			par.loadReg(keyVal);					}							}}