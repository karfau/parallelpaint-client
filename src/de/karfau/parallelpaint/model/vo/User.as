package de.karfau.parallelpaint.model.vo
{
	
	//[RemoteClass(alias="model.User")]
	public class User //TODO: as ValueObject?
	{
		public static const NOUSER_NAME:String = "anonymousUser";
		public static const NOUSER:User = new User(NOUSER_NAME, "", "");
		
		public var username:String;
		public var password:String;
		public var mail:String;
		
		public function User (username:String=null, password:String=null, mail:String=null) {
			this.username = username;
			this.password = password;
			this.mail = mail;
			super();
		}
		
		public function toString ():String {
			return "User{username:\"" + username + "\", mail:\"" + mail + "\"}";
		}
	
	}
}