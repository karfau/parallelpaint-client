package de.karfau.parallelpaint.view.components.tools.windows
{
	import de.karfau.parallelpaint.events.AuthenticationEvent;
	import de.karfau.parallelpaint.events.DisplayMessageEvent;
	import de.karfau.parallelpaint.model.UserModel;
	import de.karfau.parallelpaint.model.vo.User;
	import de.karfau.parallelpaint.service.definition.AuthenticationService;
	
	import flash.events.Event;
	
	import org.robotlegs.core.IMediator;
	
	public class AuthenticateToolWindowMediator extends ToolWindowMediatorBase implements IMediator
	{
		[Inject]
		public var window:AuthenticateToolWindow;
		
		/*[Inject]
		 public var mDrawing:DrawingModel;*/
		
		/*[Inject]
		 public var mInteraction:InteractionModel;*/
		
		[Inject]
		public var mUser:UserModel;
		
		[Inject]
		public var authService:AuthenticationService;
		
		override public function onRegister ():void {
			eventMap.mapListener(window, AuthenticationEvent.REGISTER, handleRegister, Event);
			registerDisplayMessage(DisplayMessageEvent.REGISTER_SUCCESS, processRegisterSuccess);
			
			eventMap.mapListener(window, AuthenticationEvent.LOGIN, handleLogin, Event);
			registerDisplayMessage(DisplayMessageEvent.AUTHENTICATION_FAULT);
			
			eventMap.mapListener(eventDispatcher, AuthenticationEvent.CURRENT_USER_CHANGED, processCurrentUserChanged, AuthenticationEvent);
		}
		
		private function handleLogin (event:Event):void {
			var user:User = window.validUser;
			if (user != null) {
				window.showProgress(true);
				if (window.autoLogin) {
					//LATER: LOGIN_ENABLE_AUTO: registreiren und im Command was vom BE speichern im LocalSharedObject
					dispatch(new AuthenticationEvent(AuthenticationEvent.LOGIN_ENABLE_AUTO, user)); //LOGIN_ENABLE_AUTO
				} else {
					dispatch(new AuthenticationEvent(AuthenticationEvent.LOGIN, user));
				}
			}
		}
		
		private function handleRegister (event:Event):void {
			var user:User = window.validUser;
			if (user != null) {
				window.showProgress(true);
				dispatch(new AuthenticationEvent(AuthenticationEvent.REGISTER, user));
			}
		}
		
		private function processRegisterSuccess (event:DisplayMessageEvent):void {
			var user:User = window.validUser;
			window.showLogin();
			window.username = user.username;
			window.password = user.password;
			super.processDisplayMessage(event);
		}
		
		protected function processCurrentUserChanged (event:AuthenticationEvent):void {
			if (event.user === User.NOUSER) {
				window.showLogin();
			} else {
				window.reset();
				window.username = event.user.username;
				window.closeWindow(false);
			}
		}
	
	}
}