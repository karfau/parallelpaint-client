package de.karfau.parallelpaint.messaging
{
	import de.karfau.flexlogplus.*;
	import de.karfau.parallelpaint.events.MessagingEvent;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.messaging.Channel;
	import mx.messaging.ChannelSet;
	import mx.messaging.MultiTopicConsumer;
	import mx.messaging.Producer;
	import mx.messaging.SubscriptionInfo;
	import mx.messaging.channels.PollingChannel;
	import mx.messaging.events.ChannelEvent;
	import mx.messaging.events.MessageAckEvent;
	import mx.messaging.events.MessageEvent;
	import mx.messaging.events.MessageFaultEvent;
	import mx.messaging.messages.AsyncMessage;
	import mx.rpc.events.FaultEvent;
	
	import org.robotlegs.mvcs.Actor;
	
	public class MessagingProxy extends Actor
	{
		
		private var consumer:MultiTopicConsumer;
		
		public static const DESTINATION:String = "chat";
		//TODO: convert to instancevariables
		public static var sendingUser:String;
		public static var ignoreMessagesFromSendingUser:Boolean = false;
		
		public static function createASyncMessage (messageBody:Object, messageType:String):AsyncMessage {
			var result:AsyncMessage = new AsyncMessage(messageBody);
			if (messageType)
				result.headers[MessagingEvent.HEADER_NAME_MESSAGETYPE] = messageType;
			result.headers[MessagingEvent.HEADER_NAME_SENDING_USER] = sendingUser;
			return result;
		}
		
		//Debugliste aller empfangenen Nachrichten: breakpoint in handleMessage
		public static var recievedObjects:ArrayCollection = new ArrayCollection();
		
		public function getReceivedObjects ():ArrayCollection {
			return recievedObjects;
		}
		
		private var _subtopics:ArrayCollection = new ArrayCollection();
		
		public function MessagingProxy (channelIds:Array) {
			
			consumer = new MultiTopicConsumer();
			if (channelIds)
				consumer.channelSet = new ChannelSet(channelIds);
			
			consumer.destination = DESTINATION;
			consumer.addEventListener(MessageEvent.MESSAGE, handleMessage);
			consumer.addEventListener(MessageFaultEvent.FAULT, faultHandler);
			
			//DEBUG
			consumer.addEventListener(MessageAckEvent.ACKNOWLEDGE, otherHandler);
			consumer.addEventListener("channelConnect", otherHandler);
			consumer.addEventListener("channelDisconnect", otherHandler);
			consumer.addEventListener("channelFault", otherHandler);
			//consumer.addEventListener(, otherHandler);
		
		}
		
		/**
		 * Fügt das Subtopic  <code>baseSubtopic+subtopic</code> zu den Subscriptions hinzu.
		 *
		 * @param subtopic Das Subtopic unterhalb von <code>baseSubtopic</code> das hinzugefügt werden soll.
		 */
		public function addSubscription (subtopic:String=null):void {
			if (isSubscribed(subtopic)) {
				warn(this, ".addSubscription({0}) subtopic has already been subscribed.", subtopic);
			} else {
				consumer.addSubscription(subtopic);
				consumer.subscribe();
				debug(this, ".addSubscription({0}) complete", subtopic);
			}
		}
		
		public function addDrawingSubscription (drawingId:Number):void {
			addSubscription("ppd_" + drawingId);
		}
		
		/**
		 * Entfernt das Subtopic  <code>subtopic</code> aus den Subscriptions.
		 *
		 * @param subtopic
		 */
		public function removeSubscription (subtopic:String):void {
			if (!isSubscribed(subtopic)) {
				warn(this, ".removeSubscription({0}) subtopic has not been subscribed", subtopic);
			} else {
				consumer.removeSubscription(subtopic);
				consumer.subscribe();
				debug(this, ".removeSubscription({0}) complete", subtopic);
			}
		}
		
		public function removeDrawingSubscription (drawingId:Number):void {
			removeSubscription("ppd_" + drawingId);
		}
		
		/*		public function setMapping(type : * , notificationName : String) : void
			 {
			 typeTable[type] = notificationName;
			 logger.debug(new LogCaller([type,notificationName])+" done" );
			 }
		
			 public function deleteMapping(type : *) : void
			 {
			 typeTable[type.toString()] = undefined;
			 logger.debug(new LogCaller([type])+" done" );
		 }*/
		
		private var handledMessage:Boolean = false;
		
		private function handleMessage (event:Object):void {
			debug(this, ".handleMessage({0}) start", event);
			handledMessage = true;
			if (event == null) {
				warn(this, ".handleMessage(...) event == null");
			} else if (!event is MessageEvent) {
				warn(this, ".handleMessage(...) event is not a MessageEvent");
			} else {
				var msgEvent:MessageEvent = MessageEvent(event);
				//var topic:String = event.message.headers[AsyncMessage.SUBTOPIC_HEADER];
				var type:String = msgEvent.message.headers[MessagingEvent.HEADER_NAME_MESSAGETYPE];
				var messageSendingUser:String = msgEvent.message.headers[MessagingEvent.HEADER_NAME_SENDING_USER];
				var obj:Object = new Object();
				obj.orgBody = msgEvent.message.body;
				obj.orgMsg = msgEvent.message;
				obj.type = type;
				obj.subtopic = msgEvent.message.headers[AsyncMessage.SUBTOPIC_HEADER];
				obj.messageSendingUser = messageSendingUser;
				obj.currentSendingUser = sendingUser;
				if (type == null) {
					warn(this, ".handleMessage(...) messagetype == null");
				} else if (ignoreMessagesFromSendingUser && messageSendingUser == sendingUser) {
					obj.ignoredBySendingUser = true;
					info(this, ".handleMessage(...) ignored message from sendingUser {0}", sendingUser);
				} else {
					var result:MessagingEvent = new MessagingEvent(AsyncMessage(msgEvent.message));
					debug(this, ".handleMessage(...) dispatching {0}", result);
					dispatch(result);
				}
				recievedObjects.addItem(obj);
			}
			ludicrous(this, ".handleMessage(...) done");
		}
		
		private function faultHandler (info:Object):void {
			if (info is FaultEvent) {
				var faultEvent:FaultEvent = FaultEvent(info);
				error(this, ".faultHandler({0}) details: {1};{2}", info, faultEvent, faultEvent.fault);
			} else {
				error(this, ".faultHandler({0}) ", info);
			}
		}
		
		private var connectionLost:Boolean = false;
		
		private function otherHandler (info:Object):void {
			ludicrous(this, ".otherHandler({0}) ", info);
			if (info is FaultEvent) {
				var faultEvent:FaultEvent = FaultEvent(info);
				error(this, ".otherHandler({0}) details: {1};{2}", info, faultEvent, faultEvent.fault);
			} else if (handledMessage && info is ChannelEvent) {
				var event:ChannelEvent = ChannelEvent(info);
				if (event.reconnecting == false) {
					connectionLost = true;
					warn(this, ".otherHandler({0}) connection lost", info);
					dispatch(new Event(MessagingTypes.CONNECTION_LOST));
				}
			} else if (info is MessageAckEvent) {
				if (connectionLost)
					connectionLost = false;
				debug(this, ".otherHandler({0}) (re)connected", info);
				dispatch(new Event(MessagingTypes.CONNECTION_READY));
				
			}
		}
		
		private function producerListener (event:Event):void {
			switch (event.type) {
				case MessageAckEvent.ACKNOWLEDGE:
					verbose(this, ".producerListener({0}) message was send", event);
					break;
				case MessageFaultEvent.FAULT:
					warn(this, ".producerListener({0}) message could NOT be sent", event);
					break;
				default:
					debug(this, ".producerListener({0}) ", event);
			}
		}
		
		public function getProducer (subtopic:String=null):Producer {
			var producer:Producer = new Producer();
			producer.channelSet = consumer.channelSet;
			//
			producer.destination = DESTINATION;
			producer.subtopic = subtopic;
			return producer;
		}
		
		public function sendMessage (message:AsyncMessage, subtopic:String=null, setEventHandler:Function=null):void {
			verbose(this, ".sendMessage({0}) start", [message, subtopic, setEventHandler].join(", "));
			//logger.debug(new LogCaller([message, subtopic, setEventHandler]).qualifiedCall+" started");
			var producer:Producer = getProducer(subtopic);
			if (setEventHandler != null) {
				setEventHandler(producer);
			}
			producer.addEventListener(MessageAckEvent.ACKNOWLEDGE, producerListener);
			producer.addEventListener(MessageFaultEvent.FAULT, producerListener, false, 0, true);
			
			if (!isSubscribed(producer.subtopic)) {
				warn(this, ".sendMessage(...)  subtopic '{0}' is not subscribed.", producer.subtopic);
			}
			if (!message.headers[MessagingEvent.HEADER_NAME_MESSAGETYPE]) {
				warn(this, ".sendMessage(...) message.headers[MESSAGETYPE_HEADER_NAME] is not set.");
			}
			/*else if (!typeTable[message.headers[MESSAGETYPE_HEADER_NAME]]) {
				 logger.warn(new LogCaller().qualifiedCall + " MESSAGETYPE '" + message.headers[MESSAGETYPE_HEADER_NAME] + "' is not mapped");
			 }*/
			producer.send(message);
		}
		
		// Funktioniert nicht, weil die SubscriptionInfos nur null für die subtopics enthalten.
		private function isSubscribed (completeSubtopic:String):Boolean {
			
			for each (var si:SubscriptionInfo in consumer.subscriptions) {
				if (si.subtopic == completeSubtopic)
					return true;
			}
			return false;
		}
		
		public function connect ():void {
			consumer.subscribe();
		}
	
	}
}