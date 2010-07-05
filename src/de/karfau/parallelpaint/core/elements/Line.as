package de.karfau.parallelpaint.core.elements
{
	import de.karfau.flexlogplus.*;
	import de.karfau.parallelpaint.core.elements.style.IStrokeStyle;
	
	import flash.display.Graphics;
	import flash.geom.Point;
	
	public class Line extends AbstractStrokedElement implements IStrokedElement
	{
		public function Line (firstPoint:Point=null, initialStroke:IStrokeStyle=null) {
			super(firstPoint, initialStroke);
			verbose(this, "created {0}", this);
		}
		
		public function get selectionPoints ():Vector.<SelectionPoint> {
			/*var bounds:Vector.<Point> = boundsForPoints(points);
				 var result:Vector.<SelectionPoint> = new Vector.<SelectionPoint>();
			 result.push(*/
			var result:Vector.<SelectionPoint> = new Vector.<SelectionPoint>();
			result.push(createSelectionPoint(firstPoint),
									createSelectionPoint(lastPoint));
			return result;
		}
		
		override protected function styledRendering (graphics:Graphics):void {
			graphics.moveTo(_firstPoint.x, _firstPoint.y);
			graphics.lineTo(_lastPoint.x, _lastPoint.y);
			ludicrous(this, "styledRendering() for {0} done", this);
		}
	
	/*override public function toString ():String {
		 return "Line{firstPoint:" + firstPoint + ", lastPoint:" + lastPoint + ", stroke:" + stroke + "}";
	 }*/
	
	}
}