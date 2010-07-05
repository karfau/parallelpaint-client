package de.karfau.parallelpaint.control.drawing
{
	import de.karfau.parallelpaint.control.AbstractCommand;
	import de.karfau.parallelpaint.events.DisplayMessageEvent;
	import de.karfau.parallelpaint.events.StringEvent;
	import de.karfau.parallelpaint.model.DrawingModel;
	import de.karfau.parallelpaint.service.definition.ElementPersistanceService;

	import org.robotlegs.mvcs.Command;

	public class TakeSnapshotCommand extends AbstractCommand
	{

		[Inject]
		public var mDrawing:DrawingModel;

		[Inject]
		public var event:StringEvent;

		[Inject]
		public var sPersiatance:ElementPersistanceService;


		public override function execute():void
		{
			if(mDrawing.drawingId>0)//TODO: limit to drawings that are not a snapshot
			sPersiatance.createVersionOfDrawing(mDrawing.drawingId,event.data).setOnResult(executeResult).setOnFault(handleFault);
		}

		private function executeResult(snapshotId:Number):void {
			dispatch(DisplayMessageEvent.createColoredMessageEvent(DisplayMessageEvent.SNAPSHOT_DONE,
				"Successfully taken snapshot with id " +snapshotId+	" for drawing with id " +mDrawing.drawingId,0x00FF00));
		}


	}
}