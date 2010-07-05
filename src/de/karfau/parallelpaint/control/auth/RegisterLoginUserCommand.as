package de.karfau.parallelpaint.control.auth
{
	import de.karfau.flexlogplus.*;
	import de.karfau.parallelpaint.core.ColoredDisplayMessage;
	import de.karfau.parallelpaint.core.ErrorDisplayMessage;
	import de.karfau.parallelpaint.core.elements.IElement;
	import de.karfau.parallelpaint.core.elements.ISelectable;
	import de.karfau.parallelpaint.events.AuthenticationEvent;
	import de.karfau.parallelpaint.events.DisplayMessageEvent;
	import de.karfau.parallelpaint.events.ElementEvent;
	import de.karfau.parallelpaint.model.DrawingModel;
	import de.karfau.parallelpaint.model.UserModel;
	import de.karfau.parallelpaint.model.vo.SpringSecurityAuthentication;
	import de.karfau.parallelpaint.model.vo.User;
	import de.karfau.parallelpaint.service.definition.AuthenticationService;
	import de.karfau.parallelpaint.service.definition.ElementPersistanceService;
	
	import flash.utils.Dictionary;
	
	import org.robotlegs.mvcs.Command;
	
	public class RegisterLoginUserCommand extends Command
	{
		
		/*########################################################*/
		/*                                                        */
		/*   PROPERTIES (INCL. SETTER/GETTER)                     */
		/*                                                        */
		/*########################################################*/
		
		[Inject]
		public var sPersistance:ElementPersistanceService;
		
		[Inject]
		public var authService:AuthenticationService;
		
		[Inject]
		public var event:AuthenticationEvent;
		
		[Inject]
		public var mUser:UserModel;
		
		[Inject]
		public var mDrawing:DrawingModel;
		
		/*########################################################*/
		/*                                                        */
		/*   OVERRIDE / IMPLEMENT                                 */
		/*                                                        */
		/*########################################################*/
		
		override public function execute ():void {
			debug(this, ".execute( ) with event.type {0}", event.type);
			if (event.type == AuthenticationEvent.REGISTER)
				authService.registerUser(event.user.username, event.user.password, event.user.mail)
					.setOnResult(registerResult).setOnFault(handleFault);
			else if (event.type == AuthenticationEvent.LOGIN)
				executeLogin();
		}
		
		private var selectedElement:ISelectable;
		
		public function executeLogin ():void {
			//unselect and remember selection to avoid selection by anonymousAuthorX
			selectedElement = mDrawing.selectedElement;
			if (selectedElement != null)
				dispatch(new ElementEvent(ElementEvent.UNSELECT_ELEMENT, IElement(selectedElement)));
			
			authService.login(event.user.username, event.user.password)
				.setOnResult(loginResult).setOnFault(handleFault);
		}
		
		/*########################################################*/
		/*                                                        */
		/*  PRIVATE HELPER/UTIL                                   */
		/*                                                        */
		/*########################################################*/
		
		private function handleFault (error:Error):void {
			reselect();
			dispatch(DisplayMessageEvent.createErrorMessageEvent(DisplayMessageEvent.AUTHENTICATION_FAULT, error));
		}
		
		private function registerResult (success:Boolean):void {
			dispatch(new DisplayMessageEvent(DisplayMessageEvent.REGISTER_SUCCESS,
																			 new ColoredDisplayMessage("'" + event.user.username + "' registered successfully.")));
		}
		
		private function loginResult (auth:SpringSecurityAuthentication):void {
			mUser.currentUser = new User(auth.username);
			dispatch(new AuthenticationEvent(AuthenticationEvent.UPDATE_TOOL_ACCESS));
			//get existing authorkeys
			var existingAuthorKeys:Dictionary = mUser.getAuthorKeyMap();
			for (var i:* in existingAuthorKeys) {
				takeOwnership(i as Number, existingAuthorKeys[i]);
			}
			//take ownership for each and remove it from the list
			//if the current one was affected it has to be updated (by messageing)
			
			reselect();
		}
		
		private function takeOwnership (drawingId:Number, authorKey:String):void {
			verbose(this, ".takeOwnership({0},{1}) ", drawingId, authorKey);
			sPersistance.setRegisteredDrawingAuthor(drawingId, authorKey).setOnFault(handleFault).setOnResult(takeOwnershipResult);
		}
		
		private function takeOwnershipResult (drawingId:Number):void {
			verbose(this, ".takeOwnershipResult({0})", drawingId);
			mUser.removeAuthorKey(drawingId);
		}
		
		private function takeOwnershipFault (fault:Error):void {
			warn(this, ".takeOwnershipFault({0})", fault);
			//FIXME: SilentFail on each login
		}
		
		private function reselect ():void {
			if (selectedElement != null)
				dispatch(new ElementEvent(ElementEvent.SELECT_ELEMENT, IElement(selectedElement)));
		}
	
	}
}