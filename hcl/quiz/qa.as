﻿package com.nestor.hcl.quiz {		import flash.display.MovieClip;	import flash.events.*;	import com.greensock.TweenLite;		public class qa extends MovieClip {		var def:String;		var iH:Number;		var iW:Number;		var iX:Number;		var iY:Number;				var tH:Number;		var tY:Number;		var time:Number=0.25;		var ease:String = "";		var fH:Number;		var cH:Number;		var ftH:Number;		var ctH:Number;		var hY:Number;						public var id:Number;		private var question:String;				public var current:Boolean=false;				public function qa(_cf:XML,_q:String) {			// constructor code			addEventListener(Event.ADDED_TO_STAGE, init);			_handle.alpha=0;						question=_q;			ftH=_cf.field.@maxheight;			fH=_cf.field.@initHeight;			def=_answer.text=_cf.field.@defaultContent;			ctH=_cf.container.@maxheight;			cH=_cf.container.@initHeight;						hY=_cf.handle.@tY;			tY=0;						iH=_cf.qa.@height;			iW=_cf.qa.@width;						iX=0;								}				public function init(e:Event):void		{			iY = iH*id;			this.x=iX;			this.y=iY;			trace("Question item: "+question);						_id.text=(id+1)+".";			_question.text=question;								}				public function expand():void		{			trace("Tweening this.y to:"+tY+"  , container height to: "+tH);						TweenLite.to(this, time, {y:tY});			TweenLite.to(_container, time, {height:ctH, onComplete:expanded});			TweenLite.to(_handle, time, {y:hY,alpha:1});		}				private function expanded():void		{			TweenLite.to(_answer, time, {height:ftH});			_handle.addEventListener(MouseEvent.MOUSE_UP, collapse);		}				public function collapse(e:Event):void		{			_answer.text = (_answer.text == "") ? def : _answer.text;						_handle.removeEventListener(MouseEvent.MOUSE_UP, collapse);			//_handle.rotation=180;			TweenLite.to(this, time, {y:iY});			TweenLite.to(_handle, time, {y:0,alpha:0});			TweenLite.to(_answer, time, {height:fH});			TweenLite.to(_handle, time, {y:0,alpha:0});			TweenLite.to(_container, time, {height:cH, onComplete:collapsed});		}				private function collapsed():void		{			dispatchEvent(new Event("collapsed"));			//_handle.rotation=0;		}				public function show():void		{			this.mouseEnabled=true;			TweenLite.to(this, time*2, {alpha:1});		}		public function hide():void		{			this.mouseEnabled=false;			TweenLite.to(this, time/2, {alpha:0});		}	}	}