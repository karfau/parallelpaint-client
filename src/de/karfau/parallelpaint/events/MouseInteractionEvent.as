package de.karfau.parallelpaint.events
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class MouseInteractionEvent extends Event
	{
		
		public static const MOUSE_DOWN:String = "mouseDownInteraction";
		public static const MOUSE_MOVE:String = "mouseMoveInteraction";
		public static const MOUSE_UP:String = "mouseUpInteraction";
		
		protected var _event:MouseEvent;
		
		public function get event ():MouseEvent {
			return _event;
		}
		
		public function MouseInteractionEvent (type:String, event:MouseEvent) {
			super(type, false, false);
			this._event = event;
		}
		
		override public function clone ():Event {
			return new MouseInteractionEvent(type, _event);
		}
	}
}