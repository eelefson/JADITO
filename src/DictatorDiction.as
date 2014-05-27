package   {
	import flash.utils.Dictionary;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	/**
	 * ...
	 * @author Elijah Elefson
	 */
	public class DictatorDiction extends MinigameState {
		[Embed(source = "image_assets/dictating_boss2.png")] private var BossImage:Class;
		[Embed(source = "image_assets/dictating_speech_bubble.png")] private var SpeechImage:Class;
		[Embed(source = "image_assets/officewall.png")] private var wall:Class;
		[Embed(source = "font_assets/BowlbyOne-Regular.ttf", fontFamily = "Score2", embedAsCFF = "false")] private var ScoreFont:String;
		
		private var answers:Array;
		private var orderOfAnswers:Array; // DO NOT MODIFY
		
		private var commands:int;
		private var commandsLeft:FlxText;
		
		private var boss_graphic:FlxSprite;
		private var speech_graphic:FlxSprite;
		
		private var text_to_colors:Dictionary;
		private var colors_to_text:Dictionary;
		private var bossCommands:FlxGroup;
		private var buttonGroup:FlxGroup;
		private var currentTextIndex:int = 0;
		
		override public function create():void {
			var wallpaper:FlxSprite = new FlxSprite(0, 0);
			wallpaper.loadGraphic(wall);
			add(wallpaper);
			
			gameOver = false;
			
			// RED, GREEN, BLUE, PURPLE, ORANGE, PINK
			var colors:Array = new Array(0xFFFF0000, 0xFF00CC00, 0xFF0000FF, 0xCC00CC, 0xFFFF7519, 0xFFFFFF00);
			var text:Array = new Array("RED", "GREEN", "BLUE", "PURPLE", "ORANGE", "YELLOW");
			text_to_colors = new Dictionary();
			colors_to_text = new Dictionary();
			for (var i:int = 0; i < 6; i++) {
				text_to_colors[text[i]] = colors[i];
				colors_to_text[colors[i]] = text[i];
			}
			FlxG.shuffle(colors, colors.length * 4);
			FlxG.shuffle(text, text.length * 4);
			
			speech_graphic = new FlxSprite(20, (FlxG.height / 2) - 50, SpeechImage);
			add(speech_graphic);
			
			bossCommands = new FlxGroup();
			buttonGroup = new FlxGroup();
			var level:int = Registry.difficultyLevel;
			if (level == 0) {
				placeText(4, 1, text, colors);
				placeButtons(4, 1, text.slice(0, 4), colors.slice(0, 4), true);
				answers = colors.slice(0, 4);
				commands = 4;
			} else if (level == 1) {
				placeText(4, 1, text, colors);
				placeButtons(4, 1, text.slice(0, 4), colors.slice(0, 4), false);
				answers = text.slice(0, 4);
				commands = 4;
			} else if (level == 2) {
				placeText(3, 2, text, colors);
				placeButtons(3, 2, text.slice(0, 6), colors.slice(0, 6), true);
				answers = colors.slice(0, 6);
				commands = 6;
			} else if (level == 3) {
				placeText(3, 2, text, colors);
				placeButtons(3, 2, text.slice(0, 6), colors.slice(0, 6), false);
				answers = text.slice(0, 6);
				commands = 6;
			}
			add(bossCommands);
			add(buttonGroup);
			
			commandsLeft = new FlxText(0, 150, FlxG.width, "Commands Remaining: " + commands.toString());
			commandsLeft.setFormat("Score2", 24, 0xff000000, "center");
			add(commandsLeft);
			
			boss_graphic = new FlxSprite(-120, FlxG.height / 2, BossImage);
			boss_graphic.y = boss_graphic.y - (boss_graphic.height / 2) + 25;
			add(boss_graphic);
			
			super.create();
			
			if (level == 0) {
				super.setCommandText("Text COLOR!");
			} else if (level == 1) {
				super.setCommandText("Text MEANING!");
			} else if (level == 2) {
				super.setCommandText("Text COLOR!");
			} else if (level == 3) {
				super.setCommandText("Text MEANING!");
			}
			super.setTimer(12000);
			super.timer.callback = timeout;
			var data5:Object = { "difficulty":level,
								"playthrough":Registry.playthrough,
								"sequence number":Registry.playthroughSeqNum };
			Registry.playthroughSeqNum++;
			Registry.loggingControl.logLevelStart(6, data5);
		}
		
		override public function update():void {
			super.update();
		}
		
		private function checkIfCorrectColor(color:Array):void {
			if (answers.slice(0, 1)[0] == color[0]) {
				//correct!
				commands--;
				commandsLeft.text = "Commands Left: " + commands.toString();
				answers.shift();
				currentTextIndex++;
				bossCommands.getFirstAlive().visible = false;
				bossCommands.getFirstAlive().alive = false;
				if (answers.length == 0) {
					if(!gameOver) {
						var data1:Object = { "completed":"success" };
						Registry.loggingControl.logLevelEnd(data1);
					}
					gameOver = true;
					super.success = true;
					return;
				}
				bossCommands.getFirstAlive().visible = true;
			} else {
				// incorrect!
				drawButtonErrorBox(orderOfAnswers.indexOf(answers.slice(0, 1)[0]));
				
				if (!gameOver) {
					var data2:Object = { "completed":"failure","type":"wrong answer" };
					Registry.loggingControl.logLevelEnd(data2);
				}
				gameOver = true;
				super.success = false;
				super.timer.abort();	
			}
		}
		
		private function checkIfCorrectText(text:Array):void {
			if (answers.slice(0, 1)[0] == text[0]) {
				//correct!
				commands--;
				commandsLeft.text = "Commands Left: " + commands.toString();
				answers.shift();
				currentTextIndex++;
				bossCommands.getFirstAlive().visible = false;
				bossCommands.getFirstAlive().alive = false;
				if (answers.length == 0) {
					if (!gameOver) {
						var data1:Object = { "completed":"success" };
						Registry.loggingControl.logLevelEnd(data1);
					}
					gameOver = true;
					super.success = true;
					return;
				}
				bossCommands.getFirstAlive().visible = true;
			} else {
				// incorrect!
				drawButtonErrorBox(orderOfAnswers.indexOf(answers.slice(0, 1)[0]));
				
				if(!gameOver) {
					var data2:Object = { "completed":"failure","type":"wrong answer" };
					Registry.loggingControl.logLevelEnd(data2);
				}
				gameOver = true;
				super.success = false;
				super.timer.abort();	
			}
		}
		
		/*private function drawTextErrorBox(index:int):void {
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
				var button:FlxButton = buttonGroup.members[index];
				button.flicker(1);
				// THIS PUTS A BOX AROUND THE BUTTON
				/*var button:FlxButton = buttonGroup.members[index];
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
				add(rightWall);*/
			}
		}
		
		private function placeButtons(numberOfButtons:int, numberOfLines:int, text:Array, colors:Array, colorsToText:Boolean):void {
			FlxG.shuffle(colors, colors.length * 4);
			FlxG.shuffle(text, text.length * 4);
			var spacing:int = 20;
			var curHeight:int = 0;
			for (var i:int = 0; i < numberOfLines; i++) {
				var widthAndHeight:Dictionary = totalWidthOfMultipleButtons(numberOfButtons, numberOfLines, 50, 20);
				var totalWidth:int = widthAndHeight["totalWidth"];
				var totalHeight:int = widthAndHeight["totalHeight"];
				var button:FlxButton;
				var curWidth:int = 0;
				var scale:Number = 1.5;
				for (var j:int = 0; j < numberOfButtons; j++) {
					var temp:Array = new Array();
					if (colorsToText) {
						orderOfAnswers = colors;
						temp[0] = colors[(numberOfButtons * i) + j];
						button = new DictatorDictionButton((FlxG.width / 2) - (totalWidth / 2), FlxG.height - 150, colors_to_text[colors[(numberOfButtons * i)+j]], checkIfCorrectColor, temp);
						button.x = (button.x + curWidth) + (j * 50);
						button.y = (button.y + curHeight + (i * 20));
						
						button.scale.x = scale;
						button.scale.y = scale;
						button.label.font = "Score2";
						button.label.size = 16;
						button.label.offset.y += 7;
						button.label.color = 0xFF000000;
						//button.label.size = button.label.size * scale;
						//button.label.font = "Score2";
						
						button.color = 0xffffffff;
					} else {
						orderOfAnswers = text;
						temp[0] = text[(numberOfButtons * i)+j];
						button = new DictatorDictionButton((FlxG.width / 2) - (totalWidth / 2), FlxG.height - 150, "", checkIfCorrectText, temp);
						button.x = (button.x + curWidth) + (j * 50);
						button.y = (button.y + curHeight + (i * 20));
						
						button.scale.x = scale;
						button.scale.y = scale;
						button.label.offset.y = (scale - 1) / 2 * button.label.size;
						button.label.size = button.label.size * scale;
						
						button.color = text_to_colors[text[(numberOfButtons * i)+j]];
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
		
		private function placeText(numberToSelect:int, numberOfLines:int, text:Array, colors:Array):void {
			/*var spacing:int = 20;
			var curHeight:int = 4;
			for (var i:int = 0; i < numberOfLines; i++) {
				var widthAndHeight:Dictionary = totalWidthOfMultipleTextBoxes(i*numberToSelect, numberToSelect, numberOfLines, spacing, text);
				var totalWidth:int = widthAndHeight["totalWidth"];
				var totalHeight:int = widthAndHeight["totalHeight"];
				var command:DictatorDictionText;
				var curWidth:int = 25;
				for (var j:int = 0; j < numberToSelect; j++) {
					command = new DictatorDictionText((FlxG.width / 2) - (totalWidth / 2), (FlxG.height / 2) - (totalHeight / 2), FlxG.width, text[(numberToSelect * i)+j]);
					command.setFormat(null, 36, colors[(numberToSelect * i)+j], "left", 1);
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
			}*/
			for (var i:int = 0; i < numberOfLines; i++) {
				var command:DictatorDictionText;
				for (var j:int = 0; j < numberToSelect; j++) {
					command = new DictatorDictionText(0, (FlxG.height) / 2 - 24, FlxG.width, text[(numberToSelect * i)+j]);
					command.setFormat("Score2", 36, colors[(numberToSelect * i)+j], "center", 1);
					//command.x = (command.x + curWidth) + (j * spacing);
					//command.y = (command.y + curHeight);
					//command.width = command.getRealWidth();
					//curWidth += command.getRealWidth();
					if (((numberToSelect * i) + j) != 0) {
						command.visible = false;
					}
					bossCommands.add(command);
				}
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
		
		public function timeout():void {
			if (!gameOver) {
				var data1:Object = { "completed":"failure","type":"timeout" };
				Registry.loggingControl.logLevelEnd(data1);
			}
			gameOver = true;
		}
	}

}