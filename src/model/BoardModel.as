package model {
	import __AS3__.vec.Vector;
	
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	
	public class BoardModel extends EventDispatcher{
		
		public static const PARTICLES_SPAWNED:String = "newparticles";
		public var particles:Vector.<ParticleModel>;	// holds all the particles on the board
		public var detectors:Vector.<DetectorModel>;	// holds all detecteds on the board
		public var dispensers:Vector.<DispenserModel>;	// holds all dispensers
		public var pieces:Vector.<PieceModel>;			// holds all the pieces
		public static const bounds:Rectangle = new Rectangle(0,0,600,400);
		
		public function BoardModel() {
			super();
			particles = new Vector.<ParticleModel>();
			detectors = new Vector.<DetectorModel>();
			dispensers = new Vector.<DispenserModel>();
			pieces = new Vector.<PieceModel>();
		}
		
		public function clone():BoardModel {
			var temp:BoardModel = new BoardModel();
			for each (var detector:DetectorModel in detectors) {
				temp.detectors.push(detector.clone());
			}
			for each (var dispenser:DispenserModel in dispensers) {
				temp.dispensers.push(dispenser.clone());
			}
			for each (var piece:PieceModel in pieces) {
				temp.pieces.push(piece.clone());
			}
			return temp;
		}
		
		public function finishedBoard():Boolean {
			for each (var detector:DetectorModel in detectors) {
				if (detector.detected < GameConfig.DETECTOR_THRESHOLD) {
					return false;
				}
			}
			return true;
		}
		
		public function update():void {
			for each (var particle:ParticleModel in particles) {
				particle.update();
			}
			for each (var detector:DetectorModel in detectors) {
				detector.update();
				detector.detectCollisions(particles);
			}
			var spawned:Vector.<ParticleModel> = new Vector.<ParticleModel>();
			for each (var dispenser:DispenserModel in dispensers) {
				// can't push entire vectors
				for each (var spawnedPart:ParticleModel in dispenser.spawn()) {
					spawned.push(spawnedPart);
				}
			}
			// Can't push entire vectors
			for each (var newPart:ParticleModel in spawned) {
				particles.push(newPart);
			}
			// dispatch an update to inform any views that there are new particles.
			this.dispatchEvent(new DataUpdateEvent(spawned, PARTICLES_SPAWNED));
			for each (var piece:PieceModel in pieces) {
				//TODO: use spatial hashing to improve performance, if needed
				piece.perform(particles);
			}
			junkParticles();
		}
		
		public function junkParticles():void {
			for (var i:int = 0; i < particles.length; i++) {
				if (!bounds.containsPoint(particles[i].position)) {
					particles[i].destroyMe();
					particles.splice(i,1);
				}
			}
		}
	}
}