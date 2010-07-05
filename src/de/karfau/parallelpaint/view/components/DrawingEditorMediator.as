package de.karfau.parallelpaint.view.components
{
	import de.karfau.parallelpaint.core.tools.ToolAccess;
	import de.karfau.parallelpaint.events.AuthenticationEvent;
	import de.karfau.parallelpaint.events.DisplayMessageEvent;
	import de.karfau.parallelpaint.events.DrawingEvent;
	import de.karfau.parallelpaint.events.ElementEvent;
	import de.karfau.parallelpaint.events.MessagingEvent;
	import de.karfau.parallelpaint.messaging.MessagingTypes;
	import de.karfau.parallelpaint.model.DrawingModel;
	import de.karfau.parallelpaint.model.InteractionModel;
	import de.karfau.parallelpaint.model.vo.User;
	import de.karfau.parallelpaint.view.components.tools.windows.AuthenticateToolWindow;
	
	import flash.events.Event;
	
	import mx.messaging.events.MessageEvent;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class DrawingEditorMediator extends Mediator
	{
		private var accessForAuthor:ToolAccess = new ToolAccess(ToolAccess.REQ_AUTHOR);
		private var accessForUser:ToolAccess = new ToolAccess(ToolAccess.REQ_USER);
		
		[Inject]
		public var editor:DrawingEditor;
		
		[Inject]
		public var mInteraction:InteractionModel;
		
		[Inject]
		public var mDrawing:DrawingModel;
		
		public override function onRegister ():void {
			eventMap.mapListener(eventDispatcher, MessagingTypes.TEST, processStatusMessage, MessagingEvent);
			/*eventMap.mapListener(eventDispatcher, MessagingTypes.SELECT_ELEMENT, processStatusMessage, MessagingEvent);
				 eventMap.mapListener(eventDispatcher, MessagingTypes.UNSELECT_ELEMENT, processStatusMessage, MessagingEvent);
				 eventMap.mapListener(eventDispatcher, MessagingTypes.UPDATE_ELEMENT, processStatusMessage, MessagingEvent);
				 eventMap.mapListener(eventDispatcher, MessagingTypes.ADD_ELEMENT, processStatusMessage, MessagingEvent);
			 eventMap.mapListener(eventDispatcher, MessagingTypes.REMOVE_ELEMENT, processStatusMessage, MessagingEvent);*/
			
			eventMap.mapListener(eventDispatcher, AuthenticationEvent.TOOL_ACCESS_UPDATED, processToolAccessUpdated, AuthenticationEvent);
			eventMap.mapListener(eventDispatcher, ElementEvent.SELECTION_CHANGED, processSelectionChanged, ElementEvent);
			
			eventMap.mapListener(eventDispatcher, DrawingEvent.DRAWING_CHANGED, processDrawingChanged, DrawingEvent);
			
			eventMap.mapListener(eventDispatcher, DisplayMessageEvent.SNAPSHOT_DONE, processSnapshotDone, DisplayMessageEvent);
			
			eventMap.mapListener(eventDispatcher, AuthenticationEvent.CURRENT_USER_CHANGED, processCurrentUserChanged, AuthenticationEvent);
		}
		
		private function processStatusMessage (event:MessagingEvent):void {
			editor.addStatusMessage(event.toString());
		}
		
		private function processToolAccessUpdated (event:AuthenticationEvent):void {
			var currentAccess:uint = mInteraction.getCurrentToolsAccess();
			var isAllowedToUpdate:Boolean = mDrawing.drawingVersionOf == 0 && (accessForAuthor.getVisible(currentAccess) || accessForUser.getVisible(currentAccess));
			editor.currentState = isAllowedToUpdate ? DrawingEditor.STATE_EDIT : DrawingEditor.STATE_VIEW;
		}
		
		private function processSelectionChanged (event:ElementEvent):void {
			editor.selectionExists = mDrawing.selectedElement != null;
		}
		
		private function processDrawingChanged (event:DrawingEvent):void {
			editor.drawingSet = event.drawingId > 0;
			editor.versionDetails = mDrawing.drawingId <= 0 || mDrawing.drawingVersionOf == 0 ? null : "version of #" + mDrawing.drawingVersionOf + " (" + mDrawing.drawingVersionTag + ")";
		}
		
		private function processCurrentUserChanged (event:AuthenticationEvent):void {
			editor.username = event.user == User.NOUSER ? null : event.user.username;
		}
		
		private function processSnapshotDone (event:DisplayMessageEvent):void {
			editor.addStatusMessage(event.message.message);
		}
	
	}
}