package de.karfau.parallelpaint.core.elements
{
	import de.karfau.parallelpaint.core.IComparable;
	
	import flash.geom.Point;
	
	/**
	 *
	 * @author Karfau
	 */
	public interface IElement extends IClonable, ISelectable, IRender, IComparable
	{
		/**
		 * The first point that is used to render the element.
		 * Can be the same as lastPoint if addPoint was only called once.
		 * (The element is not visible in this case.)
		 */
		function get firstPoint ():Point;
		/**
		 * The second or last point that is used to render the element
		 */
		function get lastPoint ():Point;
		/**
		 * all points that are used to render the element
		 */
		function get points ():Vector.<Point>;
		/**
		 * Sets or adds point depending on the implementing element.
		 * For elements with only two points this could set firstPoint when called the first time
		 * and set lastPoint on each call after that. For Elements that support more then one points,
		 * this could add point to points. After calling this point is always lastPoint.
		 */
		function addPoint (point:Point):void;
		/**
		 * An element is visible if there are at least two differnt points.
		 */
		function isVisible ():Boolean;
		/**
		 * An element is valid if it isVisible() and has a drawingId assigned
		 */
		function isValid ():Boolean;
		/**
		 * moves all <code>point</code>s by adding <code>diff</code> to them
		 */
		function move (diff:Point):void;
	}
}