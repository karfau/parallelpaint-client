package de.karfau.parallelpaint.core.tools.interaction
{
	import de.karfau.parallelpaint.core.tools.AbstractTool;
	import de.karfau.parallelpaint.events.InteractionEvent;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class AbstractInteractionTool extends AbstractTool //implements Interaction
	{
		
		public function AbstractInteractionTool (groupName:String=null) {
			abstract::verifyImplementation(AbstractInteractionTool, Interaction);
			super(true, groupName);
		}
		
		override public function set active (value:Boolean):void {
			if (active != value) {
				super.active = value;
				if (!active)
					view = null;
			}
		}
		
		protected var _view:InteractableView;
		
		public function get view ():InteractableView {
			return _view;
		}
		
		public function set view (value:InteractableView):void {
			
			if (!active && value != null && value.isCapableOf(thisInteraction)) {
				if (_view != null)
					thisInteraction.registerListeners(false);
				_view = value;
				thisInteraction.registerListeners(true);
				active = true;
			} else if (value == null) {
				thisInteraction.registerListeners(false);
				if (active)
					active = false;
				_view.interactionElement = null;
				_view.triggerRedraw();
				_view = null;
			}
		}
		
		protected function mapListener (active:Boolean, dispatcher:IEventDispatcher, type:String, handler:Function):void {
			if (active)
				dispatcher.addEventListener(type, handler);
			else
				dispatcher.removeEventListener(type, handler);
		}
		
		protected function dispatchInteractionState (type:String):void {
			var resultEvent:Event;
			if (type == InteractionEvent.INTERACTION_RESULT)
				resultEvent = thisInteraction.createResultEvent();
			if (resultEvent != null)
				view.dispatchEvent(new InteractionEvent(type, thisInteraction, resultEvent));
		}
		
		public function getEventPoint (event:MouseEvent, local:Boolean=false):Point {
			var result:Point = new Point(event.stageX, event.stageY);
			if (local)
				result = new Point(event.localX, event.localY);
			return result;
		}
		
		private function get thisInteraction ():Interaction {
			return Interaction(this);
		}
	
	}
}