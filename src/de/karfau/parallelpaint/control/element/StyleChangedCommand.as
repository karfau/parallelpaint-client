package de.karfau.parallelpaint.control.element
{
	import de.karfau.flexlogplus.*;
	import de.karfau.parallelpaint.core.elements.ElementUtil;
	import de.karfau.parallelpaint.core.elements.IFilledElement;
	import de.karfau.parallelpaint.core.elements.IStrokedElement;
	import de.karfau.parallelpaint.core.elements.style.IFillStyle;
	import de.karfau.parallelpaint.core.elements.style.IStrokeStyle;
	import de.karfau.parallelpaint.core.tools.DrawElementTool;
	import de.karfau.parallelpaint.events.ElementEvent;
	import de.karfau.parallelpaint.events.ElementStyleEvent;
	import de.karfau.parallelpaint.model.DrawingModel;
	import de.karfau.parallelpaint.model.InteractionModel;

	import org.robotlegs.mvcs.Command;

	public class StyleChangedCommand extends Command
	{

		/*########################################################*/
		/*                                                        */
		/*   PROPERTIES (INCL. SETTER/GETTER)                     */
		/*                                                        */
		/*########################################################*/

		[Inject]
		public var mDrawing:DrawingModel;

		[Inject]
		public var event:ElementStyleEvent;

		[Inject]
		public var mInteraction:InteractionModel;

		/*########################################################*/
		/*                                                        */
		/*   OVERRIDE / IMPLEMENT                                 */
		/*                                                        */
		/*########################################################*/

		override public function execute ():void {
			debug(this, ".execute( ) ");
			var affectedElement:IStrokedElement = IStrokedElement(ElementUtil.cloneWithPosition(mInteraction.styledInteractionElement));
			switch (event.type) {
				case ElementStyleEvent.CHANGE_STROKE_STYLE:
					if (affectedElement)
						affectedElement.stroke = IStrokeStyle(event.style);
					break;
				case ElementStyleEvent.CHANGE_FILL_STYLE:
					if (affectedElement && affectedElement is IFilledElement)
						IFilledElement(affectedElement).fill = IFillStyle(event.style);
					break;
			}
			if (affectedElement.isValid())
				dispatch(new ElementEvent(ElementEvent.UPDATE_ELEMENT, affectedElement));
		}
	}
}