package de.karfau.parallelpaint.service.dummy
{
	import de.karfau.parallelpaint.core.elements.IElement;
	import de.karfau.parallelpaint.model.vo.Drawing;
	import de.karfau.parallelpaint.model.vo.ElementVO;
	import de.karfau.parallelpaint.service.AbstractService;
	import de.karfau.parallelpaint.service.ServiceConfig;
	import de.karfau.parallelpaint.service.callresponder.InstantCallResponder;
	import de.karfau.parallelpaint.service.callresponder.ServiceCallResponder;
	import de.karfau.parallelpaint.service.definition.ElementPersistanceService;
	
	import flash.utils.Dictionary;
	
	import mx.utils.UIDUtil;
	
	public class DummyElementPersistanceService extends AbstractService implements ElementPersistanceService
	{
		
		/*########################################################*/
		/*                                                        */
		/*   STATIC                                               */
		/*                                                        */
		/*########################################################*/
		
		private static var nextDrawingId:Number = 1;
		private static var nextElementId:Number = 1;
		
		public static const idMap:Dictionary = new Dictionary();
		
		/*########################################################*/
		/*                                                        */
		/*   PROPERTIES (INCL. SETTER/GETTER)                     */
		/*                                                        */
		/*########################################################*/
		
		private var responder:InstantCallResponder;
		
		/*########################################################*/
		/*                                                        */
		/*   CONSTRUCTOR                                          */
		/*                                                        */
		/*########################################################*/
		
		public function DummyElementPersistanceService () {
			super(ElementPersistanceService);
		}
		
		/*########################################################*/
		/*                                                        */
		/*   OVERRIDE / IMPLEMENT                                 */
		/*                                                        */
		/*########################################################*/
		
		public function findDrawingById (id:Number):ServiceCallResponder {
			responder = new InstantCallResponder(Drawing);
			return responder.withResult(getOrCreateDrawing(id));
		}
		
		public function createDrawing ():ServiceCallResponder {
			responder = new InstantCallResponder(Drawing);
			/*var result:Drawing = new Drawing();
			 result.id = nextDrawingId++;*/
			//result.label = UIDUtil.createUID();
			return responder.withResult(getOrCreateDrawing(nextDrawingId++));
		}
		
		public function addElement (element:ElementVO):ServiceCallResponder {
			responder = new InstantCallResponder(Number);
			return responder.withResult(nextElementId++);
		}
		
		public function updateElement (element:ElementVO):ServiceCallResponder {
			return new InstantCallResponder(null).withResult();
		}
		
		public function selectElement (elementId:Number):ServiceCallResponder {
			return new InstantCallResponder(null).withResult();
		}
		
		public function removeElement (elementId:Number):ServiceCallResponder {
			return new InstantCallResponder(null).withResult();
		}
		
		private function getOrCreateDrawing (id:Number):Drawing {
			var result:Drawing = idMap[id] as Drawing;
			if (result == null) {
				result = new Drawing();
				result.id = id;
				idMap[id] = result;
			}
			return result;
		}
	}
}