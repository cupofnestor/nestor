package
{
	import id.core.TouchComponent;
	import flash.events.Event;
	import gl.events.TouchEvent;
	import gl.events.GestureEvent;

	public class Base extends TouchComponent
	{
		private var _initialized:Boolean;

		public function Base()
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
			super();
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			createUI();
			commitUI();
			layoutUI();
			updateUI();

			_initialized = true;
		}

		override public function Dispose():void
		{
			if (parent)
			{
				parent.removeChild(this);
			}
		}
		
		override protected function createUI():void
		{
			
			addEventListener(TouchEvent.TOUCH_DOWN, touchDownHandler);
			addEventListener(TouchEvent.TOUCH_UP, touchUpHandler);
			addEventListener(GestureEvent.GESTURE_DRAG, gestureDragHandler);
			addEventListener(GestureEvent.GESTURE_SCALE, gestureScaleHandler);
			addEventListener(GestureEvent.GESTURE_ROTATE, gestureRotateHandler);
		}

		override protected function commitUI():void
		{
		}
		
		override protected function layoutUI():void
		{
		}
		
		override protected function updateUI():void
		{			
		}
		
		private function touchDownHandler(event:TouchEvent):void
		{	
		}
		
		private function touchUpHandler(event:TouchEvent):void
		{	
		}
		
		private function gestureDragHandler(event:GestureEvent):void
		{	
		}
		
		private function gestureScaleHandler(event:GestureEvent):void
		{
		}
		
		private function gestureRotateHandler(event:GestureEvent):void
		{
		}
		
	}
}