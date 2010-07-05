package de.karfau.parallelpaint.events
{
	import flash.events.Event;
	
	public class StringEvent extends Event
	{
		
		public static const TAKE_SNAPSHOT:String = "takeSnapshot";
		
		private var _data:String;
		
		public function StringEvent (type:String, data:String) {
			this._data = data;
			super(type);
		}
		
		public function get data ():String {
			return _data;
		}
	
	}
}