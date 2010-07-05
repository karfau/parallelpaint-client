package de.karfau.parallelpaint.control
{
	import de.karfau.flexlogplus.*;

	import org.robotlegs.mvcs.Command;

	public class AbstractCommand extends Command
	{

		protected function handleFault (error:Error):void {
			fatal(this,".handleFault({0}) ",error);
			throw error;
		}
	}
}