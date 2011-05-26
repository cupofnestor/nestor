﻿﻿package com.nestor.sxc.signage  {	import com.nestor.feeds.*;	import flash.display.MovieClip;	import flash.events.Event;	import com.adobe.xml.syndication.atom.*;	import flash.display.Loader;	import flash.display.StageDisplayState;	import flash.net.URLRequest;	import com.nestor.elements.pictureWindow;	import flash.net.URLLoader;	import flash.html.HTMLLoader;	import flash.ui.Mouse;	import flash.text.StyleSheet;	import flash.text.TextField;	import flash.geom.Rectangle;		public class sign extends MovieClip {		var evCSS:String;		var blCSS:String;		var styling:String;		public static const msperday:int = 1000 * 60 * 60 * 24;		public function sign() {			var cfgFile = "sign.cfg";			var cfgLdr:URLLoader = new URLLoader(new URLRequest(cfgFile));			cfgLdr.addEventListener(Event.COMPLETE, cfgHandler);											}				private function cfgHandler(e:Event):void		{			var cfg:XML = new XML(e.target.data);			//trace(cfg.general.updatetime);												if(cfg.screen.fullscreen == "true") fullscreen(cfg.screen.hidemouse);						evCSS=cfg.css.toString();			blCSS=cfg.css2.toString();			var BLOG:String=cfg.blog.url.toString()+cfg.blog.args.toString();			setupBlog(BLOG);						var _span=cfg.cal.span.toString();			var spanArg:String = makeSpan(_span)			styling=cfg.styling.toString();						var CAL:String=cfg.cal.url.toString()+cfg.cal.args.toString()+spanArg;			trace("URL::  "+CAL);			setupCal(CAL);											}				private function makeSpan(s:String):String		{			var span:Number = Number(s);						var today:Date = new Date();			var lastDay:Date = new Date(today.getTime() + (span * msperday));						trace("First:"+today.toString()+"  Last:"+lastDay.toString());			var mxY=lastDay.fullYear.toString();			var mxM=addZero(lastDay.month+1);			var mxD=addZero(lastDay.date);						var mnY=today.fullYear.toString();			var mnM=addZero(today.month+1);			var mnD=addZero(today.date);						var max:String=mxY+"-"+mxM+"-"+mxD;			var min:String=mnY+"-"+mnM+"-"+mnD;			var arg:String="&start-min="+min+"&start-max="+max;			return arg;		}				private function addZero(d:Number):String				{			var rtn:String;			if (d<10)			{				rtn="0"+d.toString()			}			else rtn = d.toString();			return rtn		}				private function fullscreen(m:String):void		{			//trace("Going Full");			stage.nativeWindow.activate();			stage.nativeWindow.orderToBack();			stage.nativeWindow.orderToFront();			if(m=="true") Mouse.hide();						stage.nativeWindow.alwaysInFront = true			stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;		}						private function setupCal(url:String)		{			var myCal:feedLoader=new feedLoader(url);			myCal.addEventListener("newFeed", parseCalFeed);		}				private function setupBlog(url:String)		{			var myBlog:feedLoader=new feedLoader(url);			myBlog.addEventListener("newFeed", parseBlogFeed);		}				private function parseCalFeed(c:Event):void		{						var calFeed:Array = new Array();			calFeed = c.target.feed.items;			var calHTML:String="";						for(var i=0;i<calFeed.length;i++)			{				var evStr = calFeed[i].content;				var tit = calFeed[i].title;				calHTML += parseEvent(tit, evStr);			}									events.scrollRect=new Rectangle(0,0,events.width,events.height);			if(styling=="true"){				var evStyle:StyleSheet=new StyleSheet();				//evStyle.parseCSS("p,h1{font-family: \"Franklin Gothic Book\",sans-serif;margin:0;padding:0} .location{font-size:14pt;} .desc{margin-left:12pt; text-indent:12pt;} .date{font-size:14pt;} h1{font-size:36pt;font-weight:bold;}");				evStyle.parseCSS(evCSS);				events.styleSheet = evStyle;			}			events.htmlText = calHTML;			events.height = events.textHeight;			trace(calHTML);			stage.addEventListener(Event.ENTER_FRAME, scroll);					}				private function scroll(e:Event)		{						var rect:Rectangle = events.scrollRect;			//trace(rect.y);   			if (rect.y>events.textHeight){				rect.y= -events.height;			}			else rect.y += 1;   			events.scrollRect = rect;					}				private function parseEvent(tit:String, ev:String):String		{						//Array indexes			//var iWhen:Number=0;			//var iWhere:Number=2;			//var iDesc:Number=4;			//items split at <br />			var evContent:Array = ev.split("<br />");			//trace("Array{"+evContent+"}");			//grab event properties and strip the silly prefixes			/*var where:String = evContent[iWhere];			where = splitAtColon(where);			var when:String = evContent[iWhen];			when = splitAtColon(when);			var zoneID = when.length-4;			when = when.substring(0,zoneID);			var desc:String = evContent[iDesc];			desc = splitAtColon(desc);*/			//reform html to my liking			var when,where,desc:String;			for each (var _s:String in evContent){								var aEv:Array = splitAtColon(_s);				switch(aEv[0])				{					case("Event Description"):						desc=aEv[1];						break;					case("Where"):						where=aEv[1];						break;					case("When"):						when=aEv[1];						var zoneID = when.length-4;						when = when.substring(0,zoneID);						break;				}			}						var reform:String = "";/* = //"<html>"*/						reform+="<p class=\"date\">" + when + "</p>";			reform+="<h1>" + tit + "</h1>";			reform+="<p class=\"location\">" + where + "</p>";			reform+="<p class=\"desc\">" + desc + "</p>";			reform+="<br /><br />"			//reform+="</html>";						return reform;		}				private function splitAtColon(s:String):Array		{				var aSplit:Array = s.split(": ");				(aSplit.length > 1) ? aSplit[1] : aSplit.push("  ");				return aSplit;		}				/*private function splitAtColon(s:String):String		{				var aSplit:Array = s.split(": ");				return (aSplit.length > 1) ? aSplit[1] : "   ";		}*/										private function parseBlogFeed(e:Event):void		{			var postTitle:String; 			var postContent:String;			var feed:Array = new Array();			feed = e.target.feed.items;			postTitle = feed[0].title;			postContent = feed[0].content;			this.head.text = postTitle;						////trace(postContent);			var idSub:int = postContent.search("<div");						var image:String =  postContent.substr(idSub);			var imageHTML:String = "<html>";			imageHTML += postContent+"</html>";			parseImgHTML(imageHTML);						/*			var idBR:int=postContent.search("<br />");			var bodyText:String = "<html>";			bodyText+=postContent.substr(0, idSub)+"</html>";			*/			//style();			//var webKit:HTMLLoader = new HTMLLoader(); 			var htmlStr:String = parseBlogHTML(postContent); 			//webKit.loadString(htmlStr);			//webKit.paintsDefaultBackground=false;			//addChild(webKit);			//webKit.width= this.body.width;			//webKit.height= this.body.height;			//webKit.x= this.body.x;			//webKit.y= this.body.y;									var blStyle:StyleSheet=new StyleSheet();			blStyle.parseCSS(blCSS);			this.body.styleSheet = blStyle;			this.body.condenseWhite = true;			this.body.htmlText = parseBlogHTML(postContent);					}								private function parseBlogHTML(str:String):String		{			//var postXML:XML = new XML(str);			var postList:XMLList = new XMLList(str);			//var imgURL:URLRequest=new URLRequest(xml.div.a.img.@src);			//postXML.div.a.img.@src;			//var ret:String = "<html><head><style type=\"text/css\">"+blCSS+"</style></head><body>";			var ret:String = "<html><head></head><body>";			//ret+= "We are <i>sooooo</i> happy."			ret+=str+"</body></html>";			return ret;		}						private function parseImgHTML(str:String):void		{			var blogXML:XML = new XML(str);			//var imgURL:URLRequest=new URLRequest(xml.div.a.img.@src);			this.pict_mc.loadURL(blogXML.div.a.img.@src);		}	}	}