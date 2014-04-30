package  {
	import flash.utils.Dictionary;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	/**
	 * ...
	 * @author Elijah Elefson
	 */
	public class MinigameState extends FlxState {
		
		protected var timer:FlxDelay;
		protected var timerText:FlxText;
		
		protected var success:Boolean = false;
		
		override public function create():void {
			FlxG.camera.flash(0xffffffff, 1);		
			//timer = new FlxDelay(5000); WHAT IT USED TO BE, CHANGED TO SPEED UP TESTING
		}
		
		override public function update():void {
			super.update();
			if (!timer.hasExpired) {
				timerText.text = "Time left: " + timer.secondsRemaining.toString();
			}
			if (timer.hasExpired || success) {
				if (success) {
					Registry.taskStatuses[Registry.taskStatuses.indexOf(TaskStatuses.EMPTY)] = TaskStatuses.SUCCESS;	
				} else {
					Registry.taskStatuses[Registry.taskStatuses.indexOf(TaskStatuses.EMPTY)] = TaskStatuses.FAILURE;
				}
				FlxG.switchState(new PlayState());
			}
		}
		
		protected function setTimer(runFor:int):void {
			timer = new FlxDelay(runFor);
			
			timerText = new FlxText(0, 0, FlxG.width, "Time left: " + timer.secondsRemaining.toString());
			//timerText.setFormat(null, 16, 0x00000000, "center");
			timerText.setFormat(null, 16, 0x00000000, "left");
			add(timerText);
			
			timer.start();
		}
	}
}