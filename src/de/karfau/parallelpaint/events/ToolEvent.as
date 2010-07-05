package de.karfau.parallelpaint.events
{
	import de.karfau.parallelpaint.core.tools.AbstractTool;
	
	import flash.events.Event;
	
	public class ToolEvent extends Event
	{
		
		//public static const TOOL_TOGGLE_ON:String = "tool_toggle_on";
		//public static const TOOL_TOGGLE_OFF:String = "tool_toggle_off";
		public static const TOOL_CLICK:String = "toolClick";
		public static const CLOSE_WINDOW:String = "closeWindow";
		
		protected var _tool:AbstractTool;
		
		public function get tool ():AbstractTool {
			return _tool;
		}
		
		public function ToolEvent (type:String, tool:AbstractTool) {
			super(type, false, false);
			_tool = tool;
		}
		
		override public function clone ():Event {
			return new ToolEvent(type, tool);
		}
	}
}