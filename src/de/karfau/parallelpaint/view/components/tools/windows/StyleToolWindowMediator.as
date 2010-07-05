package de.karfau.parallelpaint.view.components.tools.windows
{
	import de.karfau.flexlogplus.*;
	import de.karfau.parallelpaint.core.elements.IFilledElement;
	import de.karfau.parallelpaint.core.elements.IStrokedElement;
	import de.karfau.parallelpaint.core.elements.style.IFillStyle;
	import de.karfau.parallelpaint.core.elements.style.IStrokeStyle;
	import de.karfau.parallelpaint.events.ElementEvent;
	import de.karfau.parallelpaint.events.ElementStyleEvent;
	import de.karfau.parallelpaint.events.InteractionEvent;
	import de.karfau.parallelpaint.model.DrawingModel;
	import de.karfau.parallelpaint.model.InteractionModel;
	
	import org.robotlegs.core.IMediator;
	
	public class StyleToolWindowMediator extends ToolWindowMediatorBase implements IMediator
	{
		[Inject]
		public var window:StyleToolWindow;
		
		[Inject]
		public var mDrawing:DrawingModel;
		
		[Inject]
		public var mInteraction:InteractionModel;
		
		override public function onRegister ():void {
			eventMap.mapListener(window, ElementStyleEvent.CHANGE_STROKE_STYLE, dispatch, ElementStyleEvent);
			eventMap.mapListener(window, ElementStyleEvent.CHANGE_FILL_STYLE, dispatch, ElementStyleEvent);
			
			eventMap.mapListener(eventDispatcher, InteractionEvent.SELECTED_INTERACTION_CHANGED, processSelectedInteractionChanged, InteractionEvent);
			eventMap.mapListener(eventDispatcher, ElementEvent.SELECTION_CHANGED, processSelectionChanged, ElementEvent);
			eventMap.mapListener(eventDispatcher, ElementEvent.ELEMENTS_CHANGED, processSelectionChanged, ElementEvent);
			
			setStylesByDrawElement();
		}
		
		private function processSelectedInteractionChanged (event:InteractionEvent):void {
			setStylesByDrawElement();
		}
		
		private function processSelectionChanged (event:ElementEvent):void {
			setStylesByDrawElement();
		}
		
		private function setStylesByDrawElement ():void {
			window.displayStrokeOptions = mInteraction.styledInteractionElement is IStrokedElement;
			window.displayFillOptions = mInteraction.styledInteractionElement is IFilledElement;
			verbose(this, ".setStylesByDrawElement( ) mInteraction.styledInteractionElement is {0}", mInteraction.styledInteractionElement);
			if (window.displayStrokeOptions) {
				var stroke:IStrokeStyle = mInteraction.styledInteractionElement.stroke;
				if (window.stroke == null || stroke.isVisible()) {
					window.stroke = stroke;
				} else if (!stroke.equals(window.stroke)) {
					dispatch(new ElementStyleEvent(ElementStyleEvent.CHANGE_STROKE_STYLE, window.stroke))
				}
			}
			if (window.displayFillOptions) {
				var fill:IFillStyle = IFilledElement(mInteraction.styledInteractionElement).fill;
				if (window.fill == null || fill.isVisible()) {
					window.fill = fill;
				} else if (!fill.equals(window.fill)) {
					dispatch(new ElementStyleEvent(ElementStyleEvent.CHANGE_FILL_STYLE, window.fill))
				}
			}
		
		}
	
	}
}