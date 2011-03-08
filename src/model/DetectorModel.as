package model {
	import __AS3__.vec.Vector;
	
	import flash.geom.Point;
	
	public class DetectorModel {
		public var position:Point;
		public var detected:Number;
		private var detectionRadius:Number;
		
		private static const DEFAULT_RADIUS:Number = 30;
		
		public function DetectorModel(position:Point) {
			this.position = position.clone();
			this.detected = 0;
			this.detectionRadius = DEFAULT_RADIUS;
		}
		
		/**
		 * This function will update the state of the detector.
		 */
		public function update():void {
			// Do nothing
		}
		
		public function clone():DetectorModel {
			return new DetectorModel(this.position);
		}
		
		/**
		 * This function tests a set of particles for collisions, and returns an
		 * array of the particles with which it has collided. It also increments
		 * the detected counter for each particle collided.
		 */
		public function detectCollisions(particles:Vector.<ParticleModel>):void {
			for (var i:int = 0; i < particles.length; ++i) {
				if (Point.distance(particles[i].position,this.position) <= detectionRadius) {
					particles[i].destroyMe();
					particles.splice(i,1);
					--i; // compensate for deleting the element from the array
					++detected;
				} 
			}
		}
	}
}