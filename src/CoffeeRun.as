package {
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import org.flixel.plugin.photonstorm.API.FlxKongregate;
	
	/**
	 * @author Connor
	 */
	public class CoffeeRun extends MinigameState {
		[Embed(source = "image_assets/cupsAndTray2.png")] private var tray:Class;
		[Embed(source = "image_assets/officewall.png")] private var wall:Class;
		[Embed(source = "image_assets/click_me_left.png")] private var ClickMeLeftImage:Class;
		[Embed(source = "image_assets/click_me_right.png")] private var ClickMeRightImage:Class;
		
		private var help:FlxText;
		private var help_left_graphic:FlxExtendedSprite;
		private var help_right_graphic:FlxExtendedSprite;
		
		private var traySprite:FlxExtendedSprite;
		private var leftClickBox:FlxExtendedSprite;
		private var rightClickBox:FlxExtendedSprite;
		
		private var difficulty:int;

		
		override public function create():void {
			if (FlxG.getPlugin(FlxMouseControl) == null) {
				FlxG.addPlugin(new FlxMouseControl);
			}
			
			FlxG.mouse.show();
			
			var wallpaper:FlxSprite = new FlxSprite(0, 0);
			wallpaper.loadGraphic(wall);
			add(wallpaper);
			
			gameOver = false;
			
			difficulty = Registry.difficultyLevel;
			var seconds:int = 12;
			
			traySprite = new FlxExtendedSprite(FlxG.width/2, FlxG.height * 3 / 4, tray);
			traySprite.x = traySprite.x - traySprite.width/2;
			traySprite.y = traySprite.y - traySprite.height/2;
			traySprite.angularVelocity = 15;
			if (Math.random() < .5) {
				traySprite.angularVelocity *= - 1;
			}
			traySprite.antialiasing = true;
			add(traySprite);
			
			leftClickBox = new FlxExtendedSprite(0, FlxG.height * 1 / 2);
			leftClickBox.makeGraphic(FlxG.width / 2, FlxG.height / 2, 0x00ffffff);
			leftClickBox.enableMouseClicks(false);
			leftClickBox.mousePressedCallback = adjustTrayLeft;
			add(leftClickBox);
			
			rightClickBox = new FlxExtendedSprite(FlxG.width/2, FlxG.height * 1 / 2);
			rightClickBox.makeGraphic(FlxG.width / 2, FlxG.height / 2, 0x00ffffff);
			rightClickBox.enableMouseClicks(false);
			rightClickBox.mousePressedCallback = adjustTrayRight;
			add(rightClickBox);
			
			//help = new FlxText(FlxG.width / 4, FlxG.height * 5 / 6, FlxG.width / 2, "Click me!");
			/*help = new FlxText(FlxG.width / 4 + 25, FlxG.height * 5 / 6, FlxG.width / 2 - 50, "Click\n me!");
			help.setFormat(null, 16, 0);
			help.visible = false;
			add(help);*/
			
			help_left_graphic = new FlxExtendedSprite(traySprite.x, traySprite.y, ClickMeLeftImage);
			help_left_graphic.angularVelocity = traySprite.angularVelocity;
			help_left_graphic.antialiasing = true;
			add(help_left_graphic);
			
			help_right_graphic = new FlxExtendedSprite(traySprite.x, traySprite.y, ClickMeRightImage);
			help_right_graphic.angularVelocity = traySprite.angularVelocity;
			help_right_graphic.antialiasing = true;
			add(help_right_graphic);
			
			super.create();
			super.setCommandText("Balance It!");
			super.setTimer(seconds * 1000 + 1000);
			super.timer.callback = timeout;
			var data5:Object = { "difficulty":difficulty,
								"playthrough":Registry.playthrough,
								"sequence number":Registry.playthroughSeqNum };
			Registry.playthroughSeqNum++;
			Registry.loggingControl.logLevelStart(4, data5);
		}
		
		override public function update():void {
			if (difficulty <= 3) {
				if (traySprite.angularVelocity > 0 && traySprite.angle > 0) {
					//help.alignment = "right";
					//help.visible = true;
					help_right_graphic.visible = true;
				} else if (traySprite.angularVelocity < 0 && traySprite.angle < 0) {
					//help.alignment = "left";
					//help.visible = true;
					help_left_graphic.visible = true;
				} else {
					//help.visible = false;
					help_right_graphic.visible = false;
					help_left_graphic.visible = false;
				}
				//help.angle = traySprite.angle;
				help_right_graphic.angle  = traySprite.angle;
				help_left_graphic.angle  = traySprite.angle;
				
				help_right_graphic.angularVelocity = traySprite.angularVelocity;
				help_left_graphic.angularVelocity = traySprite.angularVelocity;
			}
			if (Math.random() < ((difficulty == 0) ? 0 : .01)) {
				if((traySprite.angle < 0 && traySprite.angularVelocity > 0) || (traySprite.angle > 0 && traySprite.angularVelocity < 0)) {
					traySprite.angularVelocity *= -(1 + .1 * difficulty);
				}
			}
			if (Math.random() < .04 * (difficulty + 1)) {
				if(traySprite.angularVelocity < 0) {
					traySprite.angularVelocity -= 1;
				} else {
					traySprite.angularVelocity += 1;
				}
			}
			if (!FlxG.paused && !gameOver && FlxG.mouse.justPressed()) {
				Registry.loggingControl.logAction(1, null);
			}
			if (Math.abs(traySprite.angle) > 60) {
				if (!gameOver) {
					var data1:Object = { "completed":"failure","type":"tray fell" };
					Registry.loggingControl.logLevelEnd(data1);
				}
				gameOver = true;
				super.success = false;
				super.timer.abort();
			}
			super.update();
		}
		
		public function adjustTrayLeft(obj:FlxExtendedSprite, x:int, y:int):void {
			traySprite.angularVelocity += (10 + 3 * difficulty);
			Registry.loggingControl.logAction(2, { "action":"tray left" } );
		}
		
		public function adjustTrayRight(obj:FlxExtendedSprite, x:int, y:int):void {
			traySprite.angularVelocity -= (10 + 3 * difficulty);
			Registry.loggingControl.logAction(3, { "action":"tray right" } );
		}
		
		public function timeout():void {
			if (!gameOver) {
				var data1:Object = { "completed":"success" };
				Registry.loggingControl.logLevelEnd(data1);
			}
			if (difficulty == 0) {
				//FlxKongregate.submitStats("CoffeeRunBeginner", 1);
				//FlxKongregate.submitStats("CoffeeRunProgress", 1);
			}else if (difficulty == 1) {
				//FlxKongregate.submitStats("CoffeeRunEasy", 1);
				//FlxKongregate.submitStats("CoffeeRunProgress", 2);
			}else if (difficulty == 2) {
				//FlxKongregate.submitStats("CoffeeRunMedium", 1);
				//FlxKongregate.submitStats("CoffeeRunProgress", 3);
			}else {
				//FlxKongregate.submitStats("CoffeeRunHard", 1);
				//FlxKongregate.submitStats("CoffeeRunProgress", 4);
			}
			gameOver = true;
			super.success = true;
			super.timer.abort();
		}
		
		override public function destroy():void {
			//	Important! Clear out the plugin otherwise resources will get messed right up after a while
			FlxMouseControl.clear();

			super.destroy();
		}
	}
}