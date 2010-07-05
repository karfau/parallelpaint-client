package de.karfau.parallelpaint.model.xml
{
	import de.karfau.flexlogplus.*;
	
	import flash.utils.Dictionary;
	
	import org.spicefactory.lib.reflect.ClassInfo;
	import org.spicefactory.lib.xml.XmlObjectMapper;
	import org.spicefactory.lib.xml.XmlProcessorContext;
	import org.spicefactory.lib.xml.mapper.PropertyMapperBuilder;
	
	public class XMLMapper
	{
		//private var _context:XmlProcessorContext;
		
		private var _classMapping:Dictionary;
		private var _xmlMapping:Object;
		
		//private var _rootElement:String;
		
		//public static const ROOT_ELEMENT:XML = <data/>;
		
		public function XMLMapper (context:XmlProcessorContext=null) {
			//_context = context != null ? context : new XmlProcessorContext();
			_classMapping = new Dictionary();
			_xmlMapping = new Object();
			//_rootElement = rootElement || ROOT_ELEMENT.toXMLString();
		
		}
		
		public function setMapping (builder:PropertyMapperBuilder):void {
			//XMLObjectMapper je CI-Klasse speichern
			//var mapper:XMLObjectMapper = builder.build();
			var clazz:Class = builder.objectType.getClass();
			_classMapping[clazz] = builder.build();
			_xmlMapping[builder.elementName.localName] = clazz;
		}
		
		public function getClassMapping (clazz:Class):XmlObjectMapper {
			if (clazz) {
				//var c:Class = clazz.getClass();
				if (_classMapping[clazz]) {
					return _classMapping[clazz];
				}
				warn(this, "getMapping(): no mapping found for {0} or {1}", clazz);
			}
			return null;
		}
		
		public function getXMLMapping (tag:XML):XmlObjectMapper {
			if (tag) {
				return getClassMapping(_xmlMapping[tag.localName()]);
			}
			return null;
		}
	
	/*public function toXML (ci:IContentItem):XML {
		 var mapper:XmlObjectMapper = getClassMapping(ClassInfo.forInstance(ci));
		 if (mapper != null) {
		 return mapper.mapToXml(ci, _context);
		 } else {
		 return null;
		 }
		 }
	
		 public function toCI (xml:XML):IContentItem {
		 var mapper:XmlObjectMapper = getXMLMapping(xml);
		 if (mapper != null) {
		 return IContentItem(mapper.mapToObject(xml, _context));
		 }
		 return null;
	 }*/
	
	/*public function toXMLList (ciList:Vector.<IContentItem>):XML {
		 var result:XML = new XML(ROOT_ELEMENT);
		 var node:XML;
		 var item:IContentItem;
		 var clazz:ClassInfo;
		 var mapper:XmlObjectMapper;
		 for (var i:* in ciList) {
		 item = ciList[i];
		 clazz = ClassInfo.forInstance(item);
		 mapper = getClassMapping(clazz);
		 try {
		 node = null;
		 node = mapper.mapToXml(item, _context);
		 result.appendChild(node);
		 } catch (err:TypeError) {
		 warn(this, "toXMLList(...): could not convert item #{0} {1} of type {2} to xml: returned {3}", i, item, clazz.getClass(), node.toXMLString());
		 }
		 }
		 return result;
	 }*/
	
	/*public function toCIList (xml:XML):Vector.<IContentItem> {
		 var node:XML;
		 for (var i:* in xml) {
		 try {
		 //node = getXMLMapping(
		 } catch (err:TypeError) {
		 //warn(this, "toXMLList(...): could not convert xml #{0} {1} to content: returned ", i, xml[i]);
		 }
		 }
		 return null;
	 }*/
	
	}

}