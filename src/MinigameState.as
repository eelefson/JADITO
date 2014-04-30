package  {
	import flash.utils.Dictionary;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	/**
	 * ...
	 * @author Elijah Elefson
	 */
	public class MinigameState extends FlxState {
		
		[Embed(source = "image_assets/MadBoss-300x284.png")] private var BossImage:Class;
		
		private var boss_graphic:FlxExtendedSprite;
		
		private var timer:FlxDelay;
		private var timerText:FlxText;
		
		protected var success:Boolean = false;
		
		override public function create():void {
			FlxG.camera.flash(0xffffffff, 2);		
			//timer = new FlxDelay(5000); WHAT IT USED TO BE, CHANGED TO SPEED UP TESTING
			timer = new FlxDelay(1);
			
			timerText = new FlxText(0, 0, FlxG.width, "Time left: " + timer.secondsRemaining.toString());
			timerText.setFormat(null, 16, 0x00000000, "center");
			add(timerText);
			
			timer.start();
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
	}
}