////////////////////////////////////////////////////////////////////////////////
//
//  OPEN EXHIBITS
//  Copyright 2010-2011 OPEN EXHIBITS
//  All Rights Reserved.
//
//  Graphic
//
//  File:    Graphic.as
//  Author:    Mattthew Valverde (matthew(at)ideum(dot)com)
//
//  NOTICE: OPEN EXHIBITS permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package id.element
{
	import id.core.TouchComponent;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;

	/**
	 * This is the Graphic class.
	 * 
	 * @langversion 3.0
	 * @playerversion AIR 2
	 * @playerversion Flash 10
	 * @playerversion Flash Lite 4
	 * @productversion GestureWorks 2.0
	 */
	public class Graphic extends TouchComponent
	{
		private var _width:Number=100;
		private var _height:Number=100;
		private var _styleList:String;

		private var fType:String=GradientType.LINEAR;
		private var colors:Array;
		private var alphas:Array;
		private var ratios:Array;
		private var matr:Matrix;
		
		private var _style:Object=
		{
		fillAlpha:1,
		outlineStroke:1,
		outlineColor:0xFFFFFF,
		outlineAlpha:0,
		cornerRadius:0
		};

		public function Graphic()
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
			if(value.fillColor1!=undefined && value.fillColor1!="")
			{
				fillColor1=value.fillColor1;
			}
			
			if(value.fillColor2!=undefined && value.fillColor2!="")
			{
				fillColor2=value.fillColor2;
			}
			
			if(value.outlineStroke!=undefined && value.outlineStroke!="")
			{
				_style.outlineStroke=value.outlineStroke;
				outlineAlpha=1;
			}
			
			if(value.outlineColor!=undefined && value.outlineColor!="")
			{
				_style.outlineColor=value.outlineColor;
				outlineAlpha=1;
			}
			
			if(value.outlineAlpha!=undefined && value.outlineAlpha!="")
			{
				_style.outlineAlpha=value.outlineAlpha;
				outlineAlpha=1;
			}
			
			if(value.fillAlpha!=undefined && value.fillAlpha!="")
			{
				_style.fillAlpha=value.fillAlpha;
				outlineAlpha=1;
			}
			
			if(value.cornerRadius!=undefined && value.cornerRadius!="")
			{
				_style.cornerRadius=value.cornerRadius;
				outlineAlpha=1;
			}
						
			updateUI();
		}

		public override function get width():Number
		{
			return _width;
		}
		override public function set width(value:Number):void
		{
			_width=value;
			updateUI();
		}

		public override function get height():Number
		{
			return _height;
		}
		override public function set height(value:Number):void
		{
			_height=value;
			updateUI();
		}

		private var _fillColor1:uint = 0x000000;
		public function get fillColor1():uint
		{
			return _fillColor1;
		}
		public function set fillColor1(value:uint):void
		{
			_fillColor1 = value;
			updateUI();
		}
		
		private var _fillColor2:uint = 0x000000;
		public function get fillColor2():uint
		{
			return _fillColor2;
		}
		public function set fillColor2(value:uint):void
		{			
			_fillColor2 = value;
			isGradient = true;
			updateUI();
		}
		
		private var _isGradient:Boolean;
		public function get isGradient():Boolean
		{
			return _isGradient;
		}
		public function set isGradient(value:Boolean):void
		{
			_isGradient=value;
		}
		
		public function get outlineStroke():Number
		{
			return _style.outlineStroke;
		}
		public function set outlineStroke(value:Number):void
		{
			_style.outlineStroke=value;
			outlineAlpha=1;
			updateUI();
		}
		
		public function get outlineColor():Number
		{
			return _style.outlineColor;
		}
		public function set outlineColor(value:Number):void
		{
			_style.outlineColor=value;
			outlineAlpha=1;
			updateUI();
		}
		
		public function get outlineAlpha():Number
		{
			return _style.outlineAlpha;
		}
		public function set outlineAlpha(value:Number):void
		{
			_style.outlineAlpha=value;
			updateUI();
		}
		
		override public function get alpha():Number
		{
			return _style.fillAlpha;
		}
		override public function set alpha(value:Number):void
		{
			_style.fillAlpha=value;
			updateUI();
		}
		
		public function get cornerRadius():Number
		{
			return _style.cornerRadius;
		}
		public function set cornerRadius(value:Number):void
		{
			_style.cornerRadius=value;
			updateUI();
		}

		override protected function createUI():void
		{
			matr = new Matrix();
		}

		override protected function commitUI():void
		{
		}

		override protected function updateUI():void
		{
			if(isGradient)
			{
				colors=[fillColor1,fillColor2];
			}
			else
			{
				colors=[fillColor1,fillColor1];
			}

			alphas=[_style.fillAlpha,_style.fillAlpha];
			ratios = [ 0x00, 0xFF ];
			
			matr.createGradientBox(width, height, 90 / 180 * Math.PI, 0, 0);
			
			with (graphics)
			{
				clear();
				lineStyle(_style.outlineStroke,_style.outlineColor,_style.outlineAlpha)
				beginGradientFill(fType, colors, alphas, ratios, matr, SpreadMethod.PAD);
				drawRoundRect(0, 0, width, height,_style.cornerRadius,_style.cornerRadius);
				endFill();
			}
		}
	}
}