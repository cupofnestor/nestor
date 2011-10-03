package id.element
{
	import flash.filters.DropShadowFilter;
	import id.core.TouchComponent;
	import id.element.Graphic;
	import id.element.KeyParser;
	import id.element.TextDisplay;
	
	/**
	 * This is the KeyButton class.
	 * 
	 * @langversion 3.0
	 * @playerversion AIR 2
	 * @playerversion Flash 10
	 * @playerversion Flash Lite 4
	 * @productversion GestureWorks 2.0
	 */
	public class KeyButton extends TouchComponent
	{
		public var capital:Boolean;
		public var shift:Boolean;
		public var action:String;
		public var capsAction:String;
		public var shiftAction:String;
		private var _initialized:Boolean;
		private var _object:Object;
		private var background:Graphic;
		private var txt:TextDisplay;
		private var _text:String;

		private var dropShadow:DropShadowFilter = new DropShadowFilter();
		private var dropShadowArray:Array=new Array(dropShadow);

		public function KeyButton()
		{
			super();
			touchChildren=false;
			_initialized=true;
		}

		public function get styleList():Object
		{
			return _object;
		}
		public function set styleList(value:Object):void
		{
			_object=value;
			createUI();
			commitUI();
			layoutUI();
			updateUI();
		}
		
		public function get text():String
		{
			return _text;
		}
		public function set text(value:String):void
		{
			_text=value;
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
			background.styleList=KeyParser.settings.Key;
			background.width=_object.width;
			background.height=_object.height;

			txt.multilined=false;
			
			capital=_object.capital;
			shift=_object.shift;
			
			action=_object.title;
			shiftAction=_object.shiftAction;
			capsAction=_object.capsAction;
			
			txt.color=KeyParser.settings.KeyText.fontColor;
			txt.size=KeyParser.settings.KeyText.fontSize;
			
			if (KeyParser.settings.Key.dropShadow=="true")
			{
				dropShadow.color=0x000000;
				dropShadow.blurX=5;
				dropShadow.blurY=5;
				dropShadow.angle=45;
				dropShadow.alpha=0.4;
				dropShadow.distance=5;
				filters=dropShadowArray;
			}
		}
		
		override protected function layoutUI():void
		{
			x=_object.x;
			y=_object.y;
			_text=_object.title;
		}
		
		override protected function updateUI():void
		{
			txt.text=_text;

			txt.x=(background.width-txt.width)/2;
			txt.y=(background.height-txt.height)/2;
			
			width=background.width;
			height=background.height;
		}
		
		public function setShiftTxt():void
		{
			text=_object.shiftText;
		}
		
		public function setCapsTxt():void
		{
			text=_object.capsText;
		}
		
		public function setNormalTxt():void
		{
			text=_object.title;
		}
		
	}
}