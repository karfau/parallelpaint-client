package de.karfau.parallelpaint.view.components.tools.windows
{
	import com.asual.swfaddress.SWFAddress;
	
	import de.karfau.flexlogplus.verbose;
	import de.karfau.parallelpaint.events.DrawingEvent;
	import de.karfau.parallelpaint.service.definition.NavigationService;
	
	import flash.external.ExternalInterface;
	
	import mx.core.FlexGlobals;
	import mx.managers.BrowserManager;
	
	public class ShareDrawingToolWindowMediator extends ToolWindowMediatorBase
	{
		[Inject]
		public var window:ShareDrawingToolWindow;
		
		[Inject]
		public var sNavigation:NavigationService;
		
		public override function onRegister ():void {
			eventMap.mapListener(eventDispatcher, DrawingEvent.DRAWING_CHANGED, processSetDrawing, DrawingEvent);
			
			updateUrl();
		}
		
		private function processSetDrawing (event:DrawingEvent):void {
			updateUrl();
		}
		
		private function updateUrl ():void {
			window.currentURL = sNavigation.getCurrentUrl();
		}
	
	}
}