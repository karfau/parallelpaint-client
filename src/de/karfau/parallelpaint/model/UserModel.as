package de.karfau.parallelpaint.model
{
	import de.karfau.flexlogplus.*;
	import de.karfau.parallelpaint.events.AuthenticationEvent;
	import de.karfau.parallelpaint.messaging.MessagingProxy;
	import de.karfau.parallelpaint.model.vo.Drawing;
	import de.karfau.parallelpaint.model.vo.User;
	import de.karfau.typedcookies.TypedLocalSharedObjectMap;
	
	import flash.utils.Dictionary;
	
	import org.robotlegs.mvcs.Actor;
	
	[Bindable]
	public class UserModel extends Actor
	{
		
		private const _authorKeys:TypedLocalSharedObjectMap = new TypedLocalSharedObjectMap("pp_authorKeyMap", String);
		
		private var _currentUser:User = User.NOUSER;
		
		public function get currentUser ():User {
			return _currentUser || User.NOUSER;
		}
		
		public function set currentUser (value:User):void {
			_currentUser = value || User.NOUSER;
			MessagingProxy.sendingUser = _currentUser.username;
			MessagingProxy.ignoreMessagesFromSendingUser = isAuthenticated();
			verbose(this, "currentUser is now {0}", _currentUser);
			dispatch(new AuthenticationEvent(AuthenticationEvent.CURRENT_USER_CHANGED, _currentUser));
		}
		
		public function isAuthenticated ():Boolean {
			return _currentUser && _currentUser.username != User.NOUSER_NAME;
		}
		
		public function setNoUser ():void {
			currentUser = User.NOUSER;
		}
		
		public function persistAuthorKey (drawing:Drawing):void {
			if (currentUser == User.NOUSER) {
				verbose(this, ".persistAuthorKey({0}) persisting key <{1}>", drawing, drawing.author);
				_authorKeys.setValue(drawing.id + "", drawing.author);
			}
		}
		
		public function checkAuthorKey (drawingId:Number, authorkey:String):Boolean {
			var key:String = _authorKeys.getValue(drawingId + "") as String;
			verbose(this, ".checkAuthorKey({0}) found key <{1}>", [drawingId, authorkey], key);
			return authorkey == key;
		}
		
		public function removeAuthorKey (drawingId:Number):void {
			verbose(this, ".removeAuthorKey({0})", drawingId);
			_authorKeys.removeValue(drawingId + "");
		}
		
		public function getAuthorKeyMap ():Dictionary {
			return _authorKeys.getValueMap(validDrawingIdFilter);
		}
		
		private function validDrawingIdFilter (key:String):Object {
			var id:Number = key ? parseInt(key) : NaN;
			if (id > 0)
				return id;
			
			return null;
		}
	
	}
}