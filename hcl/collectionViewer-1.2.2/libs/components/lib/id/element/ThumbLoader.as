////////////////////////////////////////////////////////////////////////////////
//
//  OPEN EXHIBITS
//  Copyright 2010-2011 OPEN EXHIBITS
//  All Rights Reserved.
//
//  ThumbLoader
//
//  File:     ThumbLoader.as
//  Author:    Mattthew Valverde (matthew(at)ideum(dot)com)
//
//  NOTICE: OPEN EXHIBITS permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package id.element
{
	import flash.events.Event;
	import id.core.TouchSprite;
	import id.core.TouchComponent;
	import flash.events.Event;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.display.PixelSnapping;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import gl.events.TouchEvent;
	import gl.events.GestureEvent;
	import flash.display.DisplayObject;

	/**
	 * This is the ThumbLoader class.
	 * 
	 * @langversion 3.0
	 * @playerversion AIR 2
	 * @playerversion Flash 10
	 * @playerversion Flash Lite 4
	 * @productversion GestureWorks 2.0
	 */
	public class ThumbLoader extends TouchComponent
	{
		public static const COMPLETE:String="image loading complete";

		private var _initialized:Boolean;
		private var scale:Number;
		private var pixelSize:Number;
		private var bitmap:Bitmap;
		private var imageLoader:Loader;
		private var _width:Number;
		private var _height:Number;
		private var _url:String="";

		private var _scale:Boolean;
		private var _rotate:Boolean;
		private var _drag:Boolean;

		private var polaroidSettings:XMLList;

		public function ThumbLoader()
		{
			super();
			pixelSize=150;
		}

		override public function Dispose():void
		{
			if(contains(bitmap))
			{
				removeChild(bitmap);
			}
			
			bitmap=null;
			
			if (parent)
			{
				parent.removeChild(this);
			}
		}

		public function get url():String
		{
			return _url;
		}
		public function set url(value:String):void
		{
			_url=value;
			createUI();
		}

		public function set scaling(value:Boolean):void
		{
			_scale=value;
			updateUI();
		}

		public function set rotating(value:Boolean):void
		{
			_rotate=value;
			updateUI();
		}

		public function set dragging(value:Boolean):void
		{
			_drag=value;
			updateUI();
		}

		public function set gestures(value:Boolean):void
		{
			_drag=value;
			_rotate=value;
			_scale=value;
			updateUI();
		}

		override protected function createUI():void
		{
			imageLoader = new Loader();
			imageLoader.contentLoaderInfo.addEventListener(Event.INIT, loaderComplete, false, 0, true);
			imageLoader.load(new URLRequest(_url));
			commitUI();
		}
		
		/*override protected function commitUI():void
		{
			
		}

		override protected function updateUI():void
		{
			
		}*/

		private function loaderComplete(event:Event):void
		{
			var reduceX:Number=pixelSize/event.target.loader.width;
			var reduceY:Number=pixelSize/event.target.loader.height;

			scale=reduceX>reduceY?reduceY:reduceX;

			var resizeMatrix:Matrix = new Matrix();
			resizeMatrix.scale(scale, scale);
			var bitmapData:BitmapData=new BitmapData(event.target.loader.width*scale,event.target.loader.height*scale,true,0xFFFFFF);
			bitmapData.draw(event.target.loader.content, resizeMatrix);
			bitmap=new Bitmap(bitmapData,PixelSnapping.NEVER,true);
			event.target.loader.unload();
			imageLoader=null;
			
			bitmap.smoothing=true;
			addChild(bitmap);
			
			width=bitmap.width;
			height=bitmap.height;
			
			super.layoutUI();

			event.target.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loaderComplete);
			_initialized=true;
		}

		private function touchDownHandler(event:TouchEvent):void
		{
			startTouchDrag(-1);
		}

		private function touchUpHandler(event:TouchEvent):void
		{
			stopTouchDrag(-1);
		}

		private function gestureScaleHandler(e:GestureEvent):void
		{
			scaleX+=e.value;
			scaleY+=e.value;
		}

		private function gestureRotateHandler(e:GestureEvent):void
		{
			rotation+=e.value;
		}
	}
}