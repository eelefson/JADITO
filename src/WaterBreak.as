package  {
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	/**
	 * ...
	 * @author Elijah Elefson
	 */
	public class WaterBreak extends MinigameState {
		[Embed(source = "image_assets/watercooler2.png")] private var WaterCoolerImage:Class;
		[Embed(source = "image_assets/WaterCup.png")] private var CupImage:Class;
		[Embed(source = "image_assets/level_zero_gauge.png")] private var LevelZeroGauge:Class;
		[Embed(source = "image_assets/level_one_gauge.png")] private var LevelOneGauge:Class;
		[Embed(source = "image_assets/level_two_gauge.png")] private var LevelTwoGauge:Class;
		[Embed(source = "image_assets/level_three_gauge.png")] private var LevelThreeGauge:Class;
		[Embed(source = "image_assets/white_cursor.png")] private var WhiteCursorImage:Class;
		[Embed(source = "image_assets/red_cursor.png")] private var RedCursorImage:Class;
		[Embed(source = "image_assets/green_cursor.png")] private var GreenCursorImage:Class;
		
		private var water_cooler_graphic:FlxSprite;
		private var cup_graphic:FlxSprite;
		private var gauge_graphic:FlxSprite;
		private var white_cursor_graphic:FlxSprite;
		private var red_cursor_graphic:FlxSprite;
		private var green_cursor_graphic:FlxSprite;
		
		private var curPosition:int;
		private var increasing:Boolean;
		
		private var delay:FlxDelay;
		private var successStartPosition:int;
		private var successEndPosition:int;
		
		
		override public function create():void {
			
			gameOver = false;
			
			water_cooler_graphic = new FlxSprite(FlxG.width / 2, FlxG.height / 2, WaterCoolerImage);
			water_cooler_graphic.x = water_cooler_graphic.x - (water_cooler_graphic.width / 2);
			water_cooler_graphic.y = water_cooler_graphic.y - (water_cooler_graphic.height / 2);
			add(water_cooler_graphic);
			
			cup_graphic = new FlxSprite(FlxG.width / 2, FlxG.height / 2, CupImage);
			cup_graphic.x = cup_graphic.x - (cup_graphic.width / 2);
			cup_graphic.y = cup_graphic.y - (cup_graphic.height / 2) + 100;
			add(cup_graphic);
			
			if (Registry.difficultyLevel == 0) {
				gauge_graphic = new FlxSprite(FlxG.width / 2, (FlxG.height / 2) + 155, LevelZeroGauge);
				successStartPosition = 4;
				successEndPosition = 11;
			} else if (Registry.difficultyLevel == 1) {
				gauge_graphic = new FlxSprite(FlxG.width / 2, (FlxG.height / 2) + 155, LevelOneGauge);
				successStartPosition = 5;
				successEndPosition = 10;
			} else if (Registry.difficultyLevel == 2) {
				gauge_graphic = new FlxSprite(FlxG.width / 2, (FlxG.height / 2) + 155, LevelTwoGauge);
				successStartPosition = 6;
				successEndPosition = 9;
			} else if (Registry.difficultyLevel == 3) {
				gauge_graphic = new FlxSprite(FlxG.width / 2, (FlxG.height / 2) + 155, LevelThreeGauge);
			}
			gauge_graphic.x = gauge_graphic.x - (gauge_graphic.width / 2);
			gauge_graphic.y = gauge_graphic.y - (gauge_graphic.height / 2);
			add(gauge_graphic);
			
			if (Registry.difficultyLevel == 3) {
				successStartPosition = FlxU.floor(Math.random() * 15);
				green_cursor_graphic = new FlxSprite((gauge_graphic.x + 7) + (16 * successStartPosition), gauge_graphic.y + 5, GreenCursorImage);
				add(green_cursor_graphic);
				successStartPosition -= 1;
				successEndPosition = successStartPosition + 2;
			}
			
			// 16 total squares
			// 14 pixels = width of square
			// 2 pixels between squares
			// first square 7 pixels from left
			// all squares 5 pixels below top
			
			curPosition = 0;
			increasing = true;
			
			delay = new FlxDelay(5);
			delay.start();
			
			red_cursor_graphic = new FlxSprite(gauge_graphic.x + 7, gauge_graphic.y + 5, RedCursorImage);
			red_cursor_graphic.visible = true;
			add(red_cursor_graphic);
			
			white_cursor_graphic = new FlxSprite(gauge_graphic.x + 7, gauge_graphic.y + 5, WhiteCursorImage);
			white_cursor_graphic.visible = false;
			add(white_cursor_graphic);
			
			super.create();
			
			super.setCommandText("Time It!");
			super.setTimer(20000);
			super.timer.callback = timeout;
			var data5:Object = { "difficulty":Registry.difficultyLevel };
			Registry.loggingControl.logLevelStart(14, data5);
		}
		
		override public function update():void {
			super.update();
			
			if (curPosition == 0) {
				increasing = true;
			} else if (curPosition == 15) {
				increasing = false;
			}
			
			if (delay.hasExpired) {
				if (increasing) {
					red_cursor_graphic.x += 16;
					white_cursor_graphic.x += 16;
					curPosition++;
				} else {
					red_cursor_graphic.x -= 16;
					white_cursor_graphic.x -= 16;
					curPosition--;
				}
				delay.reset(5);
			}
			
			if (curPosition > successStartPosition && curPosition < successEndPosition) {
				red_cursor_graphic.visible = false;
				white_cursor_graphic.visible = true;
				if (FlxG.mouse.justPressed()) {
					if(!gameOver){
						var data1:Object = { "completed":"success" };
						Registry.loggingControl.logLevelEnd(data1);
					}
					gameOver = true;
					super.success = true;
				}
			} else {
				red_cursor_graphic.visible = true;
				white_cursor_graphic.visible = false;
				if (FlxG.mouse.justPressed()) {
					if(!gameOver){
						var data2:Object = { "completed":"failure" };
						Registry.loggingControl.logLevelEnd(data2);
					} 
					gameOver = true;
					super.success = false;
					super.timer.abort();
				}
			}
			
			
		}
		
		public function timeout():void {
				//var data1:Object = { "completed":"failure" };
				//Registry.loggingControl.logLevelEnd(data1);
		}
	}

}