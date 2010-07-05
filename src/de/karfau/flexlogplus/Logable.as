package de.karfau.flexlogplus {
	import mx.logging.ILogger;
	
	/**
	 * Implement the following functions to make logging speed up:
	 * <pre>
	 * public function get logger():ILogger{
	 * public function get logCategory():String{
	 * </pre>
	 *
	 * @author Karfau
	 *
	 */
	public interface Logable {
		function get logger ():ILogger;
		
		function get logCategory ():String;
	}
}