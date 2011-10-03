////////////////////////////////////////////////////////////////////////////////
//
//  OPEN EXHIBITS
//  Copyright 2010-2011 OPEN EXHIBITS
//  All Rights Reserved.
//
//  Outline
//
//  File:     Outline.as
//  Author:    Mattthew Valverde (matthew(at)ideum(dot)com)
//
//  NOTICE: OPEN EXHIBITS permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package id.element
{
	import id.core.TouchComponent;
	import flash.display.Sprite;

	/**
	 * This is the Outline class.
	 * 
	 * @langversion 3.0
	 * @playerversion AIR 2
	 * @playerversion Flash 10
	 * @playerversion Flash Lite 4
	 * @productversion GestureWorks 2.0
	 */
	public class Outline extends TouchComponent
	{
		private var _alpha:Number;
		private var _width:Number=0;
		private var _height:Number=0;

		private var _style:Object=
		{
		outlineColor:0xFFFFFF,
		outlineStroke:1
		};

		public function Outline()
		{
			super();

			createUI();
			commitUI();
			updateUI();
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
			if(value.outlineColor!=undefined && value.outlineColor!="")
			{
				_style.outlineColor=value.outlineColor;
			}
			
			if(value.outlineStroke!=undefined && value.outlineStroke!="")
			{
				_style.outlineStroke=value.outlineStroke;
			}
			
			updateUI();
		}

		public override function get width():Number
		{
			return _width;
		}
		public override function set width(value:Number):void
		{
			_width=value;
			updateUI();
		}

		public override function get height():Number
		{
			return _height;
		}
		public override function set height(value:Number):void
		{
			_height=value;
			updateUI();
		}

		public function get color():uint
		{
			return _style.outlineColor;
		}
		public function set color(value:uint):void
		{
			_style.outlineColor=value;
			updateUI();
		}

		public function get size():Number
		{
			return _style.outlineStroke;
		}
		public function set size(value:Number):void
		{
			_style.outlineStroke=value;
			updateUI();
		}

		override protected function createUI():void
		{
		}

		override protected function commitUI():void
		{
		}

		override protected function updateUI():void
		{
			with (graphics)
			{
				clear();
				lineStyle(_style.outlineStroke,_style.outlineColor,1);
				drawRect(0,0,_width,_height);
			}

			x=0-width/2;
			y=0-height/2;
		}
	}
}