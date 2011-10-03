﻿package id.module
{
	import flash.events.Event;
	import id.core.TouchComponent;
	import id.component.FlickrDisplay;
	import id.element.FlickrParser;
	import id.core.ApplicationGlobals;
	
	/**
	 * 
	 * <p>
	 * The FlickrViewer is a module designed to display media content using the Flickr API.  
	 * Selected Bitmap data and short video files are downloaded from a defined Flickr user account along with associated meta data.  
	 * User account settings, image and video preferences and basic formatting can be specified using the module XML file.  
	 * Multiple touch object images and videos can be displayed on stage and each touch object can be manipulated using the TAP, DRAG, SCALE and ROTATE multitouch gestures.  
	 * All multitouch gestures can be activated and deactivated using the module XML settings.</p>
	 *
	 * <strong>Imported Components :</strong>
	 * <pre>
	 * FlickrDisplay
	 * FlickrParser</pre>
	 *
	 * <listing version="3.0">
	 * var flickrViewer:FlickrViewer = new FlickrViewer();
	 *
	 * addChild(flickrViewer);</listing>
	 *
	 * @see id.core.TouchComponent
	 * @see id.component.FlickrDisplay
	 * 
	 * @includeExample FlickrViewer.as
	 * 
	 * @langversion 3.0
	 * @playerversion AIR 2
	 * @playerversion Flash 10.1
	 * @playerversion Flash Lite 4
	 * @productversion GestureWorks 2.0
	 */
	 
	public class FlickrViewer extends TouchComponent
	{
		private var flickrDisplay:FlickrDisplay;
		public static var COMPLETE:String = "complete";
		/**
		 *
		 * The DisplayObject is an Array of all display objects added to the stage.
		 * <pre>
		 * <strong>displayObject.push(flickrDisplay);</strong></pre>
		 *
		 */
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
		 * <strong>var flickrViewer:FlickrViewer = new FlickrViewer();
		 * addChild(flickrViewer);</strong></pre>
		 *
		 */
		public function FlickrViewer()
		{
			super();
			
			FlickrParser.addEventListener(Event.COMPLETE, onParseComplete);
			FlickrParser.settingsPath="library/data/FlickrViewer.xml";
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
			for (count=0; count<FlickrParser.amountToShow; count++)
			{
				addObject(count);
			}
			
			for (var id:int=count; id<FlickrParser.totalAmount; id++)
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
			flickrDisplay=new FlickrDisplay();
			flickrDisplay.id=id;
			
			flickrDisplay.moduleName="FlickrViewer";
			idDisplayed.push(id);
			
			displayObject.push(flickrDisplay);
						
			if (parent is TouchComponent)
			{
				flickrDisplay.alpha=0;
				
				if(count+1==FlickrParser.amountToShow)
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
				addChild(flickrDisplay);
				
				if(count+1==FlickrParser.amountToShow)
				{
					isLoaded=true;
				}
				
				if(isLoaded)
				{
					dispatchEvent(new Event(FlickrViewer.COMPLETE));
					displayObject=[];
				}
			}
		}
		
	}
}