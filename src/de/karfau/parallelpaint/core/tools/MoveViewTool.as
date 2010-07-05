package de.karfau.parallelpaint.core.tools
{
	import de.karfau.parallelpaint.core.elements.ElementUtil;
	import de.karfau.parallelpaint.core.elements.IElement;
	import de.karfau.parallelpaint.core.tools.interaction.AbstractDragInteractionTool;
	import de.karfau.parallelpaint.core.tools.interaction.DragInteractableView;
	import de.karfau.parallelpaint.core.tools.interaction.DragInteraction;
	import de.karfau.parallelpaint.core.tools.interaction.InteractableView;
	import de.karfau.parallelpaint.events.ElementEvent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class MoveViewTool extends AbstractDragInteractionTool implements DragInteraction
	{
		public function MoveViewTool (view:DragInteractableView) {
			super();
			if (!view.isCapableOf(this))
				throw new ArgumentError(view + "is not capable of " + this);
			this.view = view;
		}
		
		private var dragStartPoint:Point;
		
		public function onDragStart (event:MouseEvent):void {
			draggableView.isMouseDown = true;
			dragStartPoint = getEventPoint(event);
		}
		
		public function onDragMove (event:MouseEvent):void {
			draggableView.isDragging = true;
			draggableView.moveTo(getEventPoint(event).subtract(dragStartPoint));
		}
		
		public function onDragStop (event:MouseEvent):void {
			draggableView.isMouseDown = false;
			draggableView.isDragging = false;
		}
		
		public function createResultEvent ():Event {
			if (draggableView.x != 0 && draggableView.y != 0) {
				var diff:Point = new Point(draggableView.x, draggableView.y);
				var result:IElement = ElementUtil.cloneWithPosition(view.interactionElement);
				result.move(diff);
				draggableView.moveTo(new Point(0, 0));
				return new ElementEvent(ElementEvent.UPDATE_ELEMENT, result);
			}
			return null;
		}
		
		protected function get draggableView ():DragInteractableView {
			return DragInteractableView(view);
		}
		
		public override function cancelDragging ():void {
			super.cancelDragging();
			draggableView.moveTo(new Point(0, 0));
		}
	
	}
}