package de.karfau.parallelpaint.control.element
{
	import de.karfau.flexlogplus.*;
	import de.karfau.parallelpaint.core.elements.IElement;
	import de.karfau.parallelpaint.core.tools.DrawElementTool;
	import de.karfau.parallelpaint.events.DrawingEvent;
	import de.karfau.parallelpaint.events.ElementEvent;
	import de.karfau.parallelpaint.model.DrawingModel;
	import de.karfau.parallelpaint.model.InteractionModel;
	import de.karfau.parallelpaint.model.TransferFactory;
	import de.karfau.parallelpaint.model.vo.Drawing;
	import de.karfau.parallelpaint.model.vo.ElementVO;
	import de.karfau.parallelpaint.service.definition.ElementPersistanceService;
	
	import mx.utils.OnDemandEventDispatcher;
	
	import org.robotlegs.mvcs.Command;
	
	public class AddElementCommand extends AbstractElementCommand
	{
		
		/*########################################################*/
		/*                                                        */
		/*   PROPERTIES (INCL. SETTER/GETTER)                     */
		/*                                                        */
		/*########################################################*/
		
		[Inject]
		public var mInteraction:InteractionModel;
		
		[Inject]
		public var sPersistance:ElementPersistanceService;
		
		[Inject]
		public var transferFactory:TransferFactory;
		
		private var untoolAndSelectOnResult:Boolean;
		
		/*########################################################*/
		/*                                                        */
		/*   OVERRIDE / IMPLEMENT                                 */
		/*                                                        */
		/*########################################################*/
		
		override public function execute ():void {
			debug(this, ".execute( ) ");
			if (mDrawing.drawingId <= 0)
				createDrawing();
			else
				addElement();
		}
		
		private function createDrawing ():void {
			debug(this, ".createDrawing( ) ");
			sPersistance.createDrawing().setOnResult(createDrawingResult).setOnFault(handleFault);
		}
		
		private function createDrawingResult (drawing:Drawing):void {
			verbose(this, ".createDrawingResult({0}) ", drawing);
			dispatch(new DrawingEvent(DrawingEvent.SET_DRAWING, drawing));
			addElement();
		}
		
		private function addElement ():void {
			debug(this, ".addElement({0}) ", element);
			
			//unselect
			if (mDrawing.selectedElement) {
				//throw new VerifyError("mDrawing.selectedElement is not null before adding a new element.");
				mDrawing.selectedElement = null;
					//dispatch(new ElementEvent(ElementEvent.UNSELECT_ELEMENT, element));
			}
			
			untoolAndSelectOnResult = !DrawElementTool(mInteraction.selectedInteractionTool).sticky;
			
			//set drawingId
			element.drawingId = mDrawing.drawingId;
			
			//persist
			var vo:ElementVO = transferFactory.createElementVO(element, 0); //TODO append to existing order
			
			sPersistance.addElement(vo).setOnResult(addElementResult).setOnFault(handleFault);
		
		}
		
		private function addElementResult (elementId:Number):void {
			verbose(this, ".addElementResult({0}) ", elementId);
			
			//apply id
			element.id = elementId;
			
			//add
			if (mDrawing.getElementById(elementId) == null)
				mDrawing.addElement(element);
			
			if (untoolAndSelectOnResult) {
				mInteraction.selectedInteractionTool = null;
				dispatch(new ElementEvent(ElementEvent.SELECT_ELEMENT, element));
			}
		}
	
	}
}