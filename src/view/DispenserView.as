package view
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import model.DispenserModel;
	import model.GameConfig;
	
	public class DispenserView extends Sprite {
		
		public var data:DispenserModel;
		
		public function DispenserView(data:DispenserModel) {
			super();
			this.data = data;
			drawMe();
		}
		
		private function drawMe():void {
			var symb:DisplayObject = EmbeddedSWFGraphicWarehouse.getInstance().getSkinAsset(GameConfig.DISPENSER_CLASS_NAME);
			symb.width = 40;
			symb.height = 40;
			symb.x = -20;
			symb.y = -20;
			addChild(symb);
			update();
			// debug drawing
			/*
			var g:Graphics = this.graphics;
			g.lineStyle(20, 0, 1, false);
			var temp:Point = data.direction.clone();
			temp.normalize(200);
			g.lineTo(this.x + temp.x * 100, this.y + temp.y*100);
			*/
		}
		
		public function update():void {
			this.x = data.position.x;
			this.y = data.position.y;
		}
	}
}