package de.karfau.parallelpaint.core.elements
{
	import flash.geom.Point;
	
	public class ElementUtil
	{
		
		public static function cloneWithPosition (element:IElement):IElement {
			var result:IElement = IElement(element.clone());
			for each (var p:Point in element.points) {
				result.addPoint(p);
			}
			return result;
		}
	
	}
}