package de.karfau.parallelpaint.core.tools.interaction
{
	import de.karfau.parallelpaint.core.tools.AbstractTool;
	
	public class ToolGroup
	{
		
		public static const NO_GROUP:String = "noGroup";
		public static const DRAWING:String = "drawing";
		
		public var name:String;
		
		public var defaultTool:AbstractTool;
		
		public var tools:Vector.<AbstractTool> = new Vector.<AbstractTool>();
		
		public function ToolGroup (name:String) {
			this.name = name;
		}
		
		//private var _enabled:Boolean = true;
		//private var _visible:Boolean = true;
		
		public function set enabled (value:Boolean):void {
			for each (var tool:AbstractTool in tools) {
				tool.enabled = value;
			}
		}
		
		public function set visible (value:Boolean):void {
			for each (var tool:AbstractTool in tools) {
				tool.visible = value;
			}
		}
	
	}
}