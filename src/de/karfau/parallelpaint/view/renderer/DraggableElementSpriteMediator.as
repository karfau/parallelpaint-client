package de.karfau.parallelpaint.view.renderer
{
	import de.karfau.parallelpaint.core.tools.interaction.InteractionMediatorBase;
	import de.karfau.parallelpaint.events.ElementEvent;
	import de.karfau.parallelpaint.events.InteractionEvent;
	import de.karfau.parallelpaint.model.DrawingModel;
	
	public class DraggableElementSpriteMediator extends InteractionMediatorBase
	{
		[Inject]
		public var sprite:DraggableElementSprite;
		
		[Inject]
		public var mDrawing:DrawingModel;
		
		override public function onRegister ():void {
			eventMap.mapListener(eventDispatcher, ElementEvent.SELECTION_CHANGED, processSelectionChanged, ElementEvent);
		}
		
		private function processSelectionChanged (event:ElementEvent):void {
			if (event.element != sprite.interactionElement)
				sprite.cancelAnyDragging();
		}
	}
}