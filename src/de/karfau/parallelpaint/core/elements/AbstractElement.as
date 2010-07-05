package de.karfau.parallelpaint.core.elements
{
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	
	import de.karfau.parallelpaint.core.IComparable;
	import de.karfau.parallelpaint.model.vo.User;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import org.spicefactory.lib.reflect.types.Private;
	
	//[Bindable]
	/**
	 *
	 * @author Karfau
	 */
	public class AbstractElement extends AbstractObject //implements IElement
	{
		
		/*########################################################*/
		/*                                                        */
		/*   PROPERTIES (INCL. SETTER/GETTER)                     */
		/*                                                        */
		/*########################################################*/
		
		public function get center ():Point {
			return centerForPoints(boundsForPoints(this.points));
		}
		
		private var _drawingId:Number;
		
		public function get drawingId ():Number {
			return _drawingId;
		}
		
		public function set drawingId (value:Number):void {
			_drawingId = value;
		}
		
		protected var _firstPoint:Point;
		
		//[Bindable(event="pointsChanged")]
		public function get firstPoint ():Point {
			return _firstPoint;
		}
		
		private var _id:Number = -1;
		
		public function get id ():Number {
			return _id;
		}
		
		public function set id (value:Number):void {
			_id = value;
		}
		
		protected var _lastPoint:Point;
		
		//[Bindable(event="pointsChanged")]
		public function get lastPoint ():Point {
			return _lastPoint;
		}
		
		protected const _onNeedsRendering:Signal = new Signal();
		
		public function get onNeedsRendering ():ISignal {
			return _onNeedsRendering;
		}
		
		//[Bindable(event="pointsChanged")]
		public function get points ():Vector.<Point> {
			var result:Vector.<Point> = new Vector.<Point>();
			if (firstPoint != null)
				result.push(firstPoint);
			if (lastPoint != null)
				result.push(lastPoint);
			return result;
		}
		
		//[Bindable(event="selectorChanged")]
		public function get selected ():Boolean {
			return _selector != null;
		}
		
		protected var _selector:String;
		
		public function get selector ():String {
			return _selector;
		}
		
		public function set selector (value:String):void {
			_selector = value;
		}
		
		private var _version:Number;
		
		public function get version ():Number {
			return _version;
		}
		
		public function set version (value:Number):void {
			_version = value;
		}
		
		/*########################################################*/
		/*                                                        */
		/*   CONSTRUCTOR                                          */
		/*                                                        */
		/*########################################################*/
		
		public function AbstractElement (firstPoint:Point=null) {
			super(AbstractElement, IElement);
			
			addPoint(firstPoint);
		}
		
		/*########################################################*/
		/*                                                        */
		/*   OVERRIDE / IMPLEMENT                                 */
		/*                                                        */
		/*########################################################*/
		
		public function equals (other:IComparable):Boolean {
			if (other == null)
				return false;
			if (this === other)
				return true;
			else if (this.id == -1)
				return false;
			else if (!(other is IElement))
				return false;
			else if (IElement(other).id == -1)
				return false;
			else if (getQualifiedClassName(other) == getQualifiedClassName(this) && IElement(other).id == this.id)
				return true;
			return false;
		}
		
		public function addPoint (point:Point):void {
			if (point == null) {
				return;
			} else {
				if (_firstPoint == null) {
					_firstPoint = point;
				}
				_lastPoint = point;
					//invalidate();
			}
		}
		
		public function move (diff:Point):void {
			var points:Vector.<Point> = this.points;
			for (var i:int = points.length; i--; ) {
				addToPoint(points[i], diff);
			}
			invalidateRendering();
		}
		
		public function isVisible ():Boolean {
			if (firstPoint && lastPoint)
				return firstPoint.x != lastPoint.x || firstPoint.y != lastPoint.y;
			return false;
		}
		
		public function isValid ():Boolean {
			return drawingId && isVisible();
		}
		
		public function invalidateRendering ():void {
			needsRendering = true;
		}
		
		/**
		 * The current implementation doesn't clone the position!
		 *
		 * @return cloned IElement
		 */
		public function clone ():IClonable {
			var result:IElement = IElement(new clazz());
			result.id = id;
			result.drawingId = drawingId;
			result.version = version;
			return result;
		}
		
		protected function dispatchOnNeedsRendering ():Boolean {
			//if (_needsRendering && !_delayRendering) {
			_onNeedsRendering.dispatch();
			return true;
			//}
			//return false;
		}
		
		protected final function centerForPoints (points:Vector.<Point>):Point {
			var result:Point;
			switch (points.length) {
				case 0:
					return null;
				case 1:
					result = points[0];
					break;
				case 2:
					result = points[0].add(points[1]);
					result.x /= 2;
					result.y /= 2;
					break;
				default:
					result = new Point(0, 0);
					for (var i:int = points.length; i--; ) {
						addToPoint(result, points[i]);
					}
					result.x /= points.length;
					result.y /= points.length;
			}
			return result;
		}
		
		protected final function boundsForPoints (points:Vector.<Point>):Vector.<Point> {
			var max:Point = new Point(Number.MIN_VALUE, Number.MIN_VALUE);
			var min:Point = new Point(Number.MAX_VALUE, Number.MAX_VALUE);
			var p:Point;
			for (var i:int = points.length; i--; ) {
				p = points[i];
				max.x = p.x > max.x ? p.x : max.x;
				max.y = p.y > max.y ? p.y : max.y;
				min.x = p.x < min.x ? p.x : min.x;
				min.y = p.y < min.y ? p.y : min.y;
			}
			var result:Vector.<Point> = new Vector.<Point>();
			result.push(new Point(min.x, min.y),
									new Point(min.x, max.y),
									new Point(max.x, min.y),
									new Point(max.x, max.y));
			return result;
		}
		
		protected final function createSelectionPoint (location:Point, anchor:Point=null):SelectionPoint {
			return new SelectionPoint(IElement(this), location, anchor);
		}
		
		/*########################################################*/
		/*                                                        */
		/*  PRIVATE HELPER/UTIL                                   */
		/*                                                        */
		/*########################################################*/
		
		/*protected var _delayRendering:Boolean;
		
			 protected function get delayRendering ():Boolean {
			 return _delayRendering;
			 }
		
			 protected function set delayRendering (value:Boolean):void {
			 _delayRendering = value;
			 if (_needsRendering)
			 dispatchOnNeedsRendering();
		 }*/
		
		protected var _needsRendering:Boolean;
		
		protected function get needsRendering ():Boolean {
			return _needsRendering;
		}
		
		protected function set needsRendering (value:Boolean):void {
			_needsRendering = value;
			if (_needsRendering)
				dispatchOnNeedsRendering();
		}
		
		private function addToPoint (target:Point, diff:Point):void {
			target.x += diff.x;
			target.y += diff.y;
		}
	}
}