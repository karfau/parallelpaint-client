package de.karfau.parallelpaint.model.xml
{
	import de.karfau.parallelpaint.core.elements.IElement;
	import de.karfau.parallelpaint.core.elements.IFilledElement;
	import de.karfau.parallelpaint.core.elements.IStrokedElement;
	import de.karfau.parallelpaint.core.elements.style.IElementStyle;
	import de.karfau.parallelpaint.core.elements.style.IFillStyle;
	import de.karfau.parallelpaint.core.elements.style.IStrokeStyle;
	
	public class StyleContainer
	{
		public function StyleContainer (element:IElement=null) {
			if (element is IStrokedElement)
				styles.push(IStrokedElement(element).stroke);
			if (element is IFilledElement)
				styles.push(IFilledElement(element).fill);
		}
		
		public function applyStylesTo (element:IElement):void {
			for each (var style:IElementStyle in styles) {
				if (style is IStrokeStyle) {
					if (element is IStrokedElement) {
						IStrokedElement(element).stroke = IStrokeStyle(style);
					} else {
						throw new VerifyError("StyleContainer.applyStylesTo(element): container has IStrokeStyle " + style + " but element is not an IStrokedElement " + element);
					}
				} else if (style is IFillStyle) {
					if (element is IFilledElement) {
						IFilledElement(element).fill = IFillStyle(style);
					} else {
						throw new VerifyError("StyleContainer.applyStylesTo(element): container has IFillStyle " + style + " but element is not an IFilledElement " + element);
					}
				}
			}
		}
		
		public var styles:Array = [];
	}
}