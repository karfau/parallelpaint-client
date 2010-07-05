package de.karfau.flexlogplus
{
	import mx.logging.Log;
	
	public function error (source:*, message:String, ... args):void {
		if (Log.isError())
			LogUtil.getLogger(source).error.apply(null, [message].concat(args));
	}
}