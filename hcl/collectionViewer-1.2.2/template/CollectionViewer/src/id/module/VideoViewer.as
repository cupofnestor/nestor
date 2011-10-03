package id.module
{
	import flash.events.Event;
	import id.core.TouchComponent;
	import id.component.VideoDisplay;
	import id.element.VideoParser;
	import id.core.ApplicationGlobals;
	
	/**
	 *
	 * <pre>
	 * The VideoViewer is a module designed to display media content in the form of digital video.  
	 * Video data files such as FLV and swf along with associated meta data, timed text and basic formatting can be defined using the module XML file.
	 * Multiple touch object videos can be displayed on stage and each touch object can be manipulated using the TAP, DRAG, SCALE and ROTATE multitouch gestures and standard PLAY, STOP, BACK, FORWARD and PAUSE touch buttons.  
	 * All multitouch gestures can be activated and deactivated using the module XML settings.</pre>
	 *
	 *
	 * <strong>Imported Components :</strong>
	 * <pre>
	 * VideoDisplay
	 * VideoParser</pre>
	 *
	 * <listing version="3.0">
	 * var videoViewer:VideoViewer = new VideoViewer();
	 * 
	 * addChild(videoViewer);</listing>
	 *
	 * @see id.core.TouchComponent
	 * @see id.component.VideoDisplay
	 * 
	 * @includeExample VideoViewer.as
	 * 
	 * @langversion 3.0
	 * @playerversion AIR 2
	 * @playerversion Flash 10.1
	 * @playerversion Flash Lite 4
	 * @productversion GestureWorks 2.0
	 */
	public class VideoViewer extends TouchComponent
	{
		private var videoDisplay:VideoDisplay;
		
		
		/**
		 *
		 * The DisplayObject is an Array of all display objects added to the stage.
		 * <pre>
		 * <strong>displayObject.push(videoDisplay);</strong></pre>
		 *
		 */
		public static var COMPLETE:String = "complete";
		public var displayObject:Array = new Array();
		
		private var _id:int;
		private var count:int;
		private var idDisplayed:Array = new Array();
		private var idWaiting:Array = new Array();	
		private var _moduleName:String="";
		private var isLoaded:Boolean;
		
		/**
		 *
		 * The Constructor.
		 * <pre>
		 * <strong>var videoViewer:VideoViewer = new VideoViewer();
		 * addChild(videoViewer);</strong></pre>
		 *
		 */

		public function VideoViewer()
		{
			super();
			VideoParser.settingsPath="library/data/VideoViewer.xml";
			VideoParser.addEventListener(Event.COMPLETE, onParseComplete);
		}
		
		override public function get id():int
		{
			return _id;
		}
		override public function set id(value:int):void
		{
			_id=value;
		}
		
		override public function get moduleName():String
		{
			return _moduleName;
		}
		override public function set moduleName(value:String):void
		{
			_moduleName=value;
		}
		
		override protected function updateUI():void
		{
			callNewObject(id);
		}
		
		private function onParseComplete(event:Event):void
		{
			for (count=0; count<VideoParser.amountToShow; count++)
			{
				addObject(count);
			}
			
			for (var id:int=count; id<VideoParser.totalAmount; id++)
			{
				idWaiting.push(id);
			}
		}
		
		public function callNewObject(idNumber:int):void
		{
			for (var i:int=0; i<idDisplayed.length; i++)
			{
				if(idDisplayed[i]==idNumber)
				{
					idWaiting.push(idDisplayed[i]);
					idDisplayed.splice(i, 1);
				}				
			}
			
			addObject(idWaiting[0]);
			idWaiting.shift();
		}
		
		private function addObject(id:int):void
		{
			videoDisplay=new VideoDisplay();
			videoDisplay.id=id;
			videoDisplay.moduleName="VideoViewer";
			
			idDisplayed.push(id);
			
			displayObject.push(videoDisplay);
						
			if (parent is TouchComponent)
			{
				videoDisplay.alpha=0;
				
				if(count+1==VideoParser.amountToShow)
				{
					isLoaded=true;
				}
				
				if(isLoaded)
				{
					super.layoutUI();
					displayObject=[];
				}
			}
			else
			{
				addChild(videoDisplay);
				if(count+1==VideoParser.amountToShow)
				{
					isLoaded=true;
				}
				
				if(isLoaded)
				{
					dispatchEvent(new Event(VideoViewer.COMPLETE));
					displayObject=[];
				}
			}
		}

	}
}