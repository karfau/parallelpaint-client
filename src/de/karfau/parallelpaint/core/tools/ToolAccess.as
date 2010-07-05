package de.karfau.parallelpaint.core.tools
{
	import de.karfau.flexlogplus.*;
	
	public class ToolAccess
	{
		
		/*########################################################*/
		/*                                                        */
		/*   STATIC                                               */
		/*                                                        */
		/*########################################################*/
		
		//public static const REQ_NOUSER:uint = 1;
		public static const UNLIMITED_ACCESS:ToolAccess = new ToolAccess(REQ_NOTHING);
		
		public static const REQ_NOTHING:uint = 0;
		public static const REQ_USER:uint = 2;
		//public static const REQ_EDITOR:uint = 4;
		public static const REQ_AUTHOR:uint = 8;
		
		public static function combineAccess (... accesslevels):uint {
			var result:uint = 0;
			var lvlsPrint:String = "";
			for (var i:int = accesslevels.length; i--; ) {
				result = (result | uint(accesslevels[i]));
				lvlsPrint += printAccess(accesslevels[i]) + ",";
			}
			ludicrous(ToolAccess, ".combineAccess({0}) results in {1}", lvlsPrint.slice(0, -1), result);
			return result;
		}
		
		public static function printAccess (accessLvl:uint):String {
			var list:Array = [];
			
			if (accessLvl == REQ_NOTHING)
				list.push("ANYBODY")
			else {
				if (accessLvl & REQ_USER)
					list.push("USER")
				if (accessLvl & REQ_AUTHOR)
					list.push("AUTHOR")
				/*if (accessLvl & REQ_EDITOR)
				 list.push("EDITOR")*/
			}
			return list.join(" ");
		}
		
		/*########################################################*/
		/*                                                        */
		/*   PROPERTIES (INCL. SETTER/GETTER)                     */
		/*                                                        */
		/*########################################################*/
		
		private var _enabled:uint;
		
		public function get enabled ():uint {
			return _enabled;
		}
		private var _visible:uint;
		
		public function get visible ():uint {
			return _visible;
		}
		
		public var reverse:Boolean = false;
		
		/*########################################################*/
		/*                                                        */
		/*   CONSTRUCTOR                                          */
		/*                                                        */
		/*########################################################*/
		
		public function ToolAccess (visible:uint=0, enabled:int=-1) {
			this._visible = visible;
			this._enabled = (enabled == -1) ? visible : enabled;
		}
		
		/*########################################################*/
		/*                                                        */
		/*   OVERRIDE / IMPLEMENT                                 */
		/*                                                        */
		/*########################################################*/
		
		public function getEnabled (access:uint):Boolean {
			return checkFlag(enabled, access);
		}
		
		public function getVisible (access:uint):Boolean {
			return checkFlag(visible, access);
		}
		
		private function checkFlag (flag:uint, access:uint):Boolean {
			var result:Boolean = (flag == REQ_NOTHING) || (flag & access) != 0; //bitwise AND checks if all flags given in access are set in flags
			
			return reverse ? !result : result;
		}
		
		public function updateToolAccess (tool:AbstractTool, accesslvl:uint):void {
			tool.enabled = getEnabled(accesslvl);
			tool.visible = getVisible(accesslvl);
		}
		
		public function clone ():ToolAccess {
			var result:ToolAccess = new ToolAccess(visible, enabled);
			result.reverse = reverse;
			return result;
		}
	}
}