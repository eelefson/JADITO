package  {
	import flash.utils.*;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	/**
	 * ...
	 * @author Elijah Elefson
	 */
	public class MinigameState extends FlxState {
		[Embed(source = "sound_assets/ready_set_go.mp3")] private var ReadySetGoSFX:Class;
		[Embed(source = "sound_assets/go.mp3")] private var GoSFX:Class;
		[Embed(source="sound_assets/correct-answer.mp3")] private var SuccessSFX:Class;
		[Embed(source = "sound_assets/buzzer.mp3")] private var FailureSFX:Class;
		[Embed(source="image_assets/big_check_mark3.png")] private var CheckMarkImage:Class;
		[Embed(source = "image_assets/x_mark_red_big.png")] private var XMarkImage:Class;
		[Embed(source = "font_assets/ArbutusSlab-Regular.ttf", fontFamily = "Regular", embedAsCFF = "false")] private var RegularFont:String;
		[Embed(source = "font_assets/BowlbyOne-Regular.ttf", fontFamily = "Score2", embedAsCFF = "false")] private var ScoreFont:String;
		
		
		public var walls:FlxGroup;
		public var topWall:FlxTileblock;
		public var bottomWall:FlxTileblock;
		public var leftWall:FlxTileblock;
		public var rightWall:FlxTileblock;
		
		private var check_graphic:FlxSprite;
		private var x_graphic:FlxSprite;
		
		public var timer:FlxDelay;
		public var timerText:BorderedText;
		protected var commandText:FlxText;
		private var skipButton:FlxButton;
		
		private var transparentBackground:FlxButton;
		
		private var introCommandText:BorderedText;
		
		private var introDelay:FlxTimer;
		
		public var success:Boolean = false;
		
		public var pauseForInstructions:Boolean = true;
		
		private var pauseMenu:PauseMenu = new PauseMenu(0, 0);
		
		private var timeRemaining:Number;
		private var timeLeftBar:FlxTileblock;
		private var startingTime:Number = 0;
		
		private var goText:BorderedText;
		
		private var goBool:Boolean = true;
		
		private var playSound:Boolean = true;
		private var playSound2:Boolean = true;
		
		private var playEndSound:Boolean = true;
		
		private var totalTime:Number;
		
		private var blink:Boolean = true;
		
		public var gameOver:Boolean = false;
		
		public var levelZero:Boolean;
		
		override public function create():void {
			if (Registry.skip) {
				success = true;
			}
			FlxG.camera.flash(0xffffffff, 1);
			
			walls = new FlxGroup();
			
			topWall = new FlxTileblock(0, 0, FlxG.width, 25);
			topWall.makeGraphic(FlxG.width, 25, 0xff000000);
			topWall.immovable = true;
			topWall.elasticity = 0;
			topWall.solid = true;
			walls.add(topWall);
			
			bottomWall = new FlxTileblock(2, FlxG.height - 25, FlxG.width - 4, 25);
			bottomWall.makeGraphic(FlxG.width - 4, 25, 0xFF990000);
			bottomWall.immovable = true;
			bottomWall.elasticity = 0;
			bottomWall.solid = true;
			walls.add(bottomWall);
			
			timeLeftBar = new FlxTileblock(2, FlxG.height - 25, FlxG.width - 4, 25);
			timeLeftBar.makeGraphic(FlxG.width - 4, 25, 0xFF006600);
			
			leftWall = new FlxTileblock(0, 0, 2, FlxG.height);
			leftWall.makeGraphic(2, FlxG.height, 0xff000000);
			leftWall.immovable = true;
			leftWall.elasticity = 0;
			leftWall.solid = true;
			walls.add(leftWall);
			
			rightWall = new FlxTileblock(FlxG.width - 2, 0, 2, FlxG.height);
			rightWall.makeGraphic(2, FlxG.height, 0xff000000);
			rightWall.immovable = true;
			rightWall.elasticity = 0;
			rightWall.solid = true;
			walls.add(rightWall);
			
			add(walls);
			add(timeLeftBar);
			
			var bottomBorder:FlxTileblock = new FlxTileblock(0,  FlxG.height - 2, FlxG.width, 2);
			bottomBorder.makeGraphic(FlxG.width, 2, 0xff000000);
			add(bottomBorder);
			/*skipButton = new FlxButton(FlxG.width, FlxG.height, null, skip);
			skipButton.x = skipButton.x - skipButton.width;
			skipButton.y = skipButton.y - skipButton.height;
			skipButton.color = 0xff000000;
			add(skipButton);*/
			
			goText = new BorderedText(FlxG.width / 2, FlxG.height / 2, FlxG.width, "READY!");
			goText.setFormat("Score2", 36, 0xffffffff, "center", 25);
			goText.x = goText.x - (goText.width / 2);
			goText.y = goText.y - (goText.height / 2);
			goText.visible = false;
			add(goText);
			 
			if (Registry.difficultyLevel == 0) {
				timeRemaining = 5;
				levelZero = true;
			} else {
				timeRemaining = 1;
				levelZero = false;
			}
			
		}
		
		override public function update():void {
			if (!FlxG.paused) {
				super.update();
				if (!timer.hasExpired) {
					timerText.text = "Time left: " + timer.secondsRemaining.toString();
					if (startingTime == 0) {
						startingTime = timer.secondsRemaining;
					}
					timeLeftBar.scale.x = timer.secondsRemaining / startingTime;
				}
				if (timeRemaining > 0) {
					FlxG.paused = true;
				}
			} else {
				pauseMenu.update();
			}
			
			if (timer.hasExpired || success) {
				if (playEndSound) {
					if (success) {
						FlxG.play(SuccessSFX);
						placeSuccessGraphic();
						blinkSuccess();
						setInterval(blinkSuccess, 500);
					} else {
						FlxG.play(FailureSFX);
						placeFailureGraphic();
						blinkFailure();
						setInterval(blinkFailure, 500);
					}
					totalTime = 0; //CONTROLS THE DELAY
					FlxG.paused = true;
					playEndSound = false;
					timer.abort();
				}
				
				if (success && FlxU.ceil(totalTime) < 0) {
					FlxG.mouse.show();
					FlxG.paused = false;
					Registry.taskStatuses[Registry.taskStatuses.indexOf(TaskStatuses.EMPTY)] = TaskStatuses.SUCCESS;
					if (Registry.pool.length == 0) {
						if (Registry.playCurrentDay) {
							if (Registry.score < Registry.BobScores[Registry.day] + (8000 * Registry.playthrough)) {
								FlxG.switchState(new LoseState());
							} else {
								FlxG.switchState(new TitleAwardState());
							}
						}
					} else {
						FlxG.switchState(new PlayState());
					}
				} else if (FlxU.ceil(totalTime) < 0) {
					FlxG.mouse.show();
					FlxG.paused = false;
					Registry.taskStatuses[Registry.taskStatuses.indexOf(TaskStatuses.EMPTY)] = TaskStatuses.FAILURE;
					if (Registry.pool.length == 0) {
						if (Registry.playCurrentDay) {
							if (Registry.score < Registry.BobScores[Registry.day]+ (8000 * Registry.playthrough)) {
								FlxG.switchState(new LoseState());
							} else {
								FlxG.switchState(new TitleAwardState());
							}
						}
					} else {
						FlxG.switchState(new PlayState());
					}
				}
			} else {
				if (FlxU.ceil(timeRemaining) > 1) {
					if (FlxU.ceil(timeRemaining) < 4) {
						introCommandText.y -= 10;
						introCommandText.size -= 1;
						if (FlxU.ceil(timeRemaining) == 3) {
							goText.visible = true;
						} else if (FlxU.ceil(timeRemaining) == 2) {
							goText.text = "SET!";
						}
						
						if (playSound) {
							FlxG.play(ReadySetGoSFX);
							playSound = false;
						}
						
						if (introCommandText.y <= 0) {
							commandText.visible = true;
						}
					}
					timeRemaining -= FlxG.elapsed;
				} else {
					if (!levelZero) {
						if (timeRemaining < 0.2) {
							introCommandText.y -= 10;
							introCommandText.size -= 1;
							
							if (playSound2) {
								FlxG.play(GoSFX);
								playSound2 = false;
							}
						}
						if (timeRemaining < 0.1) {
							goText.visible = true;
							goText.text = "GO!";
						}
						
						if (introCommandText.y <= 0) {
							commandText.visible = true;
						}
						
						if (timeRemaining < -0.5) {
							goText.kill();
							FlxG.paused = false;
						}
						
					} else {
						if (goBool) {
							goText.text = "GO!";
						}
						if (timeRemaining < 0.5) {
							goText.kill();
							FlxG.paused = false;
						}
					}
					timeRemaining -= FlxG.elapsed;
				}
			}
			totalTime -= FlxG.elapsed;
		}
		
		private function blinkSuccess():void {
			if (blink) {
				check_graphic.visible = true;
				blink = false;
			} else {
				check_graphic.visible = false;
				blink = true;
			}
		}
		
		private function blinkFailure():void {
			if (blink) {
				x_graphic.visible = true;
				blink = false;
			} else {
				x_graphic.visible = false;
				blink = true;
			}
		}
		
		public function placeSuccessGraphic():void {
			Registry.score += 100 * (Registry.difficultyLevel + 1);
			Registry.failedMostRecentMinigame = false;
			check_graphic = new FlxSprite(0, 0, CheckMarkImage);
			check_graphic.x = ((FlxG.width - check_graphic.width) / 2);
			check_graphic.y = ((FlxG.height - check_graphic.height) / 2);
			check_graphic.visible = false;
			check_graphic.immovable = true;
			add(check_graphic);
		}
		
		public function placeFailureGraphic():void {
			Registry.failures--;
			Registry.failedMostRecentMinigame = true;
			x_graphic = new FlxSprite(0, 0, XMarkImage);
			x_graphic.x = ((FlxG.width - x_graphic.width) / 2);
			x_graphic.y = ((FlxG.height - x_graphic.height) / 2);
			x_graphic.visible = false;
			x_graphic.immovable = true;
			add(x_graphic);
		}
		
		private function skip():void {
			success = true;
		}
		
		protected function setTimer(runFor:int):void {
			timer = new FlxDelay(runFor+1);
			timerText = new BorderedText(0, FlxG.height - 28, FlxG.width, "Time left: " + timer.secondsRemaining.toString());
			timerText.setFormat("Regular", 21, 0xffffffff, "center", 10);
			add(timerText);
			// +3 for end time, +5 for start time
			totalTime = runFor + 1 + 2 + 5;
			timer.start();
		}
		
		protected function resetTimer(runFor:int):void {
			timer.reset(runFor);
			startingTime = timer.secondsRemaining;
			timeLeftBar.scale.x = 1;
		}
		
		protected function disableTimer():void {
			remove(timeLeftBar);
			timerText.visible = false;
			bottomWall.color = 0xFF000000;
		}
		
		protected function setCommandText(command:String):void {
			introCommandText = new BorderedText(FlxG.width / 2, FlxG.height / 2, FlxG.width, command);
			introCommandText.setFormat("Score2", 36, 0xffffffff, "center", 25);
			introCommandText.x = introCommandText.x - (introCommandText.width / 2);
			introCommandText.y = introCommandText.y - (introCommandText.height / 2);
			add(introCommandText);
			
			commandText = new FlxText(0, -2, FlxG.width, command);
			commandText.setFormat("Score2", 16, 0xffffffff, "center");
			commandText.visible = false;
			add(commandText);
		}
	}
}