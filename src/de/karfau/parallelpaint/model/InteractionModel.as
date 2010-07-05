package de.karfau.parallelpaint.model
{
	import de.karfau.flexlogplus.*;
	import de.karfau.parallelpaint.core.elements.IElement;
	import de.karfau.parallelpaint.core.elements.IStrokedElement;
	import de.karfau.parallelpaint.core.tools.AbstractTool;
	import de.karfau.parallelpaint.core.tools.DrawElementTool;
	import de.karfau.parallelpaint.core.tools.SelectElementTool;
	import de.karfau.parallelpaint.core.tools.ToolAccess;
	import de.karfau.parallelpaint.core.tools.interaction.Interaction;
	import de.karfau.parallelpaint.core.tools.interaction.ToolGroup;
	import de.karfau.parallelpaint.events.ElementEvent;
	import de.karfau.parallelpaint.events.InteractionEvent;
	import de.karfau.parallelpaint.events.MouseInteractionEvent;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import org.robotlegs.mvcs.Actor;
	
	//[Event(name="mouse_down", type="de.karfau.parallelpaint.events.MouseInteractionEvent")]
	[Event(name="drawElementChange", type="de.karfau.parallelpaint.events.MouseInteractionEvent")]
	public class InteractionModel extends Actor
	{
		
		[Inject]
		public var mDrawing:DrawingModel;
		
		/*########################################################*/
		/*                                                        */
		/*   PROPERTIES (INCL. SETTER/GETTER)                     */
		/*                                                        */
		/*########################################################*/
		
		private var groupNameMap:Object = new Object();
		
		private var _selectedInteractionTool:Interaction;
		
		public function get selectedInteractionTool ():Interaction {
			return _selectedInteractionTool;
		}
		
		public function set selectedInteractionTool (value:Interaction):void {
			if (_selectedInteractionTool != value) {
				if (_selectedInteractionTool != null) {
					_selectedInteractionTool.active = false;
				}
				var defaultTool:Interaction;
				if (value == null) {
					defaultTool = unselectGroup(AbstractTool(_selectedInteractionTool).groupName, value as AbstractTool) as Interaction;
				} else if (value is AbstractTool) {
					var tool:AbstractTool = AbstractTool(value);
					defaultTool = unselectGroup(tool.groupName, tool) as Interaction;
				}
				_selectedInteractionTool = value ? value : defaultTool;
				verbose(this, "selectedInteractionTool is {0}", _selectedInteractionTool);
				dispatch(new InteractionEvent(InteractionEvent.SELECTED_INTERACTION_CHANGED, _selectedInteractionTool));
				if (_selectedInteractionTool && !_selectedInteractionTool.active)
					dispatch(new InteractionEvent(InteractionEvent.ACTIVATE_INTERACTION, _selectElementTool));
			}
		
		}
		
		private var _selectElementTool:SelectElementTool
		
		public function get selectElementTool ():SelectElementTool {
			if (!_selectElementTool) {
				_selectElementTool = new SelectElementTool();
				_selectElementTool.label = "Select by Mouse";
			}
			return _selectElementTool;
		}
		
		public function get styledInteractionElement ():IStrokedElement {
			var result:IStrokedElement;
			if (_selectedInteractionTool is DrawElementTool) {
				result = DrawElementTool(_selectedInteractionTool).elementToStyle;
			} else if (_selectedInteractionTool is SelectElementTool) {
				result = mDrawing.selectedElement as IStrokedElement;
			}
			return result;
		}
		
		/*########################################################*/
		/*                                                        */
		/*   CONSTRUCTOR                                          */
		/*                                                        */
		/*########################################################*/
		
		public function InteractionModel () {
			super();
		}
		
		/*########################################################*/
		/*                                                        */
		/*   OVERRIDE / IMPLEMENT                                 */
		/*                                                        */
		/*########################################################*/
		
		public function registerTool (tool:AbstractTool, currentAccessLvl:uint=0, asGroupDefault:Boolean=false):void {
			if (!_selectElementTool) {
				registerTool(selectElementTool, 0, true);
				selectedInteractionTool = _selectElementTool;
			}
			var group:ToolGroup = getOrCreateGroup(tool.groupName);
			if (group.tools.indexOf(tool) == -1) {
				group.tools.push(tool);
				tool.updateAccessLvl(currentAccessLvl);
				debug(this, "registerTool(...) registered {0}tool for group '{1}': <{2}>", (asGroupDefault ? "default " : ""), tool.groupName, tool);
			}
			if (asGroupDefault)
				group.defaultTool = tool;
		}
		
		private var _currentToolsAccess:uint = ToolAccess.REQ_NOTHING;
		
		public function setCurrentToolsAccess (currentAccess:uint):void {
			if (_currentToolsAccess != currentAccess) {
				_currentToolsAccess = currentAccess;
				for each (var toolGroup:ToolGroup in groupNameMap) {
					updateToolGroupAccess(toolGroup, currentAccess);
				}
			}
		}
		
		public function getCurrentToolsAccess ():uint {
			return _currentToolsAccess;
		}
		
		public function updateToolGroupAccess (toolGroup:ToolGroup, currentAccess:uint):void {
			for each (var tool:AbstractTool in toolGroup.tools) {
				tool.updateAccessLvl(currentAccess);
			}
		}
		
		/*########################################################*/
		/*                                                        */
		/*  PRIVATE HELPER/UTIL                                   */
		/*                                                        */
		/*########################################################*/
		
		private function getOrCreateGroup (name:String):ToolGroup {
			if (!groupNameMap[name])
				groupNameMap[name] = new ToolGroup(name);
			return ToolGroup(groupNameMap[name]);
		}
		
		private function unselectGroup (groupName:String, excludeTool:AbstractTool=null):AbstractTool {
			var group:ToolGroup = getOrCreateGroup(groupName);
			for each (var tool:AbstractTool in group.tools) {
				if (!excludeTool || tool !== excludeTool)
					tool.active = false;
			}
			return group.defaultTool;
		}
	}
}