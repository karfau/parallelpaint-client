package de.karfau.parallelpaint.core.elements
{
	import flash.display.Graphics;
	
	import org.osflash.signals.ISignal;
	
	public interface IRender
	{
		function get onNeedsRendering ():ISignal;
		function renderOn (graphics:Graphics):void;
		function invalidateRendering ():void;
		//protected function set/get delayRendering:Boolean;
	}
}