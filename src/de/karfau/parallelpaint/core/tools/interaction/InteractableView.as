package de.karfau.parallelpaint.core.tools.interaction
{
	import de.karfau.parallelpaint.core.elements.IElement;
	
	import flash.display.Graphics;
	import flash.events.IEventDispatcher;
	
	import mx.managers.ISystemManager;
	
	[Event(name="interactionStart", type="de.karfau.parallelpaint.events.InteractionEvent")]
	[Event(name="interactionUpdate", type="de.karfau.parallelpaint.events.InteractionEvent")]
	[Event(name="interactionResult", type="de.karfau.parallelpaint.events.InteractionEvent")]
	
	public interface InteractableView extends IEventDispatcher
	{
		function isCapableOf (interaction:Interaction):Boolean;
		
		function triggerRedraw ():void;
		
		function get interactionElement ():IElement;
		function set interactionElement (value:IElement):void;
		
		//provided by UIComponent, needed for rendering
		function get systemManager ():ISystemManager;
		function get graphics ():Graphics;
	}
}