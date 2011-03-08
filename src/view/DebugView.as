package view {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.getQualifiedClassName;
	
	import model.BoardModel;
	import model.DetectorModel;
	import model.DispenserModel;
	import model.GameConfig;
	import model.GameModel;
	import model.PieceModel;
	
	/**
	 * The debug view breaks MVC in horrible ways. But it's a debug view meant
	 * for creating new levels quickly. I'll probably come back and improve this
	 * much more since this is arguably the most fun part of the game
	 * (toggle it with F4)
	 */
	public class DebugView extends Sprite {
		private var mapXML:TextField;
		private var data:GameModel;
		private var ui:GameView;
		private static const ORIGIN:Point = new Point(0,0);
		
		public function DebugView(data:GameModel, ui:GameView) {
			super();
			this.data = data;
			this.ui = ui;
			
			mapXML = new TextField();
			mapXML.x = 520;
			mapXML.y = 375;
			mapXML.selectable = true;
			addChild(mapXML);
			
			var XMLButton:GameSimpleButton = new GameSimpleButton(0xDEAD,"XML",520, 350,60,23,0xC0C0C0,0xB0B0B0);
			XMLButton.addEventListener(MouseEvent.CLICK,onXMLClick);
			addChild(XMLButton);
			
			//TODO: change these to be drag&drop buttons that spawn new pieces on click
			var upPieceButton:GameSimpleButton = new GameSimpleButton(PieceModel.UP_PIECE, "Up", 280,350,60,23,0xC0C0C0,0xB0B0B0);
			upPieceButton.addEventListener(MouseEvent.CLICK,newPiece);
			addChild(upPieceButton);
			
			var rightPieceButton:GameSimpleButton = new GameSimpleButton(PieceModel.RIGHT_PIECE, "Right", 360,350,60,23,0xC0C0C0,0xB0B0B0);
			rightPieceButton.addEventListener(MouseEvent.CLICK,newPiece);
			addChild(rightPieceButton);
			
			var leftPieceButton:GameSimpleButton = new GameSimpleButton(PieceModel.LEFT_PIECE, "Left", 440,350,60,23,0xC0C0C0,0xB0B0B0);
			leftPieceButton.addEventListener(MouseEvent.CLICK,newPiece);
			addChild(leftPieceButton);
			
			var downPieceButton:GameSimpleButton = new GameSimpleButton(PieceModel.DOWN_PIECE, "Down", 280,375,60,23,0xC0C0C0,0xB0B0B0);
			downPieceButton.addEventListener(MouseEvent.CLICK,newPiece);
			addChild(downPieceButton);
			
			var inPieceButton:GameSimpleButton = new GameSimpleButton(PieceModel.IN_PIECE, "In", 360,375,60,23,0xC0C0C0,0xB0B0B0);
			inPieceButton.addEventListener(MouseEvent.CLICK,newPiece);
			addChild(inPieceButton);
			
			var outPieceButton:GameSimpleButton = new GameSimpleButton(PieceModel.OUT_PIECE, "Out", 440,375,60,23,0xC0C0C0,0xB0B0B0);
			outPieceButton.addEventListener(MouseEvent.CLICK,newPiece);
			addChild(outPieceButton);
			
			var detectorButton:GameSimpleButton = new GameSimpleButton(10, "Detector", 200, 350,60,23,0xC0C0C0,0xB0B0B0);
			detectorButton.addEventListener(MouseEvent.CLICK, newDetector);
			addChild(detectorButton);
			
			var dispenserButton:GameSimpleButton = new GameSimpleButton(10, "Dispenser", 200, 375,60,23,0xC0C0C0,0xB0B0B0);
			dispenserButton.addEventListener(MouseEvent.CLICK, newDispenser);
			addChild(dispenserButton);
		}
		
		private var selectedObject:Object;	// this is a result of bad planning
		public function selectView(e:Event):void {
			selectedObject = e.currentTarget;
		}
		
		public function deleteSelectedObject():void {
			if (selectedObject == null) return;
			var i:int, j:int;
			if (selectedObject is DetectorView) {
				for (i = 0; i < data.currentLevel.detectors.length; i++) {
					if (data.currentLevel.detectors[i] == (selectedObject as DetectorView).data) {
						data.currentLevel.detectors.splice(i,1);
						for (j = 0; j < ui.board.detectors.length; j++) {
							if (ui.board.detectors[j] == selectedObject) {
								ui.board.removeChild(selectedObject as DisplayObject);
								ui.board.detectors.splice(j,1);
								return;
							}
						}
						trace("Inconsistent data found and deleted");
						return;
					}
				}
				trace("Didn't find detector");
			} else if (selectedObject is DispenserView) {
				for (i = 0; i < data.currentLevel.dispensers.length; i++) {
					if (data.currentLevel.dispensers[i] == (selectedObject as DispenserView).data) {
						data.currentLevel.dispensers.splice(i,1);
						for (j = 0; j < ui.board.dispensers.length; j++) {
							if (ui.board.dispensers[j] == selectedObject) {
								ui.board.removeChild(selectedObject as DisplayObject);
								ui.board.dispensers.splice(j,1);
								return;
							}
						}
						trace("Inconsistent data found and deleted");
						return;
					}
				}
				trace("Didn't find dispenser");
			} else if (selectedObject is PieceView) {
				for (i = 0; i < data.currentLevel.pieces.length; i++) {
					if (data.currentLevel.pieces[i] == (selectedObject as PieceView).data) {
						data.currentLevel.pieces.splice(i,1);
						for (j = 0; j < ui.board.pieces.length; j++) {
							if (ui.board.pieces[j] == selectedObject) {
								ui.board.removeChild(selectedObject as DisplayObject);
								ui.board.pieces.splice(j,1);
								return;
							}
						}
						trace("Inconsistent data found and deleted");
						return;
					}
				}
				trace("Didn't find piece");
			}
		}
		
		private static const defaultLocation:Point = new Point(200,200);
		public function newDetector(e:Event):void {
			var newModel:DetectorModel = new DetectorModel(defaultLocation);
			this.data.currentLevel.detectors.push(newModel);
			var newView:DebugDetectorView = new DebugDetectorView(newModel);
			newView.addEventListener(MouseEvent.CLICK, selectView, false, 0, true);
			ui.board.detectors.push(newView);
			ui.board.addChild(newView);
		}
		
		public function newDispenser(e:Event):void {
			var angle:Number = 180 * (Math.PI / 180);
			var newModel:DispenserModel = new DispenserModel(defaultLocation, Point.polar(1,angle));
			this.data.currentLevel.dispensers.push(newModel);
			var newView:DebugDispenserView = new DebugDispenserView(newModel);
			newView.addEventListener(MouseEvent.CLICK, selectView, false, 0, true);
			ui.board.dispensers.push(newView);
			ui.board.addChild(newView);
		}
		
		public function newPiece(e:Event):void {
			var radius:Number = 60;
			var strength:Number = 0.4;
			var newModel:PieceModel = new PieceModel(defaultLocation, radius, strength, (e.target as GameSimpleButton).id, true);
			this.data.currentLevel.pieces.push(newModel);
			var newView:PieceView = new PieceView(newModel);
			newView.addEventListener(MouseEvent.CLICK, selectView, false, 0, true);
			ui.board.pieces.push(newView);
			ui.board.addChild(newView);
		}
		
		public function onXMLClick(e:Event):void {
			mapXML.text = "";
			mapXML.appendText(model2XML(data.currentLevel).toXMLString());
			mapXML.width = 100;
			mapXML.height = 40;
		}
		
		public function model2XML(board:BoardModel):XML {
			var levelNode:XML = <level></level>
			for each (var dispenser:DispenserModel in board.dispensers) {
				var dispenserNode:XML = <dispenser></dispenser>
				dispenserNode.@dir = Math.atan2(dispenser.direction.y, dispenser.direction.x) * (180 / Math.PI);
				dispenserNode.@x = dispenser.position.x;
				dispenserNode.@y = dispenser.position.y;
				levelNode.appendChild(dispenserNode);
			}
			for each (var detector:DetectorModel in board.detectors) {
				var detectorNode:XML = <detector></detector>
				detectorNode.@x = detector.position.x;
				detectorNode.@y = detector.position.y;
				levelNode.appendChild(detectorNode);
			}
			for each (var piece:PieceModel in board.pieces) {
				var pieceNode:XML = <piece></piece>
				pieceNode.@x = piece.position.x;
				pieceNode.@y = piece.position.y;
				pieceNode.@radius = piece.radius;
				pieceNode.@strength = piece.strength;
				pieceNode.@type = GameConfig.PIECE_CLASS_NAMES[piece.type];
				pieceNode.@moveable = piece.moveable;
				levelNode.appendChild(pieceNode);
			}
			return levelNode;
		}
	}
}