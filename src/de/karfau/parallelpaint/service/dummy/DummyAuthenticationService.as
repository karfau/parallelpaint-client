package de.karfau.parallelpaint.service.dummy
{
	import de.karfau.parallelpaint.model.vo.User;
	import de.karfau.parallelpaint.service.AbstractService;
	import de.karfau.parallelpaint.service.callresponder.InstantCallResponder;
	import de.karfau.parallelpaint.service.callresponder.ServiceCallResponder;
	import de.karfau.parallelpaint.service.definition.AuthenticationService;
	
	public class DummyAuthenticationService extends AbstractService implements AuthenticationService
	{
		
		/*########################################################*/
		/*                                                        */
		/*   STATIC                                               */
		/*                                                        */
		/*########################################################*/
		
		private static const usernames:Object = {};
		private static const usermails:Object = {};
		
		public static const DUMMY:User = new User("dummy", " ", "no@mail.to");
		
		/*########################################################*/
		/*                                                        */
		/*   CONSTRUCTOR                                          */
		/*                                                        */
		/*########################################################*/
		
		public function DummyAuthenticationService () {
			super(AuthenticationService);
			mapUser(DUMMY);
		}
		
		/*########################################################*/
		/*                                                        */
		/*   OVERRIDE / IMPLEMENT                                 */
		/*                                                        */
		/*########################################################*/
		
		public function login (username:String, password:String):ServiceCallResponder {
			responder = new InstantCallResponder(User);
			var user:User = getUser(username);
			
			if (user == null)
				return responder.withFaultMessage("unknown username");
			if (user.password != password)
				return responder.withFaultMessage("wrong password");
			
			return responder.withResult(user);
		}
		
		public function registerUser (username:String, password:String, mail:String):ServiceCallResponder {
			responder = new InstantCallResponder(Boolean);
			var errorMessage:String = mapUser(new User(username, password, mail)); //
			if (errorMessage != null)
				return responder.withFaultMessage(errorMessage);
			
			return responder.withResult(true);
		}
		
		public function logout ():ServiceCallResponder {
			return new InstantCallResponder(null).withResult();
		}
		
		/*########################################################*/
		/*                                                        */
		/*  PRIVATE HELPER/UTIL                                   */
		/*                                                        */
		/*########################################################*/
		
		private var responder:InstantCallResponder;
		
		private function getUser (username:String):User {
			return usernames[username] as User;
		}
		
		private function mapUser (user:User):String {
			if (userExists(user.username, user.mail))
				return "username or mail in use";
			usermails[user.mail] = user;
			usernames[user.username] = user;
			return null;
		}
		
		private function userExists (username:String, mail:String=null):Boolean {
			if (usernames[username] is User)
				return true;
			if (mail && usermails[mail] is User)
				return true;
			return false;
		
		}
	}

}