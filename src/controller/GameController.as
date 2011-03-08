package controller
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	import model.GameModel;
	import model.factory.ModelFactory;
	
	import view.DebugView;
	import view.GameView;

	public class GameController
	{
		private var debugMode:Boolean = false; // true = debug mode (level creation)
		private var debug:DebugView;
		
		private var data:GameModel;
		private var ui:GameView;
		private var main:Sprite;
		private var inputTimer:Timer;
		private static const TIMER_DELAY:Number = 100;
		
		public function GameController(main:Sprite) {
			this.main = main;
			generateUIFrame(main); // add a surface to click on, catch keyboard, etc.
			data = ModelFactory.getGameModel();
			ui = new GameView( data );
			main.addChild(ui);
			startGame();
			debug = new DebugView(data, ui);
			if (debugMode) toggleDebug();
		}
		
		public function toggleDebug():void {
			if (debugMode) {
				main.addChild(debug);
			} else {
				main.removeChild(debug);
			}
		}
		
		public function startGame():void {
			main.stage.addEventListener(KeyboardEvent.KEY_DOWN, inputDispatcher);
			main.addEventListener(Event.ENTER_FRAME, frameUpdate);
			data.addEventListener(GameModel.GAME_OVER, endGame);
		}
		
		private function generateUIFrame(main:Sprite):void {
			var temp:Sprite = new Sprite();
			var g:Graphics = temp.graphics;
			g.beginFill(0xFFFFFF,0); // white background
			g.drawRect(0,0,GameView.GAME_WIDTH,GameView.GAME_HIEGHT);
			main.addChild(temp);
		}
		
		public function endGame(e:Event):void {
			main.removeEventListener(Event.ENTER_FRAME, frameUpdate);
			data.removeEventListener(GameModel.GAME_OVER, endGame);
			// Throw up a message that the game is over
			var endGameMessage:TextField = new TextField();
			endGameMessage.htmlText = "<font size='48' face='Arial'>The End</font>"
			endGameMessage.width = GameView.GAME_WIDTH;
			endGameMessage.y = GameView.GAME_HIEGHT / 2 - endGameMessage.height;
			var format:TextFormat = new TextFormat();
			format.align = "center";
			endGameMessage.setTextFormat(format);
			endGameMessage.selectable = false;
			ui.addChild(endGameMessage);
		}
		
		public function frameUpdate(e:Event):void {
			data.update();
			ui.update();
		}
		
		public function inputDispatcher(ev:Event):void {
			/**
			 * In an attempt NOT to reinvent the wheel, I'm allowing the Flash
			 * system to handle things like event dispatching to the proper
			 * view objects based upon the DOM Level 3 Events Standard.  
			 */
			if (ev is KeyboardEvent) {
				var e:KeyboardEvent = ev as KeyboardEvent;
				switch (e.keyCode) {
				case Keyboard.DELETE:
					if (debugMode)
						debug.deleteSelectedObject();
					break;
				case Keyboard.F4:
					debugMode = !debugMode;
					toggleDebug();
					break;
				}
			}
		}
	}
}