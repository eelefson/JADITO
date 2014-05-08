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
		private var answers:Array;
		
		private var text_to_colors:Dictionary;
		private var colors_to_text:Dictionary;
		private var bossCommands:FlxGroup;
		
		override public function create():void {
			// RED, GREEN, BLUE, PURPLE, ORANGE, PINK
			var colors:Array = new Array(0xFFFF0000, 0xFF00CC00, 0xFF0000FF, 0xCC00CC, 0xFFFF7519, 0xFFFFFF00);
			var text:Array = new Array("RED", "GREEN", "BLUE", "PURPLE", "ORANGE", "YELLOW");
			text_to_colors = new Dictionary();
			colors_to_text = new Dictionary();
			for (var i:int = 0; i < 6; i++) {
				text_to_colors[text[i]] = colors[i];
				colors_to_text[colors[i]] = text[i];
			}
			FlxG.shuffle(colors, 2);
			FlxG.shuffle(text, 2);
			
			
			bossCommands = new FlxGroup();
			var level:int = 2;//Registry.difficultyLevel;
			if (level == 0) {
				placeText(4, 1, text, colors);
				placeButtons(text.slice(0, 4), colors.slice(0, 4), true);
				answers = colors.slice(0, 4);
			} else if (level == 1) {
				placeText(4, 1, text, colors);
				placeButtons(text.slice(0, 4), colors.slice(0, 4), false);
				answers = text.slice(0, 4);
			} else if (level == 2) { //WONT WORK CORRECTLY ATM
				placeText(3, 2, text, colors);
				placeButtons2(3, 2, text.slice(0, 6), colors.slice(0, 6), false);
				answers = colors.slice(0, 6);		
			} else if (level == 3) { //WONT WORK CORRECTLY ATM
				placeText(3, 2, text, colors);
				placeButtons(text.slice(0, 6), colors.slice(0, 6), false);
				answers = text.slice(0, 6);	
			}
			add(bossCommands);
			
			super.create();
			
			if (level == 0) {
				super.setCommandText("Text COLOR!");
			} else if (level == 1) {
				super.setCommandText("Text MEANING!");
			} else if (level == 2) {
				
			} else if (level == 3) {
				
			}
			super.setTimer(20000);
		}
		
		override public function update():void {
			super.update();
		}
		
		private function checkIfCorrectColor(color:Array):void {
			if (answers.slice(0, 1)[0] == color[0]) {
				//correct!
				answers.shift();
				if (answers.length == 0) {
					super.success = true;
				}
			} else {
				// incorrect!
				super.success = false;
				super.timer.abort();	
			}
		}
		
		private function checkIfCorrectText(text:Array):void {
			if (answers.slice(0, 1)[0] == text[0]) {
				//correct!
				answers.shift();
				if (answers.length == 0) {
					super.success = true;
				}
			} else {
				// incorrect!
				super.success = false;
				super.timer.abort();	
			}
		}
		
		private function placeButtons2(numberOfButtons:int, numberOfLines:int, text:Array, colors:Array, colorsToText:Boolean):void {
			FlxG.shuffle(colors, 2);
			FlxG.shuffle(text, 2);
			var spacing:int = 20;
			var curHeight:int = 0;
			for (var i:int = 0; i < numberOfLines; i++) {
				var widthAndHeight:Dictionary = totalWidthOfMultipleButtons(4, 1, 50);
				var totalWidth:int = widthAndHeight["totalWidth"];
				var totalHeight:int = widthAndHeight["totalHeight"];
				var button:FlxButton;
				var curWidth:int = 0;
				var temp:Array = new Array();
				for (var j:int = 0; j < numberOfButtons; j++) {
					if (colorsToText) {
						temp[0] = colors[i];
						button = new DictatorDictionButton((FlxG.width / 2) - (totalWidth / 2), FlxG.height - 150, colors_to_text[colors[i]], checkIfCorrectColor, temp);
						button.scale.x = 1.25;
						button.scale.y = 1.25;
						button.x = (button.x + curWidth) + (i * 50);
						button.color = 0xffffffff;
					} else {
						temp[0] = text[i];
						button = new DictatorDictionButton((FlxG.width / 2) - (totalWidth / 2), FlxG.height - 150, null, checkIfCorrectText, temp);
						button.scale.x = 1.25;
						button.scale.y = 1.25;
						button.x = (button.x + curWidth) + (i * 50);
						button.color = text_to_colors[text[i]];
					}
					curWidth += button.width;
					add(button);	
				}
				curHeight += button.height;
			}
		}
		
		private function placeButtons(text:Array, colors:Array, colorsToText:Boolean):void {
			FlxG.shuffle(colors, 2);
			FlxG.shuffle(text, 2);
			var curWidth:int = 0;
			var widthAndHeight:Dictionary = totalWidthOfMultipleButtons(4, 1, 50);
			var totalWidth:int = widthAndHeight["totalWidth"];
			var totalHeight:int = widthAndHeight["totalHeight"];
			for (var i:int = 0; i < 4; i++) {
				var button:FlxButton;
				var temp:Array = new Array();
				if (colorsToText) {
					temp[0] = colors[i];
					button = new DictatorDictionButton((FlxG.width / 2) - (totalWidth / 2), FlxG.height - 150, colors_to_text[colors[i]], checkIfCorrectColor, temp);
					button.scale.x = 1.25;
					button.scale.y = 1.25;
					button.x = (button.x + curWidth) + (i * 50);
					button.color = 0xffffffff;
				} else {
					temp[0] = text[i];
					button = new DictatorDictionButton((FlxG.width / 2) - (totalWidth / 2), FlxG.height - 150, null, checkIfCorrectText, temp);
					button.scale.x = 1.25;
					button.scale.y = 1.25;
					button.x = (button.x + curWidth) + (i * 50);
					button.color = text_to_colors[text[i]];
				}
				curWidth += button.width;
				add(button);
			}
		}
		
		private function totalWidthOfMultipleButtons(numberOfButtons:int, numberOfLines:int, horizontalSpacing:int):Dictionary {
			var button:DictatorDictionButton = new DictatorDictionButton(0, 0);
			var dict:Dictionary = new Dictionary();
			dict["totalWidth"] = (button.width * numberOfButtons) + ((numberOfButtons-1) * horizontalSpacing);
			dict["totalHeight"] = button.height * numberOfLines;
			return dict;
		}
		
		private function placeText(numberToSelect:int, numberOfLines:int, text:Array, colors:Array):void {
			var spacing:int = 20;
			var curHeight:int = 0;
			for (var i:int = 0; i < numberOfLines; i++) {
				var widthAndHeight:Dictionary = totalWidthOfMultipleTextBoxes(i*numberToSelect, numberToSelect, numberOfLines, spacing, text);
				var totalWidth:int = widthAndHeight["totalWidth"];
				var totalHeight:int = widthAndHeight["totalHeight"];
				var command:DictatorDictionText;
				var curWidth:int = 0;
				for (var j:int = 0; j < numberToSelect; j++) {
					command = new DictatorDictionText((FlxG.width / 2) - (totalWidth / 2), (FlxG.height / 2) - (totalHeight / 2), FlxG.width, text[(numberToSelect * i)+j]);
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
				var textBox:DictatorDictionText = new DictatorDictionText(0, 0, FlxG.width, text[i]);
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