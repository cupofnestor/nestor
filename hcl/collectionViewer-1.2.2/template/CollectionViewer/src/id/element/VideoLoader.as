package id.element
{
	import id.core.TouchComponent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import id.component.ControlBtns;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.NetStatusEvent;

	/**
	 * This is the VideoLoader class.
	 * 
	 * @langversion 3.0
	 * @playerversion AIR 2
	 * @playerversion Flash 10
	 * @playerversion Flash Lite 4
	 * @productversion GestureWorks 2.0
	 */
	public class VideoLoader extends TouchComponent
	{
		public static var TIME:String = "Time";
		private var nc:NetConnection;
		public var timer:Timer;
		public var ns:NetStream;
		private var video:Video;
		private var _width:Number;
		private var _height:Number;
		private var _url:String;
		private var _scale:Number=1;
		private var _pixels:Number=0;
		private var videoObject:Object;
		private var _timerFormated:String="00:00";
		public var timerUpdate:Boolean;
		private var count:int;

		public function VideoLoader()
		{
			super();
		}

		override public function Dispose():void
		{
			timer.stop();
			
			timer.removeEventListener(TimerEvent.TIMER, updateDisplay);
			timer=null;
			
			ns.close();
			ns = null;
			
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

		public function get time():String
		{
			return _timerFormated;
		}
		
		override protected function createUI():void
		{
			videoObject = new Object();
			timer=new Timer(10);
			timer.addEventListener(TimerEvent.TIMER, updateDisplay);
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

			addChild(video);

			width=video.width;
			height=video.height;

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

			count++;

			if (count==2)
			{			
				super.layoutUI();
			}
		}

		public function play():void
		{
			ns.resume();
			timer.start();
		}

		public function pause():void
		{
			ns.pause();
			timer.stop();
		}

		public function back():void
		{
			timer.stop();
			ns.seek(0);
			ns.pause();
		}
		
		public function forward():void
		{
			ns.seek(ns.time+2);
			var stringForward:String=formatTime(ns.time+2);
			sendUpdate(stringForward);
		}
		
		private function onVideoStatus(evt:Object):void
		{
			if (evt.info.code=="NetStream.Play.Start")
			{
				/*if (parent is TouchComponent)
				{
					var par:TouchComponent=TouchComponent(parent);
					par.layoutUI();
					par.visible=true;
				}*/
			}
			if (evt.info.code=="NetStream.Seek.Notify")
			{
				sendUpdate("00:00");
			}
			if (evt.info.code=="NetStream.Play.Stop")
			{
				back();
				sendUpdate("00:00");
			}
		}

		private function updateDisplay(event:TimerEvent):void
		{
			var string:String=formatTime(ns.time);
			sendUpdate(string);
		}

		private function sendUpdate(string:String):void
		{
			_timerFormated=string;
			dispatchEvent(new Event(VideoLoader.TIME, true, true));
		}

		private function formatTime(t:int):String
		{
			var s:int=Math.round(t);
			var m:int=0;
			if (s>0)
			{
				while (s > 59)
				{
					m++;
					s-=60;
				}
				return String((m < 10 ? "0" : "") + m + ":" + (s < 10 ? "0" : "") + s);
				//return String((m < 10 ? "0" : "") + m + ":" + (s < 10 ? "0" : "") + s);
			}
			else
			{
				return "00:00";
			}
		}

	}
}