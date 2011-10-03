////////////////////////////////////////////////////////////////////////////////
//
//  OPEN EXHIBITS
//  Copyright 2010-2011 OPEN EXHIBITS
//  All Rights Reserved.
//
//  QRCodeDisplay
//
//  File:     QRCodeDisplay.as
//  Author:    Mattthew Valverde (matthew(at)ideum(dot)com)
//
//  NOTICE: OPEN EXHIBITS permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package id.element
{
	import id.core.TouchSprite;
	import flash.display.Sprite;
	import org.qrcode.QRCode;
	import flash.display.Bitmap;
	import id.core.TouchComponent;
	
	public class QRCodeDisplay extends TouchComponent
	{
		private var _string:String="";
		
		private var qrCode:QRCode;
		
		private var bitmap:Bitmap;
		
		private var _width:Number=60;
		
		private var _height:Number=60;
		
		public function QRCodeDisplay()
		{
			super();
		}

		override public function Dispose():void
		{
			if (parent)
			{
				parent.removeChild(this);
			}
		}
		
		override public function get width():Number
		{
			return _width;
		}
		override public function set width(value:Number):void
		{
			_width=value;
			_height=value;
			updateUI();
		}
		
		override public function get height():Number
		{
			return _height;
		}
		override public function set height(value:Number):void
		{
			_height=value;
			_width=value;
			updateUI();
		}
		
		public function get string():String
		{
			return _string;
		}
		public function set string(value:String):void
		{
			if(!value)return;
			
			_string=value;
			createUI();
			commitUI();
			updateUI();
		}
		
		override protected function createUI():void
		{
			qrCode= new QRCode();
			qrCode.encode(_string);
			bitmap=new Bitmap(qrCode.bitmapData);
			
			addChild(bitmap);
		}
		
		override protected function commitUI():void
		{
			bitmap.smoothing=true;
		}

		/*
		
		override protected function layoutUI():void
		{
		}*/
		
		override protected function updateUI():void
		{			
			bitmap.width=_width;
			bitmap.height=_height;
		}		
		
	}
}