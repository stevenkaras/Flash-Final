package view {
	import flash.events.MouseEvent;
	
	import model.DispenserModel;
	
	public class DebugDispenserView extends DispenserView{
		private var dragging:Boolean;
		public function DebugDispenserView(data:DispenserModel) {
			super(data);
			this.addEventListener(MouseEvent.MOUSE_DOWN,pickUp);
			this.addEventListener(MouseEvent.DOUBLE_CLICK,adjustProps);
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
		
		public function adjustProps(event:MouseEvent):void {
			//TODO: develop some sort of props UI
		}
		
		override public function update():void {
			if (dragging) {
				this.data.position.x = this.x;
				this.data.position.y = this.y;
			}
			super.update();
		}
	}
}