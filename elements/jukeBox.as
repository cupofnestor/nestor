﻿package com.nestor.elements {	import flash.media.Sound;	import flash.media.SoundTransform;	import flash.media.SoundChannel;	import flash.net.URLRequest;	import flash.events.*;		public class jukeBox {		private var sndsURL:Array = new Array();		private var box:Array = new Array();		private var randI:Array = new Array();		private var shufI:Number = 0;		private var juke:SoundChannel = new SoundChannel();		var tran:SoundTransform = new SoundTransform();		public function jukeBox(_sounds:Array) {			// constructor code			sounds = _sounds		}				public function set sounds(snds:Array):void		{			sndsURL = snds;			loadSounds();		}				public function set vol(val:Number):void		{			tran = new SoundTransform(val);			juke.soundTransform = tran;		}				private function loadSounds():void		{			for each (var url:String in sndsURL){				var snd:Sound = new Sound();				snd.addEventListener(Event.COMPLETE, completeHandler);				var req:URLRequest = new URLRequest(url);				box.push(snd);				snd.load(req);							}			buildRandomIndex();					}				private function completeHandler(event:Event):void {            trace("completeHandler: " + event);        }				private function buildRandomIndex():void		{			randI = shuffle(range(box.length))		}				public function playRand():void		{						if(shufI >= box.length)			{				buildRandomIndex();				shufI = 0;			}						playSnd(randI[shufI]);						shufI++;		}							public function playSnd(_i:Number):void		{			trace("JukeBox:: Playing Sound::  " + sndsURL[_i]);						juke = box[_i].play(0,0,tran);			trace(juke);			//box[_i].play();		}				private function range(l:Number):Array		{			var ret:Array = new Array();			for (var i:Number = 0; i<l; i++) ret.push(i);			return ret;		}				private function shuffle(lin:Array):Array		{			var shuf:Array = new Array(lin.length); 			var randomPos:Number = 0;			for (var i:int = 0; i < shuf.length; i++)				{					randomPos = int(Math.random() * lin.length);					shuf[i] = lin.splice(randomPos, 1)[0];   //since splice() returns an Array, we have to specify that we want the first (only) element				}			return shuf;		}	}	}