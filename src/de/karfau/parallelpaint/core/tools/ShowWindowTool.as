package de.karfau.parallelpaint.core.tools
{
	import de.karfau.parallelpaint.view.components.tools.windows.ToolWindow;
	
	public class ShowWindowTool extends AbstractTool
	{
		
		private var _window:ToolWindow;
		
		public override function set enabled (value:Boolean):void {
			super.enabled = value;
			closeWindowWhenToolNotAvailabe();
		}
		
		public override function set visible (value:Boolean):void {
			super.visible = value;
			closeWindowWhenToolNotAvailabe();
		}
		
		public function get window ():ToolWindow {
			return _window;
		}
		
		public function ShowWindowTool (toolWindow:ToolWindow, groupName:String=null) {
			
			super(true);
			_window = toolWindow;
			toolWindow.tool = this;
		}
		
		private function closeWindowWhenToolNotAvailabe ():void {
			if (!enabled || !visible)
				window.closeWindow();
		}
	
	}
}