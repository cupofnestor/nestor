package id.component
{
	import flash.events.Event;
	import flash.display.DisplayObject;
	import id.core.TouchComponent;
	import id.component.KeyNotePad;
	import id.component.KeyDisplay;
	import id.element.KeyParser;
	import id.core.ApplicationGlobals;
	import gl.events.TouchEvent;

	/**
	 * <p>
	 * The KeyManager Component allows communication and positioning between the KeyDisplay component and the KeyNotePad component.
	 * </p>
	 *
	 * <strong>Imported Components :</strong>
	 * <pre>
	 * KeyDisplay
	 * KeyNotePad
	 * KeyParser
	 * </pre>
	 *
	 * <listing version="3.0">
	 * var keyManager:KeyManager = new KeyManager();
	 *
	 * addChild(keyManager);</listing>
	 *
	 * @see id.core.TouchComponent
	 * 
	 * @includeExample KeyManager.as
	 * 
	 * @langversion 3.0
	 * @playerversion AIR 2
	 * @playerversion Flash 10.1
	 * @playerversion Flash Lite 4
	 * @productversion GestureWorks 2.0
	 */
	public class KeyManager extends TouchComponent
	{
		private var keyDisplay:KeyDisplay;
		private var notePad:KeyNotePad;
		private var notePadOn:Boolean;
		private var dock:Boolean;
		private var dockType:Number;

		/**
		 *
		 * The Constructor.
		 * <pre>
		 * <strong>var keyManager:KeyManager = new KeyManager();
		 * addChild(keyManager);</strong></pre>
		 *
		 */
		public function KeyManager()
		{
			super();

			createUI();
			commitUI();
			updateUI();
		}

		override protected function createUI():void
		{
			dock=KeyParser.settings.NotePad.dock=="true"?true:false;
			dockType=KeyParser.settings.NotePad.dockType;
			notePadOn=KeyParser.settings.NotePad.NotePadDraw=="true"?true:false;

			if (! dockType)
			{
				dockType=0;
			}

			keyDisplay = new KeyDisplay();
			addChild(keyDisplay);
			
			keyDisplay.x=(ApplicationGlobals.application.stage.stageWidth)/2;
			keyDisplay.y=(ApplicationGlobals.application.stage.stageHeight)/2;

			if (notePadOn)
			{
				notePad = new KeyNotePad();
				addChild(notePad);
			}

			addEventListener(KeyDisplay.RETURN_EVENT, returnKeyEvent);
			addEventListener(TouchEvent.TOUCH_DOWN, touchDownHandler);
		}

		override protected function commitUI():void
		{
			if (notePadOn)
			{
				notePad.styleList=KeyParser.settings.NotePad;

				var widthValue:Number;
				if (KeyParser.settings.NotePad.width=="KeyViewer")
				{
					widthValue=keyDisplay.width;
				}
				else
				{
					widthValue=KeyParser.settings.NotePad.width;
				}
				notePad.width=widthValue;
			}
		}

		override protected function updateUI():void
		{
			/*if(notePadOn)
			{
			if (dock)
			{
			notePad.x=keyDisplay.x-(keyDisplay.width/2);
			notePad.y=keyDisplay.y-(keyDisplay.height/2)-notePad.height;
			notePad.alpha=keyDisplay.alpha;
			}
			}*/
		}

		private function returnKeyEvent(event:Event):void
		{
			if (notePadOn)
			{
				notePad.text=keyDisplay.outputString;
			}
			updateUI();
		}

		private function touchDownHandler(event:TouchEvent):void
		{
			parent.setChildIndex(this as DisplayObject,parent.numChildren-1);
		}

	}
}