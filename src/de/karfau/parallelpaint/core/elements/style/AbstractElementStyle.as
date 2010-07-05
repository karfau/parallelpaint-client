package de.karfau.parallelpaint.core.elements.style
{
	import de.karfau.parallelpaint.core.IComparable;
	import de.karfau.parallelpaint.core.elements.IClonable;
	import de.karfau.parallelpaint.core.elements.IElement;

	[Bindable]
	public class AbstractElementStyle extends AbstractObject // implements IElementStyle
	{

		public static const INVISIBLE_ALPHA:Number = 0;
		public static const INVISIBLE_COLOR:uint = 0xFFFFFF;

		/*########################################################*/
		/*                                                        */
		/*   PROPERTIES (INCL. SETTER/GETTER)                     */
		/*                                                        */
		/*########################################################*/

		protected var _alpha:Number;

		public function get alpha ():Number {
			return _alpha;
		}

		public function set alpha (value:Number):void {
			_alpha = value;
			invalidateElement();
		}

		protected var _color:uint;

		public function get color ():uint {
			return _color;
		}

		public function set color (value:uint):void {
			_color = value;
			invalidateElement();
		}

		protected var _element:IElement;

		public function set element (value:IElement):void {
			_element = value;
		}

		public function get element ():IElement {
			return _element;
		}

		/*########################################################*/
		/*                                                        */
		/*   CONSTRUCTOR                                          */
		/*                                                        */
		/*########################################################*/

		public function AbstractElementStyle (color:uint=INVISIBLE_COLOR, alpha:Number=INVISIBLE_ALPHA) {
			super(AbstractElementStyle, IElementStyle);
			this._alpha = alpha;
			this._color = color;
		}

		protected function invalidateElement ():void {
			if (_element != null)
				_element.invalidateRendering();
		}

		/**
		 * current implementation doesn't clone element.
		 *
		 * @return cloned IElementStyle
		 */
		public function clone ():IClonable {
			return new clazz(color, alpha);
		}

		public function isVisible ():Boolean {
			return color != INVISIBLE_COLOR && alpha != INVISIBLE_ALPHA;
		}

		public function equals(other:IComparable):Boolean
		{
			if (other == null)
				return false;
			if (this === other)
				return true;
/*			else if (this.element != null.id == -1)
				return false;*/
			else if (!(other is clazz))
				return false;
			else if (IElementStyle(other).color == color && IElementStyle(other).alpha == alpha)
				return true;
/*			else if (getQualifiedClassName(other) == getQualifiedClassName(this) && IElement(other).id == this.id)
				return true;*/
			return false;
		}

	}
}