﻿package com.nestor.hcl.slideshow {	import flash.events.*;	import flash.html.*;	import flash.display.Bitmap;	import flash.display.BitmapData;	import flash.display.Sprite;		public class slide extends Sprite{		var bm:Bitmap;		var bmd:BitmapData;		var hload:HTMLLoader;		public function slide(s:String, w:Number=640, h:Number=480) {			hload = new HTMLLoader();			hload.width = w;			hload.height = h;			bm = new Bitmap()			bmd = new BitmapData(hload.width, hload.height);			hload.addEventListener(Event.COMPLETE, loadedHTML);			hload.loadString(s);		}				private function loadedHTML(e:Event):*		{			e.target.removeEventListener(Event.COMPLETE, loadedHTML);			trace("HTML LOADED, CHEIF");			bmd.draw(hload);			bm.bitmapData=bmd;			addChild(bm);			dispatchEvent(new Event("readyToPlay", true));		}	}	}