package de.karfau.parallelpaint.view.components.tools.windows
{
	import de.karfau.parallelpaint.events.DisplayMessageEvent;
	import de.karfau.parallelpaint.events.ExportEvent;
	
	import flash.events.MouseEvent;
	
	public class ExportToolWindowMediator extends ToolWindowMediatorBase
	{
		
		[Inject]
		public var window:ExportToolWindow;
		
		public override function onRegister ():void {
			eventMap.mapListener(window.btSave, MouseEvent.CLICK, handleBtSaveClick, MouseEvent);
			registerDisplayMessage(DisplayMessageEvent.EXPORT_STATUS);
			registerDisplayMessage(DisplayMessageEvent.EXPORT_ERROR, processExportDone);
			registerDisplayMessage(DisplayMessageEvent.EXPORT_DONE, processExportDone);
		}
		
		private function handleBtSaveClick (event:MouseEvent):void {
			var format:String = window.rbGroupFormat.selectedValue as String;
			dispatch(new ExportEvent(format));
		}
		
		private function processExportDone (event:DisplayMessageEvent):void {
			processDisplayMessage(event, true);
			if (event.type == DisplayMessageEvent.EXPORT_DONE)
				window.closeWindow();
		}
	}
}