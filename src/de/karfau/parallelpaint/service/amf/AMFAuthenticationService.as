package de.karfau.parallelpaint.service.amf
{
	import de.karfau.flexlogplus.*;
	import de.karfau.parallelpaint.model.vo.SpringSecurityAuthentication;
	import de.karfau.parallelpaint.service.AbstractService;
	import de.karfau.parallelpaint.service.callresponder.ServiceCallResponder;
	import de.karfau.parallelpaint.service.callresponder.ServiceCallWorker;
	import de.karfau.parallelpaint.service.callresponder.WorkerContainer;
	import de.karfau.parallelpaint.service.definition.AuthenticationService;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.Responder;
	
	public class AMFAuthenticationService extends AbstractService implements AuthenticationService
	{
		public function AMFAuthenticationService () {
			super(AuthenticationService);
		}
		
		public function getCurrentAuthenticatedUser ():ServiceCallResponder {
			return buildServiceCallWorker("getCurrentAuthenticatedUser", [], String);
		}
		
		public function login (username:String, password:String):ServiceCallResponder {
			/*special: BlazeDS4 uses login-/logout-methods on the ChannelSet:*/
			var result:ServiceCallWorker = new ServiceCallWorker(
				AsyncToken(service.channelSet.login(username, password)),
				SpringSecurityAuthentication, Error,
				new Responder(workLoginResult, faultFromFaultEvent)
				);
			return result;
			//return buildServiceCallWorker("login", [username, password]);
		}
		
		private function workLoginResult (container:WorkerContainer):void {
			container.outcome = new SpringSecurityAuthentication(container.asResultEvent.result);
		}
		
		public function registerUser (username:String, password:String, mail:String):ServiceCallResponder { //
			return buildServiceCallWorker("registerUser", [username, password, mail], Boolean); //
		}
		
		public function logout ():ServiceCallResponder {
			/*special: BlazeDS4 uses login-/logout-methods on the ChannelSet:*/
			var result:ServiceCallWorker = new ServiceCallWorker(
				AsyncToken(service.channelSet.logout()),
				null, Error,
				new Responder(workLogoutResult, faultFromFaultEvent)
				);
			return result;
			//return buildServiceCallWorker("logout");
		}
		
		private function workLogoutResult (container:WorkerContainer):void {
			verbose(this, ".workLogoutResult({0}) ", container.asResultEvent.result);
			//ensure that we don't return a value as documented in AuthService
			container.outcome = null;
		}
		
		public function autoLogin (autoLoginKey:String):ServiceCallResponder {
			return buildServiceCallWorker("autoLogin", [autoLoginKey], String);
		}
		
		public function setAutoLogin (autoLoginKey:String):ServiceCallResponder {
			return buildServiceCallWorker("setAutoLogin", [autoLoginKey], null);
		}
	
	}
}