package de.karfau.parallelpaint.control.auth
{
	import de.karfau.flexlogplus.*
	import de.karfau.parallelpaint.events.AuthenticationEvent;
	import de.karfau.parallelpaint.events.DisplayMessageEvent;
	import de.karfau.parallelpaint.model.UserModel;
	import de.karfau.parallelpaint.service.definition.AuthenticationService;
	import org.robotlegs.mvcs.Command;
	
	public class LogoutUserCommand extends Command
	{
		
		/*########################################################*/
		/*                                                        */
		/*   PROPERTIES (INCL. SETTER/GETTER)                     */
		/*                                                        */
		/*########################################################*/
		
		[Inject]
		public var authService:AuthenticationService;
		
		[Inject]
		public var event:AuthenticationEvent;
		
		[Inject]
		public var mUser:UserModel;
		
		/*########################################################*/
		/*                                                        */
		/*   OVERRIDE / IMPLEMENT                                 */
		/*                                                        */
		/*########################################################*/
		
		override public function execute ():void {
			debug(this, ".execute( ) ");
			authService.logout().setOnResult(logoutResult).setOnFault(handleFault);
		}
		
		/*########################################################*/
		/*                                                        */
		/*  PRIVATE HELPER/UTIL                                   */
		/*                                                        */
		/*########################################################*/
		
		private function logoutResult ():void {
			mUser.setNoUser();
			dispatch(new AuthenticationEvent(AuthenticationEvent.UPDATE_TOOL_ACCESS));
		}
		
		private function handleFault (error:Error):void {
			dispatch(DisplayMessageEvent.createErrorMessageEvent(DisplayMessageEvent.UNEXPECTED_ERROR, error));
		}
	}
}