package de.karfau.parallelpaint.view.components.layers
{
	import de.karfau.flexlogplus.*;
	import de.karfau.parallelpaint.core.elements.IElement;
	import de.karfau.parallelpaint.core.elements.IStrokedElement;
	import de.karfau.parallelpaint.core.elements.style.IStrokeStyle;
	import de.karfau.parallelpaint.core.tools.SelectElementTool;
	import de.karfau.parallelpaint.core.tools.interaction.InteractionMediatorBase;
	import de.karfau.parallelpaint.events.*;
	import de.karfau.parallelpaint.model.DrawingModel;
	import de.karfau.parallelpaint.model.InteractionModel;
	import de.karfau.parallelpaint.model.UserModel;
	
	import flash.events.MouseEvent;
	
	import org.robotlegs.core.IMediator;
	import org.robotlegs.mvcs.Mediator;
	
	public class InteractionLayerMediator extends InteractionMediatorBase implements IMediator
	{
		
		[Inject]
		public var mUser:UserModel;
		
		[Inject]
		public var layer:InteractionLayer;
		
		[Inject]
		public var mDrawing:DrawingModel;
		
		override public function onRegister ():void {
			//eventMap.mapListener(layer, MouseInteractionEvent.MOUSE_DOWN, dispatch, MouseInteractionEvent);
			
			//events that case a change in foreign selections:
			eventMap.mapListener(eventDispatcher, ElementEvent.ELEMENT_ADDED, processElementsChanged, ElementEvent);
			eventMap.mapListener(eventDispatcher, ElementEvent.ELEMENTS_CHANGED, processElementsChanged, ElementEvent); //is dispatched before DrawingEvent.DRAWING_CHANGED
			eventMap.mapListener(eventDispatcher, ElementIdEvent.ELEMENT_REMOVED, processElementRemoved, ElementIdEvent);
			
			eventMap.mapListener(eventDispatcher, ElementEvent.SELECTION_CHANGED, processSelectionChanged, ElementEvent);
			eventMap.mapListener(eventDispatcher, ElementEvent.FOREIGN_SELECTION_CHANGED, processForeignSelectionChanged, ElementEvent);
			/*
				 eventMap.mapListener(eventDispatcher,
			 */
			eventMap.mapListener(eventDispatcher, InteractionEvent.SELECTED_INTERACTION_CHANGED, processSelectedInteractionChanged, InteractionEvent);
		
		}
		
		override protected function handleInteractionStateEvent (event:InteractionEvent):void {
			super.handleInteractionStateEvent(event);
		}
		
		private function processElementsChanged (event:ElementEvent):void {
			verbose(this, ".processElementsChanged({0}) ", event);
			if (event.element) {
				if (event.element.selector && event.element.selector != mUser.currentUser.username)
					layer.setForeignSelection(event.element);
			} else {
				layer.removeAllForeignSelections();
			} //layer.triggerRedraw();
		}
		
		private function processElementRemoved (event:ElementIdEvent):void {
			layer.removeForeignSelection(event.elementId);
		}
		
		private function processSelectionChanged (event:ElementEvent):void {
			verbose(this, ".processSelectionChanged({0}) ", event);
			displaySelectionPoints();
		}
		
		private function processSelectedInteractionChanged (event:InteractionEvent):void {
			displaySelectionPoints();
		}
		
		private function processForeignSelectionChanged (event:ElementEvent):void {
			layer.setForeignSelection(event.element);
		}
		
		private function displaySelectionPoints ():void {
			if (mInteraction.selectedInteractionTool is SelectElementTool && mDrawing.selectedElement != null) {
				layer.selectionPoints = mDrawing.selectedElement.selectionPoints;
			} else {
				layer.selectionPoints = null;
			}
		}
	
	}
}