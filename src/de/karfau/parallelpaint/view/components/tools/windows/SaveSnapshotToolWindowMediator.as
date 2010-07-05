package de.karfau.parallelpaint.view.components.tools.windows
{
	import de.karfau.parallelpaint.events.DisplayMessageEvent;
	import de.karfau.parallelpaint.events.StringEvent;

	import flash.events.MouseEvent;

	public class SaveSnapshotToolWindowMediator extends ToolWindowMediatorBase
	{
		[Inject]
		public var window:SaveSnapshotToolWindow;

		public override function onRegister ():void {
			eventMap.mapListener(eventDispatcher,DisplayMessageEvent.SNAPSHOT_DONE,processSnapshotDone,DisplayMessageEvent);

			eventMap.mapListener(window.btTakeSnapshot, MouseEvent.CLICK, handleBtTakeSnapshotClick, MouseEvent);
		}



		private function processSnapshotDone (event:DisplayMessageEvent):void {
			window.closeWindow();
		}

		private function handleBtTakeSnapshotClick (event:MouseEvent):void {
			dispatch(new StringEvent(StringEvent.TAKE_SNAPSHOT, window.tiVersionTag.text));
		}

	}
}