package id.element
{
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.Event;

	/**
	 * This is the KeyParser class.
	 * 
	 * @langversion 3.0
	 * @playerversion AIR 2
	 * @playerversion Flash 10
	 * @playerversion Flash Lite 4
	 * @productversion GestureWorks 2.0
	 */
	public class KeyParser extends EventDispatcher
	{
		public static var settings:XML;
		public static var layout:Array = new Array();
		public static var dataSet:Array = new Array();
		public static var flickr:Array = new Array();
		private static var _settingsPath:String="";
		private static var settingsLoader:URLLoader;
		private static var layoutLoader:URLLoader;
		protected static var dispatch:EventDispatcher;
		private static var count:int;
		public static var totalAmount:int;
		private static var request:URLRequest;
		private static var object:Object;
		public static var initialXml:XML;
		public static var test:Array = new Array();
		public static var xmlTester:XML;

		public static function get settingsPath():String
		{
			return _settingsPath;
		}

		public static function set settingsPath(value:String):void
		{
			if (_settingsPath==value)
			{
				return;
			}

			settingsLoader = new URLLoader();
			settingsLoader.addEventListener(Event.COMPLETE, settingsLoaderComplete);
			_settingsPath=value;
			settingsLoader.load(new URLRequest(_settingsPath));
		}

		private static function settingsLoaderComplete(event:Event):void
		{
			settings=new XML(event.target.data);

			layoutLoader = new URLLoader();
			layoutLoader.load(new URLRequest(settings.GlobalSettings.layoutPath));
			layoutLoader.addEventListener(Event.COMPLETE, layoutLoaderComplete);

			settingsLoader.removeEventListener(Event.COMPLETE, settingsLoaderComplete);
			settingsLoader=null;
		}

		private static function layoutLoaderComplete(event:Event):void
		{
			var xmlLayout:XML=new XML(event.target.data);
			var widthFactor:Number=0;
			var X:Number=0;
			var _width:Number=0;
			var totalWidth:Number=0;
			var Y:Number=0;
			var _height:Number=0;
			var totalHeight:Number=0;

			for (var i:int=0; i<xmlLayout.ROW.length(); i++)
			{
				for (var j:int = 0; j<xmlLayout.ROW[i].KEY.length(); j++)
				{
					var lay:Object=xmlLayout.ROW[i].KEY[j];

					var object:Object=new Object();

					if (lay.@shiftAction==undefined)
					{
						object.shiftText=lay.@title;
						object.shiftAction=lay.@action;
					}
					else
					{
						object.shiftText=lay.@shiftAction;
						object.shiftAction=lay.@shiftAction;
					}

					if (lay.@capsAction==undefined)
					{
						object.capsText=lay.@title;
						object.capsAction=lay.@action;
					}
					else
					{
						object.capsText=lay.@capsAction;
						object.capsAction=lay.@capsAction;
					}

					if (lay.@shiftKey!=undefined)
					{
						object.shift=lay.@shiftKey=="true"?true:false;
					}

					if (lay.@capitalKey!=undefined)
					{
						object.capital=lay.@capitalKey=="true"?true:false;
					}

					if (j==0)
					{
						if(X+_width>totalWidth)
						{
							totalWidth=X+_width;
						}
						
						widthFactor=0;
					}

					object.action=lay.@action;
					object.title=lay.@title;
					object.width=lay.@width;
					object.height=lay.@height;
					object.x=widthFactor+(Number(settings.Key.spacing)*j);
					object.y=(Number(lay.@height)+Number(settings.Key.spacing))*i;
					widthFactor+=Number(lay.@width);
					X=object.x;
					_width=Number(lay.@width);
					Y=object.y;
					_height=Number(lay.@height);
					
					layout.push(object);
					
					if(Y+_height>totalHeight)
					{
						totalHeight=Y+_height;
					}
				}
			}
			
			settings.keysWidth=totalWidth;
			settings.keysHeight=totalHeight;
			
			layoutLoader.removeEventListener(Event.COMPLETE, layoutLoaderComplete);
			layoutLoader=null;
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public static function addEventListener(p_type:String, p_listener:Function, p_useCapture:Boolean=false, p_priority:int=0, p_useWeakReference:Boolean=false):void
		{
			if (dispatch==null)
			{
				dispatch = new EventDispatcher();
			}
			dispatch.addEventListener(p_type, p_listener, p_useCapture, p_priority, p_useWeakReference);
		}

		public static function removeEventListener(p_type:String, p_listener:Function, p_useCapture:Boolean=false):void
		{
			if (dispatch==null)
			{
				return;
			}
			dispatch.removeEventListener(p_type, p_listener, p_useCapture);
		}

		public static function dispatchEvent(event:Event):void
		{
			if (dispatch==null)
			{
				return;
			}
			dispatch.dispatchEvent(event);
		}

	}
}