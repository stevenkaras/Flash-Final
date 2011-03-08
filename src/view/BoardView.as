package view
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import model.BoardModel;
	import model.DataUpdateEvent;
	import model.DetectorModel;
	import model.DispenserModel;
	import model.ParticleModel;
	import model.PieceModel;
	
	public class BoardView extends Sprite {
		private var data:BoardModel;
		
		public var detectors:Vector.<DetectorView>;
		public var dispensers:Vector.<DispenserView>;
		public var pieces:Vector.<PieceView>;
		public var particles:Vector.<ParticleView>;
		
		public function BoardView(data:BoardModel) {
			super();
			this.detectors = new Vector.<DetectorView>();
			this.dispensers = new Vector.<DispenserView>();
			this.pieces = new Vector.<PieceView>();
			this.particles = new Vector.<ParticleView>();
			this.data = data;
			this.data.addEventListener(BoardModel.PARTICLES_SPAWNED,
										this.spawnParticles,
										false,
										0,
										true);
			drawMe();
		}
		
		private function drawMe():void {
			for each (var detector:DetectorModel in data.detectors) {
				var detectorView:DetectorView = new DetectorView(detector);
				addChild(detectorView);
				this.detectors.push(detectorView);
			}
			for each (var dispenser:DispenserModel in data.dispensers) {
				var dispenserView:DispenserView = new DispenserView(dispenser);
				addChild(dispenserView);
				this.dispensers.push(dispenserView);
			}
			for each (var piece:PieceModel in data.pieces) {
				var pieceView:PieceView = new PieceView(piece);
				addChild(pieceView);
				this.pieces.push(pieceView);
			}
			for each (var particle:ParticleModel in data.particles) {
				var particleView:ParticleView = new ParticleView(particle);
				addChild(particleView);
				this.particles.push(particleView);
			}
		}
		
		public function update():void {
			for each (var dispenser:DispenserView in dispensers) {
				dispenser.update();
			}
			for each (var detector:DetectorView in detectors) {
				detector.update();
			}
			for each (var piece:PieceView in pieces) {
				piece.update();
				// ensure that the pieces are the topmost
				this.setChildIndex(piece, this.numChildren-1);
			}
			for each (var particle:ParticleView in particles) {
				particle.update();
			}
		}
		
		public function spawnParticles(ev:Event):void {
			var e:DataUpdateEvent = ev as DataUpdateEvent;
			for each (var particle:ParticleModel in e.data) {
				var particleView:ParticleView = new ParticleView(particle);
				addChild(particleView);
				this.particles.push(particleView);
			}
		}
	}
}