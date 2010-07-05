package de.karfau.parallelpaint.model.vo
{
	import de.karfau.parallelpaint.core.IComparable;
	
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Abstract(*) implementation for ValueObject, <br/>
	 * provides property id (which can only be set to a persistable value once), <br/>
	 * and equals(ValueObject) that checks for type and id.
	 *
	 *
	 * (*) extending classes need to implement ValueObject, else a VerifyError is thrown at creation-time
	 * @author Karfau
	 */
	public class AbstractValueObject extends AbstractObject // implements ValueObject
	{
		/**
		 *
		 */
		public function AbstractValueObject () {
			super(AbstractValueObject, ValueObject);
		}
		
		/**
		 *
		 * @default -1
		 */
		protected var _id:Number = -1;
		
		/** @private */
		public function get id ():Number {
			return _id;
		}
		
		/**
		 *
		 * @param value
		 * @throws VerifyError if one tries to set it after it has already been set to something else then -1;
		 */
		public function set id (value:Number):void {
			if (_id > -1)
				throw new VerifyError(this + ".id has already been set to" + _id + " and can not be set to " + value);
			_id = value;
		
		}
		
		/**
		 * compares this and other by comparing type and id.
		 *
		 * @param other
		 * @return only true if type and id of this and other are the same, false otherwise
		 */
		public function equals (other:IComparable):Boolean {
			if (this._id == -1)
				return false;
			
			var otherVo:ValueObject = (other as ValueObject);
			if (otherVo == null || otherVo.id == -1)
				return false;
			
			if (getQualifiedClassName(this) == getQualifiedClassName(other) &&
				thisVO().id == otherVo.id)
				return true;
			
			return false;
		}
		
		private function thisVO ():ValueObject {
			return ValueObject(this);
		}
	}
}