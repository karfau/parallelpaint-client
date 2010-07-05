package de.karfau.parallelpaint.core.tools.interaction
{
	import de.karfau.parallelpaint.events.InteractionEvent;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import mx.events.SandboxMouseEvent;
	
	public class AbstractDragInteractionTool extends AbstractInteractionTool
	{
		
		/*########################################################*/
		/*                                                        */
		/*   PROPERTIES (INCL. SETTER/GETTER)                     */
		/*                                                        */
		/*########################################################*/
		
		private var dragListeners:Object;
		
		private function get thisDragInteraction ():DragInteraction {
			return DragInteraction(this);
		}
		
		/*########################################################*/
		/*                                                        */
		/*   CONSTRUCTOR                                          */
		/*                                                        */
		/*########################################################*/
		
		public function AbstractDragInteractionTool (groupName:String=null) {
			abstract::verifyImplementation(AbstractDragInteractionTool, DragInteraction);
			super(groupName);
		}
		
		/*########################################################*/
		/*                                                        */
		/*   OVERRIDE / IMPLEMENT                                 */
		/*                                                        */
		/*########################################################*/
		
		public function registerListeners (active:Boolean):void {
			mapListener(active, view, MouseEvent.MOUSE_DOWN, mouseDownHandler);
			if (!active && hasDragListeners()) {
				registerDragListeners(active);
			}
		}
		
		protected function hasDragListeners ():Boolean {
			return dragListeners != null;
		}
		
		protected final function buildDragListeners ():void {
			if (!hasDragListeners()) {
				dragListeners = new Object();
				//dragListeners[MouseEvent.MOUSE_DOWN] = mouseDownHandler;
				dragListeners[MouseEvent.MOUSE_MOVE] = mouseMoveHandler;
				dragListeners[SandboxMouseEvent.MOUSE_UP_SOMEWHERE] = mouseUpHandler;
				dragListeners[MouseEvent.MOUSE_UP] = mouseUpHandler;
			}
		}
		
		protected function registerDragListeners (active:Boolean):void {
			buildDragListeners();
			var sbr:DisplayObject = view.systemManager.getSandboxRoot();
			for (var eventType:String in dragListeners) {
				mapListener(active, sbr, eventType, dragListeners[eventType] as Function);
			}
			if (!active)
				dragListeners = null;
		}
		
		private var _canceled:Boolean = false;
		
		protected function get canceled ():Boolean {
			return _canceled;
		}
		
		public function cancelDragging ():void {
			_canceled = true;
			registerDragListeners(false);
		}
		
		/*########################################################*/
		/*                                                        */
		/*   EVENT-HANDLER                                        */
		/*                                                        */
		/*########################################################*/
		
		protected function mouseDownHandler (event:MouseEvent):void {
			if (active) {
				thisDragInteraction.onDragStart(event);
				dispatchInteractionState(InteractionEvent.INTERACTION_START);
				registerDragListeners(true);
			}
		}
		
		protected function mouseMoveHandler (event:MouseEvent):void {
			thisDragInteraction.onDragMove(event);
			dispatchInteractionState(InteractionEvent.INTERACTION_UPDATE);
			view.triggerRedraw();
		}
		
		protected function mouseUpHandler (event:MouseEvent):void {
			registerDragListeners(false);
			dispatchInteractionState(InteractionEvent.INTERACTION_RESULT);
			thisDragInteraction.onDragStop(event);
		}
	}
}