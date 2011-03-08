package view {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	
	import model.GameConfig;
	import model.GameModel;
	
	public class GameView extends Sprite {
		public static const GAME_WIDTH:int = 600;
		public static const GAME_HIEGHT:int = 400;
		
		private var data:GameModel;
		public var board:BoardView;
		private var timer:TimerView;
		
		private var musicToggle:GameSimpleButton;
		private var musicChannel:SoundChannel;
		private var musicAsset:Sound;
		private var lastPosition:Number;
		private var playingMusic:Boolean;
		
		public function GameView(data:GameModel) {
			super();
			this.data = data;
			timer = new TimerView(data.timer);
			timer.y = 0;
			timer.x = GAME_WIDTH - (timer.width + 100);
			addChild(timer);
			newLevel(null);
			this.data.addEventListener(GameModel.NEW_LEVEL,newLevel,false,0,true);
			
			// add the music controls & start playing
			musicAsset = EmbeddedSWFGraphicWarehouse.getInstance().getSoundAsset(GameConfig.MUSIC_CLASS_NAME);
			musicChannel = musicAsset.play(0,1);
			playingMusic = true;
			musicToggle = new GameSimpleButton(15,"Toggle Music",20,GAME_HIEGHT-40,100,23,0xC0C0C0,0xB0B0B0);
			musicToggle.addEventListener(MouseEvent.CLICK,toggleMusic);
			addChild(musicToggle);
		}
		
		public function toggleMusic(e:Event):void {
			if (playingMusic) {
				lastPosition = musicChannel.position;
				musicChannel.stop()
				playingMusic = false;
			} else {
				musicChannel = musicAsset.play(lastPosition,0);
				playingMusic = true;
			}
		}
		
		public function update():void {
			board.update();
			timer.update();
		}
		
		public function newLevel(e:Event):void {
			if (board != null) removeChild(board);
			board = new BoardView(data.currentLevel);
			addChild(board);
		}
	}
}