package view {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	import model.GameConfig;
	import model.PieceModel;
	
	public class PieceView extends Sprite {
		
		public var data:PieceModel;
		private var dragging:Boolean;
		
		public function PieceView(data:PieceModel) {
			super();
			this.data = data;
			if (this.data.moveable) {
				this.addEventListener(MouseEvent.MOUSE_DOWN, pickUp);
				this.buttonMode = true;
			}
			drawMe();
		}
		
		public function pickUp(event:MouseEvent):void {
		    this.startDrag(false);
		    this.removeEventListener(MouseEvent.MOUSE_DOWN, pickUp);
			this.addEventListener(MouseEvent.MOUSE_UP, dropIt);
		    dragging = true;
		}
		
		public function dropIt(event:MouseEvent):void {
		    this.stopDrag();
		    this.addEventListener(MouseEvent.MOUSE_DOWN, pickUp);
			this.removeEventListener(MouseEvent.MOUSE_UP, dropIt);
		    dragging = false;
		}
			
		private function drawMe():void {
			var symb:DisplayObject = EmbeddedSWFGraphicWarehouse.getInstance()
				.getSkinAsset(GameConfig.PIECE_CLASS_NAMES[data.type]);
			symb.width = 40;
			symb.height = 40;
			symb.x = -20;
			symb.y = -20; 
			addChild(symb);
			if (!data.moveable) {
				this.filters = [ new GlowFilter() ];
			}
			update();
			this.x = data.position.x;
			this.y = data.position.y;
		}
		
		/**
		 * This function breaks MVC. The performance impact of sending the
		 * updated coordinates through the controller sent the min spec through
		 * the roof to a quad core system. Maybe in a year or two when computers
		 * are faster on average and the flash VM is better it'll be possible
		 * to save MVC. 
		 */
		public function update():void {
			if (dragging) {
				this.data.position.x = this.x;
				this.data.position.y = this.y;
			}
		}
	}
}