package de.karfau.parallelpaint.control.auth
{
	import de.karfau.flexlogplus.*;
	import de.karfau.parallelpaint.control.AbstractCommand;
	import de.karfau.parallelpaint.events.AuthenticationEvent;
	import de.karfau.parallelpaint.model.UserModel;
	import de.karfau.parallelpaint.model.vo.SpringSecurityAuthentication;
	import de.karfau.parallelpaint.model.vo.User;
	import de.karfau.parallelpaint.service.definition.AuthenticationService;
	
	public class AutoLoginCommand extends AbstractCommand
	{
		
		[Inject]
		public var mUser:UserModel;
		
		[Inject]
		public var sAuth:AuthenticationService;
		
		[Inject]
		public var event:AuthenticationEvent;
		
		public override function execute ():void {
			debug(this, ".execute( ) ");
			//if the user refreshed the app,the session could still be alive
			sAuth.getCurrentAuthenticatedUser().setOnResult(getAuthUserResult).setOnFault(getAuthUserFault);
		}
		
		private function getAuthUserResult (authentication:String):void {
			debug(this, ".getAuthUserResult({0}) ", authentication);
			if (authentication != null) {
				applyAuthenticationAsUser(authentication);
			} else {
				executeAutoLogin();
			}
		}
		
		private function getAuthUserFault (error:Error):void {
			info(this, ".getAuthUserFault(...) user has not been logged in or there was no session to restore authentication from");
			executeAutoLogin();
		}
		
		private function executeAutoLogin ():void {
			info(this, ".executeAutoLogin(...) not implemented ");
			//TODO:use autologin from flashcookie
		/*
			 var autoLoginKey:String = mUser.autoLoginKey;
			 if(autoLoginKey){
			 sAuth.autoLogin(autoLoginKey).setOnResult(autoLoginResult).setOnFault(handleFault);
			 }
		 */
		}
		
		private function autoLoginResult (authentication:String):void {
			debug(this, ".autoLoginResult({0}) ", authentication);
			if (authentication != null) {
				applyAuthenticationAsUser(authentication);
			}
		}
		
		private function applyAuthenticationAsUser (authentication:String):void {
			debug(this, ".applyAuthenticationAsUser({0}) ", authentication);
			if (authentication != null) {
				mUser.currentUser = new User(authentication);
				dispatch(new AuthenticationEvent(AuthenticationEvent.UPDATE_TOOL_ACCESS));
			}
		}
	
	}
}