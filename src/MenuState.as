package  {
	import org.flixel.*;
	import flash.utils.*;
	import org.flixel.plugin.photonstorm.*;
	import org.flixel.plugin.photonstorm.API.FlxKongregate;
	
	/**
	 * ...
	 * @author Elijah Elefson
	 */
	public class MenuState extends FlxState {
		[Embed(source = "image_assets/DesktopBackground.jpg")] private var background:Class;
		[Embed(source = "image_assets/Mute.png")] private var MuteButton:Class;
		[Embed(source = "image_assets/Play.png")] private var PlayButton:Class;
		[Embed(source = "image_assets/SplashScreen.jpg")] private var SplashScreenImage:Class;
		[Embed(source = "font_assets/SLOPI___.ttf", fontFamily = "Typewriter", embedAsCFF = "false")] private var TypewriterFont:String;
		[Embed(source = "font_assets/ArbutusSlab-Regular.ttf", fontFamily = "Regular", embedAsCFF = "false")] private var RegularFont:String;
		
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
			var title:FlxText;
			splash_screen_graphic = new FlxSprite(0, 0, SplashScreenImage);
			add(splash_screen_graphic);
			
			mute_button = new FlxButton(10, FlxG.height, null, mute);
			mute_button.loadGraphic(PlayButton);
			mute_button.y = mute_button.y - (mute_button.height);
			add(mute_button);
			
			musicText = new FlxText(5, FlxG.height - mute_button.height, FlxG.width, "Music:");
			musicText.setFormat("Regular", 24, 0xFF000000, "left");
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
			instructions = new FlxText(0, FlxG.height - 125, FlxG.width, "Click to start!");
			instructions.setFormat("Regular", 30, 0xFF000000, "center");
			add(instructions);

			if(Registry.kongregate) {
				FlxKongregate.init(apiHasLoaded);
				FlxKongregate.submitStats("GameLoad", 1);
			}
			super.create();
		}
		
		private function apiHasLoaded():void {
			FlxKongregate.connect();
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
			Registry.beginGame();
			FlxG.switchState(new PlayState());
		}
	}
}