package de.karfau.parallelpaint.core.tools.interaction
{
	import flash.geom.Point;
	
	public interface DragInteractableView extends InteractableView
	{
		function set isMouseDown (value:Boolean):void;
		function get isMouseDown ():Boolean;
		
		function set isDragging (value:Boolean):void;
		function get isDragging ():Boolean;
		
		function get x ():Number;
		function get y ():Number;
		
		function moveTo (diff:Point):void;
	}
}