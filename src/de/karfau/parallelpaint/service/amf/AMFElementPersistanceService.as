package de.karfau.parallelpaint.service.amf
{
	import de.karfau.parallelpaint.core.elements.IElement;
	import de.karfau.parallelpaint.model.vo.Drawing;
	import de.karfau.parallelpaint.model.vo.ElementVO;
	import de.karfau.parallelpaint.service.AbstractService;
	import de.karfau.parallelpaint.service.ServiceConfig;
	import de.karfau.parallelpaint.service.callresponder.ServiceCallResponder;
	import de.karfau.parallelpaint.service.definition.ElementPersistanceService;
	
	import mx.collections.ArrayCollection;
	
	public class AMFElementPersistanceService extends AbstractService implements ElementPersistanceService
	{
		public function AMFElementPersistanceService () {
			super(ElementPersistanceService);
		}
		
		public function setRegisteredDrawingAuthor (drawingId:Number, authorKey:String):ServiceCallResponder {
			return buildServiceCallWorker("setRegisteredDrawingAuthor", [drawingId, authorKey], Number);
		}
		
		public function findDrawingById (id:Number):ServiceCallResponder {
			return buildServiceCallWorker("findDrawingById", [id], Drawing);
		}
		
		public function createDrawing ():ServiceCallResponder {
			return buildServiceCallWorker("createDrawing", [], Drawing);
		}
		
		public function addElement (element:ElementVO):ServiceCallResponder {
			return buildServiceCallWorker("addElement", [element], Number);
		}
		
		public function updateElement (element:ElementVO):ServiceCallResponder {
			return buildServiceCallWorker("updateElement", [element], null);
		}
		
		public function selectElement (elementId:Number):ServiceCallResponder {
			return buildServiceCallWorker("selectElement", [elementId], String);
		}
		
		public function selectSoleElement (elementId:Number):ServiceCallResponder {
			return buildServiceCallWorker("selectSoleElement", [elementId], String);
		}
		
		public function unselectElement (elementId:Number):ServiceCallResponder {
			return buildServiceCallWorker("unselectElement", [elementId], String);
		}
		
		public function removeElement (elementId:Number):ServiceCallResponder {
			return buildServiceCallWorker("removeElement", [elementId], null);
		}
		
		public function createVersionOfDrawing (originalDrawingId:Number, versionTag:String):ServiceCallResponder {
			return buildServiceCallWorker("createVersionOfDrawing", [originalDrawingId, versionTag], Number);
		}
		
		public function getAllVersionsOfDrawing (originalDrawingId:Number):ServiceCallResponder {
			return buildServiceCallWorker("getAllVersionsOfDrawing", [originalDrawingId], ArrayCollection);
		}
	
	}
}