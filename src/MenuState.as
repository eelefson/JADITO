package  {
	import org.flixel.*;
	import flash.utils.*;
	import org.flixel.plugin.photonstorm.*;
	
	/**
	 * ...
	 * @author Elijah Elefson
	 */
	public class MenuState extends FlxState {
		[Embed(source = "image_assets/start-button.png")] private var ImageButton:Class // This is a sprite of the button
		[Embed(source = "image_assets/Mute.png")] private var MuteButton:Class;
		[Embed(source = "image_assets/Play.png")] private var PlayButton:Class;
		
		public var start_button:FlxButton;
		public var mute_button:FlxButton;
		public var musicText:FlxText;
		public var bool:Boolean = true;
		public var startingGame:Boolean = false;
		
		override public function create():void {
			
			var title:FlxText;
			title = new FlxText(0, 16, FlxG.width, "Just Another Day In The Office");
			title.setFormat(null, 50, 0xFFFFFFFF, "center");
			add(title);
			
			start_button = new FlxButton(FlxG.width / 2, FlxG.height / 2, null, clickStartButton);
			start_button.loadGraphic(ImageButton);
			start_button.x = start_button.x - (start_button.width / 2);
			start_button.y = start_button.y - (start_button.height / 2);
			add(start_button);
			
			mute_button = new FlxButton(0, FlxG.height, null, mute);
			mute_button.loadGraphic(PlayButton);
			mute_button.y = mute_button.y - (mute_button.height);
			add(mute_button);
			
			musicText = new FlxText(0, FlxG.height - mute_button.height, FlxG.width, "Music:");
			musicText.setFormat(null, 16, 0xFFFFFFFF, "left");
			musicText.y = musicText.y - (musicText.height / 2);
			add(musicText);
			
			var instructions:FlxText;
			instructions = new FlxText(0, FlxG.height - 128, FlxG.width, "Instructions:\n" + 
				"Use the mouse throughout the game.\n");
			instructions.setFormat(null, 16, 0xFFFFFFFF, "center");
			add(instructions);
			
			super.create();
		}
		
		override public function update():void {
			super.update();
			if (bool) {
				bool = false;
				FlxG.playMusic(Elevatormusic7);
			}
		}
		
		public function mute():void {
			FlxG.music.pause();
			mute_button.kill();
			mute_button = new FlxButton(0, FlxG.height, null, play);
			mute_button.loadGraphic(MuteButton);
			mute_button.y = mute_button.y - (mute_button.height);
			add(mute_button);
		}
		
		public function play():void {
			FlxG.music.resume();
			mute_button.kill();
			mute_button = new FlxButton(0, FlxG.height, null, mute);
			mute_button.loadGraphic(PlayButton);
			mute_button.y = mute_button.y - (mute_button.height);
			add(mute_button);
		}
		
		public function clickStartButton():void {
			// Array storing all the possible minigames available to play
			var a:Array = new Array(MinigameEnums.DICTATOR_DICTION, MinigameEnums.COFFEE_RUN, MinigameEnums.COLD_CALLER,
				MinigameEnums.MY_DAUGTHERS_ART_PROJECT, MinigameEnums.SIGN_PAPER, MinigameEnums.IN_OUT,
				MinigameEnums.BRAINSTORMER, MinigameEnums.SPEEDY_STAPLER, MinigameEnums.SPELL_CHECKER,
				MinigameEnums.AVOID_THE_COWORKER, MinigameEnums.CATCH_PENCIL, MinigameEnums.PICK_UP_PAPERS,
				MinigameEnums.CLOCK_IN);
			shuffle(a);
			var levelZeroMinigames:Array = new Array();
			// Adds 10 minigames at difficulty level 0 from the overall pool of minigames
			var numMinigamesToSelect:int = 6;
			for (var i:int = 0; i < numMinigamesToSelect; i++) {
				levelZeroMinigames[i] = a[i];
			}
			
			// Array containing arrays of the minigames at each difficulty level(0-3)
			var minigames:Array = new Array(levelZeroMinigames, new Array(), new Array(), new Array());
			Registry.day = DaysOfTheWeek.MONDAY;
			Registry.playCurrentDay = false;
			Registry.pool = new Array();
			Registry.taskStatuses = new Array();
			for (i = 0; i < 6; i++) {
				Registry.taskStatuses[i] = TaskStatuses.EMPTY;
			}
			Registry.minigames = minigames;
			FlxG.switchState(new PlayState());
		}
		
		public function shuffle(a:Array):void {
			var p:int;
			var t:*;
			for (var i:int = a.length - 1; i >= 0; i--) {
				p = Math.floor((i+1)*Math.random());
				t = a[i];
				a[i] = a[p];
				a[p] = t;
			}
		}
	}
}