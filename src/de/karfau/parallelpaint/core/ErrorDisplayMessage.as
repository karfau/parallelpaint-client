package de.karfau.parallelpaint.core
{
	
	public class ErrorDisplayMessage implements IDisplayMessage
	{
		private var _error:Error;
		
		public function ErrorDisplayMessage (error:Error) {
			this._error = error;
			super();
		}
		
		public function get color ():uint {
			return 0xFF0000;
		}
		
		public function get message ():String {
			return _error.message;
		}
	
	}
}