﻿package com.nestor.hcl.quiz {		import flash.display.MovieClip;	import flash.events.*;		public class pagination extends MovieClip {		private var thisP:Number;		protected var lastP:Number;		private var inactive:Number=0.2;		private var initP:Number;				public function pagination(_initP:Number = 0) {			initP = _initP;			addEventListener(MouseEvent.MOUSE_UP, nav);						addEventListener(Event.ADDED_TO_STAGE, init);		}				private function init(e:Event){			 currentPage = initP;		}				public function set lastPage(_l:Number):void		{			lastP = _l;			_lastPage.text=String(lastP+1);		}				public function get lastPage():Number		{			return lastP;		}				public function set currentPage(_p:Number):void		{			checkRange(_p);			thisP = _p;			_page.text=String(thisP+1);			dispatchEvent(new Event(Event.CHANGE, true));			trace("Dispatching Event: CHANGE");		}				public function get currentPage():Number		{			return thisP;		}				private function checkRange(i:Number)		{			if(i==lastP) deactivate(next);			else if(i==0) deactivate(prev);			else if(!next.mouseEnabled)activate(next);			else if(!prev.mouseEnabled)activate(prev);		}				private function nav(e:Event):void		{			if(e.target is anArrow){				(e.target.name=="next") ? nextP() : prevP();			}		}						private function nextP(){						this.currentPage=thisP+1;		}		private function prevP(){						this.currentPage=thisP-1;		}				private function activate(d:MovieClip){			d.alpha=1;			d.mouseEnabled=true;		}		private function deactivate(d:MovieClip){			d.alpha=inactive;			d.mouseEnabled=false;		}	}	}