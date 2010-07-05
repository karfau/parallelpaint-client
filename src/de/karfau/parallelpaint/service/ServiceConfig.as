package de.karfau.parallelpaint.service
{
	import de.karfau.flexlogplus.debug;
	
	import flash.utils.Dictionary;
	
	/**
	 * Handels mapping from RemoteObject-Destinations to ServiceInterfaces.
	 *
	 * If u only need one mapping use <code>instance</code>.
	 *
	 * @author Karfau
	 *
	 * @see #INSTANCE
	 */
	public class ServiceConfig
	{
		
		/*########################################################*/
		/*                                                        */
		/*   STATIC                                               */
		/*                                                        */
		/*########################################################*/
		
		/**
		 * For usage if only one mapping is needed.
		 *
		 * @default with instanceId "static const instance"
		 */
		public static const INSTANCE:ServiceConfig = new ServiceConfig("static const instance");
		
		/*########################################################*/
		/*                                                        */
		/*   PROPERTIES (INCL. SETTER/GETTER)                     */
		/*                                                        */
		/*########################################################*/
		
		private var _channelEndpoint:String;
		
		private var _instanceId:String;
		
		public function get channelEndpoint ():String {
			return _channelEndpoint;
		}
		
		public function set channelEndpoint (value:String):void {
			_channelEndpoint = value;
		}
		
		/**
		 *
		 * @return
		 */
		public function get instanceId ():String {
			return _instanceId;
		}
		
		private const destinations:Object = new Object();
		private const services:Dictionary = new Dictionary();
		
		/*########################################################*/
		/*                                                        */
		/*   CONSTRUCTOR                                          */
		/*                                                        */
		/*########################################################*/
		
		/**
		 *
		 * @param instanceId
		 *
		 * @see #INSTANCE
		 */
		public function ServiceConfig (instanceId:String) {
			_instanceId = instanceId;
		}
		
		/*########################################################*/
		/*                                                        */
		/*   OVERRIDE / IMPLEMENT                                 */
		/*                                                        */
		/*########################################################*/
		
		public function toString ():String {
			return "ServiceConfig{" + instanceId + "}";
		}
		
		/**
		 * Creates or overrides a mapping.
		 *
		 * @param destination
		 * @param serviceInterface
		 */
		public function mapServiceInterface (serviceInterface:Class, destination:String):void {
			if (getDestination(serviceInterface) != null) {
				debug(this, "mapServiceInterface({0}) OVERRIDES mapping to {1}", [serviceInterface, destination], getServiceInterface(destination));
				removeMapping(serviceInterface, destination);
			} else {
				debug(this, "mapServiceInterface({0})", [serviceInterface, destination]);
			}
			destinations[destination] = serviceInterface;
			services[serviceInterface] = destination;
		}
		
		/**
		 * Deletes a mapping if existant.
		 *
		 * @param destination
		 * @param serviceInterface
		 */
		public function unmapServiceInterface (serviceInterface:Class, destination:String):void {
			debug(this, "unmapServiceInterface({0})", [serviceInterface, destination]);
			removeMapping(serviceInterface, destination);
		}
		
		/**
		 *
		 * @param destination
		 * @return mapped <code>serviceInterface</code> for <code>destination</code>
		 */
		private function getServiceInterface (destination:String):Class {
			return destinations[destination] as Class;
		}
		
		/**
		 *
		 * @param serviceInterface
		 * @return mapped <code>destination</code> for <code>serviceInterface</code>
		 */
		public function getDestination (serviceInterface:Class):String {
			return services[serviceInterface] as String;
		}
		
		/*########################################################*/
		/*                                                        */
		/*  PRIVATE HELPER/UTIL                                   */
		/*                                                        */
		/*########################################################*/
		
		private function removeMapping (serviceInterface:Class, destination:String):void {
			delete destinations[destination];
			delete services[serviceInterface];
		}
	}
}