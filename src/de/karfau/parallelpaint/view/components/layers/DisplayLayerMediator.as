package de.karfau.parallelpaint.view.components.layers
{
	import de.karfau.parallelpaint.core.elements.IElement;
	import de.karfau.parallelpaint.core.elements.ISelectable;
	import de.karfau.parallelpaint.events.ElementEvent;
	import de.karfau.parallelpaint.events.ElementIdEvent;
	import de.karfau.parallelpaint.events.ExportEvent;
	import de.karfau.parallelpaint.events.MouseInteractionEvent;
	import de.karfau.parallelpaint.model.DrawingModel;
	import de.karfau.parallelpaint.model.InteractionModel;
	
	import mx.graphics.ImageSnapshot;
	
	import org.robotlegs.core.IMediator;
	import org.robotlegs.mvcs.Mediator;
	
	public class DisplayLayerMediator extends Mediator implements IMediator
	{
		
		[Inject]
		public var layer:DisplayLayer;
		
		[Inject]
		public var mDrawing:DrawingModel;
		
		//[Inject]
		//public var mInteraction:InteractionModel;
		
		override public function onRegister ():void {
			eventMap.mapListener(eventDispatcher, ElementEvent.ELEMENT_ADDED, processElementAdded, ElementEvent);
			eventMap.mapListener(eventDispatcher, ElementEvent.ELEMENTS_CHANGED, processElementsChanged, ElementEvent);
			eventMap.mapListener(eventDispatcher, ElementIdEvent.ELEMENT_REMOVED, processElementRemoved, ElementIdEvent);
			//eventMap.mapListener(eventDispatcher,ElementEvent.UPDATE_ELEMENT,processAddElement,ElementEvent);
			
			eventMap.mapListener(eventDispatcher, MouseInteractionEvent.MOUSE_DOWN, processMouseDown);
			
			eventMap.mapListener(eventDispatcher, ExportEvent.SET_BITMAP_DATA, processSetBitmapData, ExportEvent);
		}
		
		private function processElementAdded (event:ElementEvent):void {
			layer.addDrawingElement(event.element);
		}
		
		private function processElementRemoved (event:ElementIdEvent):void {
			layer.removeDrawingElement(event.elementId);
		}
		
		private function processSetBitmapData (event:ExportEvent):void {
			event.setBitmapDataBySource(layer);
			dispatch(event.clone());
		}
		
		private function processElementsChanged (event:ElementEvent):void {
			if (event.element == null)
				layer.elements = mDrawing.elements;
			else
				layer.updateElement(event.element);
		}
		
		private function processMouseDown (event:MouseInteractionEvent):void {
			var elementToSelect:IElement = layer.getElementUnderPoint(event.event.stageX, event.event.stageY);
			if (elementToSelect != null)
				dispatch(new ElementEvent(ElementEvent.SELECT_ELEMENT, elementToSelect));
			else if (mDrawing.selectedElement != null)
				dispatch(new ElementEvent(ElementEvent.UNSELECT_ELEMENT, IElement(mDrawing.selectedElement)));
		
		}
	}
}