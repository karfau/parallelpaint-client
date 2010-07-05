package de.karfau.parallelpaint.service.definition
{
	import de.karfau.parallelpaint.service.callresponder.ServiceCallResponder;
	
	import mx.rpc.IResponder;
	
	/**
	 *
	 * @author Karfau
	 */
	public interface AuthenticationService
	{
		
		/**
		 *
		 * @return result-type:String, fault-type:Error
		 */
		function getCurrentAuthenticatedUser ():ServiceCallResponder;
		
		/**
		 *
		 * @param username
		 * @param password
		 *
		 * @return result-type:SpringSecurityAuthentication, fault-type:Error
		 */
		function login (username:String, password:String):ServiceCallResponder;
		/**
		 *
		 * @param username
		 * @param password
		 * @param mail
		 *
		 * @return result-type:boolean, fault-type:Error(UserExistsException)
		 */
		function registerUser (username:String, password:String, mail:String):ServiceCallResponder; //
		/**
		 *
		 * @return result-type:void, fault-type:Error
		 */
		function logout ():ServiceCallResponder;
		
		/**
		 *
		 * @return result-type:void, fault-type:Error(NotImplementedException)
		 */
		function setAutoLogin (autoLoginKey:String):ServiceCallResponder;
		
		/**
		 *
		 * @return result-type:String, fault-type:Error(NotImplementedException)
		 */
		function autoLogin (autoLoginKey:String):ServiceCallResponder;
	
	}
}