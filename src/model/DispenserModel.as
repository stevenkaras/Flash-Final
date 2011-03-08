package model {
	import flash.geom.Point;
	
	public class DispenserModel {
		public var position:Point;
		public var direction:Point;
		private var spawnCount:Number;
		private static const SPAWN_RATE:Number = 1.5;
		private static const SPAWN_THRESHOLD:Number = 5;
		private static const SPAWN_RADIUS:Number = 10;
		
		public function DispenserModel(position:Point, direction:Point) {
			this.position = position.clone();
			this.direction = direction;
			this.spawnCount = 0;
		}
		
		public function spawn():Vector.<ParticleModel> {
			spawnCount += SPAWN_RATE;
			var count:int = int(spawnCount / SPAWN_THRESHOLD);
			spawnCount %= SPAWN_THRESHOLD;
			var particles:Vector.<ParticleModel> = new Vector.<ParticleModel>(count);
			for (var i:int = 0; i < particles.length; i++) {
				var offset:Point = Point.polar(Math.random()*SPAWN_RADIUS,Math.random()*Math.PI*2);
				particles[i] = new ParticleModel(position.add(offset), direction.clone());
			}
			return particles;
		}
		
		public function clone():DispenserModel {
			return new DispenserModel(this.position, this.direction);
		}
	}
}