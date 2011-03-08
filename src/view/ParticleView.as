package view {
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	
	import model.ParticleModel;
	
	public class ParticleView extends Sprite {
		private static const DEFAULT_RADIUS:Number = 3;
		private static const DEFAULT_COLOR:Number = 0x0080FF;
		private var data:ParticleModel;
		
		public function ParticleView(data:ParticleModel) {
			super();
			this.data = data;
			this.data.addEventListener(ParticleModel.PARTICLES_DETECTED, destroyMe, false, 0, true);
			drawMe();
		}
		
		public function destroyMe(e:Event):void {
			this.parent.removeChild(this);
		}
		
		private function drawMe():void {
			var shape:Shape = new Shape();
			var g:Graphics = shape.graphics;
			
			g.lineStyle(1,DEFAULT_COLOR);
			g.drawCircle(0,0,DEFAULT_RADIUS);
			var glow:GlowFilter = new GlowFilter(0x0080FF, 0.5,3,3,1);
			shape.filters = [glow];
			addChild(shape);
			update();
		}
		
		public function update():void {
			this.x = data.position.x;
			this.y = data.position.y;
		}
	}
}