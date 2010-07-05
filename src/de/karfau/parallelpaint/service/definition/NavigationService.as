package de.karfau.parallelpaint.service.definition
{
	
	public interface NavigationService
	{
		function setActiveDrawingID (id:Number):void;
		function getActiveDrawingID ():Number;
		
		function getCurrentUrl ():String;
	}
}