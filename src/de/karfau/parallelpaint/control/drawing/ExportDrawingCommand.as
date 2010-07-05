package de.karfau.parallelpaint.control.drawing
{
	import de.karfau.flexlogplus.error;
	import de.karfau.parallelpaint.core.ColoredDisplayMessage;
	import de.karfau.parallelpaint.events.DisplayMessageEvent;
	import de.karfau.parallelpaint.events.ExportEvent;
	import de.karfau.parallelpaint.model.DrawingModel;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.FileReference;
	import flash.sampler.NewObjectSample;
	
	import org.robotlegs.mvcs.Command;
	
	public class ExportDrawingCommand extends Command
	{
		[Inject]
		public var event:ExportEvent;
		
		[Inject]
		public var mDrawing:DrawingModel;
		
		private var fileRef:FileReference = new FileReference();
		private var progress:String = "";
		private var filename:String = "...";
		private const SAVING_FILE:String = "saving file "
		
		public override function execute ():void {
			var data:Object = null;
			if (event.isBinary() && event.bitmapData != null) {
				data = event.bitmapData;
			} else {
				switch (event.format) {
					default:
						throw new Error("format '" + event.format + "' is not implemented.");
				}
			}
			
			if (data != null) {
				var defaultname:String = "pp_drawing_" + mDrawing.drawingId + "." + event.format.toLowerCase();
				
				fileRef.addEventListener(Event.CANCEL, onDone);
				fileRef.addEventListener(Event.COMPLETE, onDone);
				fileRef.addEventListener(IOErrorEvent.IO_ERROR, onError);
				fileRef.addEventListener(ProgressEvent.PROGRESS, onProgress);
				fileRef.addEventListener(Event.SELECT, onSelect);
				onProgress(null);
				fileRef.save(data, defaultname);
			} else {
				error(this, ".execute( ) data to save was null for event {0}", event);
			}
		}
		
		private function onSelect (event:Event):void {
			filename = fileRef.name;
		}
		
		private function onError (event:IOErrorEvent):void {
			dispatch(DisplayMessageEvent.createErrorMessageEvent(DisplayMessageEvent.EXPORT_ERROR, "error " + SAVING_FILE));
		}
		
		private function onProgress (event:Event):void {
			progress += ".";
			dispatch(DisplayMessageEvent.createColoredMessageEvent(DisplayMessageEvent.EXPORT_STATUS,
																														 SAVING_FILE + filename + progress));
		}
		
		private function onDone (event:Event):void {
			dispatch(DisplayMessageEvent.createColoredMessageEvent(DisplayMessageEvent.EXPORT_DONE, ""));
		}
	
	}
}