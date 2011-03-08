package model {
	import flash.geom.Point;
	
	public class PieceModel {
		public var position:Point;
		public var radius:Number;
		public var strength:Number;
		public var effect:Function; // Should have signature f(ParticleM):void
		public var moveable:Boolean;
		public var type:Number;
		public static const UP_PIECE:Number = 0;
		public static const DOWN_PIECE:Number = 1;
		public static const LEFT_PIECE:Number = 2;
		public static const RIGHT_PIECE:Number = 3;
		public static const IN_PIECE:Number = 4;
		public static const OUT_PIECE:Number = 5;
		
		public function PieceModel(position:Point, radius:Number, strength:Number, type:Number, moveable:Boolean) {
			this.position = position.clone();
			this.radius = radius;
			this.strength = strength;
			this.type = type;
			switch(type) {
			case UP_PIECE:
				this.effect = ForceUp;
				break;
			case DOWN_PIECE:
				this.effect = ForceDown;
				break;
			case LEFT_PIECE:
				this.effect = ForceLeft;
				break;
			case RIGHT_PIECE:
				this.effect = ForceRight;
				break;
			case IN_PIECE:
				this.effect = ForceIn;
				break;
			case OUT_PIECE:
				this.effect = ForceOut;
				break;
			default:
				throw new ArgumentError("Invalid piece type: "+type);
			}
			this.moveable = moveable;
		}
		
		public function clone():PieceModel {
			return new PieceModel(this.position, this.radius, this.strength, this.type, this.moveable);
		}
		
		public function perform(particles:Vector.<ParticleModel>):void {
			for each (var particle:ParticleModel in particles) {
				/*
				// apply inverse square law
				var distance:Number = Point.distance(particle.position, this.position);
				effect.call(this, particle, strength / (distance * distance));
				//*/
				if (Point.distance(particle.position, this.position) < radius) {
					effect.call(this, particle, strength);
				}
			}
		}
		
		// The various force effect functions.
		private static const upForce:Point = new Point(0, -1);
		public function ForceUp(particle:ParticleModel, amount:Number):void {
			var temp:Point = upForce.clone();
			temp.normalize(amount);
			particle.applyForce(temp);
		}
		private static const downForce:Point = new Point(0, 1);
		public function ForceDown(particle:ParticleModel, amount:Number):void {
			var temp:Point = downForce.clone();
			temp.normalize(amount);
			particle.applyForce(temp);
		}
		private static const rightForce:Point = new Point(1, 0);
		public function ForceRight(particle:ParticleModel, amount:Number):void {
			var temp:Point = rightForce.clone();
			temp.normalize(amount);
			particle.applyForce(temp);
		}
		private static const leftForce:Point = new Point(-1, 0);
		public function ForceLeft(particle:ParticleModel, amount:Number):void {
			var temp:Point = leftForce.clone();
			temp.normalize(amount);
			particle.applyForce(temp);
		}
		public function ForceIn(particle:ParticleModel, amount:Number):void {
			var temp:Point = this.position.subtract(particle.position);
			temp.normalize(amount);
			particle.applyForce(temp);
		}
		public function ForceOut(particle:ParticleModel, amount:Number):void {
			var temp:Point = particle.position.subtract(this.position);
			temp.normalize(amount);
			particle.applyForce(temp);
		}
	}
}