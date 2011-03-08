package model {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	
	public class ParticleModel extends EventDispatcher {
		public static const PARTICLES_DETECTED:String = "detectedparticles";
		private static const DEFAULT_SPEED:Number = 10;
		private var direction:Point;
		private var speed:Number;
		private var _position:Point;
		
		public function ParticleModel(pos:Point, direction:Point) {
			this._position = pos;
			this.direction = direction;
			this.speed = DEFAULT_SPEED;
		}
		
		public function update():void {
			var temp:Point = direction.clone();
			temp.normalize(speed);
			_position = _position.add(temp);
		}
		
		public function applyForce(force:Point):void {
			direction = direction.add(force);
		}
		
		public function get position():Point {
			return this._position;	
		}
		
		public function destroyMe():void {
			this.dispatchEvent(new Event(PARTICLES_DETECTED));
		}
	}
}