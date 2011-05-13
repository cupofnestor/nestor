﻿package  {	import flash.net.LocalConnection;	import flash.display.MovieClip;	import flash.display.NativeWindow;	import flash.display.NativeWindowDisplayState;	import flash.display.StageDisplayState;			import flash.net.*;	import flash.events.*;	import fl.video.VideoPlayer;	import fl.video.*;	import flash.media.Video;		public class player extends MovieClip{		private var datagramSocket:DatagramSocket = new DatagramSocket();		var myPlayer:VideoPlayer = new VideoPlayer(723,523);		var cfg:XML;		var sqlData:Array;		var db_id:Number=0;		var db_title:Number=1;		var db_file:Number=2;		var db_length:Number=3;		var db_abs:Number=4;		var db_desc:Number=5;		var db_thumb:Number=6;		var db_image:Number=7;		var db_position:Number=8;		var db_active:Number=9;		var host:String;		var path:String;				public function player() {												myPlayer.scaleMode = VideoScaleMode.EXACT_FIT;			frame_mc.addChild(myPlayer);			addEventListener(Event.ADDED, winInit);						myPlayer.addEventListener(VideoEvent.COMPLETE, reset);			var cfgLoader:URLLoader = new URLLoader();			cfgLoader.addEventListener(Event.COMPLETE, cfgLoaded);			cfgLoader.load(new URLRequest("courtTV_conf.xml"));		}						function cfgLoaded(e:Event):void		{   			cfg=new XML(e.target.data);  			trace(cfg);			host=cfg.net.host;			path=cfg.net.path;			var PHPgateway:String="http://"+cfg.net.host+":"+cfg.net.amfphp.port+cfg.net.amfphp.gateway			var myLoader:MovieClip = new amfPHPLoader(PHPgateway);			trace(PHPgateway);			myLoader.goGet("courtTV.getList");			myLoader.addEventListener(Event.COMPLETE, loadDone);			initUDP();								}				function winInit(e:Event):void		{					}				function reset(v:VideoEvent):void		{			myPlayer.stop();			myPlayer.clear();			attract_frame.opacity(1);			attract_frame.gotoAndPlay(1);					}		private function loadDone(e:Event):void		{			sqlData = e.target.d;			trace("sql:"+sqlData[1]);					}		public function initUDP():void		{			datagramSocket.addEventListener(DatagramSocketDataEvent.DATA, dataHandler);       		datagramSocket.addEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler);      		datagramSocket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);			       		datagramSocket.bind(int(cfg.net.udp.port), "127.0.0.1");			datagramSocket.receive();			trace("waiting for connection");		}						private function dataHandler(e:DatagramSocketDataEvent) : void {								var msg:String = e.data.readUTFBytes(e.data.length);				var aMsg:Array = msg.split(";");				var cmd:String=aMsg[0];				var vidID:String=aMsg[1];				var vidFile:String = sqlData[int(vidID)][db_file];				var fullPath:String="http://"+host+path+vidFile;				trace("Command: "+aMsg[0]+" \n"+"Url: "+aMsg[1]);				if(cmd=="play")				{					title.text=sqlData[int(vidID)][db_title];					time.text=sqlData[int(vidID)][db_length]+" minutes";					abs.text=sqlData[int(vidID)][db_abs];					trace("Playing: "+vidID);					attract_frame.opacity(0);					attract_frame.stop();					myPlayer.play(fullPath);					myPlayer.addEventListener(VideoEvent.READY, vidReady);								trace("@:"+fullPath);									}				else if(cmd=="stop")				{					myPlayer.stop();				}				else trace(aMsg+" is an invalid command string");				   								//myPlayer.play(msg);						}					private function vidReady(v:VideoEvent):void		{			trace("Vid Ready");			trace("MyPlayer:"+myPlayer.width+":"+ myPlayer.height);			trace("vid:"+myPlayer.videoWidth+":"+ myPlayer.videoHeight);			var scale=myPlayer.videoWidth/myPlayer.width;			trace("Scale:"+scale);			myPlayer.setScale(scale,scale);								}		private function IOErrorHandler(event:IOErrorEvent) : void {					trace(event);						}				private function securityErrorHandler(event:SecurityErrorEvent) : void {						trace(event);					}				public function playVid() {								}	}	}