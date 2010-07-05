package de.karfau.parallelpaint.model.vo
{
	import de.karfau.parallelpaint.core.IComparable;
	
	public interface ValueObject extends IComparable
	{
		function get id ():Number;
		function set id (value:Number):void;
	}
}