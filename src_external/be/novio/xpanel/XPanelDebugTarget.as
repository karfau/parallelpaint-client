package be.novio.xpanel{
	import mx.logging.targets.LineFormattedTarget;
	import flash.events.StatusEvent;
	import mx.logging.LogEvent;
	import mx.logging.LogEventLevel;
	import mx.logging.ILogger;
	import flash.utils.getTimer;
	import flash.net.LocalConnection;

	/**
	 *  Provides a logger target that outputs to a <code>LocalConnection</code>,
	 *  connected to the Debug application.
	 */
	public class XPanelDebugTarget extends LineFormattedTarget {

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
	
	    /**
	     *  Constructor.
		 *
		 *  <p>Constructs an instance of a logger target that will send
		 *  the log data to the Debug application.</p>
		 *
	     *  @param defines the Debug application connection string
	     *
	     *  @param defines what method to call on the Debug application connection.
	     */
	    public function XPanelDebugTarget(connection:String = "_xpanel1",
										method:String = "dispatchMessage") {
			super();
			
			lc = new LocalConnection();
	        lc.addEventListener(StatusEvent.STATUS, statusEventHandler,false,0,true);
	        this.connection = connection;
	        this.method = method;
	    }
    
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
	
	    /**
	     *  @private
	     */
	    private var lc:LocalConnection;
	    
	    /**
	     *  @private
	     *  The name of the method to call on the Debug application connection.
	     */
	    private var method:String;
	
	    /**
	     *  @private
	     *  The name of the connection string to the Debug application.
	     */
	    private var connection:String;   

		//--------------------------------------------------------------------------
		//
		//  EventListener
		//
		//--------------------------------------------------------------------------
	
	    private function statusEventHandler(event:StatusEvent):void {
	        ;//trace("statusEventHandler: " + event);
	    }


		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
	
	    /**
	     *  Override to send the data in the format of XPanel
	     */
	    override public function logEvent(event:LogEvent):void
	    {
	    	var level:int = event.level;
			if( event.level == LogEventLevel.ALL || 
				event.level == LogEventLevel.INFO )
				level = 0x02;
			else if( event.level == LogEventLevel.DEBUG )
				level = 0x01;
			else if( event.level == LogEventLevel.WARN )
				level = 0x04;
			else if( event.level == LogEventLevel.ERROR ||
				event.level == LogEventLevel.FATAL )
				level = 0x08;
	
	 		var category:String = includeCategory ?
								  ILogger(event.target).category + fieldSeparator :
								  "";
			
			try {
				//lc.send( "_xpanel1", "dispatchMessage", flash.utils.getTimer(), event.message, level );
				lc.send( connection, method, flash.utils.getTimer(), category + event.message, level);
		        //internalLog(date + level + category + event.message);
			} catch (error:ArgumentError) {
				lc.send( connection, method, flash.utils.getTimer(), "Logging failed: " + error.message, LogEventLevel.ERROR);
			}
    	}
  
	}

}