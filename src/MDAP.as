package {
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;

	/**
	 * @author Connor
	 */
	public class MDAP extends MinigameState {
		[Embed(source = "sound_assets/startup.mp3")] private var Startup:Class;
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
		
		private var dot:Dot;
		private var sketchpad:FlxSprite;
		private var drawing:FlxSprite;
		
		private var dotsLeft:FlxText;
		//private var command:FlxText;
		private var question:FlxText;
		
		private var b1:FlxButton;
		private var b2:FlxButton;
		private var b3:FlxButton;
		private var b4:FlxButton;
		
		private var difficulty:int;
		private var dots:int;
		private var haze:int;
		private var praise:int;
		private var words:int;
		private var hazePhrases:Array;
		private var praisePhrases:Array;
		
		private var color:uint;
		
		private var finalQuestion:Boolean;
		private var correctAnswer:FlxButton;
		
		private var lastX:int;
		private var lastY:int;
		
		override public function create():void {
			//FlxG.addPlugin(new FlxMouseControl()); must have already been called
			FlxG.play(Startup);
			
			FlxG.mouse.show();
			FlxG.bgColor = 0xffffffff;
			
			difficulty = Registry.difficultyLevel;
			dots = 7 + 5 * difficulty;
			words = 20 + 10 * difficulty;
			var seconds:int = 10 + 5 * difficulty;
			
			finalQuestion = false;
			
			lastX = 0;
			lastY = 0;
			dot = new Dot();
			dot.enableMouseClicks(false);
			dot.mousePressedCallback = moveDot;
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
			
			praisePhrases = ["Nice job!"];
			
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
			
			add(dotsLeft);
			//add(command);
			add(dot);
			
			var X_OFFSET:int = 0;
			var Y_OFFSET:int = -80;
			var SCALE:Number = 0.7;
			randNum = Math.floor(Math.random() * 6);
			switch (randNum) {
				case 0:
					FlxG.mouse.load(crayonRedImage, SCALE, X_OFFSET, Y_OFFSET);
					color = 0xFFDB4D4D;
					break;
				case 1:
					FlxG.mouse.load(crayonBlueImage, SCALE, X_OFFSET, Y_OFFSET);
					color = 0xFFA3A3FF;
					break;
				case 2:
					FlxG.mouse.load(crayonGreenImage, SCALE, X_OFFSET, Y_OFFSET);
					color = 0xFF47A347;
					break;
				case 3:
					FlxG.mouse.load(crayonYellowImage, SCALE, X_OFFSET, Y_OFFSET);
					color = 0xFFFFFF00;
					break;
				case 4:
					FlxG.mouse.load(crayonOrangeImage, SCALE, X_OFFSET, Y_OFFSET);
					color = 0xFFCC6600;
					break;
				default:
					FlxG.mouse.load(crayonPurpleImage, SCALE, X_OFFSET, Y_OFFSET);
					color = 0xFFCC66FF;
					break;
			}
			
			if (difficulty == 0) {
				addWord();
			}
			super.create();
			super.setCommandText("Connect the dots!");
			super.setTimer(seconds * 1000);
			super.timer.callback = timeout;
		}
		
		override public function update():void {
			super.update();
		}
		
		public function moveDot(d:FlxExtendedSprite, currentx:int, currenty:int):void {
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
			sketchpad.drawLine(lastX, lastY, dot.x + dot.width / 2, dot.y + dot.height / 2, color, 3);
		}
		
		public function addWord():void {
			var word:String = "";
			if (Math.random() >= .5) {
				word = FlxU.getRandom(praisePhrases) as String;
				praise++;
			}else {
				word = FlxU.getRandom(hazePhrases) as String;
				haze++;
			}
			var temp:FlxText
			if (Math.random() >= .5) {
				temp = new FlxText(0, 0, FlxG.width, word);
				temp.velocity.y = 100 + 20*difficulty;
			}else {
				temp = new FlxText(0, FlxG.height - 20, 200, word);
				temp.velocity.y = -100 - 20*difficulty;
			}
			temp.setFormat(null, 16, 0);
			temp.velocity.x = 130 + 30*difficulty;
			add(temp);
		}
		
		public function bossQuestion():void {
			super.timer.reset(6000);
			
			FlxG.mouse.unload();
			
			remove(drawing);
			
			finalQuestion = true;
			dot.visible = false;
			dotsLeft.visible = false;
			sketchpad.visible = false;
			//command.visible = false;
			var answer:int = 0;
			
			var qContent:String
			question = new FlxText(0, FlxG.height * 1/2, FlxG.width, "");
			question.setFormat(null, 16, 0, "center");
			
			if (Math.random() >= .5) {
				qContent = "How many times were you told you did a good job?";
				answer = praise;
			}else {
				qContent = "How many times were you told to quit?";
				answer = haze;
			}
			question.text = qContent;
			
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
			
			var value:int = realChoices[0] as int;
			if(value == answer) {
				b1 = new FlxButton(85, FlxG.height*3/4, value.toString(), correct);
				correctAnswer = b1;
			} else {
				b1 = new FlxButton(85, FlxG.height*3/4, value.toString(), wrong);
			}
			
			value = realChoices[1] as int;
			if(value == answer) {
				b2 = new FlxButton(215, FlxG.height*3/4, value.toString(), correct);
				correctAnswer = b2;
			} else {
				b2 = new FlxButton(215, FlxG.height*3/4, value.toString(), wrong);
			}
			
			value = realChoices[2] as int;
			if(value == answer) {
				b3 = new FlxButton(345, FlxG.height*3/4, value.toString(), correct);
				correctAnswer = b3;
			} else {
				b3 = new FlxButton(345, FlxG.height * 3 / 4, value.toString(), wrong);
			}
			
			value = realChoices[3] as int;
			if(value == answer) {
				b4 = new FlxButton(475, FlxG.height*3/4, value.toString(), correct);
				correctAnswer = b4;
			} else {
				b4 = new FlxButton(475, FlxG.height*3/4, value.toString(), wrong);
			}
			
			b1.scale.x = 1.5;
			b1.scale.y = 1.5;
			b2.scale.x = 1.5;
			b2.scale.y = 1.5;
			b3.scale.x = 1.5;
			b3.scale.y = 1.5;
			b4.scale.x = 1.5;
			b4.scale.y = 1.5;
			
			add(question);
			add(b1);
			add(b2);
			add(b3);
			add(b4);
		}
		
		public function wrong():void {
			question.text = "You are wrong!";
			correctAnswer.flicker(1);
			
			super.success = false;
			super.timer.abort();
		}
		
		public function correct():void {
			question.text = "You are correct!";
			
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
			
			super.success = false;
			super.timer.abort();
		}
	}
}