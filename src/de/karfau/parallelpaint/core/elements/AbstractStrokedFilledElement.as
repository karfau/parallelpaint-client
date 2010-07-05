package de.karfau.parallelpaint.core.elements
{
	import de.karfau.flexlogplus.*;
	import de.karfau.parallelpaint.core.elements.style.Fill;
	import de.karfau.parallelpaint.core.elements.style.IFillStyle;
	import de.karfau.parallelpaint.core.elements.style.IStrokeStyle;
	
	import flash.display.Graphics;
	import flash.geom.Point;
	
	public class AbstractStrokedFilledElement extends AbstractStrokedElement //implements IFilledElement
	{
		
		/*########################################################*/
		/*                                                        */
		/*   PROPERTIES (INCL. SETTER/GETTER)                     */
		/*                                                        */
		/*########################################################*/
		
		private var _fill:IFillStyle = new Fill(); //this ensures, that the setter is called even if constructed with null
		
		public function get fill ():IFillStyle {
			return _fill;
		}
		
		public function set fill (value:IFillStyle):void {
			_fill = value != null ? value : new Fill();
			_fill.element = IFilledElement(this);
			invalidateRendering();
		}
		
		/*public function get selectionPoints():Vector.<SelectionPoint>
			 {
			 return null;
		 }*/
		
		override public function clone ():IClonable {
			var result:IFilledElement = IFilledElement(super.clone());
			if (this.fill) {
				result.fill = IFillStyle(fill.clone());
				result.fill.element = result;
			}
			verbose(this, "was cloned to {0}", result);
			return result;
		}
		
		override public function renderOn (graphics:Graphics):void {
			ludicrous(this, ".renderOn( ) ");
			fill.beginRenderStyle(graphics);
			super.renderOn(graphics);
			fill.endRenderStyle(graphics);
		}
		
		override public function renderShadow (graphics:Graphics, alpha:Number=0.5, color:int=-1, alphaAsFactor:Boolean=true):void {
			var shadowFill:IFillStyle = IFillStyle(fill.clone());
			shadowFill.alpha = alphaAsFactor ? fill.alpha * alpha : alpha;
			if (color > -1)
				shadowFill.color = color;
			shadowFill.beginRenderStyle(graphics);
			super.renderShadow(graphics, alpha, color);
			shadowFill.endRenderStyle(graphics);
		}
		
		public override function toString ():String {
			return clazz + "{# " + id + ", points:" + points + ", stroke:" + stroke + ", fill:" + _fill + "}";
		}
		
		/*########################################################*/
		/*                                                        */
		/*   CONSTRUCTOR                                          */
		/*                                                        */
		/*########################################################*/
		
		public function AbstractStrokedFilledElement (firstPoint:Point=null, initialStroke:IStrokeStyle=null, initialFill:IFillStyle=null) {
			abstract::verifyImplementation(AbstractStrokedFilledElement, IFilledElement);
			abstract::verified = false; //enables verification in superclass
			
			super(firstPoint, initialStroke);
			this.fill = initialFill;
		}
	}
}