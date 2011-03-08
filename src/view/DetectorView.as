package view
{	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.filters.ColorMatrixFilter;
	
	import model.DetectorModel;
	import model.GameConfig;
	
	public class DetectorView extends Sprite {
		
		public var data:DetectorModel;
		
		public function DetectorView(data:DetectorModel) {
			super();
			this.data = data;
			
			drawMe();
		}
		
		private function drawMe():void {
			var symb:DisplayObject = EmbeddedSWFGraphicWarehouse.getInstance().getSkinAsset(GameConfig.DETECTOR_CLASS_NAME);
			symb.width = 40;
			symb.height = 40;
			symb.x = -20;
			symb.y = -20; 
			addChild(symb);
			update();
			this.width = 40;
			this.height = 40;
		}
		
		public function update():void {
			this.x = data.position.x;
			this.y = data.position.y;
			// give visual cue about level of saturation!
			var sat:Number = (data.detected / GameConfig.DETECTOR_THRESHOLD);
			this.filters = [ new ColorMatrixFilter([(1-sat), 0, 0, 0, 0,
													0, (1-sat), 0, 0, 0,
													0, 0, (1-sat/20), 0, 0,
													0, 0, 0, 1, 0]) ];
			if (this.data.detected >= GameConfig.DETECTOR_THRESHOLD) {
				this.filters = [ new ColorMatrixFilter([1, 0, 0, 0, 0,
														0, .5, 0, 0, 0,
														0, 0, 1, 0, 0,
														0, 0, 0, 1, 0]) ];
			}
		}
	}
}