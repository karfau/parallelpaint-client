package de.karfau.parallelpaint.core.elements
{
	import de.karfau.parallelpaint.core.elements.style.IFillStyle;
	import de.karfau.parallelpaint.core.elements.style.IStrokeStyle;
	
	import flash.display.Graphics;
	import flash.geom.Point;
	
	public class Circle extends AbstractStrokedFilledElement implements IFilledElement, IStrokedElement
	{
		
		/*########################################################*/
		/*                                                        */
		/*   PROPERTIES (INCL. SETTER/GETTER)                     */
		/*                                                        */
		/*########################################################*/
		
		public override function get center ():Point {
			return firstPoint;
		}
		
		private var _radius:Number = 0;
		
		public function get radius ():Number {
			if (_radius <= 0 && isVisible()) {
				calculateRadiusByPoints();
			}
			return _radius;
		}
		
		public function set radius (value:Number):void {
			if (value > 0) {
				if (firstPoint) {
					addPoint(firstPoint.add(new Point(0, value)));
				}
			} else {
				calculateRadiusByPoints();
				
			}
		}
		
		public function get selectionPoints ():Vector.<SelectionPoint> {
			var result:Vector.<SelectionPoint> = new Vector.<SelectionPoint>();
			result.push(createSelectionPoint(new Point(firstPoint.x, firstPoint.y + radius)),
									createSelectionPoint(new Point(firstPoint.x, firstPoint.y - radius)),
									createSelectionPoint(new Point(firstPoint.x + radius, firstPoint.y)),
									createSelectionPoint(new Point(firstPoint.x - radius, firstPoint.y))
									);
			return result;
		}
		
		/*########################################################*/
		/*                                                        */
		/*   CONSTRUCTOR                                          */
		/*                                                        */
		/*########################################################*/
		
		public function Circle (firstPoint:Point=null, initialStroke:IStrokeStyle=null, initialFill:IFillStyle=null) {
			super(firstPoint, initialStroke, initialFill);
		}
		
		/*########################################################*/
		/*                                                        */
		/*   OVERRIDE / IMPLEMENT                                 */
		/*                                                        */
		/*########################################################*/
		
		public override function addPoint (point:Point):void {
			if (point != null) {
				super.addPoint(point);
				radius = -1; //triggers calculation on next rendering
			}
		}
		
		override protected function styledRendering (graphics:Graphics):void {
			graphics.drawCircle(firstPoint.x, firstPoint.y, radius);
		}
		
		/*########################################################*/
		/*                                                        */
		/*  PRIVATE HELPER/UTIL                                   */
		/*                                                        */
		/*########################################################*/
		
		private function calculateRadiusByPoints ():void {
			if (isVisible()) {
				var a:Number = _lastPoint.x - _firstPoint.x;
				var b:Number = _lastPoint.y - _firstPoint.y;
				_radius = Math.sqrt(a * a + b * b);
			} else {
				_radius = 0;
			}
		}
	}
}