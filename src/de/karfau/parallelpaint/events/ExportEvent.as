package de.karfau.parallelpaint.events
{
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import mx.graphics.ImageSnapshot;
	import mx.graphics.codec.IImageEncoder;
	import mx.graphics.codec.JPEGEncoder;
	import mx.graphics.codec.PNGEncoder;
	
	public class ExportEvent extends Event
	{
		
		/*########################################################*/
		/*                                                        */
		/*   STATIC                                               */
		/*                                                        */
		/*########################################################*/
		
		public static const FORMAT_PNG:String = "PNG";
		public static const FORMAT_JPG:String = "JPG";
		
		public static const SET_BITMAP_DATA:String = "BMP";
		public static const EXPORT_DRAWING:String = "EXPORT_DRAWING";
		
		public static function isBinary (format:String):Boolean {
			return format == ExportEvent.FORMAT_JPG || format == ExportEvent.FORMAT_PNG;
		}
		
		public static function getEncoder (format:String):IImageEncoder {
			switch (format) {
				case FORMAT_JPG:
					return new JPEGEncoder(80);
				
				case FORMAT_PNG:
				default:
					return new PNGEncoder();
			}
		}
		
		/*########################################################*/
		/*                                                        */
		/*   PROPERTIES (INCL. SETTER/GETTER)                     */
		/*                                                        */
		/*########################################################*/
		
		public var bitmapData:ByteArray;
		
		private var _format:String;
		
		public function get format ():String {
			return _format;
		}
		
		/*########################################################*/
		/*                                                        */
		/*   CONSTRUCTOR                                          */
		/*                                                        */
		/*########################################################*/
		
		public function ExportEvent (format:String, bitmapData:ByteArray=null) {
			var typ:String = ExportEvent.isBinary(format) && bitmapData == null ? SET_BITMAP_DATA : EXPORT_DRAWING;
			super(typ);
			this._format = format;
			this.bitmapData = bitmapData;
		
		}
		
		/*########################################################*/
		/*                                                        */
		/*   OVERRIDE / IMPLEMENT                                 */
		/*                                                        */
		/*########################################################*/
		
		public function setBitmapDataBySource (source:IBitmapDrawable):void {
			bitmapData = ImageSnapshot.captureImage(source, 0, getEncoder(format)).data;
		}
		
		public function isBinary ():Boolean {
			return ExportEvent.isBinary(format);
		}
		
		public override function clone ():Event {
			return new ExportEvent(format, bitmapData);
		}
	}
}