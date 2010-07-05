package de.karfau.parallelpaint.service
{
	import de.karfau.parallelpaint.core.AbstractActor;
	import de.karfau.parallelpaint.service.callresponder.ServiceCallWorker;
	import de.karfau.parallelpaint.service.callresponder.WorkerContainer;
	
	import mx.core.mx_internal;
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.Responder;
	import mx.rpc.remoting.Operation;
	import mx.rpc.remoting.RemoteObject;
	
	import org.spicefactory.lib.reflect.ClassInfo;
	import org.spicefactory.lib.reflect.Method;
	
	/**
	 * Basic implementation for a service.
	 * To be used with
	 * <ul>
	 * <li>
	 * 		an Interface defining all functions of a RemoteObject-Destination
	 * 		all having the return type <code>ServiceCallResponder</code>
	 * 		(called&nbsp;<code><b>serviceInterface</b></code>),
	 * </li>
	 * <li>
	 * 		a <code>ServiceConfig</code> with a mapping for the
	 * 		<code>destination</code>(as String) to <code><b>serviceInterface</b></code>,
	 * </li>
	 * <li>
	 * 		an implementation that extends <code>AbstractService</code>
	 * 		and implements <code><b>serviceInterface</b></code>,
	 * </li>
	 * <li>
	 * 		Commands that use the <code>ServiceCallResponder</code>s returned
	 * 		by the service-calls to add result-/fault-handlers.
	 * </li>
	 * </ul>
	 *
	 * @author Karfau
	 *
	 * @see de.karfau.parallelpaint.service.callresponder.ServiceCallResponder
	 * @see ServiceConfig
	 */
	public class AbstractService extends AbstractActor
	{
		
		/*########################################################*/
		/*                                                        */
		/*   STATIC                                               */
		/*                                                        */
		/*########################################################*/
		
		/**
		 * Default convention for the start of a function-name that handles a(ny) rcp-call(-event)
		 * to transfer it to an application-specific value
		 *
		 * @default "work"
		 */
		public static const DEFAULT_WORKER_PREFIX:String = "work";
		/**
		 * Default convention for the end of a function-name that handles a successfull rcp-call(-event)
		 * to transfer it to an application-specific value
		 *
		 * @default "Result"
		 */
		public static const DEFAULT_RESULT_SUFFIX:String = "Result";
		/**
		 * Default convention for the end of a function-name that handles a failed rcp-call(-event)
		 * to transfer it to an application-specific value/error
		 *
		 * @default "Fault"
		 */
		public static const DEFAULT_FAULT_SUFFIX:String = "Fault";
		
		/*########################################################*/
		/*                                                        */
		/*   PROPERTIES (INCL. SETTER/GETTER)                     */
		/*                                                        */
		/*########################################################*/
		
		private const UNINITIALIZED_OBJECT:Object = {};
		
		/**
		 * Is set up and used by <code>hasServiceFunction()</code>.
		 * This could be set up with names of functions if the dependency to SpiceLib is not wished.
		 *
		 * @default <code>new Object()</code>
		 *
		 * @see #hasServiceFunction()
		 *
		 */
		private var functionNames:Object = UNINITIALIZED_OBJECT;
		
		private var _service:RemoteObject;
		
		/**
		 * The <code>RemoteObject</code> that represents the connection
		 * to the backend.
		 */
		protected function get service ():RemoteObject {
			return _service;
		}
		
		private var _serviceInterface:Class;
		
		protected function get serviceInterface ():Class {
			return _serviceInterface;
		}
		
		/*########################################################*/
		/*                                                        */
		/*   CONSTRUCTOR                                          */
		/*                                                        */
		/*########################################################*/
		
		/**
		 *
		 * @param serviceInterface the implemented Service
		 * @param serviceConfig default is <code>ServiceConfig.instance</code>
		 * @throws IllegalOperationError if the constructing class doesn't implement <code>serviceInterface</code>
		 * @throws ArgumentError if <code>serviceConfig</code> has no mapping for <code>serviceInterface</code>
		 */
		public function AbstractService (serviceInterface:Class, serviceConfig:ServiceConfig=null) {
			super(AbstractService, serviceInterface);
			
			//recieve service destination
			if (serviceConfig == null)
				serviceConfig = ServiceConfig.INSTANCE;
			
			{
				/*TODO: Maybe this should better be done inside
				 ServiceConfig.createConfiguredRemoteObject(serviceInterface) or alike*/
				var destination:String = serviceConfig.getDestination(serviceInterface);
				if (!destination)
					throw new ArgumentError(clazz + " CONSTRUCTOR ERROR: <serviceInterface> " + serviceInterface +
																	"is not mapped in " + serviceConfig);
				//init
				_service = new RemoteObject(destination);
				if (serviceConfig.channelEndpoint != null) {
					service.endpoint = serviceConfig.channelEndpoint;
					service.mx_internal::initEndpoint();
				}
			}
			
			_serviceInterface = serviceInterface;
			initServiceInterfaceFunctionMap(true);
		}
		
		/*########################################################*/
		/*                                                        */
		/*   OVERRIDE / IMPLEMENT                                 */
		/*                                                        */
		/*########################################################*/
		
		/**
		 *
		 * @param name
		 * @return true if a function is defined by <code><b>serviceInterface</b></code>.
		 *
		 * @see org.spicefactory.lib.reflect.ClassInfo
		 * @see org.spicefactory.lib.reflect.Method
		 *
		 */
		protected final function hasServiceInterfaceFunction (name:String):Boolean {
			return Boolean(serviceInterfaceFunction(name));
		}
		
		protected final function serviceInterfaceFunction (name:String):Function {
			initServiceInterfaceFunctionMap();
			return functionNames[name];
		}
		
		/**
		 * Checks if <code>serviceInterface</code> has a function with the name
		 * <code>functionName</code> and returns the equivalent
		 * <code>Operation</code> for the remote call.
		 *
		 * @param functionName
		 * @return the operation for usage with <code>callToken( operation, parameters)</code>
		 * @throws ArgumentError if <code>functionName</code> is not mapped or allowed.
		 *
		 * @see #serviceInterface
		 * @see #hasServiceFunction()
		 * @see #callToken()
		 * @see mx.rpc.remoting.Operation
		 */
		protected function operation (functionName:String):Operation {
			/*if (!functionName)
				 functionName = currentFunctionName;
				 if (!functionName)
			 throw new ArgumentError(clazz + "#operation(): both *functionName and #currentFunctionName are NULL or an empty String.");*/
			if (!hasServiceInterfaceFunction(functionName))
				throw new ArgumentError(clazz + "#operation(): *functionName '" + functionName + "' is not mapped or allowed.");
			var result:Operation = Operation(service.getOperation(functionName));
			return result;
		}
		
		/**
		 * Calls <code>operation</code> with <code>parameters</code>
		 * and returns the <code>AsyncToken</code> for the remote call.
		 *
		 * @see #callToken()
		 * @see mx.rpc.remoting.Operation
		 */
		protected function callToken (operation:Operation, parameters:Array=null):AsyncToken {
			var result:AsyncToken = AsyncToken((operation.send as Function).apply(null, parameters));
			return result;
		}
		
		/**
		 * Creates an <code>IResponder</code> based on the following function-name-convention/-configuration:<br/>
		 * using <code>#workerPrefix + <i>functionName</i> + #faultSuffix</code> as "result-handler"<br/>
		 * and <code>#workerPrefix + <i>functionName</i> + #resultSuffix</code> as "fault-handler".
		 *
		 * @see #workerPrefix
		 * @see #faultSuffix
		 * @see #resultSuffix
		 * @see mx.rpc.IResponder
		 */
		protected function workerResponder (functionName:String=null):IResponder {
			var resultHandler:Function = resultFromResultEvent;
			var faultHandler:Function = faultFromFaultEvent;
			
			if (functionName == null) {
				functionName = "";
			} else if (workerPrefix) {
				functionName = functionName.charAt(0).toUpperCase() + functionName.substr(1);
			}
			
			var name:String = workerPrefix + functionName;
			if (this.hasOwnProperty(name + resultSuffix))
				resultHandler = this[name + resultSuffix] as Function || resultFromResultEvent;
			if (this.hasOwnProperty(name + faultSuffix))
				faultHandler = this[name + faultSuffix] as Function || faultFromFaultEvent;
			
			return new Responder(resultHandler, faultHandler);
		}
		
		/**
		 *
		 *
		 * @param functionName
		 * @param parameters as used by Function#apply(): <code>null</code> (or []) for no parameters, an Array with values in parameter-order
		 * @return
		 */
		protected function buildServiceCallWorker (functionName:String, parameters:Array, resultType:Class, faultType:Class=null):ServiceCallWorker {
			if (serviceInterfaceFunction(functionName).length != ((parameters || []) as Array).length)
				throw new VerifyError(clazz + "#buildServiceCallWorker():" +
															" The function '" + functionName + "' needs " + serviceInterfaceFunction(functionName).length +
															" arguments but *parameters provides " + ((parameters || []) as Array).length + " arguments: <" + parameters + ">.");
			var result:ServiceCallWorker = new ServiceCallWorker(
				callToken(operation(functionName), parameters),
				resultType, faultType,
				workerResponder(functionName)
				);
			return result;
		}
		
		/**
		 * This uses the "Spicelib Reflection API" to automatically return true
		 * for functions that are defined by the <code>serviceInterface</code>.
		 * <p>To avoid the use of the reflection API override this method
		 * to create a mapping from function-names (as <code>String</code>)
		 * to the actual function (as <code>Function</code>).
		 * In most cases this could be done by using <code>#mapServiceInterfaceFunction()</code>
		 * </p>
		 *
		 * @param override override existing map, else the map is only created when the map is empty.
		 *
		 * @see #mapServiceInterfaceFunction()
		 */
		protected function initServiceInterfaceFunctionMap (override:Boolean=false):void {
			if (functionNames == UNINITIALIZED_OBJECT || override) {
				functionNames = new Object();
				
				{ //start : spicelib-depending code
					/*TODO: exclude depending code by Compiler-Argument
					 or create a seperate util/interface for this (minimal reflection API).*/
					var methods:Array = ClassInfo.forClass(serviceInterface).getMethods();
					for each (var method:Method in methods) {
						mapServiceInterfaceFunction(method.name);
					}
				} //end : spicelib-depending code
			}
		}
		
		protected final function mapServiceInterfaceFunction (name:String):void {
			if (this[name] is Function)
				functionNames[name] = this[name];
			else
				throw new VerifyError("The property '" + name + "' is not a Function: <" + this[name] + ">.");
		}
		
		protected function resultFromResultEvent (worker:WorkerContainer):void {
			if (worker.asResultEvent)
				worker.outcome = worker.asResultEvent.result;
		}
		
		protected function faultFromFaultEvent (worker:WorkerContainer):void {
			if (worker.asFaultEvent)
				worker.outcome = worker.asFaultEvent.fault;
		}
		
		/*########################################################*/
		/*                                                        */
		/*  PRIVATE HELPER/UTIL                                   */
		/*                                                        */
		/*########################################################*/
		
		//protected var currentFunctionName:String;
		/**
		 * Default convention for the end of a function-name that handles a failed rcp-call(-event)
		 * to transfer it to an application-specific value/error
		 *
		 * @default DEFAULT_FAULT_SUFFIX
		 *
		 * @see #DEFAULT_FAULT_SUFFIX
		 * @see #defaultWorkerResponder()
		 */
		protected var faultSuffix:String = DEFAULT_FAULT_SUFFIX;
		/**
		 * Default convention for the end of a function-name that handles a successfull rcp-call(-event)
		 * to transfer it to an application-specific value
		 *
		 * @default DEFAULT_RESULT_SUFFIX
		 *
		 * @see #DEFAULT_RESULT_SUFFIX
		 * @see #defaultWorkerResponder()
		 */
		protected var resultSuffix:String = DEFAULT_RESULT_SUFFIX;
		
		/**
		 * The start of a function-name that handles a(ny) rcp-call(-event) to transfer it to an application-specific value.
		 *
		 * @default DEFAULT_WORKER_PREFIX
		 *
		 * @see #DEFAULT_WORKER_PREFIX
		 * @see #defaultWorkerResponder()
		 */
		protected var workerPrefix:String = DEFAULT_WORKER_PREFIX;
	}
}