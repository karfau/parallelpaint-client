package de.karfau.flexlogplus
{
	import mx.logging.Log;
	
	public function fatal (source:*, message:String, ... args):void {
		if (Log.isFatal())
			LogUtil.getLogger(source).fatal.apply(null, [message].concat(args));
	}
}