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
	
	public class AddElementMessageCommand extends AbstractCommand
	{
		[Inject]
		public var transferFactory:TransferFactory;
		
		[Inject]
		public var mDrawing:DrawingModel;
		
		[Inject]
		public var message:MessagingEvent;
		
		public override function execute ():void {
			debug(this, ".execute({0}) start", message);
			var vo:ElementVO = ElementVO(message.data);
			if (mDrawing.getElementById(vo.id))
				info(this, ".execute(...) element with id {0} already present, just added by me ?", vo.id);
			else {
				var element:IElement = transferFactory.createElementFromVo(vo);
				debug(this, ".execute(...) adding {0}", element);
				mDrawing.addElement(element);
			}
		}
	
	}
}