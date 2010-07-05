package de.karfau.parallelpaint.events
{
	import de.karfau.parallelpaint.model.vo.Drawing;
	
	import flash.events.Event;
	
	import org.spicefactory.lib.errors.IllegalArgumentError;
	
	/**
	 *
	 * @author Karfau
	 */
	public class DrawingEvent extends Event
	{
		/**
		 * Invokes SetDrawingCommand wich works synchronously if the event is given a drawing.
		 * @default
		 */
		public static const SET_DRAWING:String = "setDrawing";
		/**
		 * Invoked when the currently active drawing has changed.
		 * This will be dispatched after ElementEvent.ELEMENTS_CHANGED that occures for the same reason
		 * @default
		 */
		public static const DRAWING_CHANGED:String = "drawingChanged";
		
		/**
		 * Invoke this to create a new Drawing.
		 * @default
		 */
		public static const CREATE_DRAWING:String = "createDrawing";
		
		private static const NULL_DRAWING:Drawing = new Drawing();
		
		private var _drawingOrId:Object = null;
		
		/**
		 *
		 * @param type
		 * @param drawingOrId the affected drawing represented through the drawing itself or its id.
		 * If this is only an id the Command can only work async, because it has to recieve the drawing from the ElementPersistanceService.
		 * @throws IllegalArgumentError if drawingOrId is not of type Drawing or Number(a drawingId)
		 */
		public function DrawingEvent (type:String, drawingOrId:Object=-1) {
			super(type);
			if (drawingOrId is Drawing || drawingOrId is Number)
				_drawingOrId = drawingOrId;
			else
				throw new IllegalArgumentError("drawingOrId has to be a Drawing or a Number but was <" + drawingOrId + ">");
		}
		
		/**
		 * The drawing if the event was created with the instance, null if the Event was created with an id.
		 */
		public function get drawing ():Drawing {
			return isDrawingPresent() ? Drawing(_drawingOrId) : null;
		}
		
		/**
		 * The id of the affected drawing.
		 */
		public function get drawingId ():Number {
			return drawing ? drawing.id : Number(_drawingOrId);
		}
		
		public function isDrawingPresent ():Boolean {
			return _drawingOrId is Drawing;
		}
		
		override public function clone ():Event {
			return new DrawingEvent(type, isDrawingPresent() ? drawing : drawingId);
		}
	
	}
}