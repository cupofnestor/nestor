////////////////////////////////////////////////////////////////////////////////
//
//  OPEN EXHIBITS
//  Copyright 2010-2011 OPEN EXHIBITS
//  All Rights Reserved.
//
//  CustomGraphic
//
//  File:     CustomGraphic.as
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
	public class CustomGraphic extends TouchComponent
	{
		private var _width:Number=200;
		private var _height:Number=200;
		private var _styleList:String;

		private var fType:String=GradientType.LINEAR;
		private var colors:Array;
		private var alphas:Array;
		private var ratios:Array;
		private var matr:Matrix;
		
		private var _style:Object=
		{
		fillColor1:0x333333,
		fillColor2:0,
		fillAlpha:1,
		outlineStroke:1,
		outlineColor:0xFFFFFF,
		outlineAlpha:1,
		cornerRadius:0
		};

		public function CustomGraphic()
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
			if(!value) return;
			
			if(value.fillColor1!=undefined && value.fillColor1!="")
			{
				_style.fillColor1=value.fillColor1;
			}
			
			if(value.fillColor2!=undefined && value.fillColor2!="")
			{
				_style.fillColor2=value.fillColor2;
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
		}

		public override function get height():Number
		{
			return _height;
		}
		override public function set height(value:Number):void
		{
			_height=value;
		}

		public function get fillColor1():uint
		{
			return _style.fillColor1;
		}
		public function set fillColor1(value:uint):void
		{
			_style.fillColor1=value;
			updateUI();
		}

		public function get fillColor2():uint
		{
			return _style.fillColor2;
		}
		public function set fillColor2(value:uint):void
		{
			_style.fillColor2=value;
			updateUI();
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
		}

		override protected function commitUI():void
		{
		}

		override protected function updateUI():void
		{
			if(_style.fillColor2!=0)
			{
				colors=[_style.fillColor1,_style.fillColor2];
			}
			else
			{
				colors=[_style.fillColor1,_style.fillColor1];
			}

			matr = new Matrix();
			matr.createGradientBox( width, height, 0, 0, 0 );
			
			alphas=[_style.fillAlpha,_style.fillAlpha];
			ratios=[0,255];
			
			with (graphics)
			{
				clear();
				lineStyle(_style.outlineStroke,_style.outlineColor,_style.outlineAlpha)
				beginGradientFill(fType, colors, alphas, ratios, matr, SpreadMethod.PAD);
				
				moveTo(0, 0);
				lineTo(width-0, 0);
				curveTo(width, 0, width, 0);
				
				lineTo(width, height-_style.cornerRadius);
				curveTo(width, height, width-_style.cornerRadius, height);
				
				lineTo(_style.cornerRadius, height);
				curveTo(0, height, 0, height-_style.cornerRadius);
				
				lineTo(0, 0);
				curveTo(0, 0, 0, 0);
				
				lineTo(0, 0);
				endFill();
			}
		}
		
	}
}