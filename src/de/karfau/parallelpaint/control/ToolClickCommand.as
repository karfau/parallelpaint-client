package de.karfau.parallelpaint.control
{
	import de.karfau.flexlogplus.*;
	import de.karfau.parallelpaint.core.elements.IElement;
	import de.karfau.parallelpaint.core.tools.AbstractTool;
	import de.karfau.parallelpaint.core.tools.DispatchEventTool;
	import de.karfau.parallelpaint.core.tools.DrawElementTool;
	import de.karfau.parallelpaint.core.tools.ShowWindowTool;
	import de.karfau.parallelpaint.core.tools.interaction.Interaction;
	import de.karfau.parallelpaint.events.ElementEvent;
	import de.karfau.parallelpaint.events.InteractionEvent;
	import de.karfau.parallelpaint.events.ToolEvent;
	import de.karfau.parallelpaint.model.DrawingModel;
	import de.karfau.parallelpaint.model.InteractionModel;
	import de.karfau.parallelpaint.view.components.tools.windows.PopUpAnchor;
	import de.karfau.parallelpaint.view.components.tools.windows.ToolWindow;
	
	import mx.managers.PopUpManager;
	
	import org.robotlegs.mvcs.Command;
	
	public class ToolClickCommand extends Command
	{
		
		/*########################################################*/
		/*                                                        */
		/*   PROPERTIES (INCL. SETTER/GETTER)                     */
		/*                                                        */
		/*########################################################*/
		
		[Inject]
		public var event:ToolEvent;
		
		[Inject]
		public var mDrawing:DrawingModel;
		[Inject]
		public var mInteraction:InteractionModel;
		
		private var tool:AbstractTool;
		
		/*########################################################*/
		/*                                                        */
		/*   OVERRIDE / IMPLEMENT                                 */
		/*                                                        */
		/*########################################################*/
		
		override public function execute ():void {
			debug(this, ".execute( ) with tool {0}", event.tool);
			tool = event.tool;
			if (tool is Interaction) {
				if (tool.active) { //active is current state
					mInteraction.selectedInteractionTool = null;
				} else {
					if (tool is DrawElementTool && mDrawing.selectedElement)
						dispatch(new ElementEvent(ElementEvent.UNSELECT_ELEMENT, IElement(mDrawing.selectedElement)));
					dispatch(new InteractionEvent(InteractionEvent.ACTIVATE_INTERACTION, Interaction(tool)));
				}
			} else {
				if (tool.toggle) {
					tool.active = !tool.active;
				} else {
					//mInteraction.activeTool = event.tool;
				}
				
				/*if (event.tool is DrawElementTool) {
					 if (tool.active)
					 //mInteraction.drawElement = tool.active ? DrawElementTool(event.tool).elementClone : null;
				 }*/
				
				if (event.tool is ShowWindowTool)
					togglePopup(event.tool.active);
				
				if (event.tool is DispatchEventTool)
					dispatch(DispatchEventTool(event.tool).event);
			}
		}
		
		/*########################################################*/
		/*                                                        */
		/*  PRIVATE HELPER/UTIL                                   */
		/*                                                        */
		/*########################################################*/
		
		private function togglePopup (visible:Boolean=true):void {
			if (!visible) {
				dispatch(new ToolEvent(ToolEvent.CLOSE_WINDOW, tool));
			} else {
				var window:ToolWindow = ShowWindowTool(event.tool).window;
				if (window.styleName is PopUpAnchor) {
					PopUpAnchor(window.styleName).displayPopUp = true;
				} else {
					PopUpManager.addPopUp(window, contextView);
					mediatorMap.createMediator(window);
				}
			}
		}
	}
}