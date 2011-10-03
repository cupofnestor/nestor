////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2010 Ideum
//  All Rights Reserved.
//
//  GestureWorks
//
//  File:     Version.as
//  Author:   Chris Gerber (chris(at)ideum(dot)com)
//
//  NOTICE: Ideum permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////
package id.managers
{

import id.core.id_internal;
import id.core.ApplicationGlobals;
import id.structs.ComponentPriorityQueue;

import flash.events.Event;
import flash.events.EventDispatcher;
import id.core.TouchComponent;

use namespace id_internal;

public class LifeCycleManager extends EventDispatcher
{
	
	private static var instance:LifeCycleManager;
	public static function getInstance():LifeCycleManager
	{
		if(!instance)
			instance = new LifeCycleManager();

		return instance;
	}

	//--------------------------------------------------------------------------
	//
	//  Variables
	//
	//--------------------------------------------------------------------------

	private var application:Object;
	
	private var eventsAttached:Boolean;
	private var waitedAFrame:Boolean;
	
	private var invalidatePropertiesQueue:ComponentPriorityQueue;
	private var invalidateSizeQueue:ComponentPriorityQueue;
	private var invalidateDisplayListQueue:ComponentPriorityQueue;
	private var updateCompleteQueue:ComponentPriorityQueue;
	
	private var invalidatePropertiesFlag:Boolean;
	private var invalidateSizeFlag:Boolean;
	private var invalidateDisplayListFlag:Boolean;
	
	private var targetLevel:int = int.MAX_VALUE;
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------

    /**
     *  Constructor.
     *  
     * @langversion 3.0
     * @playerversion AIR 1.5
     * @playerversion Flash 10
     * @playerversion Flash Lite 4
     * @productversion GestureWorks 1.5
     */ 
	public function LifeCycleManager()
	{
		super();
		
		invalidatePropertiesQueue = new ComponentPriorityQueue();
		invalidateSizeQueue = new ComponentPriorityQueue();
		invalidateDisplayListQueue = new ComponentPriorityQueue();
		updateCompleteQueue = new ComponentPriorityQueue();
		
		application = ApplicationGlobals.application;
		
	}

	//--------------------------------------------------------------------------
	//
	//  Methods: LifeCycle Mechanism
	//
	//--------------------------------------------------------------------------
	
	private function establishLifeCycle():void
	{
		////trace("\n");
		////trace("establishLifeCycle");
		if(invalidatePropertiesFlag)
		{
			validateProperties();
		}
		
		if(invalidateSizeFlag)
		{
			validateSize();
		}
		
		if(invalidateDisplayListFlag)
		{
			validateDisplayList();
		}
		
		eventsAttached = false;
		
		var obj:TouchComponent = updateCompleteQueue.removeLargest();
		while(obj)
		{
			if(!obj.initialized)
			{
				obj.initialized = true;
			}
			
			obj.updateCompletePendingFlag = false;
			obj = updateCompleteQueue.removeLargest();
		}
	}
	
	public function validateClient(target:TouchComponent, skipDisplayList:Boolean = false):void
	{
		var obj:TouchComponent;
		
		obj = invalidatePropertiesQueue.removeSmallestChild(target) as TouchComponent;
		while(obj)
		{
			obj.validateProperties();
			if(!obj.updateCompletePendingFlag)
			{
				updateCompleteQueue.addObject(obj, obj.nestLevel);
				obj.updateCompletePendingFlag = true;
			}
			
			obj = invalidatePropertiesQueue.removeSmallestChild(target) as TouchComponent;
		}
		
		invalidatePropertiesFlag = false;
		
		obj = invalidateSizeQueue.removeLargestChild(target) as TouchComponent;
		while(obj)
		{
			obj.validateSize();
			if(!obj.updateCompletePendingFlag)
			{
				updateCompleteQueue.addObject(obj, obj.nestLevel);
				obj.updateCompletePendingFlag = true;
			}
			
			// add support for properties invalidation
			
			obj = invalidateSizeQueue.removeLargestChild(target) as TouchComponent;
		}
		
		invalidateSizeFlag = false;
		
		/*
		if(skipDisplayList)
		{
			break;
		}
		*/
		
		if(!skipDisplayList)
		{
			obj = invalidateDisplayListQueue.removeSmallestChild(target) as TouchComponent;
			while(obj)
			{
				obj.validateDisplayList();
				if(!obj.updateCompletePendingFlag)
				{
					updateCompleteQueue.addObject(obj, obj.nestLevel);
					obj.updateCompletePendingFlag = true;
				}
				
				// add support for properties and size invalidation
				
				obj = invalidateDisplayListQueue.removeSmallestChild(target) as TouchComponent;
			}
			
			invalidateDisplayListFlag = false;
		}
		
		obj = updateCompleteQueue.removeLargestChild(target) as TouchComponent;
		while(obj)
		{
			if(!obj.initialized)
			{
				obj.initialized = true;
			}
			
			obj.updateCompletePendingFlag = false;
			obj = updateCompleteQueue.removeLargestChild(target) as TouchComponent;
		}
	}

	//--------------------------------------------------------------------------
	//
	//  Methods: Invalidation
	//
	//--------------------------------------------------------------------------
	
	public function invalidateProperties(obj:*):void
	{
		if(!invalidatePropertiesFlag && application)
		{
			invalidatePropertiesFlag = true;
			
			if(!eventsAttached)
			{
				attachEvents(application);
			}
		}
		
		/*
		if(invalidatePropertiesQueue.indexOf(obj) != -1)
		{
			return;
		}
		*/
		
		//invalidatePropertiesQueue.push(obj);
		invalidatePropertiesQueue.addObject(obj, obj.nestLevel);
	}
	
	public function invalidateSize(obj:*):void
	{
		if(!invalidateSizeFlag && application)
		{
			invalidateSizeFlag = true;
			
			if(!eventsAttached)
			{
				attachEvents(application);
			}
		}
		
		/*
		if(invalidateSizeQueue.indexOf(obj) != -1)
		{
			return;
		}
		*/
		
		//invalidateSizeQueue.push(obj);
		invalidateSizeQueue.addObject(obj, obj.nestLevel);
	}
	
	public function invalidateDisplayList(obj:*):void
	{
		if(!invalidateDisplayListFlag && application)
		{
			invalidateDisplayListFlag = true;
			
			if(!eventsAttached)
			{
				attachEvents(application);
			}
		}
		
		/*
		if(invalidateDisplayListQueue.indexOf(obj) != -1)
		{
			return;
		}
		*/
		
		//invalidateDisplayListQueue.push(obj);
		invalidateDisplayListQueue.addObject(obj, obj.nestLevel);
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods: Validation
	//
	//--------------------------------------------------------------------------
	
	private function validateProperties():void
	{
		/*
		var idx:uint;
		var index:int;
		
		for(idx=0; idx<invalidatePropertiesQueue.length; idx++)
		{
			invalidatePropertiesQueue[idx].validateProperties();
		}
		
		invalidatePropertiesFlag = false;
		invalidatePropertiesQueue = null;
		*/
		
		var obj:TouchComponent = invalidatePropertiesQueue.removeSmallest();
		while(obj)
		{
			obj.validateProperties();
			if(!obj.updateCompletePendingFlag)
			{
				updateCompleteQueue.addObject(obj, obj.nestLevel);
				obj.updateCompletePendingFlag = true;
			}
			
			obj = invalidatePropertiesQueue.removeSmallest();
		}
		
		if(!invalidatePropertiesQueue.isEmpty())
		{
			throw new Error("invalidatePropertiesQueue !empty");
		}
		
		invalidatePropertiesFlag = false;
	}
	
	private function validateSize():void
	{
		/*
		var idx:uint;
		
		for(idx=0; idx<invalidateSizeQueue.length; idx++)
		{
			invalidateSizeQueue[idx].validateSize();
		}
		
		invalidateSizeFlag = false;
		invalidateSizeQueue = null;
		*/
		
		var obj:TouchComponent = invalidateSizeQueue.removeLargest();
		while(obj)
		{
			obj.validateSize();
			if(!obj.updateCompletePendingFlag)
			{
				updateCompleteQueue.addObject(obj, obj.nestLevel);
				obj.updateCompletePendingFlag = true;
			}
			
			obj = invalidateSizeQueue.removeLargest();
		}
		
		if(!invalidateSizeQueue.isEmpty())
		{
			throw new Error("invalidateSizeQueue !empty");
		}
		
		invalidateSizeFlag = false;
	}
	
	private function validateDisplayList():void
	{
		/*
		var idx:uint;
		
		for(idx=0; idx<invalidateDisplayListQueue.length; idx++)
		{
			invalidateDisplayListQueue[idx].validateDisplayList();
		}
		
		invalidateDisplayListFlag = false;
		invalidateDisplayListQueue = null;
		*/
		//trace("LifeCycle *** validateDisplayList")
		var obj:TouchComponent = invalidateDisplayListQueue.removeSmallest();
		while(obj)
		{
			obj.validateDisplayList();
			if(!obj.updateCompletePendingFlag)
			{
				updateCompleteQueue.addObject(obj, obj.nestLevel);
				obj.updateCompletePendingFlag = true;
			}
			
			obj = invalidateDisplayListQueue.removeSmallest();
		}
		
		if(!invalidateDisplayListQueue.isEmpty())
		{
			throw new Error("invalidateDisplayListQueue !empty");
		}
		
		invalidateDisplayListFlag = false;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Events: Management
	//
	//--------------------------------------------------------------------------
	
	private function attachEvents(application:Object):void
	{
		if(!waitedAFrame)
		{
			application.stage.addEventListener(Event.ENTER_FRAME, waitAFrame);
		}
		else
		{
			application.stage.addEventListener(Event.ENTER_FRAME, application_enterFrameHandler);
		}
		
		eventsAttached = true;
	}
	
	private function waitAFrame(event:Event):void
	{
		application.stage.removeEventListener(Event.ENTER_FRAME, waitAFrame);
		application.stage.addEventListener(Event.ENTER_FRAME, application_enterFrameHandler);
		
		waitedAFrame = true;
		//trace("wait a frame")
	}
	
	//--------------------------------------------------------------------------
	//
	//  Events: Callbacks
	//
	//--------------------------------------------------------------------------
	
	private function application_enterFrameHandler(event:Event):void
	{
		application.stage.removeEventListener(Event.ENTER_FRAME, application_enterFrameHandler);
		
		establishLifeCycle();
	}
	
}

}