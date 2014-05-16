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
		[Embed(source = "image_assets/DesktopBackground.jpg")] private var background:Class;
		[Embed(source = "image_assets/Mute.png")] private var MuteButton:Class;
		[Embed(source = "image_assets/Play.png")] private var PlayButton:Class;
		[Embed(source = "image_assets/SplashScreen.jpg")] private var SplashScreenImage:Class;
		[Embed(source = "font_assets/SLOPI___.ttf", fontFamily = "Typewriter", embedAsCFF = "false")] private var TypewriterFont:String;
		
		public var start_button:FlxButton;
		public var mute_button:FlxButton;
		public var musicText:FlxText;
		public var splash_screen_graphic:FlxSprite;
		
		public var topWall:FlxTileblock;
		public var bottomWall:FlxTileblock;
		public var leftWall:FlxTileblock;
		public var rightWall:FlxTileblock;
		
		public var bool:Boolean = true;
		public var startingGame:Boolean = false;
		
		override public function create():void {
			
			//Registry.loggingControl = new Logger("jadito", 103, "4453dcb14ff92850b75600e5193f7247", 1, 1);
			
			var title:FlxText;
			splash_screen_graphic = new FlxSprite(0, 0, SplashScreenImage);
			add(splash_screen_graphic);
			
			/*var title:FlxText;
>>>>>>> d240771ba609a916af38ab5535f581b6c3438b89
			title = new FlxText(0, 16, FlxG.width, "Just Another Day In The Office");
			title.setFormat(null, 50, 0xFFFFFFFF, "center");
			add(title);*/
			
			/*start_button = new FlxButton(FlxG.width / 2, FlxG.height / 2, null, clickStartButton);
			start_button.loadGraphic(ImageButton);
			start_button.x = start_button.x - (start_button.width / 2);
			start_button.y = start_button.y - (start_button.height / 2);
			add(start_button);*/
			
			mute_button = new FlxButton(10, FlxG.height, null, mute);
			mute_button.loadGraphic(PlayButton);
			mute_button.y = mute_button.y - (mute_button.height);
			add(mute_button);
			
			musicText = new FlxText(5, FlxG.height - mute_button.height, FlxG.width, "Music:");
			musicText.setFormat("Typewriter", 24, 0xFF000000, "left");
			musicText.y = musicText.y - (musicText.height / 2);
			add(musicText);
			
			topWall = new FlxTileblock(0, 0, FlxG.width, 2);
			topWall.makeGraphic(FlxG.width, 2, 0xff000000);
			add(topWall);
			
			bottomWall = new FlxTileblock(0, FlxG.height - 2, FlxG.width, 2);
			bottomWall.makeGraphic(FlxG.width, 2, 0xff000000);
			add(bottomWall);
			
			leftWall = new FlxTileblock(0, 0, 2, FlxG.height);
			leftWall.makeGraphic(2, FlxG.height, 0xff000000);
			add(leftWall);
			
			rightWall = new FlxTileblock(FlxG.width - 2, 0, 2, FlxG.height);
			rightWall.makeGraphic(2, FlxG.height, 0xff000000);
			add(rightWall);
			
			var instructions:FlxText;
			instructions = new FlxText(0, FlxG.height - 120, FlxG.width, "Click to start!");
			instructions.setFormat("Typewriter", 24, 0xFF000000, "center");
			add(instructions);
			
			super.create();
		}
		
		override public function update():void {
			super.update();
			if (bool) {
				bool = false;
				FlxG.playMusic(Elevatormusic7);
			}
			if (FlxG.mouse.justReleased() && FlxG.mouse.y < mute_button.y && FlxG.mouse.x > 10 + mute_button.width) {
				clickStartButton();
			}
		}
		
		public function mute():void {
			FlxG.music.pause();
			mute_button.kill();
			mute_button = new FlxButton(10, FlxG.height, null, play);
			mute_button.loadGraphic(MuteButton);
			mute_button.y = mute_button.y - (mute_button.height);
			add(mute_button);
		}
		
		public function play():void {
			FlxG.music.resume();
			mute_button.kill();
			mute_button = new FlxButton(10, FlxG.height, null, mute);
			mute_button.loadGraphic(PlayButton);
			mute_button.y = mute_button.y - (mute_button.height);
			add(mute_button);
		}
		
		public function clickStartButton():void {
			Registry.titles = new Array("Lead Pencil Pusher",
										"King of the Cubicles",
										"Director of Menial Tasks",
										"Senior Productivity Engineer",
										"Water Cooler Warrior",
										"Assistant to the Regional Manager",
										"Assistant Regional Manager",
										"Employee of the Month Week",
										"Lord of the Lunch Break",
										"Good at Something",
										"Clicked a Mouse, Hurray",
										"Duke of the Office Drones");
										/*"Good at Something",
										"Clicked a Mouse, Hurray", // Need these to be more positive
										"Duke of the Dunces",
										"Assistant Suck-Up"*/
			shuffle(Registry.titles);
			
			// Array storing all the possible minigames available to play
			var a:Array = new Array(MinigameEnums.DICTATOR_DICTION, MinigameEnums.COFFEE_RUN, MinigameEnums.COLD_CALLER,
				MinigameEnums.MY_DAUGTHERS_ART_PROJECT, MinigameEnums.SIGN_PAPER, MinigameEnums.IN_OUT,
				MinigameEnums.BRAINSTORMER, MinigameEnums.SPEEDY_STAPLER, /*MinigameEnums.SPELL_CHECKER,*/
				MinigameEnums.AVOID_THE_COWORKER, MinigameEnums.CATCH_PENCIL, MinigameEnums.PICK_UP_PAPERS,
				MinigameEnums.CLOCK_IN, MinigameEnums.WATER_BREAK/*, MinigameEnums.WHAT_DID_THE_BOSS_SAY*/);
			shuffle(a);
			
			Registry.usingWhatDidTheBossSay = false;
			
			var levelZeroMinigames:Array = new Array();
			// Adds 10 minigames at difficulty level 0 from the overall pool of minigames
			var numMinigamesToSelect:int = 10;
			for (var i:int = 0; i < numMinigamesToSelect; i++) {
				levelZeroMinigames[i] = a[i];
				if (a[i] == MinigameEnums.WHAT_DID_THE_BOSS_SAY) {
					Registry.usingWhatDidTheBossSay = true;
				}
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