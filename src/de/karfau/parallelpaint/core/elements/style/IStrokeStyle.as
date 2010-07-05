package de.karfau.parallelpaint.core.elements.style
{
	
	[Bindable]
	public interface IStrokeStyle extends IElementStyle
	{
		function get width ():Number;
		function set width (value:Number):void;
	}
}