////////////////////////////////////////////////////////////////////////////////
//
//  OPEN EXHIBITS
//  Copyright 2010-2011 OPEN EXHIBITS
//  All Rights Reserved.
//
//  ImageDisplay
//
//  File:     ImageDisplay.as
//  Author:    Mattthew Valverde (matthew(at)ideum(dot)com)
//
//  NOTICE: OPEN EXHIBITS permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package id.component
{
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.text.TextField;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.media.Video;
	import id.core.ApplicationGlobals;
	import id.core.TouchSprite;
	import id.core.TouchComponent;
	import id.component.ControlBtns;
	import id.element.ThumbLoader;
	import id.element.BitmapLoader;
	import id.element.Outline;
	import id.element.Graphic;
	import id.element.TextDisplay;
	import id.element.Parser;
	import id.element.QRCodeDisplay;
	import gl.events.TouchEvent;
	import gl.events.GestureEvent;
	import com.greensock.TweenLite;

	public class ImageDisplay extends TouchComponent
	{
		private var thumbnail:ThumbLoader;
		private var media:BitmapLoader;
		private var metadata:TouchComponent;
		private var controlBtns:ControlBtns;
		private var outline:Outline;
		private var backgroundGraphic:Graphic;
		private var title:TextDisplay;
		private var description:TextDisplay;
		private var author:TextDisplay;
		private var publish:TextDisplay;
		private var qrCode:QRCodeDisplay;

		private var _id:int;
		private var infoPadding:Number=10;
		private var intialize:Boolean;
		private var globalScale:Number;
		private var scale:Number;
		private var imagesNormalize:Number;
		private var infoPaddingNumber:Number;
		private var maxScale:Number;
		private var minScale:Number;
		private var infoBtnStyle:Object;
		private var backgroundOutlineStyle:Object;
		private var backgroundGraphicStyle:Object;
		private var titleStyle:Object;
		private var descriptionStyle:Object;
		private var authorStyle:Object;
		private var publishStyle:Object;
		private var mediaUrl:String;
		private var thumbUrl:String;
		private var qrCodeTag:String;
		private var titleText:String;
		private var descriptionText:String;
		private var authorText:String;
		private var publishText:String;
		private var dragGesture:Boolean=true;
		private var rotateGesture:Boolean=true;
		private var scaleGesture:Boolean=true;
		private var doubleTapGesture:Boolean=true;
		private var flickGesture:Boolean=true;
		private var information:Boolean;
		private var stageWidth:Number;
		private var stageHeight:Number;
		private var disposeArray:Array = new Array();

		private var flickFriction:Number=.9;
		private var flickDx:Number;
		private var flickDy:Number;

		/**
		 *
		 * The Constructor.
		 * <pre>
		 * <strong>var imageDisplay:ImageDisplay = new ImageDisplay();
		 * addChild(imageDisplay);</strong></pre>
		 *
		 */
		public function ImageDisplay()
		{
			super();
			blobContainerEnabled=true;
			visible=false;
		}

		private function destroyChildren(child:*):void
		{
			if (! child)
			{
				return;
			}

			disposeArray.push(child);

			for (var idx:int=0; idx<child.numChildren; idx++)
			{
				var nested:* =child.getChildAt(idx);

				var sprite:Sprite=nested as Sprite;
				if (sprite)
				{
					nested.parent.removeChild(sprite);
					sprite=null;
					return;
				}

				var shape:Shape=nested as Shape;
				if (shape)
				{
					nested.parent.removeChild(shape);
					shape=null;
					return;
				}

				var txtField:TextField=nested as TextField;
				if (txtField)
				{
					nested.parent.removeChild(txtField);
					txtField=null;
					return;
				}

				var video:Video=nested as Video;
				if (video)
				{
					nested.parent.removeChild(video);
					video=null;
					return;
				}

				var loader:Loader=nested as Loader;
				if (loader)
				{
					loader.unload();
					nested.parent.removeChild(loader);
					loader=null;
					return;
				}

				var bitmap:Bitmap=nested as Bitmap;
				if (bitmap)
				{
					bitmap.bitmapData.dispose();
					nested.parent.removeChild(bitmap);
					bitmap.bitmapData=null;
					bitmap=null;
					return;
				}

				nested.Dispose();
				nested=null;
			}
		}
		/**
		 *
		 * The Disposal method for the module. It will clean out and nullify all children.
		 * <pre>
		 * <strong>imageDisplay.Dispose();</strong></pre>
		 *
		 */
		override public function Dispose():void
		{
			for (var i:int=0; i<numChildren; i++)
			{
				destroyChildren(getChildAt(i) as DisplayObjectContainer);
			}

			for (var j:int=0; j<disposeArray.length; j++)
			{
				disposeArray[j].Dispose();
				disposeArray[j]=null;
			}

			disposeArray=[];
			disposeArray=null;

			if (dragGesture)
			{
				removeEventListener(TouchEvent.TOUCH_DOWN, touchDownHandler);
				removeEventListener(TouchEvent.TOUCH_UP, touchUpHandler);
			}

			if (doubleTapGesture)
			{
				removeEventListener(TouchEvent.TOUCH_DOUBLE_TAP, doubleTapHandler);
			}

			if (flickGesture)
			{
				removeEventListener(GestureEvent.GESTURE_FLICK, flickGestureHandler);
			}

			if (scaleGesture)
			{
				removeEventListener(GestureEvent.GESTURE_SCALE, scaleGestureHandler);
			}

			if (rotateGesture)
			{
				removeEventListener(GestureEvent.GESTURE_ROTATE, rotateGestureHandler);
			}

			removeEventListener(ControlBtns.INFO_CALL, informationHandler);

			super.updateUI();

			if (parent)
			{
				parent.removeChild(this);
			}
		}

		override public function get id():int
		{
			return _id;
		}

		override public function set id(value:int):void
		{
			_id=value;
			createUI();
			commitUI();
		}

		override protected function createUI():void
		{
			// Style
			globalScale=Parser.settings.GlobalSettings.globalScale;
			scale=Parser.settings.GlobalSettings.scale;
			imagesNormalize=Parser.settings.GlobalSettings.imagesNormalize;
			infoPaddingNumber=Parser.settings.GlobalSettings.infoPadding;
			maxScale=Parser.settings.GlobalSettings.maxScale;
			minScale=Parser.settings.GlobalSettings.minScale;
			stageWidth=ApplicationGlobals.application.stage.stageWidth;
			stageHeight=ApplicationGlobals.application.stage.stageHeight;

			if (! maxScale||! minScale)
			{
				maxScale=2;
				minScale=.5;
			}

			infoBtnStyle=Parser.settings.ControlBtns;
			backgroundOutlineStyle=Parser.settings.BackgroundOutline;
			backgroundGraphicStyle=Parser.settings.BackgroundGraphic;
			titleStyle=Parser.settings.InfoText.TitleText;
			descriptionStyle=Parser.settings.InfoText.DescriptionText;
			authorStyle=Parser.settings.InfoText.AuthorText;
			publishStyle=Parser.settings.InfoText.PublishText;

			// Gestures
			if (Parser.settings.Gestures!=undefined)
			{
				dragGesture=Parser.settings.Gestures.drag=="true"?true:false;
				rotateGesture=Parser.settings.Gestures.rotate=="true"?true:false;
				scaleGesture=Parser.settings.Gestures.scale=="true"?true:false;
				doubleTapGesture=Parser.settings.Gestures.doubleTap=="true"?true:false;
				flickGesture=Parser.settings.Gestures.flick=="true"?true:false;
			}

			// Data
			
			mediaUrl=Parser.settings.Content.Source[id].url;
			thumbUrl=Parser.settings.Content.Source[id].url;
			qrCodeTag=Parser.settings.Content.Source[id].qrCodeTag;
			titleText=Parser.settings.Content.Source[id].title;
			descriptionText=Parser.settings.Content.Source[id].description;
			authorText=Parser.settings.Content.Source[id].author;
			publishText=Parser.settings.Content.Source[id].publish;

			// Objects
			thumbnail = new ThumbLoader();
			media = new BitmapLoader();
			controlBtns = new ControlBtns();
			outline = new Outline();
			backgroundGraphic = new Graphic();
			title = new TextDisplay();
			description = new TextDisplay();
			author = new TextDisplay();
			publish = new TextDisplay();
			qrCode = new QRCodeDisplay();

			metadata = new TouchComponent();

			// Add Children
			
			metadata.addChild(backgroundGraphic);
			if (qrCodeTag)
			{
				metadata.addChild(qrCode);
			}
			metadata.addChild(title);
			metadata.addChild(description);
			metadata.addChild(author);
			metadata.addChild(publish);
			metadata.addChild(thumbnail);

			addChild(controlBtns);
			addChild(metadata);
			addChild(media);
			addChild(outline);

			// Add Event Listeners
			if (dragGesture)
			{
				addEventListener(TouchEvent.TOUCH_DOWN, touchDownHandler);
				addEventListener(TouchEvent.TOUCH_UP, touchUpHandler);
			}

			if (doubleTapGesture)
			{
				addEventListener(TouchEvent.TOUCH_DOUBLE_TAP, doubleTapHandler);
			}

			if (flickGesture)
			{
				addEventListener(GestureEvent.GESTURE_FLICK, flickGestureHandler);
			}

			if (scaleGesture)
			{
				addEventListener(GestureEvent.GESTURE_SCALE, scaleGestureHandler);
			}

			if (rotateGesture)
			{
				addEventListener(GestureEvent.GESTURE_ROTATE, rotateGestureHandler);
			}

			addEventListener(ControlBtns.INFO_CALL, informationHandler);
		}

		override protected function commitUI():void
		{
			if (scale)
			{
				media.scale=scale;
			}

			if (imagesNormalize)
			{
				media.pixels=imagesNormalize;
			}

			qrCode.string=qrCodeTag;

			controlBtns.styleList=infoBtnStyle;
			outline.styleList=backgroundOutlineStyle;
			backgroundGraphic.styleList=backgroundGraphicStyle;
			title.styleList=titleStyle;
			description.styleList=descriptionStyle;
			author.styleList=authorStyle;
			publish.styleList=publishStyle;

			media.url=mediaUrl;
			thumbnail.url=thumbUrl;

			title.text=titleText;
			description.text=descriptionText;
			author.text=authorText;
			publish.text=publishText;

			if (infoPaddingNumber)
			{
				infoPadding=infoPaddingNumber;
			}

			metadata.alpha=0;
		}

		override protected function layoutUI():void
		{
			if (! intialize)
			{
				if (globalScale)
				{
					scaleX=globalScale;
					scaleY=globalScale;
				}
				intialize=true;
			}

			backgroundGraphic.width=media.width;
			backgroundGraphic.height=media.height;

			media.x=0-media.width/2;
			media.y=0-media.height/2;

			outline.width=media.width;
			outline.height=media.height;

			thumbnail.x=infoPadding;
			thumbnail.y=media.height-thumbnail.height-infoPadding;

			qrCode.x=media.width-qrCode.width-infoPadding;
			qrCode.y=media.height-qrCode.height-infoPadding;

			title.textWidth=media.width-(infoPadding*2);
			title.x=infoPadding;
			title.y=infoPadding;

			description.textWidth=media.width-(infoPadding*2);
			description.x=infoPadding;
			description.y=title.y+title.height+infoPadding;

			author.textWidth=media.width-(thumbnail.x+thumbnail.width)-(infoPadding*2);
			author.x=thumbnail.x+thumbnail.width+infoPadding;
			author.y=thumbnail.y;

			publish.textWidth=media.width-(thumbnail.x+thumbnail.width)-(infoPadding*2);
			publish.x=thumbnail.x+thumbnail.width+infoPadding;
			publish.y=thumbnail.y+thumbnail.height-publish.height;

			metadata.x=media.x;
			metadata.y=media.y;

			width=media.width;
			height=media.height;

			visible=true;
			controlBtns.visible=false;
			metadata.visible=false;
		}

		override protected function updateUI():void
		{
			width=media.width*scaleX;
			height=media.height*scaleY;

			if (scaleX<1)
			{
				controlBtns.visible=false;
			}
			else
			{
				controlBtns.visible=true;
				controlBtns.scale=scaleX;
				controlBtns.x=media.width/2;
				controlBtns.y=media.height/2;
			}

			if ( (x-(width/2)>stageWidth) || (x+(width/2)<0) || (y-(height/2)>stageHeight) || (y+(height/2)<0) )
			{
				if (hasEventListener(Event.ENTER_FRAME))
				{
					removeEventListener(Event.ENTER_FRAME, flickEnterFrameHandler);
				}

				Dispose();
			}
		}

		private function touchDownHandler(event:TouchEvent):void
		{
			startTouchDrag(-1);
			parent.setChildIndex(this as DisplayObject,parent.numChildren-1);
		}

		private function touchUpHandler(event:TouchEvent):void
		{
			stopTouchDrag(-1);
		}

		private function rotateGestureHandler(event:GestureEvent):void
		{
			rotation+=event.value;
		}

		private function doubleTapHandler(event:TouchEvent):void
		{
			TweenLite.to(this, .5, {scaleX:1, scaleY:1, onUpdate:updateUI});
		}

		private function flickGestureHandler(event:GestureEvent):void
		{
			flickDx=event.velocityX;
			flickDy=event.velocityY;
			addEventListener(Event.ENTER_FRAME, flickEnterFrameHandler);
		}

		private function scaleGestureHandler(event:GestureEvent):void
		{
			scaleX+=event.value;
			scaleY+=event.value;

			scaleY=scaleY>Number(maxScale)?Number(maxScale):scaleY<Number(minScale)?Number(minScale):scaleY;
			scaleX=scaleX>Number(maxScale)?Number(maxScale):scaleX<Number(minScale)?Number(minScale):scaleX;

			updateUI();
		}

		private function informationHandler(event:Event):void
		{
			if (! information)
			{
				metadata.visible=true;
				information=true;
				TweenLite.to(media, .5, { alpha:0});
				TweenLite.to(metadata, .5, { alpha:1, onComplete:visibility});
			}
			else
			{
				media.visible=true;
				information=false;
				TweenLite.to(media, .5, { alpha:1});
				TweenLite.to(metadata, .5, { alpha:0, onComplete:visibility});
			}
		}

		private function visibility():void
		{
			if (! information)
			{
				metadata.visible=false;
			}
			else
			{
				media.visible=false;
			}
		}

		// Flick Physics EnterFrame Handler \\
		private function flickEnterFrameHandler(event:Event):void
		{
			var dValue:Number;
			var d_x:Number=flickDx;
			var d_y:Number=flickDy;

			if (d_x<0)
			{
				d_x=- d_x;
			}

			if (d_y<0)
			{
				d_y=- d_y;
			}

			if (d_x>d_y)
			{
				dValue=d_x;
			}
			else
			{
				dValue=d_y;
			}

			if (Math.abs(dValue)<=1)
			{
				flickDx=0;
				flickDy=0;
				removeEventListener(Event.ENTER_FRAME, flickEnterFrameHandler);
			}

			x+=flickDx;
			y+=flickDy;

			flickDx*=flickFriction;
			flickDy*=flickFriction;

			updateUI();
		}
	}
}