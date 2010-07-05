package de.karfau.parallelpaint.view.renderer
{
	import assets.img.com.yusukekamiyamane.p.FugueIcons;
	
	import de.karfau.flexlogplus.*;
	import de.karfau.parallelpaint.core.elements.IElement;
	import de.karfau.parallelpaint.core.tools.MoveViewTool;
	import de.karfau.parallelpaint.core.tools.interaction.*;
	import de.karfau.parallelpaint.events.InteractionEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class DraggableElementSprite extends ElementSprite implements DragInteractableView
	{
		
		/*########################################################*/
		/*                                                        */
		/*   PROPERTIES (INCL. SETTER/GETTER)                     */
		/*                                                        */
		/*########################################################*/
		
		private var cursorOverId:int = -1;
		
		private var _interactionElement:IElement;
		
		public function get interactionElement ():IElement {
			return element;
		}
		
		public function set interactionElement (value:IElement):void {
			element = value;
		}
		private var _isDragging:Boolean;
		
		public function get isDragging ():Boolean {
			return _isDragging;
		}
		
		public function set isDragging (value:Boolean):void {
			_isDragging = value;
		}
		
		private var _isMouseDown:Boolean;
		
		public function get isMouseDown ():Boolean {
			return _isMouseDown;
		}
		
		public function set isMouseDown (value:Boolean):void {
			_isMouseDown = value;
		}
		
		private var tool:MoveViewTool;
		
		/*########################################################*/
		/*                                                        */
		/*   CONSTRUCTOR                                          */
		/*                                                        */
		/*########################################################*/
		
		public function DraggableElementSprite (element:IElement) {
			super(element);
			this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			this.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			this.tool = new MoveViewTool(this);
		}
		
		private function onFocusIn (event:FocusEvent):void {
			trace(this, "has focus");
		}
		
		private function onMouseUp (event:MouseEvent):void {
			verbose(this, ".onMouseUp({0}) ", event);
			/*buttonWasUp = true;
			 displayMoveCursor(true);*/
			onMouseOver(event);
			//this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseOver);
		
		}
		
		/*########################################################*/
		/*                                                        */
		/*   OVERRIDE / IMPLEMENT                                 */
		/*                                                        */
		/*########################################################*/
		
		protected override function updateDisplayList (unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			ludicrous(this, ".updateDisplayList(...) drawing {0}", element);
			graphics.clear();
			if (_element)
				_element.renderShadow(graphics,
															(isDragging ? 0.5 : 0.1),
															(isDragging ? -1 : 0xFFFFFF));
		}
		
		public function moveTo (diff:Point):void {
			super.move(diff.x, diff.y);
		}
		
		public function isCapableOf (interaction:Interaction):Boolean {
			return interaction is MoveViewTool;
		}
		
		public function triggerRedraw ():void {
			invalidateDisplayList();
		}
		
		public function cancelAnyDragging ():void {
			tool.cancelDragging();
		}
		
		/*########################################################*/
		/*                                                        */
		/*   EVENT-HANDLER                                        */
		/*                                                        */
		/*########################################################*/
		
		private function onMouseOut (event:MouseEvent):void {
			verbose(this, ".onMouseOut({0}) ", event);
			displayMoveCursor(false);
		}
		
		private function onMouseOver (event:MouseEvent):void {
			verbose(this, ".onMouseOver({0}) ", event);
			displayMoveCursor(checkButtonUp(event));
		}
		
		private var buttonWasUp:Boolean = false;
		
		private function checkButtonUp (event:MouseEvent):Boolean {
			if (!buttonWasUp)
				buttonWasUp = buttonWasUp || !event.buttonDown;
			return buttonWasUp;
		}
		
		private function displayMoveCursor (show:Boolean):void {
			if (show) {
				if (cursorOverId == -1)
					cursorOverId = cursorManager.setCursor(FugueIcons.arrowMove, 2, -8, -8);
			} else {
				if (cursorOverId != -1) {
					cursorManager.removeCursor(cursorOverId);
					cursorOverId = -1;
				}
			}
		}
	}
}