package model.factory
{
	import __AS3__.vec.Vector;
	
	import flash.geom.Point;
	import flash.utils.ByteArray;
	
	import model.*;

	public class ModelFactory
	{
		[Embed(source="../../assets/map.xml", mimeType="application/octet-stream")]
		private static const LevelStream:Class;
		
		private static var xml:XML;
		private static function getXML():XML {
			if (xml == null) {
				var file:ByteArray = new LevelStream;
				var str:String = file.readUTFBytes( file.length );
				xml = new XML( str );
			}
			return xml;
		}
		
		public static function getGameModel():GameModel {
			var gameModel:GameModel = new GameModel();
			return gameModel;
		}
		
		public static function loadLevels():Vector.<BoardModel> {
			var xml:XML = getXML();
			var levels:XMLList = xml.level;
			var resultSet:Vector.<BoardModel> = new Vector.<BoardModel>();
			for each (var level:XML in levels) {
				resultSet.push(loadLevel(level));
			}
			return resultSet;
		}
		
		public static function loadLevel(level:XML):BoardModel {
			var data:BoardModel = new BoardModel();
			for each (var dispenser:XML in level.dispenser) {
				data.dispensers.push(new DispenserModel(new Point(dispenser.@x, dispenser.@y),
														Point.polar(1,(dispenser.@dir * Math.PI / 180))));
			}
			for each (var detector:XML in level.detector) {
				data.detectors.push(new DetectorModel(new Point(detector.@x, detector.@y)));
			}
			for each (var piece:XML in level.piece) {
				var position:Point = new Point(piece.@x, piece.@y);
				var typeIn:Number = GameConfig.PIECE_CLASS_NAMES.indexOf(new String(piece.@type));
				var moveable:Boolean = true;
				if (piece.@moveable.length() == 1) {
					moveable = (piece.@moveable.toString() != 'false');
				}
				var pieceM:PieceModel = new PieceModel(position, piece.@radius, piece.@strength, typeIn, moveable);
				data.pieces.push(pieceM);
			}
			return data;
		}
	}
}