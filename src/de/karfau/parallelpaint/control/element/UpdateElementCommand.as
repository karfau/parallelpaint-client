package de.karfau.parallelpaint.control.element
{
	import de.karfau.flexlogplus.*;
	import de.karfau.parallelpaint.core.elements.IElement;
	import de.karfau.parallelpaint.events.ElementEvent;
	import de.karfau.parallelpaint.model.DrawingModel;
	import de.karfau.parallelpaint.model.TransferFactory;
	import de.karfau.parallelpaint.model.vo.ElementVO;
	import de.karfau.parallelpaint.service.definition.ElementPersistanceService;
	
	import org.robotlegs.mvcs.Command;
	
	public class UpdateElementCommand extends AbstractElementCommand
	{
		
		[Inject]
		public var sPersistance:ElementPersistanceService;
		
		[Inject]
		public var transferFactory:TransferFactory;
		
		override public function execute ():void {
			if (!element.isValid()) {
				throw VerifyError("trying to update the invalid element <" + element + ">");
			} else {
				var vo:ElementVO = transferFactory.createElementVO(element, 0); //TODO keep existing order
				sPersistance.updateElement(vo).setOnResult(executeResult).setOnFault(handleFault);
			}
		}
		
		private function executeResult ():void {
			//success means version is one higher
			element.version++;
			var elementById:IElement = mDrawing.getElementById(element.id);
			if (elementById === element || elementById.version != element.version) {
				debug(this, ".executeResult( ) updating element <{0}>", element);
				mDrawing.updateElement(element);
				dispatch(new ElementEvent(ElementEvent.SELECT_ELEMENT, element));
			}
		}
	
	}
}