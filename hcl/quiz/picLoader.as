﻿package com.nestor.hcl.quiz {	import flash.display.Graphics;	import flash.display.Shape;	import flash.events.*;	import flash.display.Sprite;	import flash.display.Loader;	import flash.net.URLRequest;	import flash.display.LoaderInfo;		import flash.display.Stage;	import flash.display.StageDisplayState;		public class picLoader extends Sprite{		var default_bg_color:uint = 0x000000;				var stW,stH:Number;		var pics:Array=[];		var current:Number=9999;				public function picLoader() {			this.addEventListener(Event.ADDED_TO_STAGE, init);								}				private function init(e:Event):void		{			//this.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;						stW=stage.stageWidth;			stH=stage.stageHeight;			var bg:Sprite = new Sprite();   			bg.graphics.beginFill(default_bg_color);    		bg.graphics.drawRect(0,0,stW, stH);			addChildAt(bg, 0);		}				public function preload(_a:Array)		{			var i:Number = 0;			for each (var s:String in _a)			{				var ldr:Loader=new Loader;				var req:URLRequest =  new URLRequest(s);				ldr.load(req);				addListeners(ldr.contentLoaderInfo);				pics.push(ldr);			}		}												private function addListeners(c:LoaderInfo):void		{			c.addEventListener(Event.COMPLETE, loadComplete);			c.addEventListener(IOErrorEvent.IO_ERROR, error);			c.addEventListener(HTTPStatusEvent.HTTP_STATUS, http);		}				private function loadComplete(e:Event):void		{			trace("Loaded 1 Image:"+e.target.loader);			resizeIt(e.target.loader);		}				private function resizeIt(l:Loader):void		{			var lH:Number = l.height;			var lW:Number = l.width;			if(lH>=stH || lW>=stW){								trace("Pre-scale:"+lH+" / "+lW)				var scale:Number = (lH >= lW) ? stH/lH : stW/lW;				lH*=scale;				lW*=scale;				l.scaleX=l.scaleY=scale;			}			l.x = (stW - lW)/2;			l.y = (stH - lH)/2;		}				private function centerIt(l:Loader):void		{					}				private function error(e:Event):void		{			trace("***ERROR of type "+e.type+" :: "+e.toString());		}				private function http(e:Event):void		{			trace("***HTTP_STATUS  :: "+e.toString());		}						public function loadIMG(i:Number):void		{			//if(this.getChildAt(1)) this.removeChildAt(1);			if(current != 9999){removeChild(pics[current])};			addChild(pics[i]);			//resizeIt(pics[i]);			current = i;		}	}	}