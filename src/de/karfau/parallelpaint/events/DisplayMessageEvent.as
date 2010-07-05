package de.karfau.parallelpaint.events
{
	import de.karfau.parallelpaint.core.ColoredDisplayMessage;
	import de.karfau.parallelpaint.core.ErrorDisplayMessage;
	import de.karfau.parallelpaint.core.IDisplayMessage;

	import flash.events.Event;

	import mx.messaging.messages.IMessage;

	public class DisplayMessageEvent extends Event
	{

		public static const UNEXPECTED_ERROR:String = "unexpectedError";
		public static const AUTHENTICATION_FAULT:String = "authenticationFault";
		public static const REGISTER_SUCCESS:String = "registerSuccess";

		public static const EXPORT_STATUS:String = "exportStatus";
		public static const EXPORT_ERROR:String = "exportError";
		public static const EXPORT_DONE:String = "exportDone";

		public static const SNAPSHOT_DONE:String = "snapshotDone";

		public static function createErrorMessageEvent (type:String, error:Error):DisplayMessageEvent {
			return new DisplayMessageEvent(type, new ErrorDisplayMessage(error));
		}

		public static function createColoredMessageEvent (type:String, message:String, color:uint=0x0000FF):DisplayMessageEvent {
			return new DisplayMessageEvent(type, new ColoredDisplayMessage(message, color));
		}

		/*########################################################*/
		/*                                                        */
		/*   PROPERTIES (INCL. SETTER/GETTER)                     */
		/*                                                        */
		/*########################################################*/

		private var _message:IDisplayMessage;

		public function get message ():IDisplayMessage {
			return _message;
		}

		/*########################################################*/
		/*                                                        */
		/*   CONSTRUCTOR                                          */
		/*                                                        */
		/*########################################################*/

		public function DisplayMessageEvent (type:String, message:IDisplayMessage=null) {
			super(type);
			_message = message;
		}

		public override function clone ():Event {
			return new DisplayMessageEvent(type, message);
		}

	}
}