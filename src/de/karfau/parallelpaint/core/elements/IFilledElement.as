package de.karfau.parallelpaint.core.elements
{
	import de.karfau.parallelpaint.core.elements.style.IFillStyle;
	
	public interface IFilledElement extends IElement
	{
		function get fill ():IFillStyle
		function set fill (value:IFillStyle):void;
	}
}