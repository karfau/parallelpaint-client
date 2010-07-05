package de.karfau.parallelpaint.service.callresponder
{
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	
	/**
	 * An object of this class contains all the logic that is nessesary to
	 * <ul>
	 * <li>let a service manage a result from a remote call and </li>
	 * <li>return the outcome to the <code>ServiceCallResponder</code></li>
	 * </ul>
	 * it gets created for each service is called.
	 *
	 */
	public class ServiceCallWorker extends AbstractServiceCallResponder implements ServiceCallResponder
	{
		
		/*########################################################*/
		/*                                                        */
		/*   PROPERTIES (INCL. SETTER/GETTER)                     */
		/*                                                        */
		/*########################################################*/
		
		private var _managerResponder:IResponder;
		
		protected function get managerResponder ():IResponder {
			return _managerResponder;
		}
		
		private var _token:AsyncToken;
		
		protected function get token ():AsyncToken {
			return _token;
		}
		
		private function set token (value:AsyncToken):void {
			/*we can not remove a responder easily,
			 and assigning a second token to the Response makes no sense:*/
			if (_token)
				throw new VerifyError(this + " tried to set token twice.");
			_token = value;
			_token.addResponder(this);
		}
		
		/*########################################################*/
		/*                                                        */
		/*   CONSTRUCTOR                                          */
		/*                                                        */
		/*########################################################*/
		
		/**
		 *
		 *
		 * @param token the token generated by the remote call, the created object adds itself as responder to the token.
		 * @param managerResponder defines the functions that manage
		 * the values returned by the remote call
		 */
		public function ServiceCallWorker (token:AsyncToken, resultType:Class, faultType:Class=null, managerResponder:IResponder=null) {
			super(resultType, faultType);
			private::token = token;
			_managerResponder = managerResponder;
		}
		
		/*########################################################*/
		/*                                                        */
		/*   OVERRIDE / IMPLEMENT                                 */
		/*                                                        */
		/*########################################################*/
		
		public override function fault (info:Object):void {
			var container:WorkerContainer = createContainer(info);
			if (managerResponder) {
				managerResponder.fault(container);
			}
			super.fault(container.outcome);
		}
		
		public override function result (data:Object):void {
			var container:WorkerContainer = createContainer(data);
			if (managerResponder) {
				managerResponder.result(container);
			}
			super.result(container.outcome);
		}
		
		/**
		 *
		 * @param incoming
		 * @return
		 */
		protected function createContainer (incoming:Object):WorkerContainer {
			return new WorkerContainer(incoming, abstract::thisResponder);
		}
	}
}