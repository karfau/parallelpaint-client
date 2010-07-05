package de.karfau.parallelpaint.core.elements
{
	import de.karfau.parallelpaint.core.elements.style.IStrokeStyle;
	
	public interface IStrokedElement extends IElement
	{
		function get stroke ():IStrokeStyle;
		function set stroke (value:IStrokeStyle):void;
	}
}