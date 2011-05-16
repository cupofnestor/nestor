﻿package  {		import flash.display.*;	import flash.events.*;	import flash.display.Stage;	import flash.filters.BlurFilter;	import flash.filters.BitmapFilterQuality;	import flash.filesystem.*;	import flash.net.*;	import flash.display.BlendMode;	import flash.geom.Matrix;	import com.adobe.	images.JPGEncoder;	import flash.utils.ByteArray;		public class hilite extends MovieClip {		var canvas:MovieClip;		var layers:MovieClip;		var blkLayer:MovieClip;		var circLayer:MovieClip;		var stH,stW:Number;		var ldr:Loader;		var cScale:Number = 0.87;		var blurX:Number = 10;		var blurY:Number = 10;		var stX,stY,dX,dY:Number;		var blur:BlurFilter;		var file,dest:File;		var img:Bitmap;		var W,H:Number;		var bmd:BitmapData;		public function hilite() {			addEventListener(Event.ADDED_TO_STAGE, init);		}				private function init(e:Event)		{			save.alpha = 0;			stage.align = StageAlign.TOP_LEFT;			ldr = new Loader();						stW=stage.stageWidth;			stH=stage.stageHeight;									file=new File();			blur=new BlurFilter(blurX,blurY,BitmapFilterQuality.HIGH);			trace(stage.stageWidth+"/"+stage.stageHeight);			open.addEventListener(MouseEvent.MOUSE_UP, openFile);								}								private function openFile(m:Event):void		{			file.addEventListener(Event.SELECT, fileSelected);			file.browseForOpen("Select an Image");		}				private function fileSelected(e:Event){			trace(e.target.url);			var req:URLRequest = new URLRequest(e.target.url);			ldr.load(req);			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, setupCanv);					}						private function setupCanv(e:Event){									var _l,_t,_w,_h:Number;						_w=ldr.width;			_h=ldr.height;						var horiz:Boolean = (_w>_h) ? true : false;			var scale:Number = (horiz) ? 640/_w : 640/_h;			W=_w*scale;			H=_h*scale;						var matrix:Matrix = new Matrix();			matrix.scale(scale, scale);			var imgData:BitmapData = new BitmapData(W, H, true, 0x000000);			imgData.draw(ldr, matrix, null, null, null, true);			img = new Bitmap(imgData, PixelSnapping.NEVER, true);						_w=img.width;			_h=img.height;						_l=(container_mc.width-_w)/2;						canvas=new MovieClip();			layers=new MovieClip();						circLayer=new MovieClip();			//circLayer.width=_w;			//circLayer.height=_h;						layers.addChild(circLayer);						canvas.addChild(img);			canvas.addChild(layers);						canvas.BlendMode=BlendMode.OVERLAY;						container_mc.addChild(canvas);			canvas.x=_l;			canvas.y=0;			canvas.width=_w;			canvas.height=_h;						/*blkLayer.graphics.lineStyle(0);			blkLayer.graphics.beginFill(0x000000);			blkLayer.graphics.drawRect(0,0,_w,_h);			blkLayer.endFill;			*/									canvas.addEventListener(MouseEvent.MOUSE_DOWN, startCircle);		}						private function startCircle(e:Event):void		{			trace("MouseDown");			circLayer.graphics.clear();			stX=canvas.mouseX;			stY=canvas.mouseY;			canvas.removeEventListener(MouseEvent.MOUSE_DOWN, startCircle);			canvas.addEventListener(MouseEvent.MOUSE_MOVE,drawCirc);			canvas.addEventListener(MouseEvent.MOUSE_UP,endCirc);		}				private function drawCirc(m:Event){			dX=canvas.mouseX-stX;			dY=canvas.mouseY-stY;			circLayer.graphics.clear();			circLayer.graphics.lineStyle(5);			circLayer.graphics.beginFill(0xffffff);			circLayer.graphics.drawEllipse(stX,stY,dX,dY);			circLayer.endFill;					}				private function endCirc(m:Event):void		{			canvas.removeEventListener(MouseEvent.MOUSE_MOVE,drawCirc);			canvas.addEventListener(MouseEvent.MOUSE_DOWN, startCircle);			circLayer.filters=[blur];			circLayer.alpha=0.8;			bmd = new BitmapData(W,H);			bmd.draw(img);			bmd.draw(circLayer,null,null,BlendMode.OVERLAY,null,true);			circLayer.filters=[];			circLayer.graphics.clear();			circLayer.graphics.lineStyle(0,0,0);			circLayer.graphics.beginBitmapFill(bmd);			circLayer.graphics.drawRect(0,0,W,H);			circLayer.endFill;			save.alpha=1;			save.addEventListener(MouseEvent.MOUSE_UP, saveFile);		}				function saveFile(m:Event):void		{			save.removeEventListener(MouseEvent.MOUSE_UP, saveFile);			dest = File.desktopDirectory.resolvePath("myImage.jpg");			dest.addEventListener(Event.SELECT, destSelected);			dest.browseForSave("Save Your Image")		}						private function destSelected(e:Event){						var enc:JPGEncoder = new JPGEncoder();			var bytes:ByteArray = enc.encode(bmd);			var fs:FileStream = new FileStream();			try{			 //open file in write mode			 fs.open(dest,FileMode.WRITE);			 //write bytes from the byte array			 fs.writeBytes(bytes);			 //close the file			 fs.close();			}catch(e:Error){			 trace(e.message);			}						container_mc.removeChild(canvas);			save.alpha=0;		}			}	}