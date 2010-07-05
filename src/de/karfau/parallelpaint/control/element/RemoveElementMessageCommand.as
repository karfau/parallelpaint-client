package de.karfau.parallelpaint.control.element
{
	import de.karfau.flexlogplus.*;
	import de.karfau.parallelpaint.control.AbstractCommand;
	import de.karfau.parallelpaint.core.elements.IElement;
	import de.karfau.parallelpaint.events.MessagingEvent;
	import de.karfau.parallelpaint.model.DrawingModel;
	import de.karfau.parallelpaint.model.TransferFactory;
	import de.karfau.parallelpaint.model.vo.ElementVO;
	
	import org.robotlegs.mvcs.Command;
	
	public class RemoveElementMessageCommand extends AbstractCommand
	{
		[Inject]
		public var transferFactory:TransferFactory;
		
		[Inject]
		public var mDrawing:DrawingModel;
		
		[Inject]
		public var message:MessagingEvent;
		
		public override function execute ():void {
			debug(this, ".execute({0}) start", message);
			var elementId:Number = Number(message.data);
			var elementToRemove:IElement = mDrawing.getElementById(elementId);
			if (elementToRemove == null)
				info(this, ".execute(...) element with id {0} not present, just removed by me ?", elementId);
			else {
				debug(this, ".execute(...) removing {0}", elementToRemove);
				mDrawing.removeElement(elementToRemove);
			}
		}
	}
}