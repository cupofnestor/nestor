////////////////////////////////////////////////////////////////////////////////
//
//  OPEN EXHIBITS
//  Copyright 2010-2011 OPEN EXHIBITS
//  All Rights Reserved.
//
//  ImageViewer
//
//  File:     ImageViewer.as
//  Author:    Mattthew Valverde (matthew(at)ideum(dot)com)
//
//  NOTICE: OPEN EXHIBITS permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package id.module
{
	import flash.events.Event;
	import id.core.TouchComponent;
	import id.component.ImageDisplay;
	import id.element.Parser;
	import id.core.ApplicationGlobals;

	/**
	 * 
	 * <p>
	 * The ImageViewer is a module designed to display media content in the form of static images. Bitmap data files such as PNG, GIF and JPG along with associated meta data and basic formatting can be defined using a simple XML file.
	 * Multiple touch object images can be displayed on stage and each touch object can be manipulated using the TAP, DRAG, SCALE and ROTATE multitouch gestures.
	 * All multitouch gestures can be activated and deactivated using the module XML settings.</p>
	 *
	 * <strong>Imported Components :</strong>
	 * <pre>
	 * ImageDisplay
	 * Parser</pre>
	 * 
	 *
	 * <listing version="3.0">
	 * var imageViewer:ImageViewer = new ImageViewer();
	 *
	 * addChild(imageViewer);</listing>
	 *
	 * @see id.core.TouchComponent
	 * @see id.component.ImageDisplay
	 * 
	 * @includeExample ImageViewer.as
	 * 
	 * @langversion 3.0
	 * @playerversion AIR 2
	 * @playerversion Flash 10.1
	 * @playerversion Flash Lite 4
	 * @productversion GestureWorks 2.0
	 */

	public class ImageViewer extends TouchComponent
	{
		/**
		 *
		 * The DisplayObject is an Array of all display objects added to the stage.
		 * <pre>
		 * <strong>displayObject.push(imageDisplay);</strong></pre>
		 *
		 */
		public var displayObject:Array = new Array();
		public static var COMPLETE:String = "complete";
		private var imageDisplay:ImageDisplay;
		private var _id:int;
		private var _settingsPath:String="";
		private var count:int;
		private var idDisplayed:Array = new Array();
		private var idWaiting:Array = new Array();		
		public var moduleID:int;
		private var _moduleName:String="";
		
		private var isLoaded:Boolean;
		private var parserIsCalled:Boolean;
				
		/**
		 *
		 * The Constructor.
		 * <pre>
		 * <strong>var imageViewer:ImageViewer = new ImageViewer();
		 * addChild(imageViewer);</strong></pre>
		 *
		 */

		public function ImageViewer()
		{
			super();
			Parser.settingsPath="library/data/ImageViewer.xml";
			Parser.addEventListener(Event.COMPLETE,onParseComplete);
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
			for (count=0; count<Parser.amountToShow; count++)
			{
				addObject(count);
			}
			
			for (var id:int=count; id<Parser.totalAmount; id++)
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
			imageDisplay=new ImageDisplay();
			imageDisplay.id=id;
			imageDisplay.moduleName="ImageViewer";
			idDisplayed.push(id);
			
			displayObject.push(imageDisplay);
			
			if (parent is TouchComponent)
			{
				imageDisplay.alpha=0;
				
				if(count+1==Parser.amountToShow)
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
				addChild(imageDisplay);
				
				if(count+1==Parser.amountToShow)
				{
					isLoaded=true;
				}
				
				if(isLoaded)
				{
					dispatchEvent(new Event(ImageViewer.COMPLETE));
					displayObject=[];
				}
				
			}
		}
		
	}
}