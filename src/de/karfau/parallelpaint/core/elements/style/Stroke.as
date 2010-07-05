package de.karfau.parallelpaint.core.elements.style
{
	import de.karfau.parallelpaint.core.IComparable;
	import de.karfau.parallelpaint.core.elements.IClonable;
	import de.karfau.parallelpaint.core.elements.IElement;
	
	import flash.display.Graphics;
	
	[Bindable]
	public class Stroke extends AbstractElementStyle implements IStrokeStyle
	{
		
		public static const INVISIBLE_WIDTH:Number = 0;
		
		/*########################################################*/
		/*                                                        */
		/*   PROPERTIES (INCL. SETTER/GETTER)                     */
		/*                                                        */
		/*########################################################*/
		
		private var _width:Number;
		
		public override function equals (other:IComparable):Boolean {
			return this === other || (super.equals(other) && IStrokeStyle(other).width == width);
		}
		
		public function get width ():Number {
			return _width;
		}
		
		public function set width (value:Number):void {
			_width = value;
			invalidateElement();
		}
		
		/*########################################################*/
		/*                                                        */
		/*   CONSTRUCTOR                                          */
		/*                                                        */
		/*########################################################*/
		
		public function Stroke (color:uint=INVISIBLE_COLOR, alpha:Number=INVISIBLE_ALPHA, width:Number=INVISIBLE_WIDTH) {
			
			super(color, alpha);
			this._width = width;
			invalidateElement();
		}
		
		/*########################################################*/
		/*                                                        */
		/*   OVERRIDE / IMPLEMENT                                 */
		/*                                                        */
		/*########################################################*/
		
		public function beginRenderStyle (graphics:Graphics):void {
			/**TRACEDISABLE:trace(this, "beginRenderStyle", isVisible(), _color, _alpha);*/
			/*if (isVisible())*/
			graphics.lineStyle(_width, _color, _alpha);
		/*else
		 graphics.lineStyle(2, 0xFF0000, 0.5);*/
		}
		
		public function endRenderStyle (graphics:Graphics):void {
			//nothing to do for lineStyle?
		}
		
		override public function clone ():IClonable {
			var result:Stroke = super.clone() as Stroke;
			result.width = this.width;
			return result;
		}
		
		public function toString ():String {
			return "Stroke{width:" + width + ",alpha:" + alpha + ",color:" + color + "}";
		}
		
		public override function isVisible ():Boolean {
			return super.isVisible() && width != INVISIBLE_WIDTH;
		}
	}
}