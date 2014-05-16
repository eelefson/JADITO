package  {
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	/**
	 * ...
	 * @author Elijah Elefson
	 */
	public class TitleAwardState extends FlxState {
		[Embed(source = "image_assets/award.png")] private var AwardImage:Class;
		[Embed(source = "sound_assets/title_award.mp3")] private var RewardSFX:Class;
		[Embed(source = "image_assets/officewall.png")] private var wall:Class;
		
		private var award_graphic:FlxSprite;
		private var awardText:FlxText;
		
		public var topWall:FlxTileblock;
		public var bottomWall:FlxTileblock;
		public var leftWall:FlxTileblock;
		public var rightWall:FlxTileblock;
		
		private var delay:FlxDelay;
		
		override public function create():void {
			//FlxG.bgColor = 0xffffffff;
			
			var wallpaper:FlxSprite = new FlxSprite(0, 0);
			wallpaper.loadGraphic(wall);
			add(wallpaper);
			
			//var wallpaper:FlxSprite = new FlxSprite(0, 0);
			//wallpaper.loadGraphic(wall);
			//add(wallpaper);
			
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
			
			award_graphic = new FlxSprite(FlxG.width / 2, FlxG.height / 2, AwardImage);
			award_graphic.x = award_graphic.x - (award_graphic.width / 2);
			award_graphic.y = award_graphic.y - (award_graphic.height / 2);
			add(award_graphic);
			
			var title:String;
			if (Registry.day == DaysOfTheWeek.SATURDAY) {
				title = "The New Boss!";
			} else {
				title = Registry.titles.shift();
			}
			
			awardText = new FlxText(FlxG.width / 2, FlxG.height / 2, 125, title);
			awardText.setFormat(null, 16, 0xff000000, "center");
			awardText.x = awardText.x - (awardText.width / 2);
			awardText.y = awardText.y - (awardText.height / 2);
			add(awardText);
			
			delay = new FlxDelay(3000);
			delay.start();
			
			FlxG.play(RewardSFX);
			
			super.create();
		}
		
		override public function update():void {
			super.update();
			if (delay.hasExpired) {
				if (Registry.day == DaysOfTheWeek.SATURDAY) {
					FlxG.switchState(new WinState());
				} else {
					FlxG.switchState(new PlayState());
				}
			}
		}
	}
}