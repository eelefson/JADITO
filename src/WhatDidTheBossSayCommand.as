package  {
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	/**
	 * ...
	 * @author Elijah Elefson
	 */
	public class WhatDidTheBossSayCommand extends FlxState {
		
		private var rememberText:FlxText;
		private var toRememberText:DictatorDictionText;
		private var descriptionText:FlxText;
		
		public var topWall:FlxTileblock;
		public var bottomWall:FlxTileblock;
		public var leftWall:FlxTileblock;
		public var rightWall:FlxTileblock;
		
		public var level0Array:Array = new Array("Steve", "John", "Ted", "Bob", "Frank", "Tim", "Pete");
		public var level1Array:Array = new Array("fluffy123", "password77", "princess1983", "america987",
												"ilovecoffee4");
		public var level2Array:Array = new Array("spoofsandgoofs.com/984", "employeetrainer.com/ref", "funny-r-us.net/list",
												 "mybossisa.com/devil");
		public var level3Array:Array = new Array("67823", "28532", "38759", "08236", "64238", "47476");
		
		private var delay:FlxDelay;
		
		override public function create():void {
			FlxG.bgColor = 0xffffffff;
			
			rememberText = new FlxText(0, FlxG.height / 2, FlxG.width, "REMEMBER!");
			rememberText.setFormat(null, 64, 0xff000000, "center");
			rememberText.y = rememberText.y - (rememberText.height / 2) - 75;
			add(rememberText);
			
			var text1:String;
			var text2:String;
			if (Registry.difficultyLevel == 0) {
				text1 = "Steve";
				text2 = "New guy's name:";
			} else if (Registry.difficultyLevel == 1) {
				text1 = "fluffy123";
				text2 = "WiFi password:";
			} else if (Registry.difficultyLevel == 2) {
				text1 = "spoofsandgoofs.com/944";
				text2 = "Funny website URL:";
			} else if (Registry.difficultyLevel == 3) {
				text1 = "67823";
				text2 = "Security code:";
			}
			
			descriptionText = new FlxText(0, FlxG.height / 2, FlxG.width, text2);
			descriptionText.setFormat(null, 40, 0xff000000, "center");
			descriptionText.y = descriptionText.y - (descriptionText.height / 2);
			add(descriptionText);
			
			toRememberText = new DictatorDictionText(0, FlxG.height / 2, FlxG.width, text1);
			toRememberText.setFormat(null, 32, 0xff000000, "center");
			toRememberText.y = toRememberText.y - (toRememberText.height / 2) + 50;
			add(toRememberText);
			
			var a:Number = (FlxG.width - toRememberText.getRealWidth()) / 2;
			
			topWall = new FlxTileblock(a, toRememberText.y, toRememberText.getRealWidth(), 2);
			topWall.makeGraphic(toRememberText.getRealWidth(), 2, 0xff000000);
			add(topWall);
			
			bottomWall = new FlxTileblock(a, toRememberText.y + toRememberText.height - 2, toRememberText.getRealWidth(), 2);
			bottomWall.makeGraphic(toRememberText.getRealWidth(), 2, 0xff000000);
			add(bottomWall);
			
			leftWall = new FlxTileblock(a - 2, toRememberText.y, 2, toRememberText.height);
			leftWall.makeGraphic(2, toRememberText.height, 0xff000000);
			add(leftWall);
			
			rightWall = new FlxTileblock(a + toRememberText.getRealWidth(), toRememberText.y, 2, toRememberText.height);
			rightWall.makeGraphic(2, toRememberText.height, 0xff000000);
			add(rightWall);
			
			delay = new FlxDelay(5000);
			delay.start();
		}
		
		override public function update():void {
			super.update();
			if (delay.hasExpired) {
				FlxG.switchState(new PlayState());
			}
		}
		
	}

}