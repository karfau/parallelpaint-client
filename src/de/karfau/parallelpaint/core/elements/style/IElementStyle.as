package de.karfau.parallelpaint.core.elements.style
{
	import de.karfau.parallelpaint.core.IComparable;
	import de.karfau.parallelpaint.core.elements.IClonable;
	import de.karfau.parallelpaint.core.elements.IElement;
	
	import flash.display.Graphics;
	
	[Bindable]
	public interface IElementStyle extends IClonable, IComparable
	{
		function get alpha ():Number;
		function set alpha (value:Number):void;
		
		function get color ():uint;
		function set color (value:uint):void;
		
		function get element ():IElement;
		function set element (value:IElement):void;
		
		function beginRenderStyle (graphics:Graphics):void;
		function endRenderStyle (graphics:Graphics):void;
		
		function isVisible ():Boolean;
	}
}