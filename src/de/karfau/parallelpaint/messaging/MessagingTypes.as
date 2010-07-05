package de.karfau.parallelpaint.messaging
{
	import de.karfau.parallelpaint.events.MessagingEvent;

	public class MessagingTypes
	{
		public static const TEST:String = "test" + MessagingEvent.TYPE;

		//FIXME: Offline-State/reconnect-button for DrawingEditor
		public static const CONNECTION_LOST:String = "connectionLost";
		public static const CONNECTION_READY:String = "connectionReady";

		public static const ADD_ELEMENT:String = "addElement" + MessagingEvent.TYPE;
		public static const UPDATE_ELEMENT:String = "updateElement" + MessagingEvent.TYPE;
		public static const REMOVE_ELEMENT:String = "removeElement" + MessagingEvent.TYPE;
		public static const SELECT_ELEMENT:String = "selectElement" + MessagingEvent.TYPE;
		public static const UNSELECT_ELEMENT:String = "unselectElement" + MessagingEvent.TYPE;

	/*
		 public static const :String = "" + MessagingEvent.TYPE;
	 */
	}
}