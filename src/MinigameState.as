package  {
	import flash.utils.Dictionary;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	/**
	 * ...
	 * @author Elijah Elefson
	 */
	public class MinigameState extends FlxState {
		[Embed(source = "sound_assets/ready_set_go.mp3")] private var ReadySetGoSFX:Class;
		[Embed(source = "sound_assets/success.mp3")] private var SuccessSFX:Class;
		[Embed(source = "sound_assets/failure.mp3")] private var FailureSFX:Class;
		
		public var topWall:FlxTileblock;
		public var bottomWall:FlxTileblock;
		
		public var timer:FlxDelay;
		protected var timerText:FlxText;
		protected var commandText:FlxText;
		private var skipButton:FlxButton;
		
		private var transparentBackground:FlxButton;
		
		private var introCommandText:BorderedText;
		
		private var introDelay:FlxTimer;
		
		public var success:Boolean = false;
		
		public var pauseForInstructions:Boolean = true;
		
		private var pauseMenu:PauseMenu = new PauseMenu(0, 0);
		
		private var countDownText:BorderedText;
		
		private var timeRemaining:Number;
		
		private var goText:BorderedText;
		
		private var goBool:Boolean = true;
		
		private var playSound:Boolean = true;
		
		private var playEndSound:Boolean = true;
		
		//public var endDelay:FlxDelay;
		
		private var totalTime:Number;
		
		override public function create():void {
			FlxG.camera.flash(0xffffffff, 1);
			
			topWall = new FlxTileblock(0, 0, FlxG.width, 25);
			topWall.makeGraphic(FlxG.width, 25, 0xff000000);
			add(topWall);
			
			bottomWall = new FlxTileblock(0, FlxG.height - 25, FlxG.width, 25);
			bottomWall.makeGraphic(FlxG.width, 25, 0xff000000);
			add(bottomWall);
			
			skipButton = new FlxButton(FlxG.width, FlxG.height, null, skip);
			skipButton.x = skipButton.x - skipButton.width;
			skipButton.y = skipButton.y - skipButton.height;
			skipButton.color = 0xff000000;
			add(skipButton);
			
			countDownText = new BorderedText(0, FlxG.height / 2, FlxG.width, "3");
			countDownText.setFormat(null, 32, 0xffffffff, "center", 30);
			countDownText.y = countDownText.y - (countDownText.height / 2);
			countDownText.visible = false;
			add(countDownText);
			
			goText = new BorderedText(FlxG.width / 2, FlxG.height / 2, FlxG.width, "READY!");
			goText.setFormat(null, 36, 0xffffffff, "center", 30);
			goText.x = goText.x - (goText.width / 2);
			goText.y = goText.y - (goText.height / 2);
			goText.visible = false;
			add(goText);			
			
			timeRemaining = 5;
			
		}
		
		override public function update():void {
			if (!FlxG.paused) {
				super.update();
				if (!timer.hasExpired) {
					timerText.text = "Time left: " + timer.secondsRemaining.toString();
				}
				/*if (timer.hasExpired || success) {
					if (success) {
						Registry.taskStatuses[Registry.taskStatuses.indexOf(TaskStatuses.EMPTY)] = TaskStatuses.SUCCESS;	
					} else {
						Registry.taskStatuses[Registry.taskStatuses.indexOf(TaskStatuses.EMPTY)] = TaskStatuses.FAILURE;
					}
					FlxG.switchState(new PlayState());
				}*/
				
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
					} else {
						FlxG.play(FailureSFX);
					}
					totalTime = 2; //CONTROLS THE DELAY
					FlxG.paused = true;
					playEndSound = false;
					timer.abort();
				}
				if (success && FlxU.ceil(totalTime) < 0) {
					Registry.taskStatuses[Registry.taskStatuses.indexOf(TaskStatuses.EMPTY)] = TaskStatuses.SUCCESS;
					FlxG.switchState(new PlayState());
				} else if (FlxU.ceil(totalTime) < 0) {
					Registry.taskStatuses[Registry.taskStatuses.indexOf(TaskStatuses.EMPTY)] = TaskStatuses.FAILURE;
					FlxG.switchState(new PlayState());
				}
			} else {
				if (FlxU.ceil(timeRemaining) > 1) {
					if (FlxU.ceil(timeRemaining) < 4) {
						introCommandText.y -= 10;
						introCommandText.size -= 1;
						//countDownText.visible = true;
						//countDownText.text = FlxU.ceil(timeRemaining).toFixed(0).toString();
						if (FlxU.ceil(timeRemaining) == 3) {
							goText.visible = true;
						} else if (FlxU.ceil(timeRemaining) == 2) {
							goText.text = "SET!";
						} else if (FlxU.ceil(timeRemaining) == 1) {
							goText.text = "GO!";
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
					if (goBool) {
						goText.text = "GO!";
					}
					if (timeRemaining < 0.5) {
						goText.kill();
						FlxG.paused = false;
					}
					countDownText.kill();
					timeRemaining -= FlxG.elapsed;
				}
			}
			totalTime -= FlxG.elapsed;
		}
		
		private function skip():void {
			success = true;
		}
		
		protected function setTimer(runFor:int):void {
			timer = new FlxDelay(runFor);
			timerText = new FlxText(0, FlxG.height - 25, FlxG.width, "Time left: " + timer.secondsRemaining.toString());
			timerText.setFormat(null, 16, 0xffffffff, "center");
			add(timerText);
			// +3 for end time, +5 for start time
			totalTime = runFor + 2 + 5;
			
			timer.start();
		}
		
		protected function setCommandText(command:String):void {
			introCommandText = new BorderedText(FlxG.width / 2, FlxG.height / 2, FlxG.width, command);
			introCommandText.setFormat(null, 36, 0xffffffff, "center", 30);
			introCommandText.x = introCommandText.x - (introCommandText.width / 2);
			introCommandText.y = introCommandText.y - (introCommandText.height / 2);
			add(introCommandText);
			
			commandText = new BorderedText(0, 0, FlxG.width, command);
			commandText.setFormat(null, 16, 0xffffffff, "center");
			commandText.visible = false;
			add(commandText);
		}
	}
}