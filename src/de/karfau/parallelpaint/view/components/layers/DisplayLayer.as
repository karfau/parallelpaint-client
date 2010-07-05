package de.karfau.parallelpaint.view.components.layers
{
	import de.karfau.flexlogplus.error;
	import de.karfau.parallelpaint.core.elements.IElement;
	import de.karfau.parallelpaint.view.renderer.ElementSprite;
	
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	
	public class DisplayLayer extends LayerBase
	{
		
		/*########################################################*/
		/*                                                        */
		/*   PROPERTIES (INCL. SETTER/GETTER)                     */
		/*                                                        */
		/*########################################################*/
		
		private var _elements:Vector.<IElement> = new Vector.<IElement>();
		
		public function set elements (value:ArrayCollection):void {
			_elements = new Vector.<IElement>();
			for each (var element:IElement in value) {
				if (element == null)
					error(this, ".set elements({0}) recieved a null element", value);
				else
					addDrawingElement(element);
			}
			//make sure we redraw even if there is no element
			clearLayer();
		
		}
		
		private var elementSpriteMap:Dictionary = new Dictionary();
		
		/*########################################################*/
		/*                                                        */
		/*   OVERRIDE / IMPLEMENT                                 */
		/*                                                        */
		/*########################################################*/
		
		/**
		 * is extended to keep elementSpriteMap in sync
		 * @inheritDoc
		 */
		public override function addChild (child:DisplayObject):DisplayObject {
			var result:DisplayObject = super.addChild(child);
			
			var sprite:ElementSprite = child as ElementSprite;
			if (sprite != null) {
				elementSpriteMap[sprite.element.id] = sprite;
			}
			
			return result;
		}
		
		/**
		 * is extended to keep elementSpriteMap in sync
		 * @inheritDoc
		 */
		public override function removeChild (child:DisplayObject):DisplayObject {
			var result:DisplayObject = super.removeChild(child);
			
			var sprite:ElementSprite = child as ElementSprite;
			if (sprite != null) {
				delete elementSpriteMap[sprite.element.id];
			}
			
			return result;
		}
		
		override protected function updateDisplayList (unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			var elementMap:Dictionary = new Dictionary();
			//ensure all elements are displayed
			for each (var element:IElement in _elements) {
				elementMap[element.id] = element;
				if (!elementSpriteMap[element.id])
					this.addChild(new ElementSprite(element));
			}
			
			//remove all elements that are not there anymore
			for (var elementId:* in elementSpriteMap) {
				if (!elementMap[elementId]) {
					removeChild(elementSpriteMap[elementId]);
				}
			}
		}
		
		public function addDrawingElement (element:IElement):void {
			var existingIndex:int = indexOf(element);
			if (existingIndex > -1)
				throw new VerifyError("element with id " + element.id + " already exists.");
			else {
				_elements.push(element);
				invalidateDisplayList();
			}
		}
		
		public function updateElement (element:IElement):void {
			var existingIndex:int = indexOf(element);
			if (existingIndex == -1)
				addDrawingElement(element);
			else {
				_elements.splice(existingIndex, 1, element);
				if (elementSpriteMap[element.id])
					removeChild(elementSpriteMap[element.id]);
				//graphics.clear();
				invalidateDisplayList();
			}
		}
		
		public function removeDrawingElement (elementId:Number):void {
			for (var i:int = _elements.length; i--; ) {
				if (_elements[i].id == elementId) {
					_elements.splice(i, 1);
					if (elementSpriteMap[elementId])
						removeChild(elementSpriteMap[elementId]);
					invalidateDisplayList();
					break;
				}
			}
		}
		
		public function getElementUnderPoint (stageX:Number, stageY:Number):IElement {
			if (hitTestPoint(stageX, stageY, true)) {
				var result:IElement;
				var children:Array = this.getChildren();
				var elSprite:ElementSprite;
				for (var i:int = children.length; i--; ) {
					if (children[i] is ElementSprite) {
						elSprite = ElementSprite(children[i]);
						if (elSprite.hitTestPoint(stageX, stageY, true)) {
							result = elSprite.element;
							break;
						}
					}
				}
				return result;
			}
			return null;
		}
		
		/*########################################################*/
		/*                                                        */
		/*  PRIVATE HELPER/UTIL                                   */
		/*                                                        */
		/*########################################################*/
		
		private function indexOf (element:IElement):int {
			var i:int;
			for (i = _elements.length; i--; ) {
				if (_elements[i].equals(element))
					break;
			}
			return i;
		}
	}
}