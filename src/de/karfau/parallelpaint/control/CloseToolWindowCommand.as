package de.karfau.parallelpaint.control
{
	import mx.managers.PopUpManager;
	
	import de.karfau.flexlogplus.*
	import de.karfau.parallelpaint.core.tools.ShowWindowTool;
	import de.karfau.parallelpaint.events.ToolEvent;
	import de.karfau.parallelpaint.model.InteractionModel;
	import de.karfau.parallelpaint.view.components.tools.windows.PopUpAnchor;
	import org.robotlegs.mvcs.Command;
	
	public class CloseToolWindowCommand extends Command
	{
		
		/*########################################################*/
		/*                                                        */
		/*   PROPERTIES (INCL. SETTER/GETTER)                     */
		/*                                                        */
		/*########################################################*/
		
		[Inject]
		public var event:ToolEvent;
		[Inject]
		public var mInterAction:InteractionModel;
		
		private var tool:ShowWindowTool;
		
		/*########################################################*/
		/*                                                        */
		/*   OVERRIDE / IMPLEMENT                                 */
		/*                                                        */
		/*########################################################*/
		
		override public function execute ():void {
			debug(this, ".execute( ) ");
			tool = ShowWindowTool(event.tool);
			tool.active = false;
			if (tool.window.anchor) {
				tool.window.anchor.displayPopUp = false;
			} else {
				PopUpManager.removePopUp(tool.window);
			}
		
		}
	}
}