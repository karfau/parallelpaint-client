package de.karfau.parallelpaint.control
{
	import de.karfau.flexlogplus.*;
	import de.karfau.parallelpaint.core.elements.IElement;
	import de.karfau.parallelpaint.events.ElementEvent;
	import de.karfau.parallelpaint.model.DrawingModel;
	
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import org.robotlegs.mvcs.Command;
	
	public class KeyDownCommand extends Command
	{
		
		/*########################################################*/
		/*                                                        */
		/*   PROPERTIES (INCL. SETTER/GETTER)                     */
		/*                                                        */
		/*########################################################*/
		
		[Inject]
		public var event:KeyboardEvent;
		
		[Inject]
		public var mDrawing:DrawingModel;
		
		/*########################################################*/
		/*                                                        */
		/*   OVERRIDE / IMPLEMENT                                 */
		/*                                                        */
		/*########################################################*/
		
		override public function execute ():void {
			verbose(this, ".execute( ) with keyCode {0}", event.keyCode);
			switch (event.keyCode) {
				case Keyboard.DELETE:
					dispatch(new ElementEvent(ElementEvent.REMOVE_ELEMENT, null));
			}
		}
	}
}