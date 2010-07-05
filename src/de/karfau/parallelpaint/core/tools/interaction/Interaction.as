package de.karfau.parallelpaint.core.tools.interaction
{
	import flash.display.Graphics;
	import flash.events.Event;
	
	public interface Interaction
	{
		function get view ():InteractableView;
		function set view (value:InteractableView):void;
		
		function get active ():Boolean;
		function set active (value:Boolean):void;
		
		/**
		 * registers/unregisters all eventlisteners needed for the interaction.
		 *
		 * @param active true for addListener, false for removeListener, user with mapListener
		 * @private
		 */
		function registerListeners (active:Boolean):void;
		
		function createResultEvent ():Event;
	
	}
}