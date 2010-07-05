package de.karfau.parallelpaint.view.components.layers
{
	import de.karfau.parallelpaint.core.elements.AbstractStrokedElement;
	import de.karfau.parallelpaint.core.elements.AbstractStrokedFilledElement;
	import de.karfau.parallelpaint.core.elements.ElementUtil;
	import de.karfau.parallelpaint.core.elements.IClonable;
	import de.karfau.parallelpaint.core.elements.IElement;
	import de.karfau.parallelpaint.core.elements.ISelectable;
	import de.karfau.parallelpaint.core.elements.SelectionPoint;
	import de.karfau.parallelpaint.core.tools.DrawElementTool;
	import de.karfau.parallelpaint.core.tools.SelectElementTool;
	import de.karfau.parallelpaint.core.tools.interaction.InteractableView;
	import de.karfau.parallelpaint.core.tools.interaction.Interaction;
	import de.karfau.parallelpaint.events.MouseInteractionEvent;
	import de.karfau.parallelpaint.view.renderer.DraggableElementSprite;
	import de.karfau.parallelpaint.view.renderer.ElementSelectionSprite;
	import de.karfau.parallelpaint.view.renderer.ForeignSelectionElementSprite;
	import de.karfau.parallelpaint.view.renderer.ForeignSelectionLabel;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.events.SandboxMouseEvent;
	
	import org.osflash.signals.Signal;
	
	public class InteractionLayer extends LayerBase implements InteractableView
	{
		
		/*########################################################*/
		/*                                                        */
		/*   PROPERTIES (INCL. SETTER/GETTER)                     */
		/*                                                        */
		/*########################################################*/
		
		private var _foreignSelectionMap:Dictionary = new Dictionary();
		private var _foreignSelections:Vector.<ISelectable> = new Vector.<ISelectable>();
		
		private var _selectionShadow:AbstractStrokedElement;
		
		public function removeForeignSelection (id:Number):void {
			var oldSelectable:ISelectable = getForeignSelection(id);
			if (oldSelectable) {
				_foreignSelections.splice(_foreignSelections.indexOf(oldSelectable), 1);
				removeChild(getForeignSelectionSprite(id));
			}
			invalidateDisplayList();
		}
		
		private function addForeignSelection (selectable:ISelectable):void {
			var oldSelectable:ISelectable = getForeignSelection(selectable.id);
			if (oldSelectable) {
				if (oldSelectable !== selectable) {
					_foreignSelections.splice(_foreignSelections.indexOf(oldSelectable), 1, selectable);
					getForeignSelectionSprite(selectable.id).element = IElement(selectable);
				}
			} else {
				_foreignSelections.push(selectable);
			}
			invalidateDisplayList();
		}
		
		private function getForeignSelection (id:Number):ISelectable {
			for (var i:int = _foreignSelections.length; i--; ) {
				if (_foreignSelections[i].id == id)
					return _foreignSelections[i];
			}
			return null;
		}
		
		private function getForeignSelectionSprite (id:Number):ForeignSelectionElementSprite {
			return _foreignSelectionMap[id] as ForeignSelectionElementSprite;
		}
		
		public function setForeignSelection (value:ISelectable):void {
			if (value.selector)
				addForeignSelection(value);
			else
				removeForeignSelection(value.id);
		}
		
		public function removeAllForeignSelections ():void {
			_foreignSelections = new Vector.<ISelectable>();
			_foreignSelectionMap = new Dictionary();
			clearLayer();
		}
		
		/*===========================*/
		/*   InteractableView        */
		/*===========================*/
		
		private var _interactionElement:IElement;
		
		public function get interactionElement ():IElement {
			return _interactionElement;
		}
		
		public function set interactionElement (value:IElement):void {
			_interactionElement = value;
		}
		
		private var _selectionPoints:Vector.<SelectionPoint>;
		
		public function get selectionPoints ():Vector.<SelectionPoint> {
			return _selectionPoints;
		}
		
		public function set selectionPoints (value:Vector.<SelectionPoint>):void {
			if (_selectionPoints && _selectionPoints.length && interactionElement && interactionElement === _selectionPoints[0].selectable)
				interactionElement = null;
			_selectionPoints = value;
			
			if (value && value.length > 0) {
				interactionElement = /*ElementUtil.cloneWithPosition(*/ IElement(value[0].selectable) /*)*/;
					//FIXME: move all this to DraggableElementSprite and add it in th updDisplList here.
			} else {
				interactionElement = null;
			}
			clearLayer();
		}
		
		private var selectionSpritesAdded:uint = 0;
		
		/*########################################################*/
		/*                                                        */
		/*   CONSTRUCTOR                                          */
		/*                                                        */
		/*########################################################*/
		
		public function InteractionLayer () {
			super();
		}
		
		/*########################################################*/
		/*                                                        */
		/*   OVERRIDE / IMPLEMENT                                 */
		/*                                                        */
		/*########################################################*/
		
		protected override function clearLayer ():void {
			selectionSpritesAdded = 0;
			super.clearLayer();
		}
		
		/**
		 * is extended to keep _foreignSelectionMap in sync
		 * @inheritDoc
		 */
		public override function addChild (child:DisplayObject):DisplayObject {
			var result:DisplayObject = super.addChild(child);
			
			var sprite:ForeignSelectionElementSprite = child as ForeignSelectionElementSprite;
			if (sprite != null) {
				_foreignSelectionMap[sprite.element.id] = sprite;
			}
			
			return result;
		}
		
		/**
		 * is extended to keep _foreignSelectionMap in sync
		 * @inheritDoc
		 */
		public override function removeChild (child:DisplayObject):DisplayObject {
			var result:DisplayObject = super.removeChild(child);
			
			var sprite:ForeignSelectionElementSprite = child as ForeignSelectionElementSprite;
			if (sprite != null) {
				delete _foreignSelectionMap[sprite.element.id];
			}
			
			return result;
		}
		
		override protected function updateDisplayList (unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			graphics.clear();
			if (_foreignSelections) {
				var elementMap:Dictionary = new Dictionary();
				var sprite:ForeignSelectionElementSprite;
				//ensure all elements are displayed
				for each (var element:IElement in _foreignSelections) {
					elementMap[element.id] = element;
					sprite = getForeignSelectionSprite(element.id);
					if (sprite == null)
						this.addChild(new ForeignSelectionElementSprite(element));
					else if (sprite.element !== element)
						sprite.element = element;
				}
				
				//remove all elements that are not there anymore
				for (var elementId:* in _foreignSelectionMap) {
					if (!elementMap[elementId]) {
						removeChild(_foreignSelectionMap[elementId]);
					}
				}
			}
			if (_selectionPoints) {
				if (selectionSpritesAdded != _selectionPoints.length) {
					
					if (selectionSpritesAdded == 0) {
						this.addChild(new DraggableElementSprite(interactionElement));
						for each (var sPoint:SelectionPoint in _selectionPoints) {
							addSelectionSprite(sPoint);
						}
					} else {
						clearLayer(); //remove all eisting and redraw everything
						return;
					}
				}
			} else {
				if (interactionElement) {
					interactionElement.renderOn(graphics);
				}
			}
		}
		
		public function isCapableOf (interaction:Interaction):Boolean {
			return interaction is DrawElementTool || interaction is SelectElementTool;
		}
		
		public function triggerRedraw ():void {
			clearLayer();
		}
		
		/*########################################################*/
		/*                                                        */
		/*  PRIVATE HELPER/UTIL                                   */
		/*                                                        */
		/*########################################################*/
		
		/*public function getEventPoint (event:MouseEvent, local:Boolean=false):Point {
			 var result:Point = new Point(event.stageX, event.stageY);
			 if (local)
			 result = new Point(event.localX, event.localY);
			 return result;
		 }*/
		
		private function addSelectionSprite (point:SelectionPoint):void {
			this.addChild(new ElementSelectionSprite(point));
			selectionSpritesAdded++;
		}
	}
}