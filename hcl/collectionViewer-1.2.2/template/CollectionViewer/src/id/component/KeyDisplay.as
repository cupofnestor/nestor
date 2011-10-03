package id.component
{
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	import id.core.ApplicationGlobals;
	import id.core.TouchComponent;
	import id.element.KeyParser;
	import id.element.Graphic;
	import id.element.KeyButton;
	import gl.events.TouchEvent;
	import gl.events.GestureEvent;
	import com.greensock.TweenLite;

	/**
	 * <p>The KeyDisplay component is the main component for the KeyViewer module.  It contains all the neccessary display objects for the module.</p>
	 *
	 * <p>
	 * The KeyViewer module constructs a simple extend-able onscreen keyboard which can be omni-directionally repositioned and re-sized onstage using multitouch gestures.  
	 * Detailed aspects of the keyboard appearance such as key size, color and separation as well as dynamic interactions can be customized using the module XML.</p>
	 * <strong>Imported Components :</strong>
	 * <pre>
	 * Graphic
	 * KeyButton
	 * TouchGesturePhysics
	 * KeyParser
	 * </pre>
	 *
	 * <listing version="3.0">
	 * var keyDisplay:KeyDisplay = new KeyDisplay();
	 *
	 * addChild(keyDisplay);</listing>
	 *
	 * @see id.core.TouchComponent
	 * 
	 * @includeExample KeyDisplay.as
	 * 
	 * @langversion 3.0
	 * @playerversion AIR 2
	 * @playerversion Flash 10.1
	 * @playerversion Flash Lite 4
	 * @productversion GestureWorks 2.0
	 */
	public class KeyDisplay extends TouchComponent
	{
		public static var RETURN_EVENT:String="event return";
		public var outputString:String;
		private var _initialized:Boolean;
		private var keyStyle:Object;
		private var fingerBoard:TouchComponent;
		private var keys:Graphic;
		private var keyButton:KeyButton;
		private var background:Graphic;
		private var key:Object;
		private var capsKey:Object;
		private var dragGesture:Boolean=true;
		private var rotateGesture:Boolean=true;
		private var scaleGesture:Boolean=true;
		private var doubleTapGesture:Boolean=true;
		private var flickGesture:Boolean=true;
		private var keyDictionary:Dictionary;
		private var shiftKeys:Dictionary;
		private var _listeners:Boolean;
		private var listenerUpdate:Boolean;
		private var shift:Boolean;
		private var capital:Boolean;
		private var capsOn:Boolean;
		private var scale:Number;
		private var keyAlpha:Number;
		private var keyAlphaOnSelect:Number;
		private var padding:Number;
		private var minScale:Number;
		private var maxScale:Number;
		private var keysWidth:Number;
		private var keysHeight:Number;
		private var backgroundStyle:Object;
		private var stageWidth:Number;
		private var stageHeight:Number;


		/**
		 *
		 * The Constructor.
		 * <pre>
		 * <strong>var keyDisplay:KeyDisplay = new KeyDisplay();
		 * addChild(keyDisplay);</strong></pre>
		 *
		 */
		public function KeyDisplay()
		{
			super();

			createUI();
			commitUI();
			updateUI();
		}
		
		/**
		 *
		 * The Disposal method for the module. It will clean out and nullify all children.
		 * <pre>
		 * <strong>keyDisplay.Dispose();</strong></pre>
		 *
		 */
		override public function Dispose():void
		{
			listeners=false;

			if (keys)
			{
				if (key)
				{
					for each (key in keyDictionary)
					{
						//keys.removeChild(key);
						//key=null;
					}
				}
				keyDictionary=null;
				fingerBoard.removeChild(keys);
			}

			if (background)
			{
				fingerBoard.removeChild(background);
			}

			if (dragGesture)
			{
				removeEventListener(TouchEvent.TOUCH_DOWN, touchDownHandler);
				removeEventListener(TouchEvent.TOUCH_UP, touchUpHandler);
			}

			if (doubleTapGesture)
			{
				removeEventListener(TouchEvent.TOUCH_DOUBLE_TAP, doubleTapHandler);
			}

			if (flickGesture)
			{
				removeEventListener(GestureEvent.GESTURE_FLICK, flickGestureHandler);
			}

			if (scaleGesture)
			{
				removeEventListener(GestureEvent.GESTURE_SCALE, scaleGestureHandler);
			}

			if (rotateGesture)
			{
				removeEventListener(GestureEvent.GESTURE_ROTATE, rotateGestureHandler);
			}

			if (parent)
			{
				parent.removeChild(this);
			}
		}

		/**
		 *
		 * Add or Remove event listeners with True or False...
		 * <pre>
		 * <strong>listeners = true;</strong></pre>
		 *
		 * @default : false
		 */
		public function get listeners():Boolean{return _listeners;}
		public function set listeners(value:Boolean):void
		{
			_listeners=value;
			listenerUpdate=true;
			updateUI();
		}

		override protected function createUI():void
		{
			scale=KeyParser.settings.GlobalSettings.objectScale;
			keyAlpha=KeyParser.settings.Key.keyAlpha;
			keyAlphaOnSelect=KeyParser.settings.Key.keyAlphaOnSelect;
			padding=KeyParser.settings.Background.padding;
			maxScale=KeyParser.settings.GlobalSettings.maxScale;
			minScale=KeyParser.settings.GlobalSettings.minScale;
			stageWidth=ApplicationGlobals.application.stage.stageWidth;
			stageHeight=ApplicationGlobals.application.stage.stageHeight;
			
			keysWidth=KeyParser.settings.keysWidth;
			keysHeight=KeyParser.settings.keysHeight;
			backgroundStyle=KeyParser.settings.Background;
			
			if(!maxScale || !minScale)
			{
				maxScale=2;
				minScale=.5;
			}
			
			blobContainerEnabled=true;

			keyDictionary=new Dictionary();
			shiftKeys=new Dictionary();
			fingerBoard = new TouchComponent();
			background = new Graphic();
			keys = new Graphic();

			for(var i:int=0; i<KeyParser.layout.length; i++)
			{
				keyButton = new KeyButton();
				keyDictionary[keyButton]=keyButton;
				keyButton.styleList=KeyParser.layout[i];
				keys.addChild(keyButton);

				if (KeyParser.layout[i].shift)
				{
					shiftKeys[keyButton]=keyButton;
				}
				
				if(KeyParser.layout[i].capital)
				{
					capsKey=keyButton;
				}
			}

			fingerBoard.addChild(background);
			fingerBoard.addChild(keys);
			addChild(fingerBoard);

			if (dragGesture)
			{
				addEventListener(TouchEvent.TOUCH_DOWN, touchDownHandler);
				addEventListener(TouchEvent.TOUCH_UP, touchUpHandler);
			}

			if (doubleTapGesture)
			{
				addEventListener(TouchEvent.TOUCH_DOUBLE_TAP, doubleTapHandler);
			}

			if (flickGesture)
			{
				addEventListener(GestureEvent.GESTURE_FLICK, flickGestureHandler);
			}

			if (scaleGesture)
			{
				addEventListener(GestureEvent.GESTURE_SCALE, scaleGestureHandler);
			}

			if (rotateGesture)
			{
				addEventListener(GestureEvent.GESTURE_ROTATE, rotateGestureHandler);
			}
			
			addEventListener("dragging", dragHandler);
		}

		override protected function commitUI():void
		{
			keys.width=keysWidth;
			keys.height=keysHeight;
			keys.alpha=0;
			
			keys.scaleX=scale;
			keys.scaleY=scale;
			
			background.styleList=backgroundStyle;
			background.width=(keys.width*scale)+((padding*2)*scale), 
			background.height=(keys.height*scale)+((padding*2)*scale), 
			
			keys.x=(background.width-keys.width*scale)/2;
			keys.y=(background.height-keys.height*scale)/2;

			width=background.width;
			height=background.height;

			fingerBoard.x=(0-width/2);
			fingerBoard.y=(0-height/2);
		}

		override protected function updateUI():void
		{
			
			if (! _initialized)
			{
				listenerUpdate=true;
				_listeners=true;
			}

			if (listenerUpdate)
			{
				for each (key in keyDictionary)
				{
					if (_listeners)
					{
						key.addEventListener(TouchEvent.TOUCH_DOWN, key_Down);
						key.addEventListener(TouchEvent.TOUCH_UP, key_Up);

					}
					else
					{
						key.removeEventListener(TouchEvent.TOUCH_DOWN, key_Down);
						key.removeEventListener(TouchEvent.TOUCH_UP, key_Up);
					}
				}
				
				keys.blobContainerEnabled=_listeners;
				keys.pointTargetRediscovery=_listeners;

				listenerUpdate=false;
			}
			
			_initialized=true;
			
			super.updateUI();
		}

		private function key_Down(event:TouchEvent):void
		{
			if (event.target.shift)
			{
				for each (key in shiftKeys)
				{
					key.alpha=keyAlphaOnSelect;
				}

				shiftKey();
				return;
			}

			event.target.alpha=keyAlphaOnSelect;

			if (event.target.capital)
			{
				capitolizeKeys();
				capsOn=true;
				return;
			}

			if (! capital&&! shift)
			{
				outputString=event.target.action;
			}

			if (capital)
			{
				outputString=event.target.capsAction;
			}

			if (shift)
			{
				outputString=event.target.shiftAction;
			}
			
			dispatchEvent(new Event(KeyDisplay.RETURN_EVENT, true, true));
		}

		private function key_Up(event:TouchEvent):void
		{
			if (capital && event.target.capital)
			{
				if (shift)
				{
					shift=false;
					for each (key in shiftKeys)
					{
						key.alpha=keyAlpha;
					}
				}
				return;
			}
			
			if(shift && event.target.shift)
			{
				if(capsOn)
				{
					capital=false;
					capsKey.alpha=keyAlpha;
				}
				return;
			}
			
			if(event.target.shift)
			{
				for each (key in shiftKeys)
				{
					key.alpha=keyAlpha;
				}
			}

			if (shift)
			{
				for each (key in shiftKeys)
				{
					key.alpha=keyAlpha;
				}
				shiftKey();
			}

			event.target.alpha=keyAlpha;
		}

		private function touchDownHandler(event:TouchEvent):void
		{
			startTouchDrag(-1);
			parent.setChildIndex(this as DisplayObject,parent.numChildren-1);
		}

		private function touchUpHandler(event:TouchEvent):void
		{
			stopTouchDrag(-1);
		}

		private function doubleTapHandler(e:TouchEvent):void
		{
			if (scaleX<1)
			{
				listeners=true;
				
				TweenLite.to(this, .5,{alpha:keyAlpha, scaleX:1, scaleY:1, onUpdate:updateUI});
			}
		}

		private function flickGestureHandler(event:GestureEvent):void
		{
		}

		private function scaleGestureHandler(event:GestureEvent):void
		{
			scaleX+=event.value;
			scaleY+=event.value;

			scaleY=scaleY>maxScale?maxScale:scaleY<minScale?minScale:scaleY;
			scaleX=scaleX>maxScale?maxScale:scaleX<minScale?minScale:scaleX;
			
			if (scaleX<1)
			{
				listeners=false;
				alpha=keyAlphaOnSelect;
			}
			else
			{
				listeners=true;
				alpha=keyAlpha;
			}
		}

		private function rotateGestureHandler(event:GestureEvent):void
		{
			rotation+=event.value;
		}
		
		private function touchMoveHandler(event:TouchEvent):void
		{
		}
		
		private function dragHandler(event:TouchEvent):void
		{
			if (parent is TouchComponent)
			{
				super.updateUI();
			}
		}

		private function shiftKey():void
		{
			if (! shift)
			{
				shift=true;
				for each (key in keyDictionary)
				{
					key.setShiftTxt();
				}
			}
			else
			{
				shift=false;
				for each (key in keyDictionary)
				{
					key.setNormalTxt();
				}
			}
		}

		private function capitolizeKeys():void
		{
			if (! capital)
			{
				capital=true;
				for each (key in keyDictionary)
				{
					key.setCapsTxt();
				}
			}
			else
			{
				capital=false;
				for each (key in keyDictionary)
				{
					key.setNormalTxt();
				}
			}
		}
		
	}
}