package de.karfau.parallelpaint.core.tools
{
	import de.karfau.parallelpaint.core.tools.interaction.ToolGroup;
	
	import org.osflash.signals.Signal;
	
	[Bindable]
	public class AbstractTool extends AbstractObject
	{
		
		/*########################################################*/
		/*                                                        */
		/*   PROPERTIES (INCL. SETTER/GETTER)                     */
		/*                                                        */
		/*########################################################*/
		
		private var _active:Boolean = false;
		
		public function get active ():Boolean {
			return _active;
		}
		
		public function set active (value:Boolean):void {
			if (toggle && _active != value) {
				_active = value;
				onSwitchToggle.dispatch(_active);
			}
		}
		
		private var _enabled:Boolean = true;
		
		public function get enabled ():Boolean {
			return _enabled;
		}
		
		public function set enabled (value:Boolean):void {
			_enabled = value;
			onInteractableChanged.dispatch();
		}
		
		private var _groupName:String;
		
		public function get groupName ():String {
			return _groupName;
		}
		
		public var icon:Class;
		
		public var label:String;
		
		public const onInteractableChanged:Signal = new Signal();
		
		public const onSwitchToggle:Signal = new Signal(Boolean);
		
		private var _toggle:Boolean;
		
		public function get toggle ():Boolean {
			return _toggle;
		}
		private var _visible:Boolean = true;
		
		public function get visible ():Boolean {
			return _visible;
		}
		
		public function set visible (value:Boolean):void {
			_visible = value;
			onInteractableChanged.dispatch();
		}
		
		public var access:ToolAccess = new ToolAccess();
		
		public function updateAccessLvl (lvl:uint):void {
			access.updateToolAccess(this, lvl);
		}
		
		/*########################################################*/
		/*                                                        */
		/*   CONSTRUCTOR                                          */
		/*                                                        */
		/*########################################################*/
		
		public function AbstractTool (toggle:Boolean, groupName:String=null) {
			super(AbstractTool);
			_toggle = toggle;
			_groupName = groupName || ToolGroup.NO_GROUP;
		}
	}
}