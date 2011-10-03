////////////////////////////////////////////////////////////////////////////////
//
//  OPEN EXHIBITS
//  Copyright 2010-2011 OPEN EXHIBITS
//  All Rights Reserved.
//
//  ForwardButton
//
//  File:     ForwardButton.as
//  Author:    Mattthew Valverde (matthew(at)ideum(dot)com)
//
//  NOTICE: OPEN EXHIBITS permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package id.element
{
	import id.core.TouchComponent;
	import id.core.TouchSprite;
	import id.element.TextDisplay;
	import flash.text.Font;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextField;
	import flash.text.AntiAliasType;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.Shape;
	import gl.events.TouchEvent;

	/**
	 * This is the ForwardButton class.
	 * 
	 * @langversion 3.0
	 * @playerversion AIR 2
	 * @playerversion Flash 10
	 * @playerversion Flash Lite 4
	 * @productversion GestureWorks 2.0
	 */
	public class ForwardButton extends TouchComponent
	{
		private var _initialized:Boolean;
		public var active:Shape;
		public var passive:Shape;
		private var triangle:Shape;
		private var bar:Shape;
		private var _toggle:Boolean;
		private var triangleHeight:Number;

		private var _style:Object=
		{
		buttonRadius:21,
		buttonColorPassive:0x222222,
		buttonColorActive:0x966540,
		buttonOutlineStroke:2,
		buttonOutlineColor:0xc3aa7b,
		buttonSymbolColor:0xFFFFFF
		};

		public function ForwardButton()
		{
			super();
			createUI();
			commitUI();
			updateUI();

			_initialized=true;
		}

		override public function Dispose():void
		{
			if (parent)
			{
				parent.removeChild(this);
			}
		}

		public function get styleList():Object
		{
			return _style;
		}
		public function set styleList(value:Object):void
		{
			if (! value)
			{
				return;
			}

			if (value.buttonRadius!=undefined&&value.buttonRadius!="")
			{
				_style.buttonRadius=value.buttonRadius;
			}

			if (value.buttonColorPassive!=undefined&&value.buttonColorPassive!="")
			{
				_style.buttonColorPassive=value.buttonColorPassive;
			}

			if (value.buttonColorActive!=undefined&&value.buttonColorActive!="")
			{
				_style.buttonColorActive=value.buttonColorActive;
			}

			if (value.buttonOutlineStroke!=undefined&&value.buttonOutlineStroke!="")
			{
				_style.buttonOutlineStroke=value.buttonOutlineStroke;
			}

			if (value.buttonOutlineColor!=undefined&&value.buttonOutlineColor!="")
			{
				_style.buttonOutlineColor=value.buttonOutlineColor;
			}

			if (value.buttonSymbolColor!=undefined&&value.buttonSymbolColor!="")
			{
				_style.buttonSymbolColor=value.buttonSymbolColor;
			}

			updateUI();
		}

		public function get buttonRadius():Object
		{
			return _style.buttonRadius;
		}
		public function set buttonRadius(value:Object):void
		{
			_style.buttonRadius=value;
			updateUI();
		}

		public function get buttonColorPassive():Object
		{
			return _style.buttonColorPassive;
		}
		public function set buttonColorPassive(value:Object):void
		{
			_style.buttonColorPassive=value;
			updateUI();
		}

		public function get buttonColorActive():Object
		{
			return _style.buttonColorActive;
		}
		public function set buttonColorActive(value:Object):void
		{
			_style.buttonColorActive=value;
			updateUI();
		}

		public function get buttonOutlineStroke():Object
		{
			return _style.buttonOutlineStroke;
		}
		public function set buttonOutlineStroke(value:Object):void
		{
			_style.buttonOutlineStroke=value;
			updateUI();
		}

		public function get buttonOutlineColor():Object
		{
			return _style.buttonOutlineColor;
		}
		public function set buttonOutlineColor(value:Object):void
		{
			_style.buttonOutlineColor=value;
			updateUI();
		}

		public function get buttonSymbolColor():Object
		{
			return _style.buttonSymbolColor;
		}
		public function set buttonSymbolColor(value:Object):void
		{
			_style.buttonSymbolColor=value;
			updateUI();
		}

		public function set toggle(value:Boolean):void
		{
			_toggle=value;
		}

		override protected function createUI():void
		{
			active = new Shape();
			passive = new Shape();
			triangle = new Shape();
			bar = new Shape();

			addChild(passive);
			addChild(active);
			addChild(triangle);
			addChild(bar);

			addEventListener(TouchEvent.TOUCH_DOWN, buttonDownHandler);
		}

		override protected function commitUI():void
		{
			active.visible=false;
		}

		override protected function layoutUI():void
		{
		}

		override protected function updateUI():void
		{
			var buttonRadius:Number=Number(_style.buttonRadius);
			var buttonPadding:Number=Number(_style.buttonPadding);
			
			triangleHeight=buttonRadius-5;

			active.graphics.clear();
			active.graphics.lineStyle(_style.buttonOutlineStroke,_style.buttonOutlineColor);
			active.graphics.beginFill(_style.buttonColorActive,1);
			active.graphics.drawCircle(0,0,buttonRadius);
			active.graphics.endFill();

			passive.graphics.clear();
			passive.graphics.lineStyle(_style.buttonOutlineStroke,_style.buttonOutlineColor);
			passive.graphics.beginFill(_style.buttonColorPassive,1);
			passive.graphics.drawCircle(0,0,buttonRadius);
			passive.graphics.endFill();

			triangle.graphics.beginFill(_style.buttonSymbolColor);
			triangle.graphics.moveTo(triangleHeight/2, 0);
			triangle.graphics.lineTo(0, buttonRadius/2);
			triangle.graphics.lineTo(triangleHeight/2, buttonRadius);
			triangle.graphics.lineTo(triangleHeight/2, 0);
			
			bar.graphics.clear();
			bar.graphics.beginFill(_style.buttonSymbolColor,1);
			bar.graphics.drawRect(0,0,4,buttonRadius);
			bar.graphics.endFill();
			
			bar.x=2;
			bar.y=(0-buttonRadius)/2;
			
			triangle.x=(0-triangle.width)-2;
			triangle.y=(0-triangle.height)/2;
			
			rotation = 180;
		}

		private function buttonDownHandler(event:TouchEvent):void
		{
			if (_toggle)
			{
				if (active.visible)
				{
					active.visible=false;
				}
				else
				{
					active.visible=true;
				}
			}
		}
	}
}