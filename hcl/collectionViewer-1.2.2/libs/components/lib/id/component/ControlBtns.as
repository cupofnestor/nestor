////////////////////////////////////////////////////////////////////////////////
//
//  OPEN EXHIBITS
//  Copyright 2010-2011 OPEN EXHIBITS
//  All Rights Reserved.
//
//  ControlBtns
//
//  File:     ControlBtns.as
//  Author:    Mattthew Valverde (matthew(at)ideum(dot)com)
//
//  NOTICE: OPEN EXHIBITS permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package id.component
{
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.display.DisplayObjectContainer;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.text.TextField;
	import flash.media.Video;
	import id.core.TouchComponent;
	import gl.events.TouchEvent;
	import id.element.InfoButton;
	import id.element.CloseButton;
	import id.element.PlayButton;
	import id.element.PauseButton;
	import id.element.BackButton;
	import id.element.ForwardButton;
	import id.element.TimeDisplay;
	import id.element.CustomGraphic;

	/**
	 * <p>
	 * The ControlBtns are a component made up of button elements that provide a way to switch between information or metadata and your media type.  Such as an image or video.
	 * </p>
	 *
	 * <strong>Imported Components :</strong>
	 * <pre>
	 * InfoButton
	 * CloseButton
	 * PlayButton
	 * PauseButton
	 * BackButton
	 * ForwardButton
	 * TimeDisplay
	 * CustomGraphic
	 * </pre>
	 *
	 * <listing version="3.0">
	 * var controlBtns:ControlBtns = new ControlBtns(); 
	 *
	 * 		controlBtns.width = Number;
	 *
	 * 		controlBtns.styleList = XMLList;
	 *
	 * 		controlBtns.scaleLock = true;
	 *
	 * 		controlBtns.scale = Number;
	 *
	 * 		controlBtns.type = "video";
	 
	 * addChild(controlBtns);</listing>
	 *
	 * @see id.core.TouchComponent
	 * 
	 * @includeExample ControlBtns.as
	 * 
	 * @langversion 3.0
	 * @playerversion AIR 2
	 * @playerversion Flash 10.1
	 * @playerversion Flash Lite 4
	 * @productversion GestureWorks 2.0
	 */
	public class ControlBtns extends TouchComponent
	{
		public static var INFO_CALL:String="infoCall";
		public static var PLAY:String="Play";
		public static var PAUSE:String="Pause";
		public static var BACK:String="Backward";
		public static var FORWARD:String="Forward";
		
		private var infoUpdate:Boolean;
		private var playUpdate:Boolean;
		private var pauseUpdate:Boolean;
		private var backUpdate:Boolean;
		private var forwardUpdate:Boolean;
		
		private var _initialized:Boolean;
		private var _width:Number=0;
		private var _height:Number=0;
		private var background:CustomGraphic;
		private var _scale:Number=1;
		private var _type:String="image";
		private var _scaleLock:Boolean=true;
		
		private var infoButton:InfoButton;
		private var closeButton:CloseButton;
		private var playButton:PlayButton;
		private var pauseButton:PauseButton;
		private var backButton:BackButton;
		private var forwardButton:ForwardButton;
		private var time:TimeDisplay;
		
		private var video:Boolean;
		private var _stylelist:Object;
		private var buttonRad:Number;
		private var buttonPad:Number;
		
		private var rightSide:Number;
		private var leftSide:Number;
		
		private var disposeArray:Array = new Array();
		
		private var _style:Object=
		{
		buttonRadius:21,
		buttonPadding:4
		};


		/**
		 *
		 * The Constructor.
		 * <pre>
		 * <strong>var controlBtns:ControlBtns = new ControlBtns();
		 * addChild(controlBtns);</strong></pre>
		 *
		 */
		public function ControlBtns()
		{
			super();

			createUI();
			commitUI();
			layoutUI();
			updateUI();

			_initialized=true;
		}
		
		private function destroyChildren(child:*):void
		{
			if (! child)
			{
				return;
			}

			disposeArray.push(child);

			for (var idx:int=0; idx<child.numChildren; idx++)
			{
				var nested:* =child.getChildAt(idx);
				
				var sprite:Sprite=nested as Sprite;
				if (sprite)
				{
					nested.parent.removeChild(sprite);
					sprite=null;
					return;
				}
				
				var shape:Shape=nested as Shape;
				if (shape)
				{
					nested.parent.removeChild(shape);
					shape=null;
					return;
				}
				
				var txtField:TextField=nested as TextField;
				if (txtField)
				{
					nested.parent.removeChild(txtField);
					txtField=null;
					return;
				}
				
				var video:Video=nested as Video;
				if (video)
				{
					nested.parent.removeChild(video);
					video=null;
					return;
				}

				var loader:Loader=nested as Loader;
				if (loader)
				{
					loader.unload();
					nested.parent.removeChild(loader);
					loader=null;
					return;
				}

				var bitmap:Bitmap=nested as Bitmap;
				if (bitmap)
				{
					bitmap.bitmapData.dispose();
					nested.parent.removeChild(bitmap);
					bitmap.bitmapData=null;
					bitmap=null;
					return;
				}

				nested.Dispose();
				nested=null;
			}
		}

		/**
		 *
		 * The Disposal method for the module. It will clean out and nullify all children.
		 * <pre>
		 * <strong>controlBtns.Dispose();</strong></pre>
		 *
		 */
		override public function Dispose():void
		{
			closeButton.removeEventListener(TouchEvent.TOUCH_DOWN, closedownHandler);
			infoButton.removeEventListener(TouchEvent.TOUCH_DOWN, infodownHandler);
			
			if (video)
			{
				playButton.removeEventListener(TouchEvent.TOUCH_DOWN, playButtonHandler);
				pauseButton.removeEventListener(TouchEvent.TOUCH_DOWN, pauseButtonHandler);
				backButton.removeEventListener(TouchEvent.TOUCH_DOWN, backBtnHandler);
				forwardButton.removeEventListener(TouchEvent.TOUCH_DOWN, forwardBtnHandler);
				
			}
			
			for (var i:int=0; i<numChildren; i++)
			{
				destroyChildren(getChildAt(i) as DisplayObjectContainer);
			}
			
			for (var j:int=0; j<disposeArray.length; j++)
			{
				disposeArray[j].Dispose();
				disposeArray[j]=null;
			}

			disposeArray=[];
			disposeArray=null;
						
			if (parent)
			{
				parent.removeChild(this);
			}
		}

		/**
		 *
		 * @private
		 *
		 */
		override public function get width():Number
		{
			return _width;
		}
		/**
		 *
		 * @private
		 *
		 */
		override public function set width(value:Number):void
		{
			_width=value;
			updateUI();
		}
		
		/**
		 *
		 * @private
		 *
		 */
		override public function get height():Number
		{
			return _height;
		}
		/**
		 *
		 * @private
		 *
		 */
		override public function set height(value:Number):void
		{
			_height=value;
			updateUI();
		}
		
		
		public function get scale():Number
		{
			return _scale;
		}
		/**
		 *
		 * Set scale for control buttons.  Contains functionality for reverse scale handling.
		 *
		 * <pre>
		 * <strong>controlBtns.scale = Number;</strong></pre>
		 * 
		 *
		 * @default : 1
		 */
		public function set scale(value:Number):void
		{
			if(_scaleLock)
			{
				scaleX=1/value;
				scaleY=1/value;
			}
			
			_scale=value;
						
			updateUI();
		}
				 
		public function get scaleLock():Boolean
		{
			return _scaleLock;
		}
		/**
		 *
		 * Sets True or False weather scale is inversed or not.
		 *
		 * <pre>
		 * <strong>controlBtns.scaleLock = true;</strong></pre>
		 * 
		 *
		 * @default : true
		 */
		public function set scaleLock(value:Boolean):void
		{			
			_scaleLock=value;
		}
		
		public function get styleList():Object
		{
			return _stylelist;
		}
		/**
		 *
		 * Sets styling for the Control Buttons component .
		 * <pre>
		 * <strong>controlBtns.styleList = XMLList;</strong></pre>
		 * 
		 *
		 * @default : 
		 * buttonRadius:21,
		 * buttonPadding:4
		 *
		 */
		public function set styleList(value:Object):void
		{
			
			if (value.buttonRadius!=undefined&&value.buttonRadius!="")
			{
				_style.buttonRadius=value.buttonRadius;
			}

			if (value.buttonPadding!=undefined&&value.buttonPadding!="")
			{
				_style.buttonPadding=value.buttonPadding;
			}

			_stylelist=value;

			layoutUI();
		}

		
		public function get type():String
		{
			return _type;
		}
		/**
		 *
		 * Sets type of control buttons to "normal" or "video".
		 *
		 * <pre>
		 * <strong>controlBtns.type = "video";</strong></pre>
		 * 
		 *
		 * @default : normal
		 */
		public function set type(value:String):void
		{
			_type=value;
			if (_type=="video")
			{
				video=true;
				addVideoControls();
				layoutUI();
				updateUI();
			}
		}

		/**
		 *
		 * Sets time for the time display.
		 *
		 * <pre>
		 * <strong>controlBtns.timeText = Number;</strong></pre>
		 * 
		 *
		 * @default : 00:00
		 */
		public function set timeText(value:String):void
		{
			time.text=value;
		}

		override protected function createUI():void
		{
			background = new CustomGraphic();
			infoButton=new InfoButton();
			closeButton=new CloseButton();

			addChild(background);
			addChild(infoButton);
			addChild(closeButton);

			closeButton.addEventListener(TouchEvent.TOUCH_DOWN, closedownHandler);
			infoButton.addEventListener(TouchEvent.TOUCH_DOWN, infodownHandler);
		}

		override protected function commitUI():void
		{
			
		}

		override protected function layoutUI():void
		{
			buttonRad=Number(_style.buttonRadius);
			buttonPad=Number(_style.buttonPadding);
			
			_height=(buttonRad*2)+(buttonPad*2);
			_width=(buttonRad*4)+(buttonPad*4);
			
			background.styleList=_stylelist;
			background.width=width*_scale;
			background.height=height;
			background.x=0-(width*_scale);
			
			if (video)
			{				
				playButton.styleList=_stylelist;
				pauseButton.styleList=_stylelist;
				pauseButton.active.visible=true;
				backButton.styleList=_stylelist;
				forwardButton.styleList=_stylelist;
				time.styleList=_stylelist;

				playButton.y=background.height/2;
				pauseButton.y=background.height/2;
				backButton.y=background.height/2;
				forwardButton.y=background.height/2;
				time.y=(background.height-time.height)/2;
			}
			
			infoButton.toggle=true;
			infoButton.styleList=_stylelist;
			closeButton.styleList=_stylelist;
			
			closeButton.y=background.height/2;
			infoButton.y=background.height/2;
			
			closeButton.x=background.x+(background.width-buttonRad-buttonPad);
			infoButton.x=closeButton.x-height;
		}

		override protected function updateUI():void
		{
			if (video)
			{
				background.width=width*_scale;
				background.x=0-background.width;
				playButton.x=background.x+buttonRad+buttonPad;
				pauseButton.x=playButton.x+height;
				backButton.x=pauseButton.x+height;
				forwardButton.x=backButton.x+height;
				time.x=background.x+((background.width-time.width)/2);
				closeButton.x=background.x+(background.width-buttonRad-buttonPad);
				infoButton.x=closeButton.x-height;
			}
			background.outlineStroke=1*_scale;
		}

		private function addVideoControls():void
		{
			playButton = new PlayButton();
			pauseButton = new PauseButton();
			backButton = new BackButton();
			forwardButton = new ForwardButton();
			time = new TimeDisplay();

			addChild(playButton);
			addChild(pauseButton);
			addChild(backButton);
			addChild(backButton);
			addChild(forwardButton);
			addChild(time);
			
			playButton.addEventListener(TouchEvent.TOUCH_DOWN, playButtonHandler);
			pauseButton.addEventListener(TouchEvent.TOUCH_DOWN, pauseButtonHandler);
			backButton.addEventListener(TouchEvent.TOUCH_DOWN, backBtnHandler);
			forwardButton.addEventListener(TouchEvent.TOUCH_DOWN, forwardBtnHandler);
		}

		private function infodownHandler(event:TouchEvent):void
		{
			if(event)
			{
				event.stopImmediatePropagation();
			}
			
			if (video)
			{
				pauseButtonHandler(null);
			}
			dispatchEvent(new Event(ControlBtns.INFO_CALL, true, true));
		}

		private function playButtonHandler(event:TouchEvent):void
		{
			if(event)
			{
				event.stopImmediatePropagation();
			}
			
			if(!playButton.active.visible)
			{
				playButton.active.visible=true;
				pauseButton.active.visible=false;
				dispatchEvent(new Event(ControlBtns.PLAY, true, true));
			}
		}

		private function pauseButtonHandler(event:TouchEvent):void
		{
			if(event)
			{
				event.stopImmediatePropagation();
			}
			
			playButton.active.visible=false;
			pauseButton.active.visible=true;
			dispatchEvent(new Event(ControlBtns.PAUSE, true, true));
		}

		private function backBtnHandler(event:TouchEvent):void
		{
			if(event)
			{
				event.stopImmediatePropagation();
			}
			
			//playButton.active.visible=false;
			//pauseButton.active.visible=true;
			dispatchEvent(new Event(ControlBtns.BACK, true, true));
		}
		
		private function forwardBtnHandler(event:TouchEvent):void
		{
			if(event)
			{
				event.stopImmediatePropagation();
			}
			//playButton.active.visible=false;
			//pauseButton.active.visible=true;
			dispatchEvent(new Event(ControlBtns.FORWARD, true, true));
		}

		private function closedownHandler(event:TouchEvent):void
		{
			if(event)
			{
				event.stopImmediatePropagation();
			}
			
			if (parent is TouchComponent)
			{
				var par:TouchComponent=TouchComponent(parent);
				par.Dispose();
			}
		}

	}
}