package de.karfau.flexlogplus
{
	import mx.logging.Log;
	
	import de.karfau.flexlogplus.*;
	
	public function debug (source:*, message:String, ... args):void {
		if (Log.isDebug())
			LogUtil.getLogger(source).debug.apply(null, [message].concat(args));
	}
}