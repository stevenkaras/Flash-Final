package model {
	public class GameConfig {
		//graphic assets class names
		public static const PARTICLE_CLASS_NAME:String = 'particle';
		public static const PIECE_CLASS_NAMES:Array = new Array('upPiece',
																'downPiece',
																'leftPiece',
																'rightPiece',
																'inPiece',
																'outPiece');
		public static const DETECTOR_CLASS_NAME:String = 'detector';
		public static const DISPENSER_CLASS_NAME:String = 'dispenser';
		public static const MUSIC_CLASS_NAME:String = 'gameMusic';
		
		public static const DETECTOR_THRESHOLD:Number = 48;
	}
}