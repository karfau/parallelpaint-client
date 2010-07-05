package de.karfau.parallelpaint.events
{
	import flash.events.Event;
	
	public class ElementIdEvent extends Event
	{
		
		public static const ELEMENT_REMOVED:String = "elementRemoved";
		
		private var _elementId:Number;
		
		public function get elementId ():Number {
			return _elementId;
		}
		
		public function ElementIdEvent (type:String, elementId:Number) {
			this._elementId = elementId;
			super(type);
		}
	
	}
}