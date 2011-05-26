﻿package  com.nestor.hcl.quiz {	import flash.display.Sprite;	import flash.display.MovieClip;	import flash.display.NativeWindow;	import flash.display.NativeWindowInitOptions;	import flash.display.NativeWindowType;	import flash.display.NativeWindowSystemChrome;	import flash.display.Stage;	import flash.display.StageDisplayState;	import flash.desktop.NativeApplication;	import flash.text.*;	import com.nestor.tools.cfgloader;	import com.nestor.tools.phpQuery;	import flash.events.*;	import com.nestor.hcl.*;	import flash.display.StageAlign;	import flash.display.StageScaleMode;	import flashx.textLayout.events.DamageEvent;	import flash.net.*;		public class quizMain extends MovieClip {		var appCfg:XML;		var picWin:NativeWindow;		var quizes:XML;		var thisQuiz:XML;		var www:String;		var media:String;		var query:String;		var submit:String;		var list:qaList;		var pic:picLoader;		var pics:Array;		var user:String;		var email:String;		var header:header_mc;		var postAnswers:String;		var a:alert;				public function quizMain() {				loadCfg();				header=new header_mc();				NativeApplication.nativeApplication.addEventListener(Event.USER_IDLE, onUserIdle);		}								private function loadCfg(){				var cfgLoad:cfgloader=new cfgloader("quiz.cfg");				cfgLoad.addEventListener(Event.COMPLETE, init);		}				private function init(e:Event){				e.target.removeEventListener(Event.COMPLETE, init);								appCfg=e.target.cfg;				var isOn:String = appCfg.picWin.act;				var startPic:Boolean = toBool(isOn);				trace("StartPic:"+startPic);				initWindow(new XML(appCfg.main));				if(startPic) initPicWin(new XML(appCfg.picWin));				//startQuiz(); //skip Signin				signIn();						}				private function signIn():void		{			var _login:login = new login();			addChild(_login);			_login.x=appCfg.login.@X;			_login.y=appCfg.login.@Y;			NativeApplication.nativeApplication.idleThreshold=appCfg.main.idleTime;			_login.addEventListener(Event.COMPLETE, signedIn);		}						private function signedIn(e:Event):void		{			var li:login =  e.target as login;			li.removeEventListener(Event.COMPLETE, signedIn);			user=li.user;			email=li.email;			removeChild(li);			startQuiz();		}						private function startQuiz():void		{			//initWindow(new XML(appCfg.main));			//initPicWin(new XML(appCfg.picWin));			initNet(new XML(appCfg.net));		}				private function initWindow(_cfg:XML) {				//this.stage.width = _cfg.width;               // this.stage.height = _cfg.height;				stage.nativeWindow.x=_cfg.xoff;				stage.displayState = toBool(_cfg.fullscreen.toString()) ? StageDisplayState.FULL_SCREEN_INTERACTIVE : StageDisplayState.NORMAL;				stage.nativeWindow.alwaysInFront = toBool(_cfg.fullscreen.toString());				stage.scaleMode = StageScaleMode.NO_SCALE;				stage.align = StageAlign.TOP_LEFT;								        }						private function initPicWin(_cfg:XML) {				trace("adding picWin");				var opts:NativeWindowInitOptions = new NativeWindowInitOptions();                opts.type = NativeWindowType.LIGHTWEIGHT;				opts.systemChrome = NativeWindowSystemChrome.NONE;				opts.resizable=true;				                picWin = new NativeWindow(opts);                picWin.title = "My New Window";                picWin.width = _cfg.width;                picWin.height = _cfg.height;				             																	//picWin.stage.displayState = toBool(_cfg.fullscreen.toString()) ? StageDisplayState.FULL_SCREEN : StageDisplayState.NORMAL;								picWin.alwaysInFront = toBool(_cfg.fullscreen.toString());				picWin.stage.scaleMode = StageScaleMode.NO_SCALE;				picWin.stage.align = StageAlign.TOP_LEFT;								pic = new picLoader();				picWin.stage.addChild(pic);				picWin.activate();				//picWin.stage.displayState = StageDisplayState.FULL_SCREEN;				var winX:Number =_cfg.xoff;				var winY:Number =_cfg.yoff;								picWin.x=winX;				picWin.y=winY;						}				private function initNet(_cfg:XML) {				www=_cfg.www.toString();				media=_cfg.media.toString();				query=_cfg.query.toString();				submit=_cfg.submit.toString();				var php:phpQuery=new phpQuery(www+query);				php.addEventListener(Event.COMPLETE,phpLoaded);										}				private function phpLoaded(e:Event):void		{			trace("php Loaded");			quizes = e.target.vars;			var classes:Array = [];			for each (var q:* in quizes.quiz)			{				classes.push(q.qclass.toString());			}			var list:class_list = new class_list(classes);			addChild(list);			list.x=appCfg.questions.xoff;			list.y=appCfg.questions.yoff;					}					private function makequiz(i:Number)		{			thisQuiz=new XML(quizes[i].quiz);			//var isset:Boolean = quiz[0][5];			trace("name: "+thisQuiz.quiz.row);									initPics();			initHeader();			_title.text=quizes.quiz[0].name;			/*			for each (var r:XML in quiz.row){				trace("ROW");				trace(r.image);			}*/		}				private function initList(_cfg:XML) {												list = new qaList(_cfg,thisQuiz);				list.addEventListener(Event.CHANGE, flip);				addChild(list);				list.x=Number(_cfg.xoff);				list.y=Number(_cfg.yoff);								list.setup(user,email,pics);				list.addEventListener("submit", youSure);				/*				var qa_mc = new qa(_cfg);				addChild(qa_mc);				qa_mc.x=_cfg.xoff;				qa_mc.y=_cfg.yoff;*/						}				private function initPics() {				pics = new Array();				for each (var s:String in thisQuiz.row.image)				{					pics.push(www+media+s);				}								pic.preload(pics);				initList(new XML(appCfg.questions));		}				private function initHeader():void		{						addChild(header);			header.x=appCfg.header.@X;			header.y=appCfg.header.@Y;					}				private function setHeader(i:Number):void		{			trace("QUIZ-Row-text: "+Boolean(thisQuiz.row[i].text));			if(thisQuiz.row[i].text!=""){header._label.text = thisQuiz.row[i].text.toString()};		}				private function flip(e:Event):void		{			if (e.target is pagination){				pic.loadIMG(e.target.currentPage);				setHeader(e.target.currentPage);			}		}				private function youSure(e:Event):void		{			a=new alert();			dimAll(this);			a.x = appCfg.alert.@X;			a.y = appCfg.alert.@Y;			addChild(a);			a.okbtn.addEventListener(MouseEvent.MOUSE_UP,isSure);			a.cancelbtn.addEventListener(MouseEvent.MOUSE_UP,notSure);		}				private function isSure(m:Event):void		{			trace("SURE");			removeChild(a);			a=null;			brightAll(this);			submitPHP(list.answers,list.user);		}				private function notSure(m:Event):void		{			removeChild(a);			a=null;			brightAll(this);		}				public function submitPHP(a:String,n:String):void		{			var phpS:String=new String(www+submit); 			trace("submitting to:"+phpS);			var myData:URLRequest = new URLRequest(phpS);			myData.method = URLRequestMethod.POST;			var vars:URLVariables = new URLVariables();			var _filename=noSpace(n);			vars.name =_filename;			vars.html=a;			myData.data = vars;			//navigateToURL(myData);			var loader:URLLoader = new URLLoader();			loader.dataFormat = URLLoaderDataFormat.TEXT;			loader.addEventListener(Event.COMPLETE, doComplete);						try {    			loader.load(myData);			} catch (error:Error) {    			trace("ERROR: "+error);			} finally {  							}					 }				function doComplete(e:Event):void		{			suicide(e)		}						function onUserIdle(e:Event):void		{			trace("idle");			var w:warning=new warning();			dimAll(this);			w.x = appCfg.alert.@X;			w.y = appCfg.alert.@Y;			addChild(w);			w.addEventListener("cancelled", moreTime);			w.addEventListener("timeout", suicide);					}				private function moreTime(e:Event):void		{			trace(" ");			var _w:warning = e.target as warning;			_w.removeEventListener("cancelled", moreTime);			_w.removeEventListener("timeout", suicide);			removeChild(_w);			brightAll(this);		}				private function suicide(e:Event):void		{			NativeApplication.nativeApplication.exit();		}				public function noSpace(originalstring:String):String		{			var original:Array=originalstring.split(" ");			return(original.join("_"));		}		function dimAll(d:MovieClip){						var l:Number= d.numChildren;			for (var i = 0; i<l; i++)			{				if (d.getChildAt(i) is Sprite)				{					var o:Sprite = d.getChildAt(i) as Sprite;					o.alpha = 0.3;					o.mouseEnabled = false;					trace("dim");				}			}					}				function brightAll(d:MovieClip){						var l:Number= d.numChildren;			for (var i = 0; i<l; i++)			{				if (d.getChildAt(i) is Sprite)				{					var o:Sprite = d.getChildAt(i) as Sprite;					o.alpha = 1;					o.mouseEnabled = true;					trace("bright");				}			}					}				private function toBool(val:*):Boolean		{			var ret:Boolean;			switch(val){				case "1":				case "true":				case "yes":					ret = true;					break;				case "0":				case "false":				case "no":					ret = false;					break;			}			return ret;		}	}			}