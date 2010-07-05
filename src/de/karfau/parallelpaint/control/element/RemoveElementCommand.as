package de.karfau.parallelpaint.control.element
{
	import de.karfau.flexlogplus.*;
	import de.karfau.parallelpaint.core.elements.IElement;
	import de.karfau.parallelpaint.core.elements.ISelectable;
	import de.karfau.parallelpaint.events.ElementEvent;
	import de.karfau.parallelpaint.model.DrawingModel;
	import de.karfau.parallelpaint.service.definition.ElementPersistanceService;
	
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Command;
	
	public class RemoveElementCommand extends AbstractElementCommand
	{
		
		[Inject]
		public var sPersistance:ElementPersistanceService;
		
		private var elementToRemove:ISelectable;
		
		public override function execute ():void {
			verbose(this, ".execute( ) with event {0}", event);
			elementToRemove = event.element;
			if (elementToRemove == null)
				elementToRemove = mDrawing.selectedElement;
			if (elementToRemove != null)
				sPersistance.removeElement(elementToRemove.id).setOnFault(handleFault).setOnResult(removeElementResult);
			else
				info(this, ".execute( ) event.element was null and nothing selected for removal.");
		}
		
		private function removeElementResult ():void {
			verbose(this, ".removeElementResult( ) ");
			if (mDrawing.getElementById(elementToRemove.id)) {
				mDrawing.removeElement(IElement(elementToRemove));
			} else {
				info(this, ".removeElementResult( ) element with id {0} is not present", elementToRemove.id);
			}
		}
	
	}
}