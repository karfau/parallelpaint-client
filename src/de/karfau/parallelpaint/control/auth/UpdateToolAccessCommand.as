package de.karfau.parallelpaint.control.auth
{
	import de.karfau.flexlogplus.*;
	import de.karfau.parallelpaint.core.tools.ToolAccess;
	import de.karfau.parallelpaint.events.AuthenticationEvent;
	import de.karfau.parallelpaint.model.DrawingModel;
	import de.karfau.parallelpaint.model.InteractionModel;
	import de.karfau.parallelpaint.model.UserModel;
	import de.karfau.parallelpaint.model.vo.User;

	import org.robotlegs.mvcs.Command;

	public class UpdateToolAccessCommand extends Command
	{

		/*########################################################*/
		/*                                                        */
		/*   PROPERTIES (INCL. SETTER/GETTER)                     */
		/*                                                        */
		/*########################################################*/

		[Inject]
		public var event:AuthenticationEvent;

		[Inject]
		public var mDrawing:DrawingModel;

		[Inject]
		public var mInteraction:InteractionModel;

		[Inject]
		public var mUser:UserModel;

		/*########################################################*/
		/*                                                        */
		/*   OVERRIDE / IMPLEMENT                                 */
		/*                                                        */
		/*########################################################*/

		override public function execute ():void {
			debug(this, ".execute( ) ");

			var currentLvl:uint = 0;

			//ignoring the user given by the event:we alsways use the one from the UserModel
			var user:User = mUser.currentUser;

			if (mUser.isAuthenticated())
				currentLvl = ToolAccess.combineAccess(ToolAccess.REQ_USER);

			if (mDrawing.drawingId>0) {
				if (mDrawing.drawingAuthor == user.username) {
					currentLvl = ToolAccess.combineAccess(currentLvl, ToolAccess.REQ_AUTHOR);
				} else if (mUser.checkAuthorKey(mDrawing.drawingId, mDrawing.drawingAuthor)) {
					currentLvl = ToolAccess.combineAccess(currentLvl, ToolAccess.REQ_AUTHOR);
				}
			}

			verbose(this, ".execute( ) is setting detected accesslevel <{0}>", ToolAccess.printAccess(currentLvl));
			mInteraction.setCurrentToolsAccess(currentLvl);
			dispatch(new AuthenticationEvent(AuthenticationEvent.TOOL_ACCESS_UPDATED));
		}
	}
}