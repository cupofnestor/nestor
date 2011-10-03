package id.template
{
	import flash.utils.getDefinitionByName;
	import flash.display.DisplayObject;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import id.core.ApplicationGlobals;
	import id.core.TouchComponent;
	import id.element.TextDisplay;
	import gl.events.TouchEvent;
	import com.greensock.TweenLite;
	import flash.utils.Dictionary;
	import flash.display.Sprite;
	
	import id.module.FlickrViewer; FlickrViewer;
	import id.module.ImageViewer; ImageViewer;
	import id.module.VideoViewer; VideoViewer;
	import id.module.YouTubeViewer; YouTubeViewer;
	import id.module.KeyViewer; KeyViewer;
	import id.module.GMapViewer; GMapViewer;
	
	import id.element.BitmapLoader;

	public class CollectionViewer extends TouchComponent
	{
		private var templates:Object;
		private var _id:int;
		private var count:int;
		private var moduleClass:Class;
		private var module:DisplayObject;
		private var txt:TextDisplay;
		public var loadingTime:Timer;
		private var layoutCalled:Boolean;
		private var secondTime:Boolean;
		private var templateLoaded:Boolean;
		private var objects:Array = new Array();
		private var isTemplateLoaded:Boolean;
		private var moduleDictionary:Dictionary = new Dictionary();
		private var moduleID:Array = new Array();
		
		private var _moduleName:String="";
		private var stageWidth:Number;
		private var stageHeight:Number;
		
		private var background:Sprite;
		private var bitmap:BitmapLoader;
		
		private var moduleNameArray:Array = new Array();
		private var backgroundUrl:String;

		public function CollectionViewer()
		{
			super();
			templates=ApplicationGlobals.dataManager.data.Template;
			createUI();
			commitUI();
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

		override protected function createUI():void
		{
			stageWidth=ApplicationGlobals.application.stage.stageWidth;
			stageHeight=ApplicationGlobals.application.stage.stageHeight;
			
			txt = new TextDisplay();
			background = new BitmapLoader();
			bitmap = new BitmapLoader();
			
			background.addChild(bitmap)
			addChild(background);
			addChild(txt);

			loadingTime=new Timer(3000);
			loadingTime.addEventListener(TimerEvent.TIMER, updateLoadingText);
		}

		override protected function commitUI():void
		{
			backgroundUrl = templates.background;
			txt.multilined=false;
			txt.color=0xFFFFFF;
			callModuleClass();
			
			if(backgroundUrl)
			{
				bitmap.url = backgroundUrl;
				bitmap.width=stageWidth;
				bitmap.height=stageHeight;
			}
		}

		override protected function layoutUI():void
		{
			layoutCalled=true;
			
			var moduleObject:Object = getModule(moduleDictionary);
				
			addToObjectsArray(moduleObject.displayObject);
			
			if(isTemplateLoaded)
			{				
				addModulesToStage();
			}
		}

		override protected function updateUI():void
		{			
			var moduleObject:Object = getModule(moduleDictionary);
			moduleObject.callNewObject(id);
		}
		
		private function updateLoadingText(event:TimerEvent):void
		{
			if(secondTime)
			{
				loadingTime.reset();
				loadingTime.stop();
				
				count++;
				
				if (count==templates.module.length())
				{
					isTemplateLoaded=true;
					txt.text="The Template is complete.";
					txt.x=(stageWidth-txt.textWidth)/2;
					loadingTime.removeEventListener(TimerEvent.TIMER, updateLoadingText);
					loadingTime = null;
					TweenLite.to(txt, 1, { alpha:0, delay:2, onComplete:addModulesToStage});
					
					return;
				}
				else
				{
					callModuleClass();
				}				
				return;
			}
			
			if (layoutCalled)
			{
				loadingTime.reset();
				loadingTime.start();
				txt.text="The \""+templates.module[count] + "\" module has loaded.";
				txt.x=(stageWidth-txt.textWidth)/2;
			}
			else
			{
				loadingTime.reset();
				loadingTime.stop();
				loadingTime.start();
			}
			secondTime=true;
		}

		private function callModuleClass():void
		{
			layoutCalled=false;
			secondTime=false;
			loadingTime.start();
			txt.text="Loading the \""+templates.module[count] + "\" module.";
			txt.x=(stageWidth-txt.textWidth)/2;
			txt.y=(stageHeight-txt.height)/2;
			moduleClass=getDefinitionByName("id.module."+templates.module[count]) as Class;
			
			module = new moduleClass();
			//module.settingsPath=templates.module[count].@xmlPath;
			addChild(module);
			
			moduleName=templates.module[count];
			moduleDictionary[module] = templates.module[count];
		}
		
		private function addModulesToStage():void
		{
			for (var i:int=0; i<objects.length; i++)
			{
				txt.Dispose();
				addChild(objects[i]);
				objects[i].rotation = Math.random()*360;
				objects[i].x=Math.random()*ApplicationGlobals.application.stage.stageWidth;
				objects[i].y=Math.random()*ApplicationGlobals.application.stage.stageHeight;
				TweenLite.to(objects[i], 2, { alpha:1});
			}
			objects=[];
		}
		
		private function addToObjectsArray(value:Array):void
		{
			for (var i:int=0; i<value.length; i++)
			{
				objects.push(value[i]);
			}
		}
		
		private function getModule(value:Dictionary):Object
		{
			var moduleObject:Object = new Object();
			
			for (var object:Object in value)
			{
				if(value[object]==moduleName)
				{
					moduleObject=object;
				}
			}
			
			return moduleObject;
		}
	}
}