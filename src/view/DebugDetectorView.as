package view {
	import flash.events.MouseEvent;
	
	import model.DetectorModel;

	public class DebugDetectorView extends DetectorView {
		private var dragging:Boolean;
		
		public function DebugDetectorView(data:DetectorModel) {
			super(data);
			this.addEventListener(MouseEvent.MOUSE_DOWN,pickUp);
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
		
		public override function update():void {
			this.data.detected = 0;
			if (dragging) {
				this.data.position.x = this.x;
				this.data.position.y = this.y;
			}
			super.update();
		}
	}
}