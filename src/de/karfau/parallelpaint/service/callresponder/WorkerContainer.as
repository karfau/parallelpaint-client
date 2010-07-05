package de.karfau.parallelpaint.service.callresponder
{
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	public class WorkerContainer
	{
		
		/*########################################################*/
		/*                                                        */
		/*   PROPERTIES (INCL. SETTER/GETTER)                     */
		/*                                                        */
		/*########################################################*/
		
		protected var _incoming:Object;
		
		public function get incoming ():Object {
			return _incoming;
		}
		
		public var outcome:Object;
		
		protected var _worker:ServiceCallResponder;
		
		public function get worker ():ServiceCallResponder {
			return _worker;
		}
		
		public function get asResultEvent ():ResultEvent {
			return incoming as ResultEvent;
		}
		
		public function get asFaultEvent ():FaultEvent {
			return incoming as FaultEvent;
		}
		
		/*########################################################*/
		/*                                                        */
		/*   CONSTRUCTOR                                          */
		/*                                                        */
		/*########################################################*/
		
		public function WorkerContainer (incoming:Object, worker:ServiceCallResponder) {
			_incoming = incoming;
			outcome = incoming;
			_worker = worker;
		}
	}
}