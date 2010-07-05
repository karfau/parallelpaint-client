package de.karfau.parallelpaint.core.tools
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import mx.events.SandboxMouseEvent;
	
	import de.karfau.parallelpaint.core.elements.IElement;
	import de.karfau.parallelpaint.core.elements.IStrokedElement;
	import de.karfau.parallelpaint.core.tools.interaction.*;
	import de.karfau.parallelpaint.events.ElementEvent;
	import de.karfau.parallelpaint.events.InteractionEvent;
	
	public class DrawElementTool extends AbstractDragInteractionTool implements DragInteraction
	{
		
		/*########################################################*/
		/*                                                        */
		/*   PROPERTIES (INCL. SETTER/GETTER)                     */
		/*                                                        */
		/*########################################################*/
		
		private var _element:IElement;
		
		public function get elementClone ():IElement {
			return IElement(_element.clone());
		}
		
		public function get elementToStyle ():IStrokedElement {
			return _element as IStrokedElement;
		}
		
		public var sticky:Boolean = true;
		
		/*########################################################*/
		/*                                                        */
		/*   CONSTRUCTOR                                          */
		/*                                                        */
		/*########################################################*/
		
		public function DrawElementTool (element:IElement) {
			super(ToolGroup.DRAWING);
			_element = element;
		}
		
		/*########################################################*/
		/*                                                        */
		/*   OVERRIDE / IMPLEMENT                                 */
		/*                                                        */
		/*########################################################*/
		
		public function createResultEvent ():Event {
			if (view.interactionElement.isVisible()) {
				return new ElementEvent(ElementEvent.ADD_ELEMENT, view.interactionElement);
			}
			return null;
		}
		
		/*########################################################*/
		/*                                                        */
		/*   EVENT-HANDLER                                        */
		/*                                                        */
		/*########################################################*/
		
		public function onDragStart (event:MouseEvent):void {
			view.interactionElement = createDrawing(getEventPoint(event));
		}
		
		public function onDragMove (event:MouseEvent):void {
			view.interactionElement.addPoint(getEventPoint(event));
		}
		
		public function onDragStop (event:MouseEvent):void {
			if (view) {
				view.interactionElement = null;
				view.triggerRedraw();
			}
		}
		
		/*########################################################*/
		/*                                                        */
		/*  PRIVATE HELPER/UTIL                                   */
		/*                                                        */
		/*########################################################*/
		
		//private var currentDrawing:IElement;
		
		private function createDrawing (start:Point):IElement {
			var result:IElement = elementClone;
			result.addPoint(start);
			return result;
		}
	
	}
}