package   {
	import flash.utils.Dictionary;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	/**
	 * ...
	 * @author Elijah Elefson
	 */
	public class DictatorDiction extends MinigameState {
		//public static var level:Number = Registry.difficultyLevel;
		
		private var bossCommands:FlxGroup;
		
		override public function create():void {
			// RED, GREEN, BLUE, PURPLE, ORANGE, PINK
			var colors:Array = new Array(0xFFFF0000, 0xFF00CC00, 0xFF0000FF, 0xCC00CC, 0xFFFF7519, 0xFFFF99FF);
			var text:Array = new Array("RED", "GREEN", "BLUE", "PURPLE", "ORANGE", "PINK");
			FlxG.shuffle(colors, 2);
			FlxG.shuffle(text, 2);
			bossCommands = new FlxGroup();
			var level:int = 0;
			if (level == 0) {
				placeText(2, 3, text, colors);
			}
			add(bossCommands);
			super.setTimer(20000);
			super.create();
		}
		
		override public function update():void {
			super.update();
		}
		
		private function placeText(numberToSelect:int, numberOfLines:int, text:Array, colors:Array):void {
			var spacing:int = 20;
			var curHeight:int = 0;
			for (var i:int = 0; i < numberOfLines; i++) {
				var widthAndHeight:Dictionary = totalWidthOfMultipleTextBoxes(i*numberToSelect, numberToSelect, numberOfLines, spacing, text);
				var totalWidth:int = widthAndHeight["totalWidth"];
				var totalHeight:int = widthAndHeight["totalHeight"];
				var command:FlxText;
				var curWidth:int = 0;
				for (var j:int = 0; j < numberToSelect; j++) {
					command = new FlxText((FlxG.width / 2) - (totalWidth / 2), (FlxG.height / 2) - (totalHeight / 2), FlxG.width, text[(numberToSelect * i)+j]);
					command.setFormat(null, 32, colors[(numberToSelect * i)+j], "left");
					command.x = (command.x + curWidth) + (j * spacing);
					command.y = (command.y + curHeight);
					curWidth += command.getRealWidth();
					bossCommands.add(command);	
				}
				curHeight += command.height;
			}
		}
		
		private function totalWidthOfMultipleTextBoxes(startingIndex:int, numberOfBoxes:int, numberOfLines:int, horizontalSpacing:int, text:Array):Dictionary {
			var totalWidth:int = 0;
			for (var i:int = startingIndex; i < startingIndex + numberOfBoxes; i++) {
				trace(i);
				var textBox:FlxText = new FlxText(0, 0, FlxG.width, text[i]);
				textBox.setFormat(null, 32);
				totalWidth += textBox.getRealWidth();
			}
			var dict:Dictionary = new Dictionary();
			dict["totalWidth"] = totalWidth + ((numberOfBoxes-1) * horizontalSpacing);
			dict["totalHeight"] = textBox.height * numberOfLines;
			return dict;
		}
	}

}