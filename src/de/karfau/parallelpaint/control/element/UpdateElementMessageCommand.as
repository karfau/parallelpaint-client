package de.karfau.parallelpaint.control.element
{
	import de.karfau.flexlogplus.*;
	import de.karfau.parallelpaint.control.AbstractCommand;
	import de.karfau.parallelpaint.core.elements.IElement;
	import de.karfau.parallelpaint.events.ElementEvent;
	import de.karfau.parallelpaint.events.MessagingEvent;
	import de.karfau.parallelpaint.model.DrawingModel;
	import de.karfau.parallelpaint.model.TransferFactory;
	import de.karfau.parallelpaint.model.vo.ElementVO;
	
	public class UpdateElementMessageCommand extends AbstractCommand
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
			var element:IElement = transferFactory.createElementFromVo(vo);
			var oldElement:IElement = mDrawing.getElementById(vo.id);
			if (oldElement == null) {
				warn(this, ".execute(...) element with id {0} not present, adding it", vo.id);
				mDrawing.addElement(element);
			} else if (oldElement.version != element.version) {
				debug(this, ".execute(...) updating {0}", element);
				mDrawing.updateElement(element);
					//dispatch(new ElementEvent(ElementEvent.SELECT_ELEMENT, element));
			}
		}
	}
}