package de.karfau.parallelpaint.events
{
	import flash.events.Event;
	
	import mx.messaging.messages.AsyncMessage;
	
	public class MessagingEvent extends Event
	{
		
		public static const HEADER_NAME_MESSAGETYPE:String = "MESSAGETYPE";
		public static const HEADER_NAME_SENDING_USER:String = "SENDING_USER";
		
		public static const TYPE:String = "Message";
		
		private var message:AsyncMessage;
		
		public function MessagingEvent (message:AsyncMessage) {
			super((message.headers[HEADER_NAME_MESSAGETYPE] as String) + TYPE);
			this.message = message;
		}
		
		public function get data ():Object {
			return message.body;
		}
		
		public function get sendingUser ():String {
			return message.headers[HEADER_NAME_SENDING_USER];
		}
		
		public override function toString ():String {
			return "MessagingEvent{" + type + " send by " + sendingUser + " containing <" + data + ">}";
		}
	
	}
}