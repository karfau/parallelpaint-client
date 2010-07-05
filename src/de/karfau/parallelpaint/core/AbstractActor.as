package de.karfau.parallelpaint.core
{
	import flash.errors.IllegalOperationError;
	
	import org.robotlegs.mvcs.Actor;
	
	public class AbstractActor extends Actor implements IAbstract
	{
		/**
		 * Copy from AbstractObject
		 */
		protected namespace abstract;
		
		/**
		 * Copy from AbstractObject
		 */
		abstract var verified:Boolean = false;
		
		/**
		 * Copy from AbstractObject
		 */
		public function AbstractActor (abstractType:Class, forcedInterface:Class=null) {
			abstract::verifyImplementation(abstractType, forcedInterface);
		}
		
		/**
		 * Copy from AbstractObject
		 */
		abstract function verifyImplementation (abstractType:Class, forcedInterface:Class=null):void {
			use namespace abstract;
			if (!verified)
				verifyAbstraction(this, abstractType, forcedInterface);
			verified = true;
		}
		
		/**
		 * Copy from AbstractObject
		 *
		 * @inheritDoc
		 */
		public function get clazz ():Class {
			return Object(this).constructor;
		}
	}

}