package de.karfau.parallelpaint.view
{
	import de.karfau.flexlogplus.*;
	import de.karfau.parallelpaint.model.InteractionModel;
	import de.karfau.parallelpaint.service.definition.ElementPersistanceService;
	import de.karfau.parallelpaint.view.components.tools.windows.PopUpAnchor;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	import org.robotlegs.core.IMediator;
	import org.robotlegs.mvcs.Mediator;
	
	public class ApplicationMediator extends Mediator implements IMediator
	{
		/*[Inject]
		 public var interactionModel:InteractionModel;*/
		
		[Inject]
		public var app:index;
		
		override public function onRegister ():void {
			eventMap.mapListener(app.stage, KeyboardEvent.KEY_DOWN, forward, KeyboardEvent, true);
			eventMap.mapListener(app, PopUpAnchor.SHOW_POPUP, handleShowPopup, Event, true);
			//eventMap.mapListener(app,PopUpAnchor.HIDE_POPUP, handleHidePopup,Event,true);
		}
		
		private function handleShowPopup (event:Event):void {
			mediatorMap.createMediator(PopUpAnchor(event.target).popUp);
		}
		
		/*private function handleHidePopup(event:Event):void {
		
		 }*/
		
		private function forward (event:KeyboardEvent):void {
			verbose(this, ".forward({0}) ", event);
			dispatch(event);
		}
	}
}