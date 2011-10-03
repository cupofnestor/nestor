package id.component
{
	import id.core.TouchComponent
	import id.element.TextDisplay;
	import id.element.Graphic;

	/**
	 * <p>
	 * The KeyNotePad component is an extention of the KeyViewer module. The KeyNotePad is utlized for output text or key strokes that come from the KeyDisplay component.</p>
	 * <p>
	 * The KeyViewer module constructs a simple extend-able onscreen keyboard which can be omni-directionally repositioned and re-sized onstage using multitouch gestures.  
	 * Detailed aspects of the keyboard appearance such as key size, color and separation as well as dynamic interactions can be customized using the module XML.</p>
	 *
	 * <strong>Import Classes:</strong>
	 * <pre>
	 * TextDisplay
	 * Graphic
	 * </pre>
	 *
	 * <listing version="3.0">
	 * var keyNotePad:KeyNotePad = new KeyNotePad();
	 *
	 * addChild(keyNotePad);</listing>
	 *
	 * @see id.core.TouchComponent
	 * 
	 * @includeExample KeyNotePad.as
	 * 
	 * @langversion 3.0
	 * @playerversion AIR 2
	 * @playerversion Flash 10.1
	 * @playerversion Flash Lite 4
	 * @productversion GestureWorks 2.0
	 */
	public class KeyNotePad extends TouchComponent
	{
		private var _initialized:Boolean;
		private var txt:TextDisplay;
		private var background:Graphic;
		private var _text:String="";
		private var _width:Number=100;
		private var _height:Number=100;
		
		private var _style:Object=
		{
		fillColor1:0x333333,
		fontColor:0xFFFFFF,
		fontSize:15
		};

		/**
		 *
		 * The Constructor.
		 * <pre>
		 * <strong>var keyNotePad:KeyNotePad = new KeyNotePad();
		 * addChild(keyNotePad);</strong></pre>
		 *
		 */
		public function KeyNotePad()
		{
			super();
			
			visible=false;
			
			createUI();
			commitUI();
			layoutUI();

			_initialized = true;
		}
		
		/**
		 *
		 * The Disposal method for the module. It will clean out and nullify all children.
		 * <pre>
		 * <strong>flickrDisplay.Dispose();</strong></pre>
		 *
		 */
		override public function Dispose():void
		{
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
			layoutUI();
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
			layoutUI();
		}
		
		public function get styleList():Object{return _style;}
		/**
		 *
		 * Sets styling for the KeyNotePad component .
		 * <pre>
		 * <strong>keyNotePad.styleList = XMLList;</strong></pre>
		 * 
		 *
		 * @default : 
		 * fillColor1:0x333333,
		 * fontColor:0xFFFFFF,
		 * fontSize:15
		 *
		 */
		public function set styleList(value:Object):void
		{			
			if(value.fontColor!=undefined && value.fontColor!="")
			{
				_style.fontColor=value.fontColor;
			}
			
			if(value.fontSize!=undefined && value.fontSize!="")
			{
				_style.fontSize=value.fontSize;
			}
			
			if(value.fillColor1!=undefined && value.fillColor1!="")
			{
				_style.fillColor1=value.fillColor1;
			}
			
			layoutUI();
		}
		
		public function get text ():String
		{
			return _text;
		}
		/**
		 *
		 * Sets teh text value for the TextDisplay component.
		 * <pre>
		 * <strong>keyNotePad.text="text";</strong></pre>
		 *
		 */
		public function set text (value:String):void
		{
			_text = value;
			updateUI();
		}
		
		override protected function createUI():void
		{
			background = new Graphic();
			txt = new TextDisplay();
			addChild(background);
			addChild(txt);
		}

		override protected function commitUI():void
		{
			txt.appendText=true;
		}
		
		override protected function layoutUI():void
		{
			txt.textWidth=width-15;
			txt.color=_style.fontColor;
			txt.size=_style.fontSize;
			background.fillColor1=_style.fillColor1;
		}
		
		override protected function updateUI():void
		{
			txt.text=_text;
			background.width=txt.width+15;
			background.height=txt.height+5;
			
			_height=background.height;
			
			visible=true;
		}		
		
	}
}