package de.karfau.parallelpaint.core.tools
{
	import flash.events.Event;
	
	public class DispatchEventTool extends AbstractTool
	{
		private var _event:Event;
		
		public function get event ():Event {
			return _event.clone();
		}
		
		public function DispatchEventTool (event:Event, groupName:String=null) {
			super(false, groupName);
			_event = event;
		}
	}
}