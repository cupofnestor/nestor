////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2010-2011 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:     GMapDisplay.as
//
//  Author:  Paul Lacey (paul(at)ideum(dot)com)		 
//
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.

////////////////////////////////////////////////////////////////////////////////
package id.component
{
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.geom.*;
	import flash.ui.Mouse;
	import flash.display.Sprite;
	import flash.display.Shape;
	import id.core.ApplicationGlobals;
	import id.core.TouchSprite;
	import gl.events.TouchEvent;
	import gl.events.GestureEvent;
	import id.core.TouchComponent;
	import id.element.Parser;

	import com.google.maps.LatLng;
  	import com.google.maps.Map3D;
 	import com.google.maps.MapEvent;
 	import com.google.maps.MapOptions;
 	import com.google.maps.MapType;
 	import com.google.maps.View;
	import com.google.maps.geom.Attitude; 
	
	import com.greensock.TweenLite;
	
		 
	 /**
	 * <p>The GMapDisplay component is the main component for the GMapViewer module.  It contains all the neccessary display objects for the module.</p>
	 *
	 * <p>
	 * The GMapViewer is a module that uses the Google Maps API to create interactive mapping window.  
	 * Multiple touch object windows can independently display maps with different sizes and orientations.  
	 * Each map can have be centered on different coordinates, use different types and views.
	 * The map windows can be interactively moved around stage, scaled and rotated using multitouch gestures additionally map type, latitude and longitude, zoom level, attitude and pitch can also be controls using multitouch gesture inside the mapping window.
	 * All multitouch gestures can be activated and deactivated using the module XML settings.</p>
	 *
	 * <strong>Import Components :</strong>
	 * <pre>
	 * Map3D
	 * Parser
	 * TouchGesturePhysics
	 * </pre>
	 *
	 * <listing version="3.0">
	 * var mapDisplay:GMapDisplay = new GMapDisplay();
	 *
	 * 		mapDisplay.id = Number;
	 *
	 * addChild(mapDisplay);</listing>
	 *
	 * @see id.module.GMapViewer
	 * 
	 * @includeExample GMapDisplay.as
	 * 
	 * @langversion 3.0
	 * @playerversion AIR 2
	 * @playerversion Flash 10.1
	 * @playerversion Flash Lite 4
	 * @productversion GestureWorks 2.0
	 */
	 
	public class GMapDisplay extends TouchComponent
	{
		private var _id:int;
		private var _intialize:Boolean;
		
		private var map:Map3D;
		private var map_holder:TouchSprite;
		private var frame:TouchSprite;
		private var screen:TouchSprite;
		
		//------ map settings ------//
		private var mapApiKey:String = "";
		private var stageWidth:Number;
		private var stageHeight:Number;
		private var currLat:Number = -73.992062;
		private var currLng:Number = 40.736072;
		private var currType:Number = 0;
		private var currSc:Number = 0;
		private var currAng:Number = 0;
		private var currtiltAng:Number = 0;
		private var stepSc:Number = 1;
		private var mapWidth:Number = 100;
		private var mapHeight:Number = 100;
		private var mapRotation:Number = 0;
		
		//---------frame settings--//
		private var frameDraw:Boolean = true;
		private var frameMargin:Number = 50;
		private var frameRadius:Number = 20;
		private var frameFillColor:Number = 0xFFFFFF;
		private var frameFillAlpha:Number = 0.5;
		private var frameOutlineColor:Number = 0xFFFFFF;
		private var frameOutlineStroke:Number = 2;
		private var frameOutlineAlpha:Number = 1;
		
		// ---map gestures---//
		private var mapDoubleTapGesture:Boolean = true;
		private var mapDragGesture:Boolean = true;
		private var mapFlickGesture:Boolean = true;
		private var mapScaleGesture:Boolean = true;
		private var mapRotateGesture:Boolean = true;
		private var mapTiltGesture:Boolean = true;
		
		//----frame gestures---//
		private var frameDragGesture:Boolean = true;
		private var frameScaleGesture:Boolean = true;
		private var frameRotateGesture:Boolean = true;
				 
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *
		 * The Constructor.
		 * <pre>
		 * <strong>var mapDisplay:GMapDisplay = new GMapDisplay();
		 * addChild(mapDisplay);</strong></pre>
		 *
		 */
	
		public function GMapDisplay()
		{
			super();
			blobContainerEnabled=true;
			visible=false;
		}

		/**
		 *
		 * The Disposal method for the module. It will clean out and nullify all children.
		 * <pre>
		 * <strong>mapDisplay.Dispose();</strong></pre>
		 *
		 */
		override public function Dispose():void
		{
			//-----------------------------//
			if(frameDraw){
				if (frameDragGesture)
				{
					removeEventListener(TouchEvent.TOUCH_DOWN, touchDownHandler);
					removeEventListener(TouchEvent.TOUCH_UP, touchUpHandler);
				}
				if (frameScaleGesture)
				{
					removeEventListener(GestureEvent.GESTURE_SCALE, objectScaleHandler);
				}
				if (frameRotateGesture)
				{
					removeEventListener(GestureEvent.GESTURE_ROTATE, objectRotateHandler);
				}
			}
			//-----------------------------//
			
			if (mapDragGesture)
			{
				removeEventListener(TouchEvent.TOUCH_MOVE, touchMoveHandler);
			}
			if (mapDoubleTapGesture)
			{
				removeEventListener(TouchEvent.TOUCH_DOUBLE_TAP, doubleTapHandler);
			}
			if (mapFlickGesture)
			{
				removeEventListener(GestureEvent.GESTURE_FLICK, gestureFlickHandler);
			}
			if (mapScaleGesture)
			{
				removeEventListener(GestureEvent.GESTURE_SCALE, gestureScaleHandler);
			}
			if (mapRotateGesture)
			{
				removeEventListener(GestureEvent.GESTURE_ROTATE, gestureRotateHandler);
			}
			if (mapTiltGesture)
			{
				removeEventListener(GestureEvent.GESTURE_TILT, gestureTiltHandler);
			}
			
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
			//--Map Settings--//
			mapApiKey = Parser.settings.GlobalSettings.apiKey;
			stageWidth=ApplicationGlobals.application.stage.stageWidth;
			stageHeight=ApplicationGlobals.application.stage.stageHeight;
			
			currLng = Parser.settings.Content.Source[id].longitude;//-73.992062;
			currLat = Parser.settings.Content.Source[id].latitude;//40.736072;
			stepSc = Parser.settings.Content.Source[id].zoomStep; //1;
			currType = Parser.settings.Content.Source[id].initialType; //1;
			currSc = Parser.settings.Content.Source[id].initialZoom; //10;
			currAng = Parser.settings.Content.Source[id].initialAttitude; //0;
			currtiltAng = Parser.settings.Content.Source[id].initialTilt; //0;
			mapWidth = Parser.settings.Content.Source[id].mapWidth;
			mapHeight = Parser.settings.Content.Source[id].mapHeight;
			mapRotation = Parser.settings.Content.Source[id].mapRotation;
		
			//--Frame Style--//
			frameDraw = Parser.settings.FrameStyle.frameDraw == "true"?true:false;
			frameMargin = Parser.settings.FrameStyle.padding;
			frameRadius = Parser.settings.FrameStyle.cornerRadius;
			frameFillColor = Parser.settings.FrameStyle.fillColor1;
			frameFillAlpha = Parser.settings.FrameStyle.fillAlpha;
			frameOutlineColor = Parser.settings.FrameStyle.outlineColor;
			frameOutlineStroke = Parser.settings.FrameStyle.outlineStroke;
			frameOutlineAlpha = Parser.settings.FrameStyle.outlineAlpha;
			
			//---Map Gestures--//
			mapDoubleTapGesture=Parser.settings.MapGestures.doubleTap == "true" ?true:false;
			mapDragGesture=Parser.settings.MapGestures.drag == "true" ?true:false;
			mapFlickGesture=Parser.settings.MapGestures.flick == "true" ?true:false;
			mapScaleGesture=Parser.settings.MapGestures.scale == "true" ?true:false;
			mapRotateGesture=Parser.settings.MapGestures.rotate == "true" ?true:false;
			mapTiltGesture=Parser.settings.MapGestures.tilt == "true" ?true:false;
			
			//--Frame Gestures--//
			frameDragGesture=Parser.settings.FrameGestures.drag == "true" ?true:false;
			frameScaleGesture=Parser.settings.FrameGestures.scale == "true" ?true:false;
			frameRotateGesture=Parser.settings.FrameGestures.rotate == "true" ?true:false;
			
			//---------- build frame ------------------------//
			if(frameDraw)
			{							
				frame = new TouchSprite();
				addChild(frame);
			}
			
			//---------- build map ------------------------//
			map = new Map3D();
			screen = new TouchSprite();
			
			addChild(map);
			addChild(screen);
			
			//-- Add Event Listeners----------------------------------//
			map.addEventListener(MapEvent.MAP_PREINITIALIZE, onMapPreInt);
			
			if(frameDraw){
				frame.addEventListener(TouchEvent.TOUCH_DOWN, touchDownHandler);
				frame.addEventListener(TouchEvent.TOUCH_UP, touchUpHandler);
				addEventListener(GestureEvent.GESTURE_SCALE, objectScaleHandler);
				addEventListener(GestureEvent.GESTURE_ROTATE, objectRotateHandler);
			}
			
			if (mapDragGesture)
			{
				screen.addEventListener(TouchEvent.TOUCH_MOVE, touchMoveHandler);
			}
			if (mapDoubleTapGesture)
			{
				screen.addEventListener(TouchEvent.TOUCH_DOUBLE_TAP, doubleTapHandler);
			}
			if (mapFlickGesture)
			{
				screen.addEventListener(GestureEvent.GESTURE_FLICK, gestureFlickHandler);
			}
			if (mapScaleGesture)
			{
				screen.addEventListener(GestureEvent.GESTURE_SCALE, gestureScaleHandler);
			}
			if (mapRotateGesture)
			{
				screen.addEventListener(GestureEvent.GESTURE_ROTATE, gestureRotateHandler);
			}
			if (mapTiltGesture)
			{
				screen.addEventListener(GestureEvent.GESTURE_TILT, gestureTiltHandler);
			}
		}

		override protected function commitUI():void
		{						
			width=mapWidth;
			height=mapHeight;
			
			if(!frameMargin)
			{
				frameMargin=0;
			}
			
			if(frameDraw)
			{		
				frame.graphics.lineStyle(frameOutlineStroke,frameOutlineColor,frameOutlineAlpha);
				frame.graphics.beginFill(frameFillColor,frameFillAlpha);
				frame.graphics.drawRoundRect(-frameMargin/2,-frameMargin/2,mapWidth+frameMargin,mapHeight+frameMargin,frameRadius,frameRadius);
				frame.graphics.endFill();
				
				width=mapWidth+frameMargin;
				height=mapHeight+frameMargin;
			}
			
			trace(width, height);
			
			map.key = mapApiKey;
			map.setSize(new Point(mapWidth,mapHeight));
			map.sensor = "false"
			
			screen.graphics.beginFill(0xFFFFFF,0);
			screen.graphics.drawRoundRect(0,0,mapWidth,mapHeight,0,0);
			screen.graphics.endFill();
			screen.blobContainerEnabled = true;
			
			rotation = mapRotation;
			
			if (! _intialize)
			{
				_intialize=true;
				visible=true;
			}
		}
		
		override protected function updateUI():void
		{
			if( (x-(frameMargin/2)>stageWidth) || (x+width-(frameMargin/2)<0) || (y-(frameMargin/2)>stageHeight) || (y+height-(frameMargin/2)<0) )
			{
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
		
		private function onMapPreInt(event:MapEvent):void
		{
 			var mOptions:MapOptions = new MapOptions();
			mOptions.zoom = currSc;
			mOptions.center = new LatLng(currLat,currLng);
			mOptions.viewMode = View.VIEWMODE_PERSPECTIVE; 
			mOptions.attitude = new Attitude(currtiltAng,currAng,0);
			
			if(currType == 0)mOptions.mapType =MapType.SATELLITE_MAP_TYPE;  
			else if(currType == 1) mOptions.mapType =MapType.HYBRID_MAP_TYPE;
			else if(currType == 2) mOptions.mapType =MapType.NORMAL_MAP_TYPE;
			else if(currType == 3) mOptions.mapType =MapType.PHYSICAL_MAP_TYPE;
				
			map.setInitOptions(mOptions);
		}
		
		private function objectScaleHandler(event:GestureEvent):void
		{
			scaleX += event.value;
			scaleY += event.value;
		}
		
		private function objectRotateHandler(event:GestureEvent):void
		{
			rotation += event.value;
		}
		
		private function touchMoveHandler(event:TouchEvent):void 
		{
			var point:Point = map.fromLatLngToPoint(map.getCenter());
			var ang:Number = this.rotation*(Math.PI/180);
			var COS:Number = Math.cos(ang);
			var SIN:Number = Math.sin(ang);
			var pdx:Number = (point.x - (event.dy*SIN + event.dx*COS));
			var pdy:Number = (point.y - (event.dy*COS - event.dx*SIN));
			var newPoint:Point = new Point(pdx,pdy);
			var newLatLng:LatLng = map.fromPointToLatLng(newPoint);
			map.setCenter(newLatLng);
			map.cancelFlyTo();
		}
		
		private function doubleTapHandler(event:TouchEvent):void
		{
			var newPoint:Point = new Point(event.localX, event.localY);
			var nLatLng:LatLng = map.fromViewportToLatLng(newPoint, true);
			currSc += stepSc;
			map.flyTo(nLatLng, currSc, new Attitude(currAng,currtiltAng,0), 2); 
		}

		private function gestureFlickHandler(event:GestureEvent):void
		{
			if (Math.abs(event.accelerationX)>20)
			{
				var mag:int = event.velocityX/Math.abs(event.velocityX);
			
				if(mag>0){
					if(currType>=3){
						currType = 3
					}
					else{
						currType += 1;
					}
				}
				if(mag<0){
					if(currType<=0){
						currType = 0;
					}
					else{
						currType -= 1;
					}
				}
				if(currType == 0) map.setMapType(MapType.SATELLITE_MAP_TYPE)  
				else if(currType == 1) map.setMapType(MapType.HYBRID_MAP_TYPE);
				else if(currType == 2) map.setMapType(MapType.NORMAL_MAP_TYPE)
				else if(currType == 3) map.setMapType(MapType.PHYSICAL_MAP_TYPE);
				map.cancelFlyTo();
			}
		}
		
		private function gestureScaleHandler(event:GestureEvent):void
		{
			currSc += event.value;
			map.setZoom(currSc, true);
			map.cancelFlyTo();
		}
		
		private function gestureRotateHandler(event:GestureEvent):void
		{
			currAng -= event.value;
			map.setAttitude(new Attitude(currAng,currtiltAng,0));
			map.cancelFlyTo();
		}
		
		private function gestureTiltHandler(event:GestureEvent):void 
		{
			currtiltAng += event.tiltY;
			map.setAttitude(new Attitude(currAng,currtiltAng,0));
			map.cancelFlyTo();
		}
		
	}
}