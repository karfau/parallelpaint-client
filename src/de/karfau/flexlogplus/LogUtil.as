package de.karfau.flexlogplus
{
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	/**
	 * Original Source lived in package de.sbistram.utils and was created by Stefan Bistram
	 *
	 * Karfau extended its functionality and moved it to de.karfau.flexlogplus so that it fits with the other utils provided in this package.
	 *
	 * @author Stefan Bistram, Karfau
	 *
	 * @see http://livedocs.adobe.com/flex/3/langref/mx/logging/Log.html#getLogger()
	 * @see http://blog.sbistram.de/2008/12/12/flex-using-the-flex3-logging-api/
	 */
	public class LogUtil
	{
		
		/**
		 * Using the full qualified class name as the category
		 * name for the logger.
		 *
		 * <p>
		 * Unfortunately the method getQualifiedClassName is
		 * returning e.g. de.sbistram.Utils::LogUtils for this class,
		 * but Log.getLogger doesn't allow ':' chars in the category
		 * name, so "::" will be replaced by "."
		 *
		 * Internal classes don't include the package, e.g.:
		 * Foo.as$0::InternalFoo
		 * </p>
		 *
		 * @param    value of an instance object or class
		 * @return    the full qualified class name without "::"
		 * @see http://blog.sbistram.de/2008/12/12/flex-using-the-flex3-logging-api/
		 * @see http://livedocs.adobe.com/flex/3/langref/mx/logging/Log.html#getLogger()
		 */
		public static function getCategory (value:*):String {
			//if(Object(value).hasOwnProperty("className")
			var qcn:String = getQualifiedClassName(value);
			qcn = qcn.replace("$", "."); // maybe an internal class using '$'
			return qcn.replace("::", "."); // public class in a package using '::'
		}
		
		/**
		 * Convert an array of classes or instances to an array of valid
		 * category names.
		 *
		 * - [...] means to include the complete package of the class
		 *  - String filter items left untouched
		 *  - For internal classes of a public class Foo -> "Foo.*"
		 *
		 * <pre>        var filters:Array = LogUtils.getFilter([
			 Config,               // add this class
			 [Foo],                // instead of: "de.sbistram.logtest.*"
			 Array,                // any class is allowed
			 logLevel,             // you can also use an instance
			 "de.sbistram.foo.*",  // you can still use strings
			 "Foo.*" 	          // to log all internal classes of Foo
			 ]);
			 </pre>
		 *
		 * @param    values
		 * @return    array of String categories
		 * @see http://blog.sbistram.de/2008/12/12/flex-using-the-flex3-logging-api/
		 */
		public static function getFilter (values:Array):Array {
			var categories:Array = [];
			for (var value:*in values) {
				value = values[value];
				// [] indicate to include all classes of a package
				if (value is Array) {
					var qcn:String = getQualifiedClassName(value[0]);
					value = qcn.slice(0, qcn.indexOf("::")).concat(".*");
				}
				categories.push((value is String) ? value : getCategory(value));
			}
			return categories;
		}
		
		/**
		 * Recieve the ILogger through the Flex Logging API with using source and getCategory() to determine the category of the returned ILogger
		 *
		 * @param source the value that is used to determine the category that the is returned.
		 * Can be an implmentation of Logable (using its logCategory), a String (used directly as a category) or anything else (using getCategory(source)).
		 * @return the instance of ILogger for the determined category.
		 *
		 */
		public static function getLogger (source:*):ILogger {
			var category:String;
			var logger:ILogger;
			if (source) {
				if (source is Logable) {
					category = Logable(source).logCategory;
					if (!category) {
						category = getCategory(source);
					}
				} else if (source is String) {
					category = source;
				} else {
					category = getCategory(source);
				}
				
				if (source is Logable) {
					logger = Logable(source).logger;
				}
				if (logger == null) {
					logger = Log.getLogger(category);
				}
			}
			if (!logger) {
				logger = Log.getLogger("de.karfau.flexlogplus");
			}
			return logger;
		}
	}
}