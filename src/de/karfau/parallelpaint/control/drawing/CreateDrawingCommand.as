package de.karfau.parallelpaint.control.drawing
{
	import de.karfau.flexlogplus.*;
	import de.karfau.parallelpaint.events.DrawingEvent;
	import de.karfau.parallelpaint.model.DrawingModel;
	import de.karfau.parallelpaint.model.UserModel;
	import de.karfau.parallelpaint.model.vo.Drawing;
	import de.karfau.parallelpaint.service.definition.ElementPersistanceService;
	
	import org.robotlegs.mvcs.Command;
	
	public class CreateDrawingCommand extends Command
	{
		
		/*########################################################*/
		/*                                                        */
		/*   PROPERTIES (INCL. SETTER/GETTER)                     */
		/*                                                        */
		/*########################################################*/
		
		[Inject]
		public var event:DrawingEvent;
		
		[Inject]
		public var mDrawing:DrawingModel;
		
		[Inject]
		public var mUser:UserModel;
		
		[Inject]
		public var sPersistance:ElementPersistanceService;
		
		/*########################################################*/
		/*                                                        */
		/*   OVERRIDE / IMPLEMENT                                 */
		/*                                                        */
		/*########################################################*/
		
		override public function execute ():void {
			debug(this, ".execute( ) ");
			sPersistance.createDrawing().setOnResult(createDrawingResult).setOnFault(handleFault);
		}
		
		private function createDrawingResult (drawing:Drawing):void {
			verbose(this, ".createDrawingResult({0}) ", drawing);
			mUser.persistAuthorKey(drawing);
			dispatch(new DrawingEvent(DrawingEvent.SET_DRAWING, drawing));
		}
		
		private function handleFault (error:Error):void {
			throw error;
		}
	}
}