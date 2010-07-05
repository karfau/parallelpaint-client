package de.karfau.parallelpaint.events
{
	import de.karfau.parallelpaint.core.elements.style.IElementStyle;
	
	import flash.events.Event;
	
	public class ElementStyleEvent extends Event
	{
		
		public static const CHANGE_STROKE_STYLE:String = "changeStrokeStyle";
		public static const CHANGE_FILL_STYLE:String = "changeFillStyle";
		
		private var _style:IElementStyle;
		
		public function get style ():IElementStyle {
			return _style;
		}
		
		public function ElementStyleEvent (type:String, style:IElementStyle) {
			super(type);
			this._style = style;
		}
		
		override public function clone ():Event {
			return new ElementStyleEvent(type, _style);
		}
		
		public override function toString ():String {
			return "ElementStyleEvent{type:" + type + "; style:" + _style + "}";
		}
	
	}
}