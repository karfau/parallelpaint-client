package de.karfau.flexlogplus
{
	import mx.logging.*;
	
	/**
	 * This implements the idea from from https://simple-log.dev.java.net/.<br/>
	 * Because LogLogger cannot handle LogEventLevel.* smaller then LogEventLevel.DEBUG (2),
	 * the lvl used is set to LogEventLevel.DEBUG insted of LogConfig.LVL_1_VERBOSE.
	 */
	public function ludicrous (source:*, message:String, ... args):void {
		if (LogConfig.isLudicrous()) {
			var logger:ILogger = LogUtil.getLogger(source);
			var lvl:int = logger is LogLogger ? LogEventLevel.DEBUG : LogConfig.LVL_0_LUDICROUS;
			logger.log.apply(null, [lvl, message].concat(args));
		}
	}
}