package id.module
{
	import flash.events.Event;
	import id.core.TouchComponent;
	import id.component.KeyManager;
	import id.element.KeyParser;

	/**
	 *
	 * <p>The KeyViewer module constructs a simple extend-able onscreen keyboard which can be omni-directionally repositioned and re-sized onstage using multitouch gestures.  
	 * Detailed aspects of the keyboard appearance such as key size, color and separation as well as dynamic interactions can be customized using the module XML.</p>
	 *
	 * <strong>Imported Components :</strong>
	 * <pre>
	 * KeyDisplay
	 * KeyParser</pre>
	 *
	 * <listing version="3.0">
	 * var keyViewer:KeyViewer = new KeyViewer();
	 *
	 * addChild(keyViewer);</listing>
	 *
	 * @see id.core.TouchComponent
	 * @see id.component.KeyDisplay
	 * @see id.component.KeyManager
	 * 
	 * @includeExample KeyViewer.as
	 * 
	 * @langversion 3.0
	 * @playerversion AIR 2
	 * @playerversion Flash 10.1
	 * @playerversion Flash Lite 4
	 * @productversion GestureWorks 2.0
	 */
	 
	public class KeyViewer extends TouchComponent
	{
		public static var COMPLETE:String = "complete";
		
		private var keyManager:KeyManager;
		
		private var _id:int;	
		private var _moduleName:String="";
		private var isLoaded:Boolean;
		
		/**
		 *
		 * The DisplayObject is an Array of all display objects added to the stage.
		 * <pre>
		 * <strong>displayObject.push(keyManage);</strong></pre>
		 *
		 */
		public var displayObject:Array = new Array();
		
		/**
		 *
		 * The Constructor.
		 * <pre>
		 * <strong>var keyViewer:KeyViewer = new KeyViewer();
		 * addChild(keyViewer);</strong></pre>
		 *
		 */
		public function KeyViewer()
		{
			super();
			KeyParser.settingsPath="library/data/KeyViewer.xml";
			KeyParser.addEventListener(Event.COMPLETE, onParseComplete);
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
		
		private function onParseComplete(event:Event):void
		{
			createUI();
			commitUI();
		}

		override protected function createUI():void
		{
			keyManager = new KeyManager();
			keyManager.moduleName="KeyViewer";
			displayObject.push(keyManager);
			
			if (parent is TouchComponent)
			{
				super.layoutUI();
				displayObject=[];
			}
			else
			{
				addChild(keyManager);
				
				dispatchEvent(new Event(KeyViewer.COMPLETE));
				displayObject=[];
			}
		}
		
		override protected function commitUI():void
		{			
			displayObject.push(keyManager);
		}
		
	}
}