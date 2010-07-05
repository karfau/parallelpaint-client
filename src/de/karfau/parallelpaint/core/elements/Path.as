package de.karfau.parallelpaint.core.elements
{
	import de.karfau.parallelpaint.core.elements.style.IFillStyle;
	import de.karfau.parallelpaint.core.elements.style.IStrokeStyle;
	
	import flash.display.Graphics;
	import flash.display.GraphicsPath;
	import flash.display.GraphicsPathCommand;
	import flash.geom.Point;
	
	public class Path extends AbstractStrokedFilledElement implements IFilledElement, IStrokedElement
	{
		
		/*########################################################*/
		/*                                                        */
		/*   PROPERTIES (INCL. SETTER/GETTER)                     */
		/*                                                        */
		/*########################################################*/
		
		private var _autoClose:Boolean;
		
		public override function invalidateRendering ():void {
			pathData = null;
			super.invalidateRendering();
		}
		
		public function get autoClose ():Boolean {
			return _autoClose;
		}
		
		public function set autoClose (value:Boolean):void {
			_autoClose = value;
		}
		
		private var _drawingCommand:int = GraphicsPathCommand.CURVE_TO;
		
		public function get drawingCommand ():int {
			return _drawingCommand;
		}
		
		public function set drawingCommand (value:int):void {
			_drawingCommand = value;
		}
		private var pathData:GraphicsPath;
		
		private var _points:Vector.<Point> = new Vector.<Point>();
		
		override public function get points ():Vector.<Point> {
			return _points.concat();
		}
		
		public function get selectionPoints ():Vector.<SelectionPoint> {
			var result:Vector.<SelectionPoint> = new Vector.<SelectionPoint>();
			var bounds:Vector.<Point> = boundsForPoints(_points);
			for each (var p:Point in bounds) {
				result.push(createSelectionPoint(p));
			}
			return result;
		}
		
		/*########################################################*/
		/*                                                        */
		/*   CONSTRUCTOR                                          */
		/*                                                        */
		/*########################################################*/
		
		public function Path (firstPoint:Point=null, initialStroke:IStrokeStyle=null, initialFill:IFillStyle=null) {
			super(firstPoint, initialStroke, initialFill);
		}
		
		/*########################################################*/
		/*                                                        */
		/*   OVERRIDE / IMPLEMENT                                 */
		/*                                                        */
		/*########################################################*/
		
		public override function addPoint (point:Point):void {
			if (point) {
				//delayRendering = true;
				super.addPoint(point);
				this._points.push(point);
				invalidateRendering();
					//delayRendering = false;
			}
			//trace(_points);
		}
		
		protected override function styledRendering (graphics:Graphics):void {
			ensurePathData();
			graphics.drawPath(pathData.commands, pathData.data, pathData.winding);
		}
		
		/*########################################################*/
		/*                                                        */
		/*  PRIVATE HELPER/UTIL                                   */
		/*                                                        */
		/*########################################################*/
		
		private function ensurePathData ():void {
			//trace("ensurePathData pathdata");
			if (!pathData) {
				//trace("rebuilding pathdata");
				pathData = new GraphicsPath();
				pathData.moveTo(firstPoint.x, firstPoint.y);
				var len:uint = _points.length;
				for (var i:int = 1; i < len; i++) {
					switch (drawingCommand) {
						case GraphicsPathCommand.CURVE_TO:
						case GraphicsPathCommand.WIDE_LINE_TO:
						case GraphicsPathCommand.WIDE_MOVE_TO:
							pushToPathData(i++);
							if (i == len) {
								pushToPathData(i - 1);
								break;
							}
						case GraphicsPathCommand.LINE_TO:
						case GraphicsPathCommand.MOVE_TO:
							pushToPathData(i);
					}
				}
			}
		}
		
		private function pushToPathData (index:int):void {
			pathData.commands.push(drawingCommand);
			pathData.data.push(_points[index].x, _points[index].y);
		}
	}
}