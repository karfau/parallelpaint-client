package de.karfau.parallelpaint.service.definition
{
	import de.karfau.parallelpaint.core.elements.IElement;
	import de.karfau.parallelpaint.model.vo.ElementVO;
	import de.karfau.parallelpaint.service.callresponder.ServiceCallResponder;
	
	/**
	 *
	 * @author Karfau
	 */
	public interface ElementPersistanceService
	{
		/**
		 *
		 * @return result-type:Drawing, fault-type:Error
		 */
		function createDrawing ():ServiceCallResponder;
		
		/**
		 *
		 * @return result-type:Number(id of affected drawing), fault-type:Error(DrawingNotFoundException,OperationNotAllowedException)
		 */
		function setRegisteredDrawingAuthor (drawingId:Number, authorKey:String):ServiceCallResponder;
		
		/**
		 *
		 * @return result-type:Drawing, fault-type:Error(DrawingNotFoundException)
		 */
		function findDrawingById (id:Number):ServiceCallResponder;
		
		/**
		 *
		 * @param drawingID
		 * @param element
		 *
		 * @return result-type:Number(applied element-id), fault-type:Error()
		 */
		function addElement (element:ElementVO):ServiceCallResponder;
		
		/**
		 *
		 * @param element
		 * @return result-type:void, fault-type:Error
		 */
		function updateElement (element:ElementVO):ServiceCallResponder;
		
		/**
		 *
		 * @param elementId
		 * @return result-type:String(current selector), fault-type:Error(ElementNotFoundException)
		 */
		function selectElement (elementId:Number):ServiceCallResponder;
		
		/**
		 *
		 * @param elementId
		 * @return result-type:String(current selector), fault-type:Error(ElementNotFoundException)
		 */
		function selectSoleElement (elementId:Number):ServiceCallResponder;
		
		/**
		 *
		 * @param elementId
		 * @return result-type:String(current selector or null if successfull), fault-type:Error(ElementNotFoundException)
		 */
		function unselectElement (elementId:Number):ServiceCallResponder;
		
		/**
		 *
		 * @param elementId
		 * @return result-type:void, fault-type:Error(ElementNotFoundException)
		 */
		function removeElement (elementId:Number):ServiceCallResponder;
		
		/**
		 *
		 * @param originalDrawingId
		 * @param versionTag
		 * @return result-type:Drawing, fault-type:Error(DrawingNotFoundException)
		 */
		function createVersionOfDrawing (originalDrawingId:Number, versionTag:String):ServiceCallResponder;
		
		/**
		 *
		 * @param originalDrawingId
		 * @return result-type:ArrayCollection<Drawing>, fault-type:Error(DrawingNotFoundException)
		 */
		function getAllVersionsOfDrawing (originalDrawingId:Number):ServiceCallResponder;
	
	}
}