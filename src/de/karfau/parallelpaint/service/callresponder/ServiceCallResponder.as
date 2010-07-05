package de.karfau.parallelpaint.service.callresponder
{
	
	/**
	 * A unique way to handle resposes to service-calls.
	 *
	 * @author Karfau
	 *
	 * @see de.karfau.parallelpaint.service.AbstractService
	 */
	public interface ServiceCallResponder
	{
		/**
		 * Sets the Function that handles the service call result.
		 *
		 * @param handler the handling function
		 * @return the handler itself, for fluent usage.
		 */
		function setOnResult (handler:Function):ServiceCallResponder;
		/**
		 * Sets the Function that handles the service call result.
		 *
		 * @param handler the handling function
		 * @return the handler itself, for fluent usage.
		 */
		function setOnFault (handler:Function):ServiceCallResponder;
	}
}