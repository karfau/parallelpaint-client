package de.karfau.flexlogplus
{
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import mx.logging.Log;
	import mx.logging.LogEventLevel;
	import mx.logging.targets.LineFormattedTarget;
	
	/*	import mx.logging.targets.TraceTarget;
	
		 import com.soenkerohde.logging.SOSLoggingTarget;
	 import be.novio.xpanel.XPanelDebugTarget;*/
	
	public class LogConfig
	{
		
		/*		public static var SOS:String = "SOS";
		
			 public static var TRACE:String = "TRACE";
		
		 public static var XP:String = "XP";*/
		
		/*		public static var logToSOS:Boolean = true;
		
			 public static var logToTrace:Boolean = true;
		
		 public static var logToXP:Boolean = false;*/
		
		private static var targetClassesActive:Dictionary = new Dictionary();
		
		private static var targets:Object = {};
		
		private static var _lowestLogLevel:int = int.MAX_VALUE;
		
		public static const LVL_0_LUDICROUS:int = LogEventLevel.ALL; //0;
		public static const LVL_1_VERBOSE:int = 1;
		public static const LVL_2_DEBUG:int = LogEventLevel.DEBUG;
		
		public static var includeCategory:Boolean = true;
		public static var includeDate:Boolean = true;
		public static var includeLevel:Boolean = true;
		public static var includeTime:Boolean = true;
		public static var fieldSeparator:String = " ";
		
		public static function get lowestLogLevel ():int {
			return _lowestLogLevel;
		}
		
		public static function isVerbose ():Boolean {
			return _lowestLogLevel <= LVL_1_VERBOSE;
		}
		
		public static function isLudicrous ():Boolean {
			return _lowestLogLevel <= LVL_0_LUDICROUS;
		}
		
		public static function addTarget (targetType:Class, active:Boolean=true):void {
			targetClassesActive[targetType] = active;
		}
		
		public static function removeTarget (targetType:Class, active:Boolean=true):void {
			delete targetClassesActive[targetType];
		}
		
		public static function configureTarget (targetType:Class, active:Boolean=true, level:int=4, filters:Array=null):void {
			
			addTarget(targetType, active);
			
			var target:LineFormattedTarget = targets[targetType];
			if (active) {
				if (!target)
					target = targets[targetType] = new targetType();
			} else {
				if (target)
					delete targets[targetType];
			}
			applyTargetUsage(target, active, level, filters);
		}
		
		public static function startUp (level:int=4, filters:Array=null):void {
			_lowestLogLevel = int.MAX_VALUE;
			for (var clazz:* in targetClassesActive) {
				configureTarget(clazz, targetClassesActive[clazz], level, filters);
			}
		}
		
		private static function applyTargetUsage (target:LineFormattedTarget, active:Boolean, level:int=4, filters:Array=null):void {
			if (active) {
				target.fieldSeparator = fieldSeparator;
				target.includeCategory = includeCategory;
				target.includeDate = includeDate;
				target.includeLevel = includeLevel;
				target.includeTime = includeTime;
				target.filters = filters;
				applyLowestLogLevel(level);
				target.level = level; //adds it to Log
			} else if (target != null) {
				//reset lowest log level
				if (target.level == _lowestLogLevel) {
					_lowestLogLevel = int.MAX_VALUE;
					for each (var lltarget:LineFormattedTarget in targets) {
						applyLowestLogLevel(lltarget.level);
					}
				}
				//remove
				try {
					Log.removeTarget(target);
				} catch (e:ArgumentError) {
					trace(LogConfig + ".applyTargetUsage(...): target " + target + " was not removable");
				}
			}
		}
		
		private static function applyLowestLogLevel (level:int):void {
			_lowestLogLevel = level < _lowestLogLevel ? level : _lowestLogLevel;
		}
	
	}
}

