package de.karfau.parallelpaint.service.callresponder
{
	
	import mx.rpc.IResponder;
	
	import org.osflash.signals.Signal;
	
	public class AbstractServiceCallResponder extends AbstractObject implements IResponder //, ServiceCallResponder
	{
		
		/*########################################################*/
		/*                                                        */
		/*   PROPERTIES (INCL. SETTER/GETTER)                     */
		/*                                                        */
		/*########################################################*/
		
		/**
		 * Dispatches the fault to the calling responder (e.g. Command),
		 * can be set by the Service, to ensure the return type.
		 *
		 * @default new Signal();
		 */
		public var onFault:Signal = new Signal();
		
		/**
		 * Dispatches the result to the calling responder (e.g. Command),
		 * can be set by the Service, to ensure the return type.
		 *
		 * @default new Signal();
		 */
		public var onResult:Signal = new Signal();
		
		/*########################################################*/
		/*                                                        */
		/*   CONSTRUCTOR                                          */
		/*                                                        */
		/*########################################################*/
		
		public function AbstractServiceCallResponder (resultType:Class, faultType:Class=null) {
			super(AbstractServiceCallResponder, ServiceCallResponder);
			if (resultType)
				setResultTypes(resultType);
			else
				setResultTypes();
			
			setFaultTypes(faultType || Error);
		}
		
		/*########################################################*/
		/*                                                        */
		/*   OVERRIDE / IMPLEMENT                                 */
		/*                                                        */
		/*########################################################*/
		
		/**
		 * <code>IResponder</code> implementation
		 * @inheritDoc
		 */
		public function fault (info:Object):void {
			onFault.dispatch(info);
		}
		
		/**
		 * <code>IResponder</code> implementation
		 * @inheritDoc
		 */
		public function result (data:Object):void {
			dispatchSingleVoidableValue(onResult, data);
		}
		
		/**
		 * <code>ServiceCallResponder</code> implementation
		 * @inheritDoc
		 */
		public function setOnResult (handler:Function):ServiceCallResponder {
			setSingleOneTimeSignalHandler(onResult, handler);
			return abstract::thisResponder;
		}
		
		/**
		 * <code>ServiceCallResponder</code> implementation
		 * @inheritDoc
		 */
		public function setOnFault (handler:Function):ServiceCallResponder {
			setSingleOneTimeSignalHandler(onFault, handler);
			return abstract::thisResponder;
		}
		
		/*########################################################*/
		/*                                                        */
		/*  PRIVATE HELPER/UTIL                                   */
		/*                                                        */
		/*########################################################*/
		
		abstract function get thisResponder ():ServiceCallResponder {
			return ServiceCallResponder(this);
		}
		
		protected function setResultTypes (... types):void {
			onResult = new Signal(types);
		}
		
		protected function setFaultTypes (... types):void {
			onFault = new Signal(types);
		}
		
		private function setSingleOneTimeSignalHandler (signal:Signal, handler:Function):void {
			signal.removeAll();
			signal.addOnce(handler);
		}
		
		protected function dispatchSingleVoidableValue (signal:Signal, value:Object):void {
			if (signal.valueClasses.length == 0 && value == null)
				signal.dispatch();
			signal.dispatch(value);
		}
	}
}