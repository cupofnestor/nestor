package 
{
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.ui.Mouse;
	import id.core.Application;
	import id.core.ApplicationGlobals;
	import id.template.CollectionViewer;
	
	public class Main extends Application
	{		
		public function Main()
		{
			settingsPath="library/data/Application.xml";
			
			stage.scaleMode=StageScaleMode.NO_SCALE;
			stage.displayState=StageDisplayState.FULL_SCREEN;
			stage.align = StageAlign.TOP_LEFT;
		}

		override protected function initialize():void
		{
			stage.frameRate=ApplicationGlobals.dataManager.data.Template.FrameRate;
			
			var collectionViewer:CollectionViewer = new CollectionViewer();
			addChild(collectionViewer);
		}
	}
}