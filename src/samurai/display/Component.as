/*
* Copyright (c) 2010 the original author or authors
*
* Permission is hereby granted to use, modify, and distribute this file
* in accordance with the terms of the license agreement accompanying it.
*/	

package samurai.display
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	public class Component extends Sprite
	{
		public function Component()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function get size():Rectangle 
		{ 
			return _size
		}
		public function set size(value:Rectangle):void
		{
			_size = value;
		}
		
		final public function addResizeHandler():void
		{
			stage.addEventListener(Event.RESIZE, onResize);
		}
		
		final public function invalidate():void
		{
			stage.addEventListener(Event.ENTER_FRAME, onRender);
		}
		
		protected function addChildren():void
		{			
			// Abstract
		}	
		
		protected function render():void
		{			
			// Abstract
		}		
		
		private function onAddedToStage(event:Event):void
		{			
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addChildren();
		}	
		
		private function onRender(event:Event):void
		{
			stage.removeEventListener(Event.ENTER_FRAME, onRender);
			render();
		}	
		
		private function onResize(event:Event):void
		{
			invalidate();
		}
		
		//
		// Internal
		
		
		private var _size:Rectangle;	
	}
}