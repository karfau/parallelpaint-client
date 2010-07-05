package de.karfau.parallelpaint.events
{
	import de.karfau.parallelpaint.core.tools.interaction.Interaction;
	
	import flash.events.Event;
	
	public class InteractionEvent extends Event
	{
		public static const ACTIVATE_INTERACTION:String = "activateInteraction";
		public static const SELECTED_INTERACTION_CHANGED:String = "selectedInteractionChanged";
		
		public static const INTERACTION_START:String = "interactionStart";
		public static const INTERACTION_UPDATE:String = "interactionUpdate";
		public static const INTERACTION_RESULT:String = "interactionResult";
		
		protected var _interaction:Interaction;
		
		public function get interaction ():Interaction {
			return _interaction;
		}
		
		protected var _resultEvent:Event;
		
		public function get resultEvent ():Event {
			return _resultEvent;
		}
		
		public function InteractionEvent (type:String, interaction:Interaction, resultEvent:Event=null) {
			super(type, false, true);
			_interaction = interaction;
			_resultEvent = resultEvent;
		}
		
		override public function clone ():Event {
			return new InteractionEvent(type, _interaction, _resultEvent);
		}
	
	}
}