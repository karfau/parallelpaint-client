package de.karfau.parallelpaint.core.elements
{
	import flash.geom.Point;
	
	public class SelectionPoint
	{
		
		/*########################################################*/
		/*                                                        */
		/*   PROPERTIES (INCL. SETTER/GETTER)                     */
		/*                                                        */
		/*########################################################*/
		
		private var _anchor:Point;
		
		public function get anchor ():Point {
			return _anchor;
		}
		
		public function set anchor (value:Point):void {
			_anchor = value;
		}
		
		private var _location:Point;
		
		public function get location ():Point {
			return _location;
		}
		
		public function set location (value:Point):void {
			_location = value;
		}
		
		private var _selectable:ISelectable;
		
		public function get selectable ():ISelectable {
			return _selectable;
		}
		
		/*########################################################*/
		/*                                                        */
		/*   CONSTRUCTOR                                          */
		/*                                                        */
		/*########################################################*/
		
		public function SelectionPoint (selectable:ISelectable, location:Point, anchor:Point=null) {
			_selectable = selectable;
			this.location = location;
			this.anchor = anchor == null ? location : anchor;
		}
	}
}