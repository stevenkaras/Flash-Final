package view {
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import model.GameModel;
	
	public class TimerView extends TextField {
		private var data:Timer;
		
		public function TimerView(data:Timer) {
			super();
			this.data = data;
			update();
		}
		
		public function update():void {
			this.htmlText = "<font face='Arial' size='14'>Time: "+(GameModel.START_TIMER - data.currentCount)+"</font>";
		}
	}
}