package {
	import controller.GameController;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import view.EmbeddedSWFGraphicWarehouse;
	
	[SWF(width="600", height="400", frameRate="24", backgroundColor="#D0D0D0")]
	
	public class BitRot extends Sprite {
		
		private var controller:GameController;
		
		public function BitRot() {
			EmbeddedSWFGraphicWarehouse.getInstance().addEventListener(Event.INIT, init);
		}
		
		private function init(e:Event):void {
			controller = new GameController(this);
		}
	}
}