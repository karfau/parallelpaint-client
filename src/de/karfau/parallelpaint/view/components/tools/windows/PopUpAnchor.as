package de.karfau.parallelpaint.view.components.tools.windows
{
	import de.karfau.flexlogplus.ludicrous;
	
	import flash.events.Event;
	import flash.geom.Point;
	
	import mx.core.IFlexDisplayObject;
	import mx.events.CloseEvent;
	import mx.events.ResizeEvent;
	
	import spark.components.PopUpAnchor;
	
	[Event(name="showPopup", type="flash.events.Event")]
	//[Event(name="hidePopup", type="flash.events.Event")]
	
	public class PopUpAnchor extends spark.components.PopUpAnchor
	{
		
		public static const SHOW_POPUP:String = "showPopup";
		
		//public static const HIDE_POPUP:String = "hidePopup";
		
		public function PopUpAnchor () {
			super();
		
		}
		
		public override function set displayPopUp (value:Boolean):void {
			if (displayPopUp != value) {
				super.displayPopUp = value;
				if (popUp != null) {
					if (displayPopUp) {
						dispatchEvent(new Event(SHOW_POPUP, true));
							//ToolWindow(popUp).addEventListener(ResizeEvent.RESIZE, handlePopupResize)
							//ToolWindow(popUp).addEventListener(, handlePopupResize)
					} else {
						popUp.dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
						ToolWindow(popUp).removeEventListener(ResizeEvent.RESIZE, handlePopupResize)
						/*if (adjustableHeight)
							 this.height = 0;
							 if (adjustableWidth)
						 this.width = 0;*/
					}
				}
				
			}
		}
		
		protected override function updateDisplayList (unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			ludicrous(this, ".updateDisplayList(...)" +
								"w " + width + "(" + adjustableWidth + ")," +
								"h " + height + "(" + adjustableHeight + ")");
		}
		
		private function handlePopupResize (event:ResizeEvent):void {
			invalidateDisplayList();
		}
		
		public var adjustableHeight:Boolean = false;
		public var adjustableWidth:Boolean = false;
		
		override protected function calculatePopUpPosition ():Point {
			var result:Point = super.calculatePopUpPosition();
			//FIXME:changing height/width resets the position of the popup. maybe padding helps?
			var localPos:Point = this.globalToLocal(result);
			
			if (adjustableHeight && (localPos.x == 0 || localPos.x == -1 * popUp.width)) {
				this.height = popUp.height;
			} else {
				//this.height = 0;
			}
			if (adjustableWidth && (localPos.y == 0 || localPos.y == -1 * popUp.height)) {
				this.width = popUp.width;
			} else {
				//this.width = 0;
			}
			ludicrous(this, ".calculatePopUpPosition() result:" + result +
								"w " + width + "(" + adjustableWidth + ")," +
								"h " + height + "(" + adjustableHeight + ")" + localPos);
			return result;
		}
	
	}
}