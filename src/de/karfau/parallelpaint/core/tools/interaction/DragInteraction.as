package de.karfau.parallelpaint.core.tools.interaction
{
	import flash.events.MouseEvent;
	
	public interface DragInteraction extends Interaction
	{
		function onDragStart (event:MouseEvent):void;
		function onDragMove (event:MouseEvent):void;
		function onDragStop (event:MouseEvent):void;
		
		function cancelDragging ():void;
	}
}