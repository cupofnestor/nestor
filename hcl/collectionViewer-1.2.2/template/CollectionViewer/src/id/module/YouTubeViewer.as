package id.module
{
	import flash.events.Event;
	import id.core.TouchComponent;
	import id.component.YouTubeDisplay;
	import id.element.YouTubeParser;
	import id.core.ApplicationGlobals;
	
	/**
	 * 
	 * <p>
	 * The YouTubeViewer is a module that uses the YouTube API to display video content from YouTube in the form of an interactive video player window. 
	 * Video can be streamed from a specified YouTube account along with associated meta data.  
	 * Youtube account preferences along with the formatting and basic appearance of the video windows can be defined from the module XML file.
	 * Multiple touch object images can be displayed on stage and each touch object can be interacted with using the TAP, DRAG, SCALE and ROTATE multitouch gestures.  
	 * All multitouch gestures can be activated and deactivated using the module XML settings.</p>
	 *
	 * <strong>Imported Components :</strong>
	 * <pre>
	 * YouTubeDisplay
	 * YouTubeParser</pre>
	 * 
	 *
	 * <listing version="3.0">
	 * var youTubeViewer:YouTubeViewer = new YouTubeViewer();
	 *
	 * addChild(youTubeViewer);</listing>
	 *
	 * @see id.core.TouchComponent
	 * @see id.component.YouTube
	 * 
	 * @includeExample YouTubeViewer.as
	 * 
	 * @langversion 3.0
	 * @playerversion AIR 2
	 * @playerversion Flash 10.1
	 * @playerversion Flash Lite 4
	 * @productversion GestureWorks 2.0
	 */
	 
	public class YouTubeViewer extends TouchComponent
	{
		/**
		 *
		 * The DisplayObject is an Array of all display objects added to the stage.
		 * <pre>
		 * <strong>displayObject.push(flickrDisplay);</strong></pre>
		 *
		 */
	 	public static var COMPLETE:String = "complete";
		public var displayObject:Array = new Array();
		private var youtubeDisplay:YouTubeDisplay;
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
		 * <strong>var youTubeViewer:YouTubeViewer = new YouTubeViewer();
		 * addChild(youTubeViewer);</strong></pre>
		 *
		 */
		public function YouTubeViewer()
		{
			super();
			YouTubeParser.addEventListener(Event.COMPLETE, onParseComplete);
			YouTubeParser.settingsPath="library/data/YouTubeViewer.xml";
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
			for (count=0; count<YouTubeParser.amountToShow; count++)
			{
				addObject(count);
			}
			
			for (var id:int=count; id<YouTubeParser.totalAmount; id++)
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
			youtubeDisplay=new YouTubeDisplay();
			youtubeDisplay.id=id;
			youtubeDisplay.moduleName="YouTubeViewer";
			idDisplayed.push(id);
			
			displayObject.push(youtubeDisplay);
						
			if (parent is TouchComponent)
			{
				youtubeDisplay.alpha=0;
				
				if(count+1==YouTubeParser.amountToShow)
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
				addChild(youtubeDisplay);
				if(count+1==YouTubeParser.amountToShow)
				{
					isLoaded=true;
				}
				
				if(isLoaded)
				{
					dispatchEvent(new Event(YouTubeViewer.COMPLETE));
					displayObject=[];
				}
			}
		}
		
	}
}