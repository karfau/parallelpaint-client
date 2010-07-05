package de.karfau.parallelpaint.events
{
	import de.karfau.parallelpaint.model.vo.User;
	
	import flash.events.Event;
	
	public class AuthenticationEvent extends Event
	{
		public static const REGISTER:String = "register";
		public static const LOGIN:String = "login";
		public static const AUTO_LOGIN:String = "autoLogin";
		public static const LOGIN_ENABLE_AUTO:String = "loginEnableAuto";
		public static const LOGOUT:String = "logout";
		public static const CURRENT_USER_CHANGED:String = "currentUserChanged";
		
		public static const UPDATE_TOOL_ACCESS:String = "updateToolAccess";
		public static const TOOL_ACCESS_UPDATED:String = "toolAccessUpdated";
		
		protected var _user:User;
		
		public function AuthenticationEvent (type:String, user:User=null) {
			super(type);
			_user = user;
		}
		
		public function get user ():User {
			return _user;
		}
		
		override public function clone ():Event {
			return new AuthenticationEvent(type, user);
		}
	
	}
}