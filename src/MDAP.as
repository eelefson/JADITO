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
		
		private var dot:Dot;
		private var sketchpad:FlxSprite;
		private var drawing:FlxSprite;
		
		private var dotsLeft:FlxText;
		private var question:FlxText;
		
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
		
		override public function create():void {
			if (FlxG.getPlugin(FlxMouseControl) == null) {
				FlxG.addPlugin(new FlxMouseControl);
			}
						
			FlxG.mouse.hide();
			FlxG.bgColor = 0xffffffff;
			
			gameOver = false;
			
			difficulty = Registry.difficultyLevel;
			dots = 7 + 6 * difficulty;
			words = 20 + 10 * difficulty;
			var seconds:int = 10 + 5 * difficulty;
						
			lastX = 0;
			lastY = 0;
			dot = new Dot();
			//dot.enableMouseClicks(false);
			//dot.mousePressedCallback = moveDot;
			//dot.clickable = true;
			
			dotsLeft = new FlxText(0, 25, FlxG.width, dots.toString() + " dots");
			dotsLeft.setFormat(null, 16, 0, "right");
			
			//command = new FlxText(0, 0, FlxG.width, "Click the dots!");
			//command.setFormat(null, 16, 0, "center");
			
			sketchpad = new FlxSprite();
			//sketchpad.makeGraphic(FlxG.width, FlxG.height);
			sketchpad.loadGraphic(sketchpadImage);
			add(sketchpad);
			
			hazePhrases = ["Just quit!"];
			//[ "Intern!!!", "You shouldn't be proud!", "You missed a spot!", "Go to college for that?", "Just quit!", 
			//":(", "That is bad!", "You will never make it!" ];
			haze = 0;
			
			praisePhrases = ["Good job!"];
			
			//[ "Nice job!", "Hang in there!", "That looks really good!", "You are my hero!", "Nice artwork!",
			//"You are great!", "You can do it!", "You got potential kid!", ":)", "You should be proud!" ];
			praise = 0;
			
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
			
			// Eli added for line draw
			ballGroup = new FlxGroup();
			crayon_graphic.x = FlxG.width / 2;
			crayon_graphic.y = FlxG.height / 2;
			dot_graphic = new FlxExtendedSprite(crayon_graphic.x, crayon_graphic.y + crayon_graphic.height, DotImage);
			crayon_graphic.offset.y = crayon_graphic.height;
			previousPoint = new FlxPoint(-100, -100);
			add(ballGroup);
			add(crayon_graphic);
			
			//dragMeText = new FlxText(crayon_graphic.x, crayon_graphic.y, 100, "Drag me!");
			//dragMeText.y = dragMeText.y - dragMeText.height - 10;
			//dragMeText.setFormat(null, 16, 0xff000000);
			//dragMeText.visible = false;
			//blinkText();
			//intervalID = setInterval(blinkText, 500);
			//add(dragMeText);
			
			add(dotsLeft);
			add(dot);
			
			if (difficulty == 0) {
				addWord();
			}
			super.create();
			super.setCommandText("Connect the dots!");
			super.setTimer(seconds * 1000);
			super.timer.callback = timeout;
			var data5:Object = { "difficulty":difficulty };
			Registry.loggingControl.logLevelStart(8, data5);
		}
		
		override public function update():void {
			super.update();
			if(!FlxG.paused) {
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
			}
		}
		
		private function blinkText():void {
			if (blink) {
				dragMeText.visible = true;
				blink = false;
			} else {
				dragMeText.visible = false;
				blink = true;
			}
		}
		
		public function moveDot():void {
			if (lastX != 0) {
				drawLine();
			}
			lastX = dot.x + dot.width / 2;
			lastY = dot.y + dot.height / 2;
			
			var speak:int = FlxU.round(Math.random() * 100);
			if (words > speak && dots >= 2) {
				addWord();
			}
			
			dot.move();
			dots--;
			dotsLeft.text = dots.toString() + " dots";
			if (dots == 0) {
				bossQuestion();
			}
		}
		
		public function drawLine():void {
			//sketchpad.drawLine(lastX, lastY, dot.x + dot.width / 2, dot.y + dot.height / 2, 0);
		}
		
		public function addWord():void {
			var word:String = "";
			var praiseTemp:Boolean = true;
			if (Math.random() >= .5) {
				word = FlxU.getRandom(praisePhrases) as String;
				praise++;
			}else {
				word = FlxU.getRandom(hazePhrases) as String;
				haze++;
				praiseTemp = false;
			}
			var temp:FlxText
			if (Math.random() >= .5) {
				temp = new FlxText(0, 0, FlxG.width, word);
				temp.velocity.y = 100 + (Math.random() * 25*difficulty);
			}else {
				temp = new FlxText(0, FlxG.height - 20, 200, word);
				temp.velocity.y = -100 - (Math.random() * 25*difficulty);
			}
			temp.setFormat(null, 20, 0);
			if (difficulty == 0) {
				temp.color = (praiseTemp) ? 0xFF006600 : 0xFFF00000;
			}
			temp.velocity.x = 130 + (Math.random() *40*difficulty);
			add(temp);
		}
		
		public function bossQuestion():void {
			remove(crayon_graphic);
			remove(dot_graphic);
			ballGroup.kill();
			super.resetTimer(6000);

			remove(drawing);
			FlxG.mouse.show();
			
			dot.visible = false;
			dotsLeft.visible = false;
			sketchpad.visible = false;
			//command.visible = false;
			var answer:int = 0;
			
			if (difficulty == 0) {
				var q1:FlxText;
				var q2:FlxText;
				
				if (Math.random() >= .5) {
					q1 = new FlxText(0, FlxG.height * 1 / 2 - 50, FlxG.width / 2 + 165, "How many times were you told you did a ");
					q2 = new FlxText(FlxG.width / 2 + 170, FlxG.height * 1 / 2 - 50, FlxG.width, "good job?");
					q2.setFormat("Typewriter", 24, 0xFF006600, "left");
					answer = praise;
				}else {
					q1 = new FlxText(0, FlxG.height * 1 / 2 - 50, FlxG.width / 2 + 130, "How many times were you told to ");
					q2 = new FlxText(FlxG.width / 2 + 135, FlxG.height * 1 / 2 - 50, FlxG.width, "just quit?");
					q2.setFormat("Typewriter", 24, 0xFFF00000, "left");
					answer = haze;
				}
				q1.setFormat("Typewriter", 24, 0, "right");
				
				add(q1);
				add(q2);
			}else {
				var qContent:String;
				question = new FlxText(0, FlxG.height * 1/2 - 50, FlxG.width, "");
				question.setFormat("Typewriter", 24, 0, "center");
				
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
				var scale:Number = 1.5;

				if(value == answer) {
					button = new FlxButton(85 + 130 * i, FlxG.height*3/4 - 50, value.toString(), correct);
					correctAnswer = button;
				} else {
					button = new FlxButton(85 + 130 * i, FlxG.height*3/4 - 50, value.toString(), wrong);
				}
				button.scale.x = scale;
				button.scale.y = scale;
				button.label.offset.y = (scale - 1) / 2 * button.label.size;
				button.label.size = button.label.size * scale;
				add(button);
			}/*
			var value:int = realChoices[0] as int;
			if(value == answer) {
				b1 = new FlxButton(85, FlxG.height*3/4 - 50, value.toString(), correct);
				correctAnswer = b1;
			} else {
				b1 = new FlxButton(85, FlxG.height*3/4 - 50, value.toString(), wrong);
			}
			
			value = realChoices[1] as int;
			if(value == answer) {
				b2 = new FlxButton(215, FlxG.height*3/4 - 50, value.toString(), correct);
				correctAnswer = b2;
			} else {
				b2 = new FlxButton(215, FlxG.height*3/4 - 50, value.toString(), wrong);
			}
			
			value = realChoices[2] as int;
			if(value == answer) {
				b3 = new FlxButton(345, FlxG.height*3/4 - 50, value.toString(), correct);
				correctAnswer = b3;
			} else {
				b3 = new FlxButton(345, FlxG.height * 3 / 4 - 50, value.toString(), wrong);
			}
			
			value = realChoices[3] as int;
			if(value == answer) {
				b4 = new FlxButton(475, FlxG.height*3/4 - 50, value.toString(), correct);
				correctAnswer = b4;
			} else {
				b4 = new FlxButton(475, FlxG.height*3/4 - 50, value.toString(), wrong);
			}
			var scale:Number = 1.5;
			b1.scale.x = scale;
			b1.scale.y = scale;
			b1.label.offset.y = (scale - 1) / 2 * b1.label.size;
			b1.label.size = b1.label.size * scale;
			
			b2.scale.x = scale;
			b2.scale.y = scale;
			b2.label.offset.y = (scale - 1) / 2 * b2.label.size;
			b2.label.size = b2.label.size * scale;
			
			b3.scale.x = scale;
			b3.scale.y = scale;
			b3.label.offset.y = (scale - 1) / 2 * b3.label.size;
			b3.label.size = b3.label.size * scale;
			
			b4.scale.x = scale;
			b4.scale.y = scale;
			b4.label.offset.y = (scale - 1) / 2 * b4.label.size;
			b4.label.size = b4.label.size * scale;
			
			add(b1);
			add(b2);
			add(b3);
			add(b4);*/
		}
		
		public function wrong():void {
			correctAnswer.flicker(1);
			
			if (!gameOver) {
				var data1:Object = { "completed":"failure" };
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
			//dot.visible = false;
			//dotsLeft.visible = false;
			//sketchpad.visible = false;
			//command.visible = false;
			
			//question = new FlxText(0, FlxG.height / 2 - 16, FlxG.width, "Out of time!");
			//question.setFormat(null, 16, 0, "center");
			//add(question);
			if (correctAnswer != null) {
				correctAnswer.flicker(1);
			}
			
			if(!gameOver) {
				var data1:Object = { "completed":"failure" };
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