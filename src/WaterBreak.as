package  {
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	/**
	 * ...
	 * @author Elijah Elefson
	 */
	public class WaterBreak extends MinigameState {
		[Embed(source = "image_assets/water_cooler4.png")] private var WaterCoolerImage:Class;
		[Embed(source = "image_assets/WaterCup.png")] private var CupImage:Class;
		[Embed(source = "image_assets/level_zero_gauge.png")] private var LevelZeroGauge:Class;
		[Embed(source = "image_assets/level_one_gauge.png")] private var LevelOneGauge:Class;
		[Embed(source = "image_assets/level_two_gauge.png")] private var LevelTwoGauge:Class;
		[Embed(source = "image_assets/level_three_gauge.png")] private var LevelThreeGauge:Class;
		[Embed(source = "image_assets/white_cursor.png")] private var WhiteCursorImage:Class;
		[Embed(source = "image_assets/red_cursor.png")] private var RedCursorImage:Class;
		[Embed(source = "image_assets/green_cursor.png")] private var GreenCursorImage:Class;
		[Embed(source = "image_assets/officewall.png")] private var wall:Class;
		[Embed(source = "font_assets/BowlbyOne-Regular.ttf", fontFamily = "Score2", embedAsCFF = "false")] private var ScoreFont:String;
		
		private var water_cooler_graphic:FlxSprite;
		private var cup_graphic:FlxSprite;
		private var gauge_graphic:FlxSprite;
		private var white_cursor_graphic:FlxSprite;
		private var red_cursor_graphic:FlxSprite;
		private var green_cursor_graphic:FlxSprite;
		private var button:FlxButtonPlus;
		
		private var curPosition:int;
		private var increasing:Boolean;
		
		private var delay:FlxDelay;
		private var successStartPosition:int;
		private var successEndPosition:int;
		
		
		override public function create():void {
			var wallpaper:FlxSprite = new FlxSprite(0, 0);
			wallpaper.loadGraphic(wall);
			add(wallpaper);
			
			gameOver = false;
			
			water_cooler_graphic = new FlxSprite(FlxG.width / 2, FlxG.height / 2, WaterCoolerImage);
			water_cooler_graphic.x = water_cooler_graphic.x - (water_cooler_graphic.width / 2);
			water_cooler_graphic.y = water_cooler_graphic.y - (water_cooler_graphic.height / 2) - 8;
			add(water_cooler_graphic);
			
			cup_graphic = new FlxSprite(FlxG.width / 2, FlxG.height / 2);
			cup_graphic.loadGraphic(CupImage, false, false, 40);
			cup_graphic.x = cup_graphic.x - (cup_graphic.width / 2);
			cup_graphic.y = cup_graphic.y - (cup_graphic.height / 2) + 100;
			add(cup_graphic);
			
			if (Registry.difficultyLevel == 0) {
				gauge_graphic = new FlxSprite(FlxG.width / 2, (FlxG.height / 2) + 155, LevelZeroGauge);
				successStartPosition = 3;
				successEndPosition = 12;
			} else if (Registry.difficultyLevel == 1) {
				gauge_graphic = new FlxSprite(FlxG.width / 2, (FlxG.height / 2) + 155, LevelOneGauge);
				successStartPosition = 4;
				successEndPosition = 11;
			} else if (Registry.difficultyLevel == 2) {
				gauge_graphic = new FlxSprite(FlxG.width / 2, (FlxG.height / 2) + 155, LevelTwoGauge);
				successStartPosition = 5;
				successEndPosition = 10;
			} else if (Registry.difficultyLevel == 3) {
				gauge_graphic = new FlxSprite(FlxG.width / 2, (FlxG.height / 2) + 155, LevelThreeGauge);
				successStartPosition = 6;
				successEndPosition = 9;
			}
			gauge_graphic.x = gauge_graphic.x - (gauge_graphic.width / 2);
			gauge_graphic.y = gauge_graphic.y - (gauge_graphic.height / 2) - 12;
			add(gauge_graphic);
			
			button = new FlxButtonPlus(FlxG.width / 2, FlxG.height - 75, null, null, "STOP!", 200, 40);
			button.updateInactiveButtonColors([ 0xffFF0080]);
			button.updateActiveButtonColors([ 0xffFFFF00, 0xffFF8000 ]);
			button.x = button.x - (button.width / 2);
			button.textNormal.setFormat("Score2", 30, 0xFFFFFFFF, null, 1);
			button.textHighlight.setFormat("Score2", 30, 0xFFFFFFFF, null, 1);
			button.textNormal.y -= 7;
			button.textHighlight.y -= 7;
			add(button);
			
			/*if (Registry.difficultyLevel == 3) {
				successStartPosition = FlxU.floor(Math.random() * 15);
				green_cursor_graphic = new FlxSprite((gauge_graphic.x + 7) + (16 * successStartPosition), gauge_graphic.y + 5, GreenCursorImage);
				add(green_cursor_graphic);
				successStartPosition -= 1;
				successEndPosition = successStartPosition + 2;
			}*/
			
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
			super.setTimer(11000);
			super.timer.callback = timeout;
			var data5:Object = { "difficulty":Registry.difficultyLevel };
			Registry.loggingControl.logLevelStart(14, data5);
		}
		
		override public function update():void {
			super.update();
			if (!FlxG.paused && !gameOver) {
				if (curPosition == 0) {
					increasing = true;
				} else if (curPosition == 15) {
					increasing = false;
				}
				
				//if (FlxG.mouse.screenX >= cup_graphic.x && FlxG.mouse.screenX <= cup_graphic.x + cup_graphic.width &&
				//	FlxG.mouse.screenY >= cup_graphic.y && FlxG.mouse.screenY <= cup_graphic.y + cup_graphic.height) {
				//		cup_graphic.frame = 1;
				//	} else {
				//		cup_graphic.frame = 0;
				//	}
				trace(button.x);
				if (FlxG.mouse.screenX >= button.x && FlxG.mouse.screenX <= button.x + 200 &&
					FlxG.mouse.screenY >= button.y && FlxG.mouse.screenY <= button.y + button.height && FlxG.mouse.justPressed()) {
					clicked();	
				} else {
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
					} else {
						red_cursor_graphic.visible = true;
						white_cursor_graphic.visible = false;
					}
				}
			}
			
		}
		
		public function clicked():void {
			if (curPosition > successStartPosition && curPosition < successEndPosition) {
				if(!gameOver){
					var data1:Object = { "completed":"success" };
					Registry.loggingControl.logLevelEnd(data1);
				}
				gameOver = true;
				super.success = true;
			} else {
				if(!gameOver){
					var data2:Object = { "completed":"failure" };
					Registry.loggingControl.logLevelEnd(data2);
				} 
				gameOver = true;
				super.success = false;
				super.timer.abort();
			}
		}
		
		public function timeout():void {
				//var data1:Object = { "completed":"failure" };
				//Registry.loggingControl.logLevelEnd(data1);
		}
	}

}