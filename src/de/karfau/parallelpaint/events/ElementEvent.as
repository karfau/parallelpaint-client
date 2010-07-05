package de.karfau.parallelpaint.events
{
	import de.karfau.parallelpaint.core.elements.IElement;
	
	import flash.events.Event;
	
	public class ElementEvent extends Event
	{
		
		/**
		 * Called to start adding an element.
		 */
		public static const ADD_ELEMENT:String = "addElement";
		/**
		 * Called to start the update of an element
		 */
		public static const UPDATE_ELEMENT:String = "updateElement";
		
		/**
		 * Called to start the removal of an element.
		 */
		public static const REMOVE_ELEMENT:String = "removeElement";
		
		/**
		 * Occures when an element has been successfully added.
		 */
		public static const ELEMENT_ADDED:String = "elementAdded";
		
		/**
		 * Occures after SET_DRAWING has been successfull.
		 */
		public static const ELEMENTS_CHANGED:String = "elementsChanged";
		
		public static const SELECT_ELEMENT:String = "selectElement";
		public static const UNSELECT_ELEMENT:String = "unselectElement";
		/**
		 * Occures if the selected element has been changed.
		 */
		public static const SELECTION_CHANGED:String = "selectionChanged";
		public static const FOREIGN_SELECTION_CHANGED:String = "foreignSelectionChanged";
		
		protected var _element:IElement;
		
		/**
		 * The affected element. it can be null if more then one element is afffected or the effected element has been removed.
		 */
		public function get element ():IElement {
			return _element;
		}
		
		public function ElementEvent (type:String, element:IElement) {
			super(type, false, false);
			_element = element;
		}
		
		override public function clone ():Event {
			return new ElementEvent(type, element);
		}
		
		public override function toString ():String {
			return "ElementEvent{type:" + type + "; element:" + _element + "}";
		}
	
	}
}