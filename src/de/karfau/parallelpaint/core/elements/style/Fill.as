package de.karfau.parallelpaint.core.elements.style
{
	import de.karfau.flexlogplus.ludicrous;
	import de.karfau.parallelpaint.core.elements.IClonable;
	import de.karfau.parallelpaint.core.elements.IElement;

	import flash.display.Graphics;

	public class Fill extends AbstractElementStyle implements IFillStyle
	{

		/*########################################################*/
		/*                                                        */
		/*   CONSTRUCTOR                                          */
		/*                                                        */
		/*########################################################*/

		public function Fill (color:uint=INVISIBLE_COLOR, alpha:Number=INVISIBLE_ALPHA) {
			super(color, alpha);
			invalidateElement();
		}

		/*########################################################*/
		/*                                                        */
		/*   OVERRIDE / IMPLEMENT                                 */
		/*                                                        */
		/*########################################################*/

		public function beginRenderStyle (graphics:Graphics):void {
			ludicrous(this, "beginRenderStyle with {0} {1}", _color, _alpha);
			graphics.beginFill(color, alpha);
		}

		public function endRenderStyle (graphics:Graphics):void {
			graphics.endFill();
		}

		override public function clone ():IClonable {
			return super.clone();
		}

		public function toString ():String {
			return "Fill{alpha:" + _alpha + ", color:" + _color + "}";
		}

	}
}