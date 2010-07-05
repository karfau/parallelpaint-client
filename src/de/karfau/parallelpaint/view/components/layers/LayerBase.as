package de.karfau.parallelpaint.view.components.layers
{
	import de.karfau.flexlogplus.verbose;
	
	import mx.containers.Canvas;
	
	public class LayerBase extends Canvas
	{
		public function LayerBase () {
			super();
			this.setStyle("color", 0xFFFFFF);
			this.setStyle("backgroundAlpha", 0.001);
		}
		
		protected function clearLayer ():void {
			verbose(this, ".clearLayer( )");
			graphics.clear();
			this.removeAllChildren();
			invalidateDisplayList();
		}
	}
}