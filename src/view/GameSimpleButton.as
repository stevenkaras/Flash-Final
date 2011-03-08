package view
{
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.text.TextField;
	
	public class GameSimpleButton extends SimpleButton
	{
		private var _id:int;
		public var title:String;
		private var cornerRadius:int;
		private var buttWidth:int;
		private var buttHeight:int;
		private var baseColor:int;
		private var overColor:int;
		private var fontSize:int;
		private var fontColor:String;
		
		public function GameSimpleButton(id:int,
										 title:String, 
										 x:int=0, y:int=0,
										 width:int=100, height:int=23,
										 baseColor:int = 0x56FE56, overColor:int = 0x5DFF6F,
										 fontSize:int = 15, fontColor:String='#060606') {
			super();
			
			this._id = id;
			this.title = title;
			this.x = x;
			this.y = y;
			this.buttWidth = width;
			this.buttHeight = height;
			this.cornerRadius = cornerRadius;
			this.baseColor = baseColor;
			this.overColor = overColor;
			this.fontSize = fontSize;
			this.fontColor = fontColor;
			
			upState = drawState('upState'),
			overState = drawState('overState'),
			downState = drawState('downState'),
			hitTestState = drawState('hitTestState');
		}
		public function get id():int { return _id };
		
		private function drawState(name:String):DisplayObject {
			var buttState:Sprite = new Sprite();
			
			var title_txt:TextField = new TextField();
			title_txt.width = buttWidth;
			title_txt.htmlText = '<font color="'+fontColor+'" face="Arial" size="'+fontSize+'">'+title+'</font>';
			title_txt.x = buttWidth/2 - title_txt.textWidth/2;
			title_txt.y = buttHeight/25;
			var gFilter:GlowFilter = new GlowFilter(0x0,.125,5,5,10);
			title_txt.filters = [gFilter];
			
			var current_color:int = baseColor
			switch(name) {
				case 'overState':
					current_color = overColor;
				case 'downState':
				case 'upState':
					buttState.addChild(title_txt);
				break;
				case 'hitTestState':
				break;
			}
			
			var inner_radius_corners:int = buttHeight/2;
			var outer_radius_corners:int = buttHeight/2+2;
			var width_padding:int = 12;
			var colors:Array = [0x000000, 0x000000, 0x000000, 0x000000];
		    var fillType:String = "linear"
		    var alphas:Array = [.15, .0, .0, .05];
		    var ratios:Array = [0, 127, 210, 255];
		    var m:Matrix = new Matrix();
		    
		    	
		    m.createGradientBox( buttWidth, buttHeight, Math.PI/2 );
		    buttState.graphics.clear();
			buttState.graphics.beginGradientFill( fillType, colors, alphas, ratios, m );
			buttState.graphics.drawRoundRectComplex(-7-width_padding/2,-3,buttWidth+width_padding+14,buttHeight+6,outer_radius_corners,outer_radius_corners,outer_radius_corners,outer_radius_corners);
			buttState.graphics.endFill();
			buttState.graphics.beginFill(current_color);
			buttState.graphics.drawRoundRectComplex(-width_padding/2,0,buttWidth+width_padding,buttHeight,inner_radius_corners,inner_radius_corners,inner_radius_corners,inner_radius_corners);
			buttState.graphics.endFill();
			buttState.graphics.beginFill(0xFFFFFF, .25);
			buttState.graphics.drawRoundRectComplex(-width_padding/2,0,buttWidth+width_padding,buttHeight/2,inner_radius_corners,inner_radius_corners,0,0);
			buttState.graphics.endFill();
			
			return buttState as DisplayObject;
		}
	}
}