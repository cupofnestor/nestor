////////////////////////////////////////////////////////////////////////////////
//
//  OPEN EXHIBITS
//  Copyright 2010-2011 OPEN EXHIBITS
//  All Rights Reserved.
//
//  VideoThumbLoader
//
//  File:     VideoThumbLoader.as
//  Author:    Mattthew Valverde (matthew(at)ideum(dot)com)
//
//  NOTICE: OPEN EXHIBITS permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package id.element
{
	import id.core.TouchComponent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.events.NetStatusEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	/**
	 * This is the VideoThumbLoader class.
	 * 
	 * @langversion 3.0
	 * @playerversion AIR 2
	 * @playerversion Flash 10
	 * @playerversion Flash Lite 4
	 * @productversion GestureWorks 2.0
	 */
	public class VideoThumbLoader extends TouchComponent
	{
		private var nc:NetConnection;
		public var ns:NetStream;
		private var video:Video;
		private var _width:Number;
		private var _height:Number;
		private var _url:String;
		private var _scale:Number=1;
		private var _pixels:Number=120;
		private var videoObject:Object;
		private var bitmap:Bitmap;
		private var bitmapData:BitmapData;
		private var count:int;
		public var time:Timer;

		public function VideoThumbLoader()
		{
			super();
		}

		override public function Dispose():void
		{
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
			commitUI();
		}

		public function get scale():Number
		{
			return _scale;
		}
		public function set scale(value:Number):void
		{
			_scale=value;
		}

		public function get pixels():Number
		{
			return _pixels;
		}
		public function set pixels(value:Number):void
		{
			_pixels=value;
		}

		override protected function createUI():void
		{
			videoObject = new Object();

			time=new Timer(1000);
			time.addEventListener(TimerEvent.TIMER, updateDisplay);
		}

		override protected function commitUI():void
		{
			var customClient:Object = new Object();

			nc=new NetConnection();
			nc.connect(null);
			ns=new NetStream(nc);
			video=new Video();
			video.attachNetStream(ns);

			customClient.onMetaData=metaDataHandler;

			ns.client=customClient;
			ns.play(_url);
			ns.pause();
			ns.seek(0);

			if (_pixels!=0)
			{
				var reduceX:Number=_pixels/video.width;
				var reduceY:Number=_pixels/video.height;
				_scale=reduceX>reduceY?reduceY:reduceX;
			}

			video.width*=_scale;
			video.height*=_scale;
			
			width=video.width;
			height=video.height;

			addChild(video);
			ns.addEventListener(NetStatusEvent.NET_STATUS,onVideoStatus);
		}
		override protected function layoutUI():void
		{
		}
		override protected function updateUI():void
		{
		}

		private function metaDataHandler(info:Object):void
		{
			videoObject=info;
		}

		private function onVideoStatus(evt:Object):void
		{
			if (evt.info.code=="NetStream.Play.Start")
			{
				time.start();
			}
			if (evt.info.code=="NetStream.Seek.Notify")
			{
			}
			if (evt.info.code=="NetStream.Play.Stop")
			{
			}
		}

		private function updateDisplay(event:TimerEvent):void
		{
			time.stop();
			
			bitmapData=new BitmapData(video.width,video.height);
			bitmapData.draw(this as DisplayObject);
			bitmap=new Bitmap(bitmapData,PixelSnapping.NEVER,true);
			bitmap.smoothing=true;
			addChild(bitmap);
						
			super.layoutUI();
			
			dispatchEvent(event);
			
			removeChild(video);
			ns.close();
			ns=null;
			nc=null;
			video=null;
		}
	}
}