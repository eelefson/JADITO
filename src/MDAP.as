package {
	import flash.utils.*;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;

	/**
	 * @author Connor
	 */
	public class MDAP extends MinigameState {
		[Embed(source = "image_assets/crayon_dot.png")] private var DotImage:Class;
		[Embed(source = "image_assets/CrayonRed.png")] private var crayon:Class;
		[Embed(source = "image_assets/drawing1.png")] private var drawing1:Class;
		[Embed(source = "image_assets/drawing2.png")] private var drawing2:Class;
		[Embed(source = "image_assets/drawing3.png")] private var drawing3:Class;
		[Embed(source = "image_assets/sketchpad.png")] private var sketchpadImage:Class;
		[Embed(source = "image_assets/CrayonRed.png")] private var crayonRedImage:Class;
		[Embed(source = "image_assets/CrayonBlue.png")] private var crayonBlueImage:Class;
		[Embed(source = "image_assets/CrayonGreen.png")] private var crayonGreenImage:Class;
		[Embed(source = "image_assets/CrayonPurple.png")] private var crayonPurpleImage:Class;
		[Embed(source = "image_assets/CrayonYellow.png")] private var crayonYellowImage:Class;
		[Embed(source = "image_assets/CrayonOrange.png")] private var crayonOrangeImage:Class;
		[Embed(source = "font_assets/SLOPI___.ttf", fontFamily = "Typewriter", embedAsCFF = "false")] private var TypewriterFont:String;
		[Embed(source = "font_assets/ArbutusSlab-Regular.ttf", fontFamily = "Regular", embedAsCFF = "false")] private var RegularFont:String;
		[Embed(source = "font_assets/BowlbyOne-Regular.ttf", fontFamily = "Score2", embedAsCFF = "false")] private var ScoreFont:String;
		
		private var dot:Dot;
		private var sketchpad:FlxSprite;
		private var drawing:FlxSprite;
		
		private var dotsLeft:FlxText;
		private var question:DictatorDictionText;
		
		/*private var b1:FlxButton;
		private var b2:FlxButton;
		private var b3:FlxButton;
		private var b4:FlxButton;*/
		
		private var difficulty:int;
		private var dots:int;
		private var haze:int;
		private var praise:int;
		private var words:int;
		private var hazePhrases:Array;
		private var praisePhrases:Array;
		
		private var color:uint;
		
		private var correctAnswer:FlxButton;
		
		private var lastX:int;
		private var lastY:int;
		
		// Eli added for line draw
		private var crayon_graphic:FlxExtendedSprite;
		private var dot_graphic:FlxExtendedSprite;
		private var previousPoint:FlxPoint;
		private var ballGroup:FlxGroup;
		
		private var dragMeText:FlxText;
		private var blink:Boolean;
		private var intervalID:uint;
		
		private var version:int;
		private var hazeOnly:Boolean;
		private var delay:FlxDelay;
		
		override public function create():void {
			if (FlxG.getPlugin(FlxMouseControl) == null) {
				FlxG.addPlugin(new FlxMouseControl);
			}
						
			FlxG.mouse.hide();
			FlxG.bgColor = 0xffffffff;
			
			gameOver = false;
			
			// CHANGE THIS TO CHANGE THE VERSION
			// 0 is original
			// 1 is with different first question
			// 2 is with mechanics separated at start
			version = 1;
			
			difficulty = Registry.difficultyLevel;
			dots = 7 + 6 * difficulty;
			words = 20 + 10 * difficulty;
			var seconds:int = 10 + 5 * difficulty;
			if (version == 1 && difficulty == 0) {
				words = 0;
			}
			
			lastX = 0;
			lastY = 0;
			dot = new Dot();
			
			dotsLeft = new FlxText(-2, 25, FlxG.width, dots.toString() + " dots");
			dotsLeft.setFormat("Score2", 24, 0, "right");
			
			sketchpad = new FlxSprite();
			sketchpad.loadGraphic(sketchpadImage);
			add(sketchpad);
			
			hazePhrases = ["Just quit!"];
			haze = 0;
			
			praisePhrases = ["Good job!"];
			
			praise = 0;
			
			hazeOnly = true;
			if (Math.random() < .5) {
				hazeOnly = false;
			}
			
			drawing = new FlxSprite(30, 70);
			drawing.alpha = 0.5;
			var randNum:int = Math.floor(Math.random() * 3);
			if (randNum == 0) {
				drawing.loadGraphic(drawing1);
				drawing.x = (FlxG.width / 2) - 80;
			} else if (randNum == 1) {
				drawing.loadGraphic(drawing2);
				drawing.x = (FlxG.width / 2) - 160;
				drawing.y = 50;
			} else {
				drawing.loadGraphic(drawing3);
				drawing.x = (FlxG.width / 2) - 130;
				drawing.y = 60;
			}
			add(drawing);
			
			if (version != 2 || difficulty != 0) {
				var X_OFFSET:int = 0;
				var Y_OFFSET:int = -80;
				var SCALE:Number = 0.7;
				randNum = Math.floor(Math.random() * 6);
				switch (randNum) {
					case 0:
						crayon_graphic = new FlxExtendedSprite(dot.x, dot.y, crayonRedImage);
						color = 0xFFDB4D4D;
						break;
					case 1:
						crayon_graphic = new FlxExtendedSprite(dot.x, dot.y, crayonBlueImage);
						color = 0xFFA3A3FF;
						break;
					case 2:
						crayon_graphic = new FlxExtendedSprite(dot.x, dot.y, crayonGreenImage);
						color = 0xFF47A347;
						break;
					case 3:
						crayon_graphic = new FlxExtendedSprite(dot.x, dot.y, crayonYellowImage);
						color = 0xFFFFFF00;
						break;
					case 4:
						crayon_graphic = new FlxExtendedSprite(dot.x, dot.y, crayonOrangeImage);
						color = 0xFFCC6600;
						break;
					default:
						crayon_graphic = new FlxExtendedSprite(dot.x, dot.y, crayonPurpleImage);
						color = 0xFFCC66FF;
						break;
				}
			}
			
			// Eli added for line draw
			if (version != 2 || difficulty != 0) {
				ballGroup = new FlxGroup();
				crayon_graphic.x = FlxG.width / 2;
				crayon_graphic.y = FlxG.height / 2;
				dot_graphic = new FlxExtendedSprite(crayon_graphic.x, crayon_graphic.y + crayon_graphic.height, DotImage);
				crayon_graphic.offset.y = crayon_graphic.height;
				previousPoint = new FlxPoint(-100, -100);
				add(ballGroup);
				add(crayon_graphic);
				
				add(dotsLeft);
				add(dot);
			}
			
			super.create();
			if (version == 2 && difficulty == 0) {
				super.setCommandText("Count distinct phrases!");
				delay = new FlxDelay(1000);
				delay.start();
			} else if (version == 2 && difficulty != 0) {
				super.setCommandText("Count and Connect Dots");
			} else {
				super.setCommandText("Connect the dots!");
			}
			super.setTimer(seconds * 1000);
			super.timer.callback = timeout;
			var data5:Object = { "difficulty":difficulty,
								"playthrough":Registry.playthrough,
								"sequence number":Registry.playthroughSeqNum };
			Registry.playthroughSeqNum++;
			Registry.loggingControl.logLevelStart(8, data5);
		}
		
		override public function update():void {
			super.update();
			if (!FlxG.paused) {
				if (version != 2 || difficulty != 0) {
					dot_graphic.x = FlxG.mouse.screenX;
					dot_graphic.y = FlxG.mouse.screenY;
					crayon_graphic.x = FlxG.mouse.screenX;
					crayon_graphic.y = FlxG.mouse.screenY;
					if (previousPoint.x != -100 && previousPoint.y != -100) {
						var line:FlxSprite = new FlxSprite();
						line.makeGraphic(640, 480, 0x00000000);
						line.drawLine(previousPoint.x, previousPoint.y, dot_graphic.x, dot_graphic.y, color, 16);
						ballGroup.add(line);
					}
					if (ballGroup.length > 3) {
						ballGroup.getFirstAlive().kill();
					}
						
					previousPoint = new FlxPoint(dot_graphic.x, dot_graphic.y);
					
					if (FlxG.overlap(dot_graphic, dot)) {
						moveDot();
					}
				} else {
					if (delay.hasExpired && dots > 0) {
						trace(dots);
						moveDot();
						delay.reset(1000);
					}
				}
			}
		}
		
		public function moveDot():void {
			lastX = dot.x + dot.width / 2;
			lastY = dot.y + dot.height / 2;
			
			var speak:int = FlxU.round(Math.random() * 100);
			if ((words > speak && dots >= 2) || (difficulty == 0 && dots == 7)) {
				addWord();
			}
			
			dot.move();
			dots--;
			dotsLeft.text = dots.toString() + " dots";
			if (dots == 0) {
				bossQuestion();
			}
		}
		
		public function addWord():void {
			var word:String = "";
			var praiseTemp:Boolean = true;
			if (difficulty == 0) {
				if (!hazeOnly) {
					word = FlxU.getRandom(praisePhrases) as String;
					praise++;
				}else {
					word = FlxU.getRandom(hazePhrases) as String;
					haze++;
					praiseTemp = false;
				}
			}else {
				if (Math.random() >= .5) {
					word = FlxU.getRandom(praisePhrases) as String;
					praise++;
				}else {
					word = FlxU.getRandom(hazePhrases) as String;
					haze++;
					praiseTemp = false;
				}
			}
			var temp:BorderedText;
			if (Math.random() >= .5) {
				temp = new BorderedText(0, 25, FlxG.width, word);
				temp.velocity.y = (75 - difficulty * 25) + (Math.random() * 25 * (2 * difficulty + 1));
			}else {
				temp = new BorderedText(0, FlxG.height - 45, FlxG.width, word);
				temp.velocity.y = -(75 - difficulty * 25) - (Math.random() * 25 * (2 * difficulty + 1));
			}
			if (difficulty == 0 || (version == 0 && difficulty <= 1)) {
				temp.setFormat("Score2", 20, 0, null, 10);
				temp.color = (praiseTemp) ? 0xFF006600 : 0xFFF00000;
			} else {
				temp.setFormat("Score2", 20, 0, null);
			}
			temp.velocity.x = 90 + (Math.random() * 40 * (difficulty + 1));
			if (difficulty >= 3) {
				if (Math.random() >= .5) {
					temp.velocity.x *= -1;
					temp.alignment = "right";
				}
			}
			add(temp);
		}
		
		public function bossQuestion():void {
			if (version != 2 && difficulty != 0) {
				remove(crayon_graphic);
				remove(dot_graphic);
				ballGroup.kill();
			}
			super.resetTimer(6000);

			remove(drawing);
			FlxG.mouse.show();
			
			dot.visible = false;
			dotsLeft.visible = false;
			sketchpad.visible = false;
			//command.visible = false;
			var answer:int = 0;
			var qContent:String;
			var scale:Number = 1.5;
			
			if(version == 0 || version == 2) {
				if (difficulty <= 1) {
					var q1:DictatorDictionText;
					var q2:DictatorDictionText;
					if(difficulty == 0) {
						if (!hazeOnly) {
							q1 = new DictatorDictionText(FlxG.width / 2, (FlxG.height / 2) - 50, FlxG.width, "How many times were you told you did a ");
							q2 = new DictatorDictionText(0, (FlxG.height / 2) - 50, FlxG.width, "good job?");
							q2.setFormat("Regular", 24, 0xFF006600);
							answer = praise;
						}else {
							q1 = new DictatorDictionText(FlxG.width / 2, FlxG.height * 1 / 2 - 50, FlxG.width / 2 + 130, "How many times were you told to ");
							q2 = new DictatorDictionText(0, FlxG.height * 1 / 2 - 50, FlxG.width, "just quit?");
							q2.setFormat("Regular", 24, 0xFFF00000);
							answer = haze;
						}
						q1.setFormat("Regular", 24, 0);
						q1.x = q1.x - ((q1.getRealWidth() + q2.getRealWidth()) / 2);
						q2.x = q1.x + q1.getRealWidth();
					}else {
						if (Math.random() >= .5) {
							q1 = new DictatorDictionText(FlxG.width / 2, (FlxG.height / 2) - 50, FlxG.width, "How many times were you told you did a ");
							q2 = new DictatorDictionText(0, (FlxG.height / 2) - 50, FlxG.width, "good job?");
							q2.setFormat("Regular", 24, 0xFF006600);
							answer = praise;
						}else {
							q1 = new DictatorDictionText(FlxG.width / 2, FlxG.height * 1 / 2 - 50, FlxG.width / 2 + 130, "How many times were you told to ");
							q2 = new DictatorDictionText(0, FlxG.height * 1 / 2 - 50, FlxG.width, "just quit?");
							q2.setFormat("Regular", 24, 0xFFF00000);
							answer = haze;
						}
						q1.setFormat("Regular", 24, 0);
						q1.x = q1.x - ((q1.getRealWidth() + q2.getRealWidth()) / 2);
						q2.x = q1.x + q1.getRealWidth();
					}
					add(q1);
					add(q2);
				}else {
					question = new DictatorDictionText(0, FlxG.height * 1/2 - 50, FlxG.width, "");
					question.setFormat("Regular", 24, 0, "center");
					
					if (Math.random() >= .5) {
						qContent = "How many times were you told you did a good job?";
						answer = praise;
					}else {
						qContent = "How many times were you told to just quit?";
						answer = haze;
					}
					question.text = qContent;
					
					add(question);
				}
			}else {
				if(difficulty == 0) {
					question = new DictatorDictionText(0, FlxG.height * 1/2 - 50, FlxG.width, "What did your coworker say when you played?");
					question.setFormat("Regular", 24, 0, "center");
					
					var hazeButton:FlxButtonPlus;
					var praiseButton:FlxButtonPlus;

					if(hazeOnly) {
						hazeButton = new FlxButtonPlus(350, FlxG.height * 3 / 4 - 50, correct, null, "Just Quit!", 200, 40);
						praiseButton = new FlxButtonPlus(90, FlxG.height * 3 / 4 - 50, wrong, null, "Good Job!", 200, 40);
						//correctAnswer = hazeButton;
					} else {
						hazeButton = new FlxButtonPlus(350, FlxG.height * 3 / 4 - 50, wrong, null, "Just Quit!", 200, 35);
						praiseButton = new FlxButtonPlus(90, FlxG.height * 3 / 4 - 50, correct, null, "Good Job!", 200, 35);
						//correctAnswer = praiseButton;
					}
					
					hazeButton.textNormal.font = "Regular";
					hazeButton.textNormal.size = 20;
					hazeButton.textHighlight.font = "Regular";
					hazeButton.textHighlight.size = 20;
					

					praiseButton.textNormal.font = "Regular";
					praiseButton.textNormal.size = 20;
					praiseButton.textHighlight.font = "Regular";
					praiseButton.textHighlight.size = 20;
					
					add(hazeButton);
					add(praiseButton);
					add(question);
				}else {
					question = new DictatorDictionText(0, FlxG.height * 1/2 - 50, FlxG.width, "");
					question.setFormat("Regular", 24, 0, "center");
					
					if (Math.random() >= .5) {
						qContent = "How many times were you told you did a good job?";
						answer = praise;
					}else {
						qContent = "How many times were you told to just quit?";
						answer = haze;
					}
					question.text = qContent;
					
					add(question);
				}
			}
			if(!(version == 1 && difficulty == 0)) {
				var choices:Array = new Array();
				var realChoices:Array = new Array();
				
				for (var i:int = answer - 4; i <= answer + 4; i++) {
					if (i != praise && i != haze && i >= 0) {
						choices.push(i);
					}
				}
				FlxU.shuffle(choices, 30);
				
				realChoices.push(praise);
				realChoices.push(choices[0]);
				realChoices.push(choices[1]);
				if (praise != haze) {
					realChoices.push(haze);
				} else {
					realChoices.push(choices[2]);
				}
				FlxU.shuffle(realChoices, 16);
				
				for (i = 0; i < 4; i++) {
					var button:FlxButton;
					var value:int = realChoices[i] as int;

					if(value == answer) {
						button = new FlxButton(85 + 130 * i, FlxG.height*3/4 - 50, value.toString(), correct);
						correctAnswer = button;
					} else {
						button = new FlxButton(85 + 130 * i, FlxG.height*3/4 - 50, value.toString(), wrong);
					}
					
					button.scale.x = scale;
					button.scale.y = scale;
					button.label.font = "Regular";
					button.label.size = 16;
					button.label.offset.y += 6;
					button.label.color = 0xFF000000;
					
					add(button);
				}
			}
		}
		
		public function wrong():void {
			if(!(version == 1 && difficulty == 0)) {
				correctAnswer.flicker(1);
			}
			
			if (!gameOver) {
				var data1:Object = { "completed":"failure","type":"wrong answer" };
				Registry.loggingControl.logLevelEnd(data1);
			}
			gameOver = true;
			super.success = false;
			super.timer.abort();
		}
		
		public function correct():void {
			if(!gameOver) {
				var data1:Object = { "completed":"success" };
				Registry.loggingControl.logLevelEnd(data1);
			}
			gameOver = true;
			super.success = true;
		}
		
		public function timeout():void {
			if (correctAnswer != null) {
				correctAnswer.flicker(1);
			}
			
			if(!gameOver) {
				var data1:Object = { "completed":"failure","type":"timeout" };
				Registry.loggingControl.logLevelEnd(data1);
			}
			gameOver = true;
			super.success = false;
			super.timer.abort();
		}
		
		override public function destroy():void {
			//	Important! Clear out the plugin otherwise resources will get messed right up after a while
			FlxMouseControl.clear();

			super.destroy();
		}
	}
}