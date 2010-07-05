package de.karfau.parallelpaint.model.vo
{
	import de.karfau.flexlogplus.*;
	
	public class SpringSecurityAuthentication
	{
		
		/*########################################################*/
		/*                                                        */
		/*   STATIC                                               */
		/*                                                        */
		/*########################################################*/
		
		private static const authorities:String = "authorities";
		private static const name:String = "name";
		
		public static const ROLE_USER:String = "ROLE_USER";
		
		/*########################################################*/
		/*                                                        */
		/*   PROPERTIES (INCL. SETTER/GETTER)                     */
		/*                                                        */
		/*########################################################*/
		
		private const roleMap:Object = {};
		private const _roles:Array = [];
		
		public function get roles ():Array {
			return _roles.concat();
		}
		
		private var _username:String;
		
		public function get username ():String {
			return _username;
		}
		
		/*########################################################*/
		/*                                                        */
		/*   CONSTRUCTOR                                          */
		/*                                                        */
		/*########################################################*/
		
		public function SpringSecurityAuthentication (authResult:Object) {
			for each (var role:String in authResult[authorities]) {
				roleMap[role] = true;
				_roles.push(role);
			}
			_username = authResult[name];
			verbose(this, ".SpringSecurityAuthentication({0}) has been constructed: {1}", authResult, this);
		}
		
		/*########################################################*/
		/*                                                        */
		/*   OVERRIDE / IMPLEMENT                                 */
		/*                                                        */
		/*########################################################*/
		
		public function hasRole (role:String):Boolean {
			return Boolean(roleMap[role]);
		}
		
		public function toString ():String {
			return "SpringSecurityAuthentication{username:'" + username + "', roles:[" + roles.join(",") + "]}";
		}
	
	}
}