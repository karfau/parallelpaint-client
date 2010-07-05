package de.karfau.parallelpaint.view.components.tools
{
	import de.karfau.parallelpaint.core.tools.AbstractTool;
	import de.karfau.parallelpaint.events.ToolEvent;
	
	import flash.events.MouseEvent;
	
	import mx.core.IFactory;
	
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	
	import spark.components.ToggleButton;
	
	/*[Event(name="tool_toggle_on", type="de.karfau.parallelpaint.events.ToolEvent")]
	 [Event(name="tool_toggle_off", type="de.karfau.parallelpaint.events.ToolEvent")]*/
	[Event(name="tool_click", type="de.karfau.parallelpaint.events.ToolEvent")]
	
	public class ToolButton extends ToggleButton
	{
		
		private var _tool:AbstractTool;
		
		[Bindable]
		public function get tool ():AbstractTool {
			return _tool;
		}
		
		public function set tool (value:AbstractTool):void {
			if (_tool != value) {
				if (_tool != null) {
					_tool.onSwitchToggle.remove(handleToggleSwitch);
					_tool.onInteractableChanged.remove(updateInteractable);
				}
				_tool = value;
				if (_tool != null) {
					_tool.onSwitchToggle.add(handleToggleSwitch);
					_tool.onInteractableChanged.add(updateInteractable);
				}
				updateInteractable();
				invalidateDisplayList();
				invalidateProperties();
			}
		}
		
		public function ToolButton (tool:AbstractTool=null) {
			this.tool = tool;
			super();
		}
		
		public override function set selected (value:Boolean):void {
			if (tool.toggle && super.selected != value) {
				super.selected = value;
					//tool.active = value;
			}
		}
		
		public const onButtonReleased:Signal = new Signal(ToolEvent);
		
		override protected function buttonReleased ():void {
			var type:String;
			if (tool.toggle) {
				super.buttonReleased();
			}
			onButtonReleased.dispatch(new ToolEvent(ToolEvent.TOOL_CLICK, tool));
		}
		
		private function handleToggleSwitch (active:Boolean):void {
			if (selected != active) {
				this.selected = active;
			}
		
		}
		
		private function updateInteractable ():void {
			if (tool) {
				this.enabled = tool.enabled;
				this.visible = tool.visible;
				this.includeInLayout = tool.visible;
			}
		}
	
	}
}