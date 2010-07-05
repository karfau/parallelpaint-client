package de.karfau.parallelpaint.view.renderer
{
	import assets.img.com.yusukekamiyamane.p.FugueIcons;
	
	import de.karfau.flexlogplus.*;
	import de.karfau.parallelpaint.core.elements.AbstractElement;
	import de.karfau.parallelpaint.core.elements.IElement;
	
	import flash.events.MouseEvent;
	
	public class ForeignSelectionElementSprite extends ElementSprite
	{
		
		/*########################################################*/
		/*                                                        */
		/*   PROPERTIES (INCL. SETTER/GETTER)                     */
		/*                                                        */
		/*########################################################*/
		
		private var cursorOverId:int = -1;
		
		private var label:ForeignSelectionLabel;
		
		/*########################################################*/
		/*                                                        */
		/*   CONSTRUCTOR                                          */
		/*                                                        */
		/*########################################################*/
		
		public function ForeignSelectionElementSprite (element:IElement) {
			super(element);
			this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			this.height = 100;
			this.percentWidth = 100;
			
			this.label = new ForeignSelectionLabel();
			label.selectable = element;
			this.addElement(label);
			this.invalidateSize();
			this.invalidateDisplayList();
		}
		
		/*########################################################*/
		/*                                                        */
		/*   OVERRIDE / IMPLEMENT                                 */
		/*                                                        */
		/*########################################################*/
		
		protected override function updateDisplayList (unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			ludicrous(this, ".updateDisplayList(...) drawing {0}, size is {1}", element, [width, height]);
			graphics.clear();
			if (_element) {
				label.update();
				_element.renderShadow(graphics, 0.2, 0x0000FF, false);
				this.toolTip = _element.selector;
			}
		}
		
		/*########################################################*/
		/*                                                        */
		/*   EVENT-HANDLER                                        */
		/*                                                        */
		/*########################################################*/
		
		private function onMouseOut (event:MouseEvent):void {
			verbose(this, ".onMouseOut({0}) ", event);
			displayCursor(false);
		}
		
		private function onMouseOver (event:MouseEvent):void {
			verbose(this, ".onMouseOver({0}) ", event);
			displayCursor(true);
		}
		
		/*########################################################*/
		/*                                                        */
		/*  PRIVATE HELPER/UTIL                                   */
		/*                                                        */
		/*########################################################*/
		
		private function displayCursor (show:Boolean):void {
			if (show) {
				if (cursorOverId == -1)
					cursorOverId = cursorManager.setCursor(FugueIcons.foreignSelection, 2, -8, -8);
			} else {
				if (cursorOverId != -1) {
					cursorManager.removeCursor(cursorOverId);
					cursorOverId = -1;
				}
			}
		}
	}
}