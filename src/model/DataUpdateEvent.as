package model {
	import flash.events.Event;
	
	public class DataUpdateEvent extends Event {
		
		private var _data:Vector.<ParticleModel>;
		
		public function DataUpdateEvent(data:Vector.<ParticleModel>,
									type:String,
									bubbles:Boolean = false,
									canceable:Boolean = false) {
			super(type, bubbles, canceable);	
			this._data = data;
		}
		
		public function get data():Vector.<ParticleModel> {
			return this._data;
		}
	}
}