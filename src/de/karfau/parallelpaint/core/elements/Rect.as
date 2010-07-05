package de.karfau.parallelpaint.core.elements
{
	import de.karfau.parallelpaint.core.elements.style.IFillStyle;
	import de.karfau.parallelpaint.core.elements.style.IStrokeStyle;
	
	import flash.display.Graphics;
	import flash.geom.Point;
	
	public class Rect extends AbstractStrokedFilledElement implements IStrokedElement, IFilledElement
	{
		public function Rect (firstPoint:Point=null, initialStroke:IStrokeStyle=null, initialFill:IFillStyle=null) {
			super(firstPoint, initialStroke, initialFill);
		}
		
		override protected function styledRendering (graphics:Graphics):void {
			graphics.drawRect(firstPoint.x, firstPoint.y,
												lastPoint.x - firstPoint.x, lastPoint.y - firstPoint.y);
		}
		
		public function get selectionPoints ():Vector.<SelectionPoint> {
			var result:Vector.<SelectionPoint> = new Vector.<SelectionPoint>();
			//var center:Point = this.center;
			result.push(createSelectionPoint(firstPoint),
									createSelectionPoint(new Point(firstPoint.x, lastPoint.y)),
									createSelectionPoint(lastPoint),
									createSelectionPoint(new Point(lastPoint.x, firstPoint.y))
									);
			return result;
		}
	}
}