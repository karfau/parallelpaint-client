package de.karfau.parallelpaint.model
{
	import de.karfau.parallelpaint.core.elements.AbstractStrokedFilledElement;
	import de.karfau.parallelpaint.core.elements.IElement;
	import de.karfau.parallelpaint.core.elements.IStrokedElement;
	import de.karfau.parallelpaint.core.elements.style.Fill;
	import de.karfau.parallelpaint.core.elements.style.Stroke;
	import de.karfau.parallelpaint.model.vo.ElementVO;
	import de.karfau.parallelpaint.model.xml.StyleContainer;
	import de.karfau.parallelpaint.model.xml.XMLMapper;

	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;

	import org.spicefactory.lib.reflect.ClassInfo;
	import org.spicefactory.lib.xml.XmlObjectMapper;
	import org.spicefactory.lib.xml.XmlProcessorContext;
	import org.spicefactory.lib.xml.mapper.Choice;
	import org.spicefactory.lib.xml.mapper.PropertyMapperBuilder;

	public class TransferFactory
	{

		private var styleMapping:XMLMapper;
		private var context:XmlProcessorContext = new XmlProcessorContext();

		public function TransferFactory () {
			styleMapping = new XMLMapper();
			styleMapping.setMapping(createPropertyMapperBuilder(Stroke, "stroke", ["element"]));
			styleMapping.setMapping(createPropertyMapperBuilder(Fill, "fill", ["element"]));
			styleMapping.setMapping(createChoiceMapperBuilder(StyleContainer, "elementstyles", "styles",
																												[styleMapping.getClassMapping(Stroke),
																												 styleMapping.getClassMapping(Fill)])
															);
		}

		public function createElementVO (element:IElement, order:uint=0):ElementVO {
			var result:ElementVO = new ElementVO();
			result.id = element.id;
			result.drawingId = element.drawingId;
			result.type = getQualifiedClassName(element);
			result.elemOrder = order;
			result.elemVersion = element.version;
			for each (var point:Point in element.points) {
				result.coords.push(point.x, point.y);
			}

			var styles:StyleContainer = new StyleContainer(element);
			result.styleXML = styleMapping.getClassMapping(StyleContainer).mapToXml(styles, context);

			return result;
		}

		public function createElementFromVo (vo:ElementVO):IElement {
			if (vo) {
				var type:Class = ClassInfo.forName(vo.type).getClass();
				var result:IElement = new type();
				result.id = vo.id;
				result.drawingId = vo.drawingId;
				result.version = vo.elemVersion;
				var styles:StyleContainer = styleMapping.getClassMapping(StyleContainer).mapToObject(XML(vo.styleXML), context) as StyleContainer;
				styles.applyStylesTo(result);
				for (var i:int = 0; i < vo.coords.length; i += 2) {
					result.addPoint(new Point(vo.coords[i], vo.coords[i + 1]));
				}
				//TODO: hanlde order
				return result;
			}
			return null;
		}

		private function createPropertyMapperBuilder (clazz:Class, elementName:String, ignore:Array=null, childTextNodes:Array=null):PropertyMapperBuilder {
			//, childElements:Object=null

			if (clazz) {
				//var classI:ClassInfo = ClassInfo.forClass(clazz);
				//var elementName:String = classI.getStaticProperty("TYPE").getValue(null);
				var builder:PropertyMapperBuilder;
				builder = new PropertyMapperBuilder(clazz, new QName(elementName));
				for each (var propName:String in ignore) {
					builder.ignoreProperty(propName);
				}
				/*var props:Array = classI.getProperties();
					 trace(clazz, ":");
					 for each (var prop:Property in props)
				 trace("  ",prop.name);*/
				//var i:int = 1;
				/*for each (var prop:Property in props) {
					 if (prop.name.charAt(0) == "_") {
					 builder.ignoreProperty(prop.name);
					 warn(this, "createPropertyMapperBuilder({0},...) found property to ignore: {1}", clazz, prop.name);
					 }
				 }*/
				//_1044356621accessRules

				var attribute:String;
				/*if (childElements) {
					 for (attribute in childElements) {
					 builder.mapToChildElement(attribute, childElements[attribute]);
					 }
				 }*/
				if (childTextNodes) {
					for each (attribute in childTextNodes) {
						builder.mapToChildTextNode(attribute);
					}
				}
				builder.mapAllToAttributes();
				return builder;
			}
			return null;
		}

		private function createChoiceMapperBuilder (clazz:Class, elementName:String, choiceAttribute:String, childTextNodes:Array):PropertyMapperBuilder {
			//, childElements:Object=null

			if (clazz) {

				var builder:PropertyMapperBuilder;
				builder = new PropertyMapperBuilder(clazz, new QName(elementName));

				/*var props:Array = classI.getProperties();
					 trace(clazz, ":");
					 for each (var prop:Property in props)
				 trace("  ",prop.name);*/
				//var i:int = 1;

				var choice:Choice = new Choice();

				/*if (childElements) {
					 for (attribute in childElements) {
					 builder.mapToChildElement(attribute, childElements[attribute]);
					 }
				 }*/
				if (childTextNodes) {
					for each (var mapper:XmlObjectMapper in childTextNodes) {
						choice.addMapper(mapper);
					}
					builder.mapToChildElementChoice(choiceAttribute, choice);
				}
				builder.mapAllToAttributes();
				return builder;
			}
			return null;
		}

	}
}