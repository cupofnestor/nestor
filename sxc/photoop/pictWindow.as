﻿package com.nestor.sxc.photoop {	import flash.display.MovieClip;	import flash.display.Loader;    import flash.events.*;    import flash.net.URLRequest;	import com.greensock.TweenLite;	//import flash.media.SoundChannel;	import flash.media.Sound;		public class pictWindow extends MovieClip{		var wide:Number;		var high:Number;		var ldr:Loader;		public var onStage:Boolean = false;				public function pictWindow():void		{			this.addEventListener(Event.ADDED_TO_STAGE, setup);			ldr = new Loader();			paper_mc.addChild(ldr);		}				private function setup(e:Event):void		{			wide=e.target.width;			high=e.target.height;			loadAnim.alpha=0;						//trace("Setup:"+wide+"/"+high);		}				public function loadImg(url:String) {			trace("Loading Image:"+url);			            configureListeners(ldr.contentLoaderInfo);            var imgURL:URLRequest=new URLRequest(url);            ldr.load(imgURL);			        }				public function loading()		{			TweenLite.to(loadAnim, 0.2, {alpha:1});			TweenLite.to(prompt, 0.2, {alpha:0});			//loadAnim.alpha=1;		}				public function killImg() {			loadAnim.alpha=0;			prompt.alpha=1;			killListeners(ldr.contentLoaderInfo);			TweenLite.to(ldr, 0.5, {y:-640, onComplete:resetLdr});			onStage = false;        }				private function resetLdr()		{			ldr.unload();		}						private function fullScale(l:Loader):void		{			//trace(l.width+"/"+l.height);			var scale:Number;			scale= high/l.height;			/*if(l.width>=l.height && l.height<high)			{				scale = wide/l.width;				//trace("Width is greater, shorter than container.  scale: "+scale);			}			else			{				scale= high/l.height;				//trace("Height is greater.  scale: "+scale);			}						l.scaleX=l.scaleY=scale;			//l.x= (wide-l.height)/2 ;*/			l.scaleX=l.scaleY=scale;		}				private function killListeners(dispatcher:IEventDispatcher):void {            dispatcher.removeEventListener(Event.COMPLETE, completeHandler);            dispatcher.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);            dispatcher.removeEventListener(Event.INIT, initHandler);            dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);            dispatcher.removeEventListener(Event.OPEN, openHandler);            dispatcher.removeEventListener(ProgressEvent.PROGRESS, progressHandler);            dispatcher.removeEventListener(Event.UNLOAD, unLoadHandler);        }		        private function configureListeners(dispatcher:IEventDispatcher):void {            dispatcher.addEventListener(Event.COMPLETE, completeHandler);            dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);            dispatcher.addEventListener(Event.INIT, initHandler);            dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);            dispatcher.addEventListener(Event.OPEN, openHandler);            dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);            dispatcher.addEventListener(Event.UNLOAD, unLoadHandler);        }	        private function completeHandler(event:Event):void {            //trace("completeHandler: " + event);			//fullScale(event.target.loader);			loadAnim.alpha=0;			event.target.loader.width=384;			event.target.loader.height=512;			event.target.loader.y=-512;			//var psc:SoundChannel = new SoundChannel();			var psnd:Sound=new print_sound();			psnd.play();			TweenLite.to(event.target.loader, 0.5, {y:0,onComplete:done});			TweenLite.to(loadAnim, 0.2, {alpha:0});			onStage = true;        }				private function done():void		{			dispatchEvent(new Event(Event.COMPLETE));		}        private function httpStatusHandler(event:HTTPStatusEvent):void {            //trace("httpStatusHandler: " + event);        }        private function initHandler(event:Event):void {            //trace("initHandler: " + event);        }        private function ioErrorHandler(event:IOErrorEvent):void {            //trace("ioErrorHandler: " + event);        }        private function openHandler(event:Event):void {            //trace("openHandler: " + event);        }        private function progressHandler(event:ProgressEvent):void {            //trace("progressHandler: bytesLoaded=" + event.bytesLoaded + " bytesTotal=" + event.bytesTotal);        }        private function unLoadHandler(event:Event):void {            //trace("unLoadHandler: " + event);        }        private function clickHandler(event:MouseEvent):void {            //trace("clickHandler: " + event);          //  var loader:Loader = Loader(event.target);            //loader.unload();        }	}	}