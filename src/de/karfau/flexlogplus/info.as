package de.karfau.flexlogplus
{
	import mx.logging.Log;
	
	public function info (source:*, message:String, ... args):void {
		if (Log.isInfo())
			LogUtil.getLogger(source).info.apply(null, [message].concat(args));
	}
}