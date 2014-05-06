package {
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;

	/**
	 * @author Connor
	 */
	public class CoffeeRun extends MinigameState {
		[Embed(source="image_assets/coffeeCup.png")] private var cup:Class; 
		[Embed(source = "image_assets/CupsAndTray.png")] private var tray:Class;
		
		
		private var command:FlxText;
		private var help:FlxText;
		
		private var traySprite:FlxExtendedSprite;
		private var leftClickBox:FlxExtendedSprite;
		private var rightClickBox:FlxExtendedSprite;
		
		private var difficulty:int;

		
		override public function create():void {
			
			FlxG.mouse.show();
			FlxG.bgColor = 0xffffffff;
			
			difficulty = Registry.difficultyLevel;
			var seconds:int = 20;
			
			traySprite = new FlxExtendedSprite(FlxG.width/2, FlxG.height * 3 / 4, tray);
			traySprite.x = traySprite.x - traySprite.width/2;
			traySprite.y = traySprite.y - traySprite.height/2;
			traySprite.angularVelocity = 15;
			if (Math.random() < .5) {
				traySprite.angularVelocity *= - 1;
			}
			traySprite.antialiasing = true;
			add(traySprite);
			
			leftClickBox = new FlxExtendedSprite(0, FlxG.height * 3 / 4);
			leftClickBox.makeGraphic(FlxG.width / 2, FlxG.height / 4, 0x00ffffff);
			leftClickBox.enableMouseClicks(false);
			leftClickBox.mousePressedCallback = adjustTrayLeft;
			add(leftClickBox);
			
			rightClickBox = new FlxExtendedSprite(FlxG.width/2, FlxG.height * 3 / 4);
			rightClickBox.makeGraphic(FlxG.width / 2, FlxG.height / 4, 0x00ffffff);
			rightClickBox.enableMouseClicks(false);
			rightClickBox.mousePressedCallback = adjustTrayRight;
			add(rightClickBox);
			
			help = new FlxText(FlxG.width / 4, FlxG.height * 5 / 6, FlxG.width / 2, "Click me!");
			help.setFormat(null, 16, 0);
			help.visible = false;
			add(help);
			
			command = new FlxText(0, 0, FlxG.width, "Don't spill the coffee!");
			command.setFormat(null, 16, 0, "center");
			super.create();
			super.setCommandText("Balance It!");
			super.setTimer(seconds * 1000);
			super.timer.callback = timeout;
		}
		
		override public function update():void {
			if (difficulty <= 2) {
				if (traySprite.angularVelocity > 0 && traySprite.angle > 0) {
					help.alignment = "right";
					help.visible = true;
				}else if (traySprite.angularVelocity < 0 && traySprite.angle < 0) {
					help.alignment = "left";
					help.visible = true;
				}else {
					help.visible = false;
				}
			}
			if (Math.random() < .01 * difficulty) {
				traySprite.angularVelocity *= -(.6 + .1*difficulty);
			}else {
				if (Math.random() < .02 * (difficulty + 1)) {
					if(traySprite.angularVelocity < 0) {
						traySprite.angularVelocity--;
					}else {
						traySprite.angularVelocity++;
					}
				}
			}
			if (Math.abs(traySprite.angle) > 60) {
				super.success = false;
				super.timer.abort();
			}
			super.update();
		}
		
		public function adjustTrayLeft(obj:FlxExtendedSprite, x:int, y:int):void {
			traySprite.angularVelocity += 10;
		}
		
		public function adjustTrayRight(obj:FlxExtendedSprite, x:int, y:int):void {
			traySprite.angularVelocity -= 10;
		}
		
		public function timeout():void {
			command.visible = false;
			
			super.success = true;
			super.timer.abort();
		}
	}
}