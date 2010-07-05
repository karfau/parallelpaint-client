package de.karfau.parallelpaint.core.elements
{
	import de.karfau.flexlogplus.verbose;
	import de.karfau.parallelpaint.core.elements.style.IStrokeStyle;
	import de.karfau.parallelpaint.core.elements.style.Stroke;
	
	import flash.display.Graphics;
	import flash.geom.Point;
	
	[Bindable]
	public class AbstractStrokedElement extends AbstractElement // implements IStrokedElement
	{
		
		/*########################################################*/
		/*                                                        */
		/*   PROPERTIES (INCL. SETTER/GETTER)                     */
		/*                                                        */
		/*########################################################*/
		
		private var _stroke:IStrokeStyle = new Stroke(); //this ensures, that the setter is called even if constructed with null
		
		public function get stroke ():IStrokeStyle {
			return _stroke;
		}
		
		public function set stroke (value:IStrokeStyle):void {
			_stroke = value != null ? value : new Stroke();
			_stroke.element = IStrokedElement(this);
			invalidateRendering();
		}
		
		/*########################################################*/
		/*                                                        */
		/*   CONSTRUCTOR                                          */
		/*                                                        */
		/*########################################################*/
		
		public function AbstractStrokedElement (firstPoint:Point=null, initialStroke:IStrokeStyle=null) {
			abstract::verifyImplementation(AbstractStrokedElement, IStrokedElement);
			
			super(firstPoint);
			this.stroke = initialStroke;
		}
		
		/*########################################################*/
		/*                                                        */
		/*   OVERRIDE / IMPLEMENT                                 */
		/*                                                        */
		/*########################################################*/
		
		public function renderOn (graphics:Graphics):void {
			stroke.beginRenderStyle(graphics);
			styledRendering(graphics)
			stroke.endRenderStyle(graphics);
		}
		
		protected function styledRendering (graphics:Graphics):void {
		
		}
		
		public function renderShadow (graphics:Graphics, alpha:Number=0.5, color:int=-1, alphaAsFactor:Boolean=true):void {
			var shadowStroke:IStrokeStyle = IStrokeStyle(stroke.clone());
			shadowStroke.alpha = alphaAsFactor ? stroke.alpha * alpha : alpha;
			if (color > -1)
				shadowStroke.color = color;
			shadowStroke.beginRenderStyle(graphics);
			styledRendering(graphics)
			shadowStroke.endRenderStyle(graphics);
		}
		
		/**
		 * The current implementation doesn't clone the position!
		 *
		 * @return cloned IStrokedElement
		 */
		override public function clone ():IClonable {
			var result:IStrokedElement = IStrokedElement(super.clone());
			if (this.stroke != null) {
				result.stroke = IStrokeStyle(this.stroke.clone());
				result.stroke.element = result;
			}
			verbose(this, "was cloned to {0}", result);
			return result;
		}
		
		public function toString ():String {
			return clazz + "{# " + id + ", points:" + points + ", stroke:" + _stroke + "}";
		}
	}
}