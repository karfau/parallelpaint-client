package de.karfau.parallelpaint.core.elements
{
	import de.karfau.parallelpaint.model.vo.User;

	import flash.display.Graphics;
	import flash.geom.Point;

	public interface ISelectable extends IClonable
	{
		function get id ():Number;
		function set id (value:Number):void;
		function get drawingId ():Number;
		function set drawingId (value:Number):void;
		function get selector ():String;
		function set selector (value:String):void;
		function get center ():Point;
		function get selectionPoints ():Vector.<SelectionPoint>;
		function get selected ():Boolean;

		function get version ():Number;
		function set version (value:Number):void;

		function renderShadow (graphics:Graphics, alpha:Number=0.5, color:int=-1, alphaAsFactor:Boolean=true):void;
	}
}