package  {
	import flash.utils.Dictionary;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	/**
	 * ...
	 * @author Elijah Elefson
	 */
	public class MinigameState extends FlxState {
		
		private var timer:FlxDelay;
		
		private var minigames:Array;
		private var level:uint;
		
		public function MinigameState(minigames:Array, level:uint) {
			this.minigames = minigames;
			this.level = level;
		}
		
		override public function create():void {
			FlxG.camera.flash(0xffffffff, 2);
			timer = new FlxDelay(5000);
			timer.start();
		}
		
		override public function update():void {
			if (timer.hasExpired) {
				Registry.taskStatuses[Registry.taskStatuses.indexOf(TaskStatuses.EMPTY)] = TaskStatuses.FAILURE;
				FlxG.switchState(new PlayState(minigames));
			}
		}
	}
}