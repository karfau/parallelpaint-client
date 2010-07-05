package de.karfau.parallelpaint.core.tools
{
	import de.karfau.parallelpaint.core.tools.interaction.AbstractInteractionTool;
	import de.karfau.parallelpaint.core.tools.interaction.Interaction;
	import de.karfau.parallelpaint.core.tools.interaction.ToolGroup;
	import de.karfau.parallelpaint.events.InteractionEvent;
	import de.karfau.parallelpaint.events.MouseInteractionEvent;

	import flash.events.Event;
	import flash.events.MouseEvent;

	public class SelectElementTool extends AbstractInteractionTool implements Interaction
	{
		public function SelectElementTool () {
			super(ToolGroup.DRAWING);
		}

		public function registerListeners (active:Boolean):void {
			mapListener(active, view, MouseEvent.MOUSE_DOWN, handleMouseDown);
		}

		private var lastEvent:MouseEvent;

		private function handleMouseDown (event:MouseEvent):void {
			if (event.target === view) {
				lastEvent = event;
				dispatchInteractionState(InteractionEvent.INTERACTION_RESULT);
			}
		}

		public function createResultEvent ():Event {
			return new MouseInteractionEvent(MouseInteractionEvent.MOUSE_DOWN, lastEvent);
		}
	}
}