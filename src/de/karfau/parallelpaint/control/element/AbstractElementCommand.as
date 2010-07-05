package de.karfau.parallelpaint.control.element
{
	import de.karfau.parallelpaint.control.AbstractCommand;
	import de.karfau.parallelpaint.core.elements.IElement;
	import de.karfau.parallelpaint.events.ElementEvent;
	import de.karfau.parallelpaint.model.DrawingModel;
	
	public class AbstractElementCommand extends AbstractCommand
	{
		
		[Inject]
		public var mDrawing:DrawingModel;
		
		[Inject]
		public var event:ElementEvent;
		
		public function get element ():IElement {
			return event.element;
		}
	}
}