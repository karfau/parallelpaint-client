package de.karfau.parallelpaint.control.drawing
{
	import de.karfau.flexlogplus.*;
	import de.karfau.parallelpaint.events.AuthenticationEvent;
	import de.karfau.parallelpaint.events.DrawingEvent;
	import de.karfau.parallelpaint.messaging.MessagingProxy;
	import de.karfau.parallelpaint.model.DrawingModel;
	import de.karfau.parallelpaint.model.vo.Drawing;
	import de.karfau.parallelpaint.service.definition.ElementPersistanceService;
	import de.karfau.parallelpaint.service.definition.NavigationService;
	
	import org.robotlegs.mvcs.Command;
	
	public class SetDrawingCommand extends Command
	{
		[Inject]
		public var event:DrawingEvent;
		
		private var drawingId:Number;
		
		[Inject]
		public var mDrawing:DrawingModel;
		
		[Inject]
		public var sNavigation:NavigationService;
		
		[Inject]
		public var sPersistance:ElementPersistanceService;
		
		[Inject]
		public var messagingProxy:MessagingProxy;
		
		public override function execute ():void {
			if (event.isDrawingPresent()) {
				debug(this, ".execute( ) recieved drawing {0} ", event.drawing);
				applyDrawing(event.drawing);
			} else {
				drawingId = event.drawingId;
				debug(this, ".execute( ) recieved drawingId {0} ", drawingId);
				if (drawingId <= 0) {
					drawingId = sNavigation.getActiveDrawingID();
					verbose(this, ".execute( ) detected drawingId {0} through NavigationService", drawingId);
				}
				if (drawingId > 0) {
					findDrawingById(drawingId);
				} else {
					applyDrawing(null);
				}
			}
		}
		
		private function findDrawingById (drawingId:Number):void {
			debug(this, ".findDrawingById({0}) ", drawingId);
			sPersistance.findDrawingById(drawingId).setOnFault(handleFault).setOnResult(applyDrawing);
		}
		
		private function applyDrawing (drawing:Drawing):void {
			debug(this, ".applyDrawing({0}) ", drawing);
			
			//remove subscription
			if (mDrawing.drawingId)
				messagingProxy.removeDrawingSubscription(mDrawing.drawingId);
			
			mDrawing.drawing = drawing;
			
			if (drawing) {
				messagingProxy.addDrawingSubscription(drawing.id);
					//messagingProxy.sendMessage(MessagingProxy.createASyncMessage("Hello Messaging: Working on drawing with id " + drawing.id, "test"), drawing.idString());
			}
			dispatch(new AuthenticationEvent(AuthenticationEvent.UPDATE_TOOL_ACCESS));
		}
		
		private function handleFault (error:Error):void {
			throw error;
		}
	}
}