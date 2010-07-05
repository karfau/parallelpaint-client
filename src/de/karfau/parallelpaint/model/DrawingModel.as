package de.karfau.parallelpaint.model
{
	import de.karfau.flexlogplus.verbose;
	import de.karfau.parallelpaint.core.elements.IElement;
	import de.karfau.parallelpaint.core.elements.ISelectable;
	import de.karfau.parallelpaint.events.DrawingEvent;
	import de.karfau.parallelpaint.events.ElementEvent;
	import de.karfau.parallelpaint.events.ElementIdEvent;
	import de.karfau.parallelpaint.model.vo.Drawing;
	import de.karfau.parallelpaint.model.vo.ElementVO;
	import de.karfau.parallelpaint.model.vo.User;
	import de.karfau.parallelpaint.service.definition.NavigationService;
	
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	
	import org.robotlegs.mvcs.Actor;
	
	/**
	 *
	 * @author Karfau
	 */
	public class DrawingModel extends Actor
	{
		
		/*########################################################*/
		/*                                                        */
		/*   PROPERTIES (INCL. SETTER/GETTER)                     */
		/*                                                        */
		/*########################################################*/
		
		[Inject]
		public var converter:TransferFactory;
		
		[Inject]
		public var sNavigation:NavigationService;
		
		/*[Inject]
		 public var mUser:UserModel;*/
		
		private var _drawing:Drawing;
		
		public function get drawingId ():Number {
			return _drawing == null ? -1 : _drawing.id;
		}
		
		public function get drawingAuthor ():String {
			if (_drawing == null)
				throw new ReferenceError("drawing is not set when requesting author");
			return _drawing.author;
		}
		
		public function get drawingVersionOf ():Number {
			return _drawing == null ? -1 : _drawing.versionOf;
		}
		
		public function get drawingVersionTag ():String {
			return _drawing == null ? null : _drawing.versionTag;
		}
		
		/**
		 * DON'T SET THIS DIRECTLY. Use DrawingEvent.SET_DRAWING instead to ensure the toolAccessLevels are updated.
		 * @param value
		 */
		public function set drawing (value:Drawing):void {
			drawingLoaded = false;
			_drawing = value;
			elements = null; //dispatches ElementEvent.ELEMENTS_CHANGED
			var distributedId:int = value ? value.id : -1;
			sNavigation.setActiveDrawingID(distributedId);
			dispatch(new DrawingEvent(DrawingEvent.DRAWING_CHANGED, distributedId));
		}
		
		//[Bindable]
		//[ArrayElementType("de.karfau.parallelpaint.core.elements.IElement")]
		private var _elements:ArrayCollection = new ArrayCollection();
		private var drawingLoaded:Boolean = false;
		
		/**
		 *
		 * @return
		 */
		public function get elements ():ArrayCollection {
			if (_drawing && _drawing.elements && !drawingLoaded) {
				var result:Array = [];
				for each (var vo:ElementVO in _drawing.elements) {
					result.push(converter.createElementFromVo(vo));
				}
				drawingLoaded = true;
				elements = new ArrayCollection(result);
			}
			return _elements;
		}
		
		public function set elements (value:ArrayCollection):void {
			selectedElement = null;
			_elements = value != null ? value : new ArrayCollection();
			dispatch(new ElementEvent(ElementEvent.ELEMENTS_CHANGED, null));
		}
		
		private var _selectedElementId:Number = -1;
		
		public function get selectedElement ():ISelectable {
			return _drawing != null && _selectedElementId > 0 ? getElementById(_selectedElementId) : null;
		}
		
		/**
		 * Setting this dispatches ElementEvent.SELECTION_CHANGED
		 * @param value
		 */
		public function set selectedElement (value:ISelectable):void {
			var newId:Number = value == null ? -1 : value.id;
			if (_selectedElementId != newId || selectedElement !== value) {
				/*if (_selectedElement != null) {
					 _selectedElement.selector = null;
					 }
					 if (value != null)
				 value.selector = mUser.currentUser;*/
				_selectedElementId = newId;
				dispatch(new ElementEvent(ElementEvent.SELECTION_CHANGED, IElement(selectedElement)));
			}
		}
		
		/*########################################################*/
		/*                                                        */
		/*   OVERRIDE / IMPLEMENT                                 */
		/*                                                        */
		/*########################################################*/
		
		/**
		 *
		 * @param element
		 * @throws VerifyError if the element already exists
		 */
		public function addElement (element:IElement):void {
			if (getElementById(element.id) != null)
				throw new VerifyError("element with id " + element.id + " already exists.");
			_elements.addItem(element);
			dispatch(new ElementEvent(ElementEvent.ELEMENT_ADDED, element));
		}
		
		/**
		 *
		 * @param element
		 * @throws VerifyError if the element could not be found
		 */
		public function updateElement (element:IElement):void {
			var oldElement:IElement = getElementById(element.id);
			if (oldElement == null)
				throw new VerifyError("element with id " + element.id + " doesn't exists.");
			if (oldElement !== element) {
				var index:uint = _elements.getItemIndex(oldElement);
				_elements.removeItemAt(index);
				element.selector = oldElement.selector;
				_elements.addItemAt(element, index);
			}
			dispatch(new ElementEvent(ElementEvent.ELEMENTS_CHANGED, element));
		}
		
		public function removeSelectedElement ():void {
			if (selectedElement != null)
				removeElement(IElement(selectedElement));
		}
		
		public function removeElement (element:IElement=null):void {
			var oldElement:IElement = getElementById(element.id);
			if (oldElement == null)
				throw new VerifyError("element with id " + element.id + " doesn't exists.");
			var index:uint = _elements.getItemIndex(oldElement);
			
			if (index > -1) {
				//unselect before removing
				//FIXME: this has to be done by command, verify that element.selector is null belongs here
				if (oldElement === selectedElement)
					selectedElement = null;
				
				//remove
				_elements.removeItemAt(index);
				/*var evo:ElementVO;
					 for (var i:int = drawing.elements.length; i--; ) {
					 if (ElementVO(drawing.elements.getItemAt(i)).id == element.id) {
					 drawing.elements.removeItemAt(i);
					 break;
					 }
				 }*/
				dispatch(new ElementIdEvent(ElementIdEvent.ELEMENT_REMOVED, element.id));
				
			}
		
		}
		
		protected override function dispatch (event:Event):Boolean {
			verbose(this, ".dispatch({0}) ", event);
			return super.dispatch(event);
		}
		
		/**
		 *
		 * @param elementId
		 * @return
		 * @throws VerifyError if drawing is not set.
		 */
		public function getElementById (elementId:Number):IElement {
			if (_drawing == null)
				throw new ReferenceError("drawing is not set when searching for element with id " + elementId);
			
			for each (var element:IElement in elements) {
				if (element.id == elementId)
					return element;
			}
			return null;
		}
	}
}