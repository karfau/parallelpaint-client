package de.karfau.parallelpaint.core
{
	
	import be.novio.xpanel.XPanelDebugTarget;
	
	import com.soenkerohde.logging.SOSLoggingTarget;
	
	import de.karfau.flexlogplus.*;
	import de.karfau.parallelpaint.control.*;
	import de.karfau.parallelpaint.control.auth.*;
	import de.karfau.parallelpaint.control.drawing.*;
	import de.karfau.parallelpaint.control.element.*;
	import de.karfau.parallelpaint.events.*;
	import de.karfau.parallelpaint.messaging.MessagingProxy;
	import de.karfau.parallelpaint.messaging.MessagingTypes;
	import de.karfau.parallelpaint.model.*;
	import de.karfau.parallelpaint.service.*;
	import de.karfau.parallelpaint.service.amf.*;
	import de.karfau.parallelpaint.service.definition.*;
	import de.karfau.parallelpaint.service.dummy.*;
	import de.karfau.parallelpaint.service.local.SWFAdressNavigationService;
	import de.karfau.parallelpaint.view.*;
	import de.karfau.parallelpaint.view.components.DrawingEditor;
	import de.karfau.parallelpaint.view.components.DrawingEditorMediator;
	import de.karfau.parallelpaint.view.components.layers.*;
	import de.karfau.parallelpaint.view.components.tools.*;
	import de.karfau.parallelpaint.view.components.tools.windows.*;
	import de.karfau.parallelpaint.view.renderer.DraggableElementSprite;
	import de.karfau.parallelpaint.view.renderer.DraggableElementSpriteMediator;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.KeyboardEvent;
	
	import mx.events.DragEvent;
	import mx.logging.LogEventLevel;
	import mx.logging.targets.TraceTarget;
	import mx.managers.FocusManager;
	import mx.messaging.config.ServerConfig;
	
	import org.robotlegs.core.IContext;
	import org.robotlegs.mvcs.Context;
	
	public class PaintContext extends Context implements IContext
	{
		
		public function PaintContext (contextView:DisplayObjectContainer=null, autoStartup:Boolean=true) {
			super(contextView, autoStartup);
		}
		
		override public function startup ():void {
			
			//### Logging ###
			LogConfig.addTarget(SOSLoggingTarget, true);
			LogConfig.addTarget(XPanelDebugTarget, false);
			LogConfig.addTarget(TraceTarget, false);
			LogConfig.startUp(LogEventLevel.INFO, LogUtil.getFilter(
				//["de.karfau.parallelpaint.*", "index"]
				//["*"] //Everything
												["de.karfau.parallelpaint.*"] //only from app
												//[[PaintContext], "*Mediator", "*Command", "*Service", "*Model"]//selected layers
												));
			
			//### Singeltons/Model ###
			
			injector.mapSingleton(InteractionModel);
			injector.mapSingleton(DrawingModel);
			injector.mapSingleton(UserModel);
			//injector.mapSingleton(ElementSelectionController);
			injector.mapSingleton(TransferFactory);
			injector.mapValue(MessagingProxy, new MessagingProxy(["my-polling-amf"]));
			
			//### Services ###
			
			//local Services
			injector.mapValue(NavigationService, new SWFAdressNavigationService());
			
			//Destinations
			ServiceConfig.INSTANCE.channelEndpoint = "http://{server.name}:8080/SpringJPATC_02/messagebroker/amf";
			ServiceConfig.INSTANCE.mapServiceInterface(AuthenticationService, "userService");
			ServiceConfig.INSTANCE.mapServiceInterface(ElementPersistanceService, "elementPersistanceService");
			
			//InjectorMapping
			//injector.mapClass(AuthenticationService, DummyAuthenticationService);
			injector.mapClass(AuthenticationService, AMFAuthenticationService);
			
			//injector.mapClass(ElementPersistanceService, DummyElementPersistanceService);
			injector.mapClass(ElementPersistanceService, AMFElementPersistanceService);
			
			//### Mediators ###
			
			mediatorMap.mapView(index, ApplicationMediator);
			
			mediatorMap.mapView(DisplayLayer, DisplayLayerMediator);
			mediatorMap.mapView(InteractionLayer, InteractionLayerMediator);
			
			mediatorMap.mapView(DraggableElementSprite, DraggableElementSpriteMediator);
			
			mediatorMap.mapView(ToolButton, ToolButtonMediator, ToolButton);
			mediatorMap.mapView(StyleToolWindow, StyleToolWindowMediator);
			mediatorMap.mapView(AuthenticateToolWindow, AuthenticateToolWindowMediator);
			mediatorMap.mapView(ExportToolWindow, ExportToolWindowMediator);
			mediatorMap.mapView(SaveSnapshotToolWindow, SaveSnapshotToolWindowMediator);
			mediatorMap.mapView(ShareDrawingToolWindow, ShareDrawingToolWindowMediator);
			mediatorMap.mapView(DrawingEditor, DrawingEditorMediator);
			
			//### Commands ###
			
			commandMap.mapEvent(ElementEvent.ADD_ELEMENT, AddElementCommand, ElementEvent);
			commandMap.mapEvent(ElementEvent.SELECT_ELEMENT, ElementSelectionCommand, ElementEvent);
			commandMap.mapEvent(ElementEvent.UNSELECT_ELEMENT, ElementSelectionCommand, ElementEvent);
			commandMap.mapEvent(ElementEvent.UPDATE_ELEMENT, UpdateElementCommand, ElementEvent);
			commandMap.mapEvent(ElementEvent.REMOVE_ELEMENT, RemoveElementCommand, ElementEvent);
			commandMap.mapEvent(ElementStyleEvent.CHANGE_STROKE_STYLE, StyleChangedCommand, ElementStyleEvent);
			commandMap.mapEvent(ElementStyleEvent.CHANGE_FILL_STYLE, StyleChangedCommand, ElementStyleEvent);
			
			commandMap.mapEvent(ToolEvent.TOOL_CLICK, ToolClickCommand, ToolEvent);
			commandMap.mapEvent(ToolEvent.CLOSE_WINDOW, CloseToolWindowCommand, ToolEvent);
			commandMap.mapEvent(KeyboardEvent.KEY_DOWN, KeyDownCommand, KeyboardEvent);
			
			commandMap.mapEvent(AuthenticationEvent.AUTO_LOGIN, AutoLoginCommand, AuthenticationEvent);
			commandMap.mapEvent(AuthenticationEvent.REGISTER, RegisterLoginUserCommand, AuthenticationEvent);
			commandMap.mapEvent(AuthenticationEvent.LOGIN, RegisterLoginUserCommand, AuthenticationEvent);
			commandMap.mapEvent(AuthenticationEvent.LOGOUT, LogoutUserCommand, AuthenticationEvent);
			commandMap.mapEvent(AuthenticationEvent.UPDATE_TOOL_ACCESS, UpdateToolAccessCommand, AuthenticationEvent);
			
			commandMap.mapEvent(DrawingEvent.SET_DRAWING, SetDrawingCommand, DrawingEvent);
			commandMap.mapEvent(DrawingEvent.CREATE_DRAWING, CreateDrawingCommand, DrawingEvent);
			
			commandMap.mapEvent(ExportEvent.EXPORT_DRAWING, ExportDrawingCommand, ExportEvent);
			commandMap.mapEvent(StringEvent.TAKE_SNAPSHOT, TakeSnapshotCommand, StringEvent);
			
			commandMap.mapEvent(MessagingTypes.ADD_ELEMENT, AddElementMessageCommand, MessagingEvent);
			commandMap.mapEvent(MessagingTypes.REMOVE_ELEMENT, RemoveElementMessageCommand, MessagingEvent);
			commandMap.mapEvent(MessagingTypes.UPDATE_ELEMENT, UpdateElementMessageCommand, MessagingEvent);
			commandMap.mapEvent(MessagingTypes.UNSELECT_ELEMENT, ElementSelectionMessageCommand, MessagingEvent);
			commandMap.mapEvent(MessagingTypes.SELECT_ELEMENT, ElementSelectionMessageCommand, MessagingEvent);
			
			//manually start mediation for contextView
			mediatorMap.createMediator(contextView);
			
			eventDispatcher.dispatchEvent(new AuthenticationEvent(AuthenticationEvent.AUTO_LOGIN));
		
		}
	}
}