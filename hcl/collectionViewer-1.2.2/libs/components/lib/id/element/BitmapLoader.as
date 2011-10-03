////////////////////////////////////////////////////////////////////////////////
//
//  OPEN EXHIBITS
//  Copyright 2010-2011 OPEN EXHIBITS
//  All Rights Reserved.
//
//  BitmapLoader
//
//  File:    BitmapLoader.as
//  Author:    Mattthew Valverde (matthew(at)ideum(dot)com)
//
//  NOTICE: OPEN EXHIBITS permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package id.element
{
	import flash.events.Event;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.display.PixelSnapping;
	import flash.display.Loader;
	import flash.net.URLRequest;
	
	import id.core.TouchComponent;

	/**
	 * This is the BitmapLoader class.
	 * 
	 * @langversion 3.0
	 * @playerversion AIR 2
	 * @playerversion Flash 10
	 * @playerversion Flash Lite 4
	 * @productversion GestureWorks 2.0
	 */
	public class BitmapLoader extends TouchComponent
	{
		public var bitmap:Bitmap;
		private var bitmapLoader:Loader;
		private var _url:String="";
		private var _scale:Number=1;
		private var _pixels:Number=0;

		public function BitmapLoader()
		{
			super();
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
		
		public function get url():String{return _url;}
		public function set url(value:String):void
		{
			_url=value;
			createUI();
		}
		
		public function get scale():Number{return _scale;}
		public function set scale(value:Number):void
		{
			_scale=value;
		}
		
		public function get pixels():Number{return _pixels;}
		public function set pixels(value:Number):void
		{
			_pixels=value;
		}
		
		override protected function createUI():void
		{
			bitmapLoader = new Loader();
			bitmapLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderComplete, false, 0, true);
			bitmapLoader.load(new URLRequest(_url));
		}
		
		override protected function commitUI():void{}

		override protected function updateUI():void{}
		
		private function loaderComplete(event:Event):void
		{
			if(_pixels!=0)
			{
				var reduceX:Number = _pixels / event.target.loader.width;
				var reduceY:Number = _pixels / event.target.loader.height;
				scale = reduceX > reduceY ? reduceY : reduceX ;
			}
			
			var resizeMatrix:Matrix = new Matrix();
			resizeMatrix.scale(1, 1);
			
			var bitmapData:BitmapData = new BitmapData(event.target.loader.width/**(scale)*/,event.target.loader.height/**(scale)*/,true,0xFFFFFF);
			bitmapData.draw( event.target.loader.content,resizeMatrix);
			bitmap=new Bitmap(bitmapData);
			
			event.target.loader.unload();
			bitmapLoader=null;
			bitmap.width*=_scale;
			bitmap.height*=_scale;
			bitmap.smoothing=true;
			addChild(bitmap);
			
			width=bitmap.width;
			height=bitmap.height;
			
			super.layoutUI();
			
			event.target.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loaderComplete);
		}
	}
}
