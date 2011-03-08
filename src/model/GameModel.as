package model {
	import core.GamesPump;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Timer;
	
	import model.factory.ModelFactory;
	
	public class GameModel extends EventDispatcher {
		public static const NEW_LEVEL:String = "newLevel";
		public static const GAME_OVER:String = "endgame";
		public static const reporting:Boolean = false;
		
		public var levels:Vector.<BoardModel>;
		public var onLevel:int;
		public var currentLevel:BoardModel;
		public var timer:Timer;
		
		public static const START_TIMER:Number = 600;
		
		public function GameModel() {
			levels = ModelFactory.loadLevels();
			onLevel = 0;
			jumpToLevel(onLevel);
			timer = new Timer(1000);
			timer.start();
			if (reporting)
				GamesPump.game_secret = "45c16da616181cb38cf89eaecdf43d5749909990";
		}
		
		public function update():void {
			currentLevel.update();
			if (currentLevel.finishedBoard()) {
				++onLevel;
				if (reporting)
					GamesPump.setScore('highest_level',onLevel);
				if (onLevel == levels.length) {
					if (reporting)
						GamesPump.setScore('finished_time',(START_TIMER - timer.currentCount));
					gameOver();
					return;
				}
				jumpToLevel(onLevel);
			}
		}
		
		public function gameOver():void {
			timer.stop();
			onLevel = -1;
			dispatchEvent(new Event(GAME_OVER));
			//TODO: report high scores or somesuch
		}
		
		public function jumpToLevel(which:int):void {
			if (which < 0 || which > levels.length) return;
			currentLevel = levels[which].clone();
			dispatchEvent(new Event(NEW_LEVEL));
		}
	}
}