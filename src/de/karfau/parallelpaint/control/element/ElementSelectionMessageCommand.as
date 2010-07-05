package de.karfau.parallelpaint.control.element
{
	import de.karfau.flexlogplus.*;
	import de.karfau.parallelpaint.control.AbstractCommand;
	import de.karfau.parallelpaint.core.elements.IElement;
	import de.karfau.parallelpaint.events.ElementEvent;
	import de.karfau.parallelpaint.events.MessagingEvent;
	import de.karfau.parallelpaint.messaging.MessagingTypes;
	import de.karfau.parallelpaint.model.DrawingModel;
	import de.karfau.parallelpaint.model.UserModel;
	
	public class ElementSelectionMessageCommand extends AbstractCommand
	{
		
		[Inject]
		public var mDrawing:DrawingModel;
		
		[Inject]
		public var mUser:UserModel;
		
		[Inject]
		public var message:MessagingEvent;
		
		public override function execute ():void {
			debug(this, ".execute({0}) start", message);
			var selectingUser:String = message.sendingUser;
			if (selectingUser != mUser.currentUser.username) {
				var elementId:Number = Number(message.data);
				var elementToSelect:IElement = mDrawing.getElementById(elementId);
				var newSelector:String = message.type == MessagingTypes.UNSELECT_ELEMENT ? null : selectingUser;
				if (elementToSelect && elementToSelect.selector != newSelector) {
					elementToSelect.selector = newSelector;
					dispatch(new ElementEvent(ElementEvent.FOREIGN_SELECTION_CHANGED, elementToSelect));
				} else {
					warn(this, ".execute( ) element with id {0} is not present for selection.", elementId);
				}
			}
		}
	}
}