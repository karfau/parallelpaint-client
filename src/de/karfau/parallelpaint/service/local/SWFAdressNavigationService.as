package de.karfau.parallelpaint.service.local
{
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	
	import de.karfau.flexlogplus.*;
	import de.karfau.parallelpaint.events.DrawingEvent;
	import de.karfau.parallelpaint.service.definition.NavigationService;
	
	import flash.external.ExternalInterface;
	
	import mx.utils.StringUtil;
	
	import org.robotlegs.mvcs.Actor;
	
	public class SWFAdressNavigationService extends Actor implements NavigationService
	{
		
		/*########################################################*/
		/*                                                        */
		/*   PROPERTIES (INCL. SETTER/GETTER)                     */
		/*                                                        */
		/*########################################################*/
		
		private const DRAWING_ID_INDEX:int = 0;
		
		/*########################################################*/
		/*                                                        */
		/*   CONSTRUCTOR                                          */
		/*                                                        */
		/*########################################################*/
		
		public function SWFAdressNavigationService () {
			SWFAddress.addEventListener(SWFAddressEvent.EXTERNAL_CHANGE, onExternalChange);
			
			super();
		}
		
		private function onExternalChange (event:SWFAddressEvent):void {
			debug(this, ".onExternalChange({0}) ", event);
			dispatch(new DrawingEvent(DrawingEvent.SET_DRAWING, getActiveDrawingID()));
		}
		
		/*		private function onInit (event:SWFAddressEvent):void {
			 debug(this, ".onInit({0}) ", event);
		 }*/
		
		/*########################################################*/
		/*                                                        */
		/*   OVERRIDE / IMPLEMENT                                 */
		/*                                                        */
		/*########################################################*/
		
		public function getActiveDrawingID ():Number {
			var pathNames:Array = SWFAddress.getPathNames();
			if (pathNames && pathNames.length > DRAWING_ID_INDEX) {
				return parseInt(pathNames[DRAWING_ID_INDEX]);
			}
			return -1;
		}
		
		public function setActiveDrawingID (id:Number):void {
			/*if (id <= 0){
			 warn(this, ".setActiveDrawingID({0}) with id <= 0", id);*/
			SWFAddress.setValue(id > 0 ? id.toString() : "");
		
		}
		
		public function getCurrentUrl ():String {
			//LATER: ergänzen um andere Möglichkeiten? (BrowserManager, application.url)
			return ExternalInterface.call("window.location.href.toString");
		}
	}
}