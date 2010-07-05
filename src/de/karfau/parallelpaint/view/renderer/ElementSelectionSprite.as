package de.karfau.parallelpaint.view.renderer
{
	import de.karfau.parallelpaint.core.elements.SelectionPoint;
	
	import flash.display.Sprite;
	
	import mx.containers.Canvas;
	
	public class ElementSelectionSprite extends Canvas
	{
		
		private var _selectionPoint:SelectionPoint;
		
		private var xpos:Number;
		private var ypos:Number;
		
		public function get selectionPoint ():SelectionPoint {
			return _selectionPoint;
		}
		
		public function ElementSelectionSprite (selectionPoint:SelectionPoint) {
			this._selectionPoint = selectionPoint;
			super();
			setPosition();
		}
		
		private function setPosition ():void {
			xpos = _selectionPoint.location.x;
			ypos = _selectionPoint.location.y;
			left = xpos;
			top = ypos;
			this.width = 30;
			this.height = 30;
		}
		
		protected override function updateDisplayList (unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			/**TRACEDISABLE:trace(xpos, ypos, selectionPoint.location, selectionPoint.anchor, x, y, width, height);*/
			graphics.clear();
			graphics.beginFill(0);
			graphics.drawRect(-5, -5, 10, 10);
			graphics.endFill();
		}
	
	}
}