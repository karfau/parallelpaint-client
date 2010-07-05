package de.karfau.parallelpaint.view.components.tools.windows
{
	import de.karfau.parallelpaint.core.IDisplayMessage;
	import de.karfau.parallelpaint.core.tools.ShowWindowTool;

	import flash.events.MouseEvent;

	import mx.controls.Button;
	import mx.events.CloseEvent;

	import spark.components.TitleWindow;

	/**
	 *
	 * @author Karfau
	 */
	public class ToolWindow extends TitleWindow
	{
		[SkinPart(required="false")]
		/**
		 *
		 * @default
		 */
		public var minMaxButton:Button;

		/**
		 *
		 * @default
		 */
		public var tool:ShowWindowTool;

		/**
		 *
		 */
		public function ToolWindow () {
			super();
		}

		/**
		 *
		 * @return
		 */
		public function get anchor ():PopUpAnchor {
			return styleName as PopUpAnchor;
		}

		[Bindable]
		/**
		 *
		 * @default
		 */
		public var message:IDisplayMessage;

		/**
		 *
		 */
		public function reset ():void {
			message = null;
			showProgress(false);
		}

		/**
		 *
		 * @param clearInputs
		 */
		public function closeWindow (clearInputs:Boolean=true):void {
			if (clearInputs) {
				reset();
			}
			dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
		}

		override public function set currentState (value:String):void {
			message = null;
			showProgress(false);
			super.currentState = value;
		}

		/**
		 *
		 * @param isProgressing
		 */
		public function showProgress (isProgressing:Boolean):void {
			this.enabled = !isProgressing;
		}

	}
}