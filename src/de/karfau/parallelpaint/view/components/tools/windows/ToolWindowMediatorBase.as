package de.karfau.parallelpaint.view.components.tools.windows
{
	import de.karfau.parallelpaint.events.DisplayMessageEvent;
	import de.karfau.parallelpaint.events.ToolEvent;
	
	import mx.events.CloseEvent;
	
	import org.robotlegs.core.IMediator;
	import org.robotlegs.mvcs.Mediator;
	
	public class ToolWindowMediatorBase extends Mediator implements IMediator
	{
		
		override public function preRegister ():void {
			eventMap.mapListener(toolWindow, CloseEvent.CLOSE, handleClose, CloseEvent);
			super.preRegister();
		}
		
		protected function handleClose (event:CloseEvent):void {
			if (toolWindow.anchor.displayPopUp)
				dispatch(new ToolEvent(ToolEvent.CLOSE_WINDOW, toolWindow.tool));
			//preRemove();
		}
		
		private function get toolWindow ():ToolWindow {
			return ToolWindow(viewComponent);
		}
		
		protected function registerDisplayMessage (messageType:String, handler:Function=null):void {
			eventMap.mapListener(eventDispatcher, messageType, handler || processDisplayMessage, DisplayMessageEvent);
		}
		
		protected function processDisplayMessage (event:DisplayMessageEvent, stopsProgress:Boolean=true):void {
			toolWindow.message = event.message;
			if (stopsProgress)
				toolWindow.showProgress(false);
		}
	}
}