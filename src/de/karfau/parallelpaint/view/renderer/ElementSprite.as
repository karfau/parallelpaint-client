package de.karfau.parallelpaint.view.renderer
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import spark.components.Group;
	
	import de.karfau.flexlogplus.ludicrous;
	import de.karfau.parallelpaint.core.elements.IElement;
	
	public class ElementSprite extends Group
	{
		
		/*########################################################*/
		/*                                                        */
		/*   PROPERTIES (INCL. SETTER/GETTER)                     */
		/*                                                        */
		/*########################################################*/
		
		protected var _element:IElement;
		
		[Bindable]
		public function get element ():IElement {
			return _element;
		}
		
		public function set element (value:IElement):void {
			if (_element) {
				_element.onNeedsRendering.remove(invalidateDisplayList);
			}
			_element = value;
			if (_element)
				_element.onNeedsRendering.add(invalidateDisplayList);
			invalidateDisplayList();
		}
		
		/*########################################################*/
		/*                                                        */
		/*   CONSTRUCTOR                                          */
		/*                                                        */
		/*########################################################*/
		
		public function ElementSprite (element:IElement) {
			this.element = element;
			super();
			invalidateDisplayList();
		}
		
		/*########################################################*/
		/*                                                        */
		/*   OVERRIDE / IMPLEMENT                                 */
		/*                                                        */
		/*########################################################*/
		
		override protected function updateDisplayList (unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			ludicrous(this, ".updateDisplayList(...) drawing {0}", element);
			graphics.clear();
			if (_element)
				_element.renderOn(graphics);
		}
		
		public function resetPosition (surpressRedraw:Boolean=false):Point {
			var result:Point = new Point(x, y);
			x = y = 0;
			if (!surpressRedraw)
				invalidateDisplayList();
			return result;
		}
	}
}