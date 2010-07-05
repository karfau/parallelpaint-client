package de.karfau.parallelpaint.core
{
	
	public class ColoredDisplayMessage implements IDisplayMessage
	{
		public var _color:uint;
		
		public var _message:String;
		
		public function ColoredDisplayMessage (message:String, color:uint=0x00B909) {
			this._message = message;
			this._color = color;
			super();
		}
		
		public function get message ():String {
			return _message;
		}
		
		public function get color ():uint {
			return _color;
		}
	}
}