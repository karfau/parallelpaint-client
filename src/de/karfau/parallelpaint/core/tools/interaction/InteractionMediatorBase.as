package de.karfau.parallelpaint.core.tools.interaction
{
	import de.karfau.parallelpaint.events.InteractionEvent;
	import de.karfau.parallelpaint.model.InteractionModel;
	
	import flash.events.IEventDispatcher;
	
	import org.robotlegs.core.IMediator;
	import org.robotlegs.mvcs.Mediator;
	
	public class InteractionMediatorBase extends Mediator implements IMediator
	{
		
		[Inject]
		public var mInteraction:InteractionModel;
		
		override public function preRegister ():void {
			eventMap.mapListener(view, InteractionEvent.INTERACTION_START, handleInteractionStateEvent, InteractionEvent);
			eventMap.mapListener(view, InteractionEvent.INTERACTION_UPDATE, handleInteractionStateEvent, InteractionEvent);
			eventMap.mapListener(view, InteractionEvent.INTERACTION_RESULT, handleInteractionStateEvent, InteractionEvent);
			
			eventMap.mapListener(eventDispatcher, InteractionEvent.ACTIVATE_INTERACTION, processActivateInteraction, InteractionEvent);
			super.preRegister();
		}
		
		protected function handleInteractionStateEvent (event:InteractionEvent):void {
			if (event.type == InteractionEvent.INTERACTION_RESULT && event.resultEvent)
				dispatch(event.resultEvent);
		}
		
		protected function processActivateInteraction (event:InteractionEvent):void {
			event.interaction.view = view;
			if (event.interaction.view == view)
				mInteraction.selectedInteractionTool = event.interaction;
		}
		
		private function get view ():InteractableView {
			return InteractableView(viewComponent);
		}
	
	}
}