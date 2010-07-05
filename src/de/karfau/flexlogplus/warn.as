package de.karfau.flexlogplus
{
	import mx.logging.Log;
	
	public function warn (source:*, message:String, ... args):void {
		if (Log.isWarn())
			LogUtil.getLogger(source).warn.apply(null, [message].concat(args));
	}
}