////////////////////////////////////////////////////////////////////////////////
//
//  OPEN EXHIBITS
//  Copyright 2010-2011 OPEN EXHIBITS
//  All Rights Reserved.
//
//  Component Structure Base
//
//  File:     TouchComponent.as
//  Author:    Mattthew Valverde (matthew(at)ideum(dot)com)
//
//  NOTICE: OPEN EXHIBITS permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package id.core
{

	import id.core.id_internal;
	import id.managers.LifeCycleManager;
	//import id.system.SystemRegister;
	//import id.system.SystemRegisterType;
	import flash.geom.Point;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;

	use namespace id_internal;
	
	

	public class TouchComponent extends TouchSprite
	{


		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		/**
		 *  Constructor.
		 *  
		 * @langversion 3.0
		 * @playerversion AIR 1.5
		 * @playerversion Flash 10
		 * @playerversion Flash Lite 4
		 * @productversion GestureWorks 1.6
		 *
		 */
			 
		public var updateCompletePendingFlag:Boolean;
		private var _id:int;
		private var _moduleName:String="";
		id_internal var _height:Number;
		id_internal var _width:Number;
		private var parentChangedFlag:Boolean;
		private var _visible:Boolean=true;
		private var _initialized:Boolean;
		private var _nestLevel:int=0;
		private var invalidatePropertiesFlag:Boolean;
		private var invalidateSizeFlag:Boolean;
		private var invalidateDisplayListFlag:Boolean;
			
		/*public static var register:SystemRegister = new SystemRegister
		(
			"TouchComponent",
			id_internal::VERSION,
			SystemRegisterType.LIBRARY
		);*/
		
		//to use embedded fonts umcomment these two lines:
		//[Embed(source='../../../assets/arial.ttf', fontName='GlobalArial', fontFamily='myFont', mimeType='application/x-font-truetype', embedAsCFF= 'false')]  
        //public static var GlobalArial:Class; 
		
		public function TouchComponent()
		{
			super();
			
			$visible=false;

			_width=super.width;
			_height=super.height;
		}

		//--------------------------------------------------------------------------
		//
		//  Overridden properties
		//
		//--------------------------------------------------------------------------
		
		
		override public function Dispose():void
		{
			if (parent)
			{
				parent.removeChild(this);
			}
		}

		//----------------------------------
		//  height
		//----------------------------------
		
		override public function get height():Number
		{
			return _height;
		}
		override public function set height(value:Number):void
		{
			if (_height==value)
			{
				return;
			}

			invalidateProperties();
			invalidateDisplayList();
			invalidateParentSizeAndDisplayList();

			_height=value;
		}


		//----------------------------------
		//  width
		//----------------------------------
		override public function get width():Number
		{
			return _width;
		}
		override public function set width(value:Number):void
		{
			if (_width==value)
			{
				return;
			}

			invalidateProperties();
			invalidateDisplayList();
			invalidateParentSizeAndDisplayList();

			_width=value;
		}


		//----------------------------------
		//  x
		//----------------------------------

		override public function get x():Number
		{
			return super.x;
		}

		override public function set x(value:Number):void
		{
			if (value==x)
			{
				return;
			}

			super.x=value;

			invalidateProperties();
		}

		id_internal final function get $x():Number
		{
			return super.x;
		}

		id_internal final function set $x(value:Number):void
		{
			super.x=value;
		}


		//----------------------------------
		//  y
		//----------------------------------

		override public function get y():Number
		{
			return super.y;
		}

		override public function set y(value:Number):void
		{
			if (value==y)
			{
				return;
			}

			super.y=value;

			invalidateProperties();
		}

		id_internal final function get $y():Number
		{
			return super.y;
		}

		id_internal final function set $y(value:Number):void
		{
			super.y=value;
		}


		//----------------------------------
		//  rotation
		//----------------------------------

		override public function get rotation():Number
		{
			return super.rotation;
		}

		override public function set rotation(value:Number):void
		{
			if (rotation==value)
			{
				return;
			}

			super.rotation=value;

			invalidateTransform();
			invalidateProperties();
			invalidateParentSizeAndDisplayList();
		}


		//----------------------------------
		//  scaleX
		//----------------------------------

		override public function get scaleX():Number
		{
			return super.scaleX;
		}

		override public function set scaleX(value:Number):void
		{
			if (scaleX==value)
			{
				return;
			}

			super.scaleX=value;

			invalidateTransform();
			invalidateProperties();
			invalidateParentSizeAndDisplayList();
		}


		//----------------------------------
		//  scaleY
		//----------------------------------

		override public function get scaleY():Number
		{
			return super.scaleY;
		}

		override public function set scaleY(value:Number):void
		{
			if (scaleY==value)
			{
				return;
			}

			super.scaleY=value;

			invalidateTransform();
			invalidateProperties();
			invalidateParentSizeAndDisplayList();
		}


		//----------------------------------
		//  visible
		//----------------------------------
		
		override public function get visible():Boolean
		{
			return _visible;
		}

		override public function set visible(value:Boolean):void
		{
			setVisible(value);
		}

		public function setVisible(value:Boolean, noEvent:Boolean = false):void
		{
			_visible=value;

			if (! initialized)
			{
				return;
			}

			if ($visible==value)
			{
				return;
			}

			$visible=value;
		}

		id_internal final function get $visible():Boolean
		{
			return super.visible;
		}

		id_internal final function set $visible(value:Boolean):void
		{
			super.visible=value;
		}
		
		//------------------------------------
		// initialization
		//------------------------------------

		public function get id():int
		{
			return _id;
		}

		public function set id(value:int):void
		{
			_id=value;
		}
		
		public function get moduleName():String
		{
			return _moduleName;
		}

		public function set moduleName(value:String):void
		{
			_moduleName=value;
		}


		//------------------------------------
		// initialization
		//------------------------------------

		public function get initialized():Boolean
		{
			return _initialized;
		}

		public function set initialized(value:Boolean):void
		{
			_initialized=value;

			if (value)
			{
				setVisible(_visible, true);
			}
		}


		//----------------------------------
		//  nestLevel
		//----------------------------------
		
		public function get nestLevel():int
		{
			return _nestLevel;
		}

		public function set nestLevel(value:int):void
		{
			if (value<=1&&value==_nestLevel)
			{
				return;
			}

			_nestLevel=value;

			var idx:uint;
			var child:TouchComponent;
			for (idx=0; idx<numChildren; idx++)
			{
				child=getChildAt(idx) as TouchComponent;
				if (! child)
				{
					continue;
				}

				child.nestLevel=value+1;
			}
		}


		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------

		override id_internal function addingChild(child:DisplayObject):void
		{
			super.addingChild(child);

			var tO:TouchComponent=child as TouchComponent;
			if (tO)
			{
				tO.parentChanged(this);
				tO.nestLevel=nestLevel+1;
			}
		}

		override id_internal function childAdded(child:DisplayObject):void
		{
			super.childAdded(child);

			var tO:TouchComponent=child as TouchComponent;
			if (tO&&! tO.initialized)
			{
				tO.initialize();
			}
		}

		override id_internal function removingChild(child:DisplayObject):void
		{
			super.removingChild(child);
		}

		override id_internal function childRemoved(child:DisplayObject):void
		{
			super.childRemoved(child);

			var tO:TouchComponent=child as TouchComponent;
			if (tO)
			{
				tO.parentChanged(null);
			}
		}


		//--------------------------------------------------------------------------
		//
		//  Methods: Initialization
		//
		//--------------------------------------------------------------------------

		override protected function initialize():void
		{
			if (initialized)
			{
				return;
			}

			addEventListener(Event.COMPLETE, onReturnComplete);

			childrenCreated();

			initializationComplete();
		}

		public function onReturnComplete(event:Event):void
		{
			var p:TouchComponent=parent as TouchComponent;
			if (! p)
			{
				return;
			}

			p.layoutUI();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods: Component Structure Common Functions
		//
		//--------------------------------------------------------------------------
		
		protected function createUI():void
		{
		}
		
		protected function commitUI():void
		{
		}
		
		protected function layoutUI():void
		{
			var p:TouchComponent=parent as TouchComponent;
			if (! p)
			{
				return;
			}
			else
			{
				p.layoutUI();
			}
		}

		protected function updateUI():void
		{
			var p:TouchComponent=parent as TouchComponent;
			if (! p)
			{
				return;
			}
			else
			{
				p.id=id;
				p.moduleName=moduleName;
				p.updateUI();
			}
		}

		protected function childrenCreated():void
		{
			invalidateProperties();
			invalidateSize();
			invalidateDisplayList();
		}

		protected function initializationComplete():void
		{
		}

		public function parentChanged(p:DisplayObjectContainer):void
		{
			if (! p)
			{
				_nestLevel=0;
			}

			parentChangedFlag=true;
		}

		//--------------------------------------------------------------------------
		//
		//  Methods: Invalidation
		//
		//--------------------------------------------------------------------------
		
		public function invalidateProperties():void
		{
			if (! parent)
			{
				return;
			}

			if (! invalidatePropertiesFlag)
			{
				invalidatePropertiesFlag=true;

				if (parent)
				{
					LifeCycleManager.getInstance().invalidateProperties(this);
				}
			}
		}

		public function invalidateSize():void
		{
			if (! parent)
			{
				return;
			}

			if (! invalidateSizeFlag)
			{
				invalidateSizeFlag=true;

				if (parent)
				{
					LifeCycleManager.getInstance().invalidateSize(this);
				}
			}
		}

		public function invalidateDisplayList():void
		{
			if (! parent)
			{
				return;
			}

			if (! invalidateDisplayListFlag)
			{
				invalidateDisplayListFlag=true;

				if (parent)
				{
					LifeCycleManager.getInstance().invalidateDisplayList(this);
				}
			}
		}

		private function invalidateTransform():void
		{
			invalidateDisplayList();
		}

		protected function invalidateParentSizeAndDisplayList():void
		{
			var p:TouchComponent=parent as TouchComponent;
			if (! p)
			{
				return;
			}

			p.invalidateSize();
			p.invalidateDisplayList();
		}

		public function validateNow():void
		{
			LifeCycleManager.getInstance().validateClient(this);
		}


		//--------------------------------------------------------------------------
		//
		//  Methods: Validation
		//
		//--------------------------------------------------------------------------

		public function validateProperties():void
		{
			if (invalidatePropertiesFlag)
			{
				invalidatePropertiesFlag=false;

			}
		}

		public function validateSize(recursive:Boolean = false):void
		{
			if (! invalidateSizeFlag)
			{
				return;
			}

			invalidateDisplayList();
			invalidateParentSizeAndDisplayList();
		}

		public function validateDisplayList():void
		{
			if (! invalidateDisplayListFlag)
			{
				return;
			}

			invalidateDisplayListFlag=false;
		}
		
	}
}