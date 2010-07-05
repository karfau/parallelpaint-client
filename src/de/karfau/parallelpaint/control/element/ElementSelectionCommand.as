package de.karfau.parallelpaint.control.element
{
	import de.karfau.parallelpaint.core.elements.IElement;
	import de.karfau.parallelpaint.events.ElementEvent;
	import de.karfau.parallelpaint.messaging.MessagingProxy;
	import de.karfau.parallelpaint.model.DrawingModel;
	import de.karfau.parallelpaint.model.UserModel;
	import de.karfau.parallelpaint.service.definition.ElementPersistanceService;
	
	import org.robotlegs.mvcs.Command;
	
	public class ElementSelectionCommand extends AbstractElementCommand
	{
		
		[Inject]
		public var sPersistance:ElementPersistanceService;
		
		[Inject]
		public var mUser:UserModel;
		
		[Inject]
		public var messaging:MessagingProxy;
		
		public override function execute ():void {
			switch (event.type) {
				case ElementEvent.SELECT_ELEMENT:
					sPersistance.selectSoleElement(element.id).setOnFault(handleFault).setOnResult(executeResult);
					break;
				case ElementEvent.UNSELECT_ELEMENT:
					sPersistance.unselectElement(element.id).setOnFault(handleFault).setOnResult(executeResult);
					break;
			}
		}
		
		private function executeResult (currentSelector:String):void {
			var isSelected:Boolean = element.equals(IElement(mDrawing.selectedElement));
			var sameSelector:Boolean = currentSelector == element.selector;
			if (isSelected && sameSelector) {
				//e.g. reselection after update. setting this again makes sure we have the same object (maybe it has been cloned for updating)
				mDrawing.selectedElement = element; //dispatches ElementEvent.SELECTION_CHANGED
			} else if (!isSelected || !sameSelector) {
				element.selector = currentSelector;
				if (currentSelector == null)
					mDrawing.selectedElement = null; //dispatches ElementEvent.SELECTION_CHANGED
				else if (currentSelector == mUser.currentUser.username)
					mDrawing.selectedElement = element; //dispatches ElementEvent.SELECTION_CHANGED
				else
					dispatch(new ElementEvent(ElementEvent.FOREIGN_SELECTION_CHANGED, element));
			}
		
		}
	
	}
}