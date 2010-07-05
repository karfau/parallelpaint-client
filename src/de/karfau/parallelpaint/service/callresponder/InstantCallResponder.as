package de.karfau.parallelpaint.service.callresponder
{
	import mx.rpc.IResponder;
	
	import org.osflash.signals.Signal;
	
	public class InstantCallResponder extends AbstractServiceCallResponder implements ServiceCallResponder
	{
		
		/*########################################################*/
		/*                                                        */
		/*   STATIC                                               */
		/*                                                        */
		/*########################################################*/
		
		public static const NO_OUTCOME_SET:String = "Neither result nor fault where set";
		
		/*########################################################*/
		/*                                                        */
		/*   PROPERTIES (INCL. SETTER/GETTER)                     */
		/*                                                        */
		/*########################################################*/
		
		private var _success:Boolean = false;
		private var _outcome:Object = NO_OUTCOME_SET;
		
		public function get isSuccess ():Boolean {
			return _success;
		}
		
		public function get faultValue ():Object {
			return isSuccess ? null : _outcome;
		}
		
		public function set faultValue (value:Object):void {
			setSuccess(value, false);
		}
		
		public function get resultValue ():Object {
			return isSuccess ? _outcome : null;
		}
		
		public function set resultValue (value:Object):void {
			setSuccess(value, true);
		}
		
		/*########################################################*/
		/*                                                        */
		/*   CONSTRUCTOR                                          */
		/*                                                        */
		/*########################################################*/
		
		public function InstantCallResponder (resultType:Class, faultType:Class=null) {
			super(resultType, faultType);
		
		}
		
		/*########################################################*/
		/*                                                        */
		/*   OVERRIDE / IMPLEMENT                                 */
		/*                                                        */
		/*########################################################*/
		
		public override function setOnFault (handler:Function):ServiceCallResponder {
			verifyOutcome();
			super.setOnFault(handler);
			if (!isSuccess)
				this.fault(_outcome);
			return this;
		}
		
		public override function setOnResult (handler:Function):ServiceCallResponder {
			verifyOutcome();
			super.setOnResult(handler);
			if (isSuccess)
				this.result(_outcome);
			return this;
		}
		
		public function withFaultMessage (message:String, errorClass:Class=null):InstantCallResponder {
			errorClass = errorClass || Error;
			faultValue = new errorClass(message);
			return this;
		}
		
		public function withFault (value:Object):InstantCallResponder {
			faultValue = value;
			return this;
		}
		
		public function withResult (value:Object=null):InstantCallResponder {
			resultValue = value;
			return this;
		}
		
		public function verifyOutcome (returnInsteadOfThrow:Boolean=false):Boolean {
			if (_outcome == NO_OUTCOME_SET) {
				if (returnInsteadOfThrow)
					return false;
				throw new VerifyError(NO_OUTCOME_SET);
			}
			return true;
		}
		
		protected function setSuccess (outcome:Object, value:Boolean):void {
			_outcome = outcome;
			_success = value;
		}
	}
}