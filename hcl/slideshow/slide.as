﻿package com.nestor.hcl.slideshow {	import flash.events.*;	import flash.html.*;	import flash.display.Bitmap;	import flash.display.BitmapData;	import flash.display.Sprite;				public class slide extends tweenable{		var bm:Bitmap;		var bmd:BitmapData;		var hload:HTMLLoader;						public function slide(s:String, w:Number=640, h:Number=480) {			addEventListener(Event.ADDED_TO_STAGE, init);			hload = new HTMLLoader();			hload.width = w;			hload.height = h;			hload.paintsDefaultBackground=false;			hload.cacheAsBitmap=true;			bm = new Bitmap()			bmd = new BitmapData(hload.width, hload.height);			hload.addEventListener(Event.COMPLETE, loadedHTML);			hload.loadString(s);		}				private function init(e:Event):void		{			//trace("INIT");			alpha=0;					}				private function loadedHTML(e:Event):*		{			e.target.removeEventListener(Event.COMPLETE, loadedHTML);			//trace("HTML LOADED, CHEIF");			var tmp:* = hload.window.document.body;			tmp.id="noBG";			var tmpS = e.target as Sprite;			addChild(tmpS);			var scale:Number = (hload.width == 1920) ? 1.5 : 1;			tmpS.scaleX=tmpS.scaleY=scale;			dispatchEvent(new Event("readyToPlay", true));		}				public function born():void		{			this.show()		}		public function die():void		{			this.hide()		}					}	}