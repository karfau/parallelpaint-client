package de.karfau.parallelpaint.view.components.tools
{
	import de.karfau.parallelpaint.events.ToolEvent;
	import de.karfau.parallelpaint.model.InteractionModel;
	import de.karfau.parallelpaint.service.definition.ElementPersistanceService;
	
	import flash.events.MouseEvent;
	
	import org.robotlegs.core.IMediator;
	import org.robotlegs.mvcs.Mediator;
	
	public class ToolButtonMediator extends Mediator implements IMediator
	{
		[Inject]
		public var button:ToolButton;
		
		[Inject]
		public var mInteraction:InteractionModel;
		
		override public function onRegister ():void {
			//eventMap.mapListener(button, MouseEvent.CLICK, handleButtonClick, MouseEvent);
			
			button.onButtonReleased.add(dispatch);
			mInteraction.registerTool(button.tool);
		}
		
		/*private function handleButtonClick (event:MouseEvent):void {
			 var type:String = ToolEvent.TOOL_CLICK;
			 if (button.tool.toggle) {
			 type = button.selected ? ToolEvent.TOOL_TOGGLE_OFF : ToolEvent.TOOL_TOGGLE_ON;
			 }
			 dispatch(new ToolEvent(type, button.tool));
		 }*/
		
		override public function onRemove ():void {
			button.onButtonReleased.remove(dispatch);
		}
	}
}