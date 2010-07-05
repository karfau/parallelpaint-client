package de.karfau.parallelpaint.core.tools
{
	
	public class StickyDrawingTool extends AbstractTool
	{
		
		private var _stickyTools:Vector.<DrawElementTool> = new Vector.<DrawElementTool>();
		
		public override function set active (value:Boolean):void {
			sticky = value;
		}
		
		public function addTool (tool:DrawElementTool):void {
			if (tool) {
				tool.sticky = sticky;
				_stickyTools.push(tool);
			}
		}
		
		public function StickyDrawingTool () {
			super(true, null);
		}
		
		public function set sticky (value:Boolean):void {
			if (value != active)
				for (var i:int = _stickyTools.length; i--; )
					_stickyTools[i].sticky = value;
			super.active = value;
		}
		
		public function get sticky ():Boolean {
			return active;
		}
	}
}