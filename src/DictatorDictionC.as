package   {
	import flash.utils.Dictionary;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	/**
	 * ...
	 * @author Elijah Elefson
	 */
	public class DictatorDictionC extends MinigameState {
		//public static var level:Number = Registry.difficultyLevel;
		private var orderOfAnswers:Array; // DO NOT MODIFY
		
		private var colors:Array;
		private var text:Array;
		
		private var usedColors:Array;
		private var usedText:Array;
		
		private var text_to_colors:Dictionary;
		private var colors_to_text:Dictionary;
		private var bossCommand:DictatorDictionText;
		private var buttonGroup:FlxGroup;
		private var buttons:int;
		private var commands:int;
		private var commandsLeft:FlxText;
		private var textColor:Boolean;
		private var difficulty:int;
		
		override public function create():void {
			// RED, GREEN, BLUE, PURPLE, ORANGE, PINK
			colors = new Array(0xFFFF0000, 0xFF00CC00, 0xFF0000FF, 0xCC00CC, 0xFFFF7519, 0xFFFFFF00);
			text = new Array("RED", "GREEN", "BLUE", "PURPLE", "ORANGE", "YELLOW");
			text_to_colors = new Dictionary();
			colors_to_text = new Dictionary();
			for (var i:int = 0; i < 6; i++) {
				text_to_colors[text[i]] = colors[i];
				colors_to_text[colors[i]] = text[i];
			}
			
			
			bossCommand = new DictatorDictionText(0, FlxG.height / 2 - 32, FlxG.width, "");
			bossCommand.setFormat(null, 32, 0x000000, "center");
			
			buttonGroup = new FlxGroup();
			difficulty = 1;
			if (difficulty == 0) { // Text Color
				commands = 4;
				textColor = true;
			} else if (difficulty == 1) { // Text Meaning
				commands = 4;
				textColor = false;
			} else if (difficulty == 2) { // text Color HM
				commands = 6;
				textColor = true;
			} else if (difficulty == 3) { // Switch between
				commands = 6;
				textColor = (Math.random() < .5);
			}
			buttons = commands;
			
			commandsLeft = new FlxText(0, 25, FlxG.width, "Commands Left: " + commands.toString());
			commandsLeft.setFormat(null, 16, 0xffffff, "right");
			
			placeButtons();
			addWord();
			
			add(bossCommand);
			add(commandsLeft);
			add(buttonGroup);
			
			super.create();
			
			if (difficulty == 0) {
				super.setCommandText("Text COLOR!");
			} else if (difficulty == 1) {
				super.setCommandText("Text MEANING!");
			} else if (difficulty == 2) {
				super.setCommandText("Text COLOR!");
			} else if (difficulty == 3) {
				super.setCommandText("Goal Switching!");
			}
			super.setTimer(20000);
		}
		
		override public function update():void {
			super.update();
		}
		
		private function checkIfCorrectColor(color:Array):void {
			if (text_to_colors[bossCommand.text] == color[0] as uint) {
				//correct!
				addWord();
				commands--;
				commandsLeft.text = "Commands Left: " + commands.toString();
				if (commands == 0) {
					super.success = true;
					return;
				}
			} else {
				// incorrect!
				for (var i:int = 0; i < buttons; i++) {
					var tempButton:DictatorDictionButton = buttonGroup.members[i] as DictatorDictionButton;
					if (tempButton.color == text_to_colors[bossCommand.text]) {
						tempButton.flicker();
						drawButtonErrorBox(i);
					}
				}
				
				super.success = false;
				super.timer.abort();	
			}
		}
		
		private function checkIfCorrectText(color:Array):void {
			if (bossCommand.color == color[0]) {
				//correct!
				
				addWord();
				commands--;
				commandsLeft.text = "Commands Left: " + commands.toString();
				
				if (commands == 0) {
					super.success = true;
					return;
				}
			} else {
				// incorrect!
				for (var i:int = 0; i < buttons; i++) {
					var tempButton:DictatorDictionButton = buttonGroup.members[i] as DictatorDictionButton;
					if (text_to_colors[tempButton.label.text] as uint == bossCommand.color) {
						tempButton.flicker();
						drawButtonErrorBox(i);
					}
				}
				
				super.success = false;
				super.timer.abort();	
			}
		}
		
		/*
		private function drawTextErrorBox(index:int):void {
			if (!FlxG.paused) {
			// THIS PUTS A BOX AROUND THE TEXT
				var command:FlxText = bossCommands.members[index];
				var x:Number = command.x;
				var y:Number = command.y;
				var width:Number = command.width;
				var height:Number = command.height;
					
				var topWall:FlxTileblock = new FlxTileblock(x, y, width, 2);
				topWall.makeGraphic(width, 2, 0xFFFF0000);
				topWall.flicker(2);
				
				var bottomWall:FlxTileblock = new FlxTileblock(x, y + height - 2, width, 2);
				bottomWall.makeGraphic(width, 2, 0xFFFF0000);
				bottomWall.flicker(2);
				
				var leftWall:FlxTileblock = new FlxTileblock(x, y, 2, height);
				leftWall.makeGraphic(2, height, 0xFFFF0000);
				leftWall.flicker(2);
				
				var rightWall:FlxTileblock = new FlxTileblock(x + width - 2, y, 2, height);
				rightWall.makeGraphic(2, height, 0xFFFF0000);
				rightWall.flicker(2);
				
				add(topWall);
				add(bottomWall);
				add(leftWall);
				add(rightWall);
			}
		}*/
		
		private function drawButtonErrorBox(index:int):void {
			if (!FlxG.paused) {
				// THIS PUTS A BOX AROUND THE TEXT
				var button:FlxButton = buttonGroup.members[index];
				var x:Number = button.x;
				var y:Number = button.y;
				var width:Number = button.width;
				var height:Number = button.height;
					
				var topWall:FlxTileblock = new FlxTileblock(x, y, width, 2);
				topWall.makeGraphic(width, 2, 0xFFFF0000);
				topWall.flicker(2);
				
				var bottomWall:FlxTileblock = new FlxTileblock(x, y + height - 2, width, 2);
				bottomWall.makeGraphic(width, 2, 0xFFFF0000);
				bottomWall.flicker(2);
				
				var leftWall:FlxTileblock = new FlxTileblock(x, y, 2, height);
				leftWall.makeGraphic(2, height, 0xFFFF0000);
				leftWall.flicker(2);
				
				var rightWall:FlxTileblock = new FlxTileblock(x + width - 2, y, 2, height);
				rightWall.makeGraphic(2, height, 0xFFFF0000);
				rightWall.flicker(2);
				
				add(topWall);
				add(bottomWall);
				add(leftWall);
				add(rightWall);
			}
		}
		
		private function addWord():void {
			bossCommand.text = FlxU.getRandom(usedText) as String;
			bossCommand.color = FlxU.getRandom(usedColors) as uint;
		}
		
		private function placeButtons():void {
			var numberOfButtons:int = 4;
			var numberOfLines:int = 1;
			if (buttons == 6) {
				numberOfButtons = 3;
				numberOfLines = 2;
			}
			var i:int;
			if (textColor) {
				FlxG.shuffle(text, 3 * 6);
				usedText = text.splice(0, buttons);
				usedColors = new Array();
				for (i = 0; i < buttons; i++) {
					var wordColor:uint = text_to_colors[usedText[i]];
					usedColors.push(wordColor);
				}
			}else {
				FlxG.shuffle(colors, 3 * 6);
				usedColors = colors.splice(0, buttons);
				usedText = new Array();
				for (i = 0; i < buttons; i++) {
					var meaning:String = colors_to_text[usedColors[i]];
					usedText.push(meaning);
				}
			}
			
			FlxG.shuffle(usedColors, 20);
			FlxG.shuffle(usedText, 20);
			
			var spacing:int = 20;
			var curHeight:int = 0;
			for (i = 0; i < numberOfLines; i++) {
				var widthAndHeight:Dictionary = totalWidthOfMultipleButtons(numberOfButtons, numberOfLines, 50, 20);
				var totalWidth:int = widthAndHeight["totalWidth"];
				var totalHeight:int = widthAndHeight["totalHeight"];
				
				var button:FlxButton;
				var curWidth:int = 0;
				for (var j:int = 0; j < numberOfButtons; j++) {
					var temp:Array = new Array();
					if (textColor) {
						temp[0] = text_to_colors[usedText[(numberOfButtons * i) + j]];
						button = new DictatorDictionButton((FlxG.width / 2) - (totalWidth / 2), FlxG.height - 150, usedText[(numberOfButtons * i)+j], checkIfCorrectText, temp);
						if (difficulty > 0) {
							button.label.color = usedColors[(numberOfButtons * i) + j] as uint;
						}
						button.scale.x = 1.25;
						button.scale.y = 1.25;
						button.x = (button.x + curWidth) + (j * 50);
						button.y = (button.y + curHeight + (i * 20));
						button.color = 0xffffffff;
					} else {
						temp[0] = usedColors[(numberOfButtons * i) + j];
						button = new DictatorDictionButton((FlxG.width / 2) - (totalWidth / 2), FlxG.height - 150, null, checkIfCorrectColor, temp);
						button.scale.x = 1.25;
						button.scale.y = 1.25;
						button.x = (button.x + curWidth) + (j * 50);
						button.y = (button.y + curHeight + (i * 20));
						button.color = usedColors[(numberOfButtons * i) + j] as uint;
					}
					curWidth += button.width;
					buttonGroup.add(button);
				}
				curHeight += button.height;
			}
		}
		
		private function totalWidthOfMultipleButtons(numberOfButtons:int, numberOfLines:int, horizontalSpacing:int, verticalSpacing:int):Dictionary {
			var button:DictatorDictionButton = new DictatorDictionButton(0, 0);
			var dict:Dictionary = new Dictionary();
			dict["totalWidth"] = (button.width * numberOfButtons) + ((numberOfButtons-1) * horizontalSpacing);
			dict["totalHeight"] = (button.height * numberOfLines) + ((numberOfLines-1) * verticalSpacing);
			return dict;
		}
		/*
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
					command.width = command.getRealWidth();
					curWidth += command.getRealWidth();
					if (((numberToSelect * i) + j) != 0) {
						command.visible = false;
					}
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
		}*/
	}

}