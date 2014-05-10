package {
	import mx.core.FlexSprite;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class TimeClock extends MinigameState {
	
		private static var NUM_WIDTH:int = 40; // The width of the number sprites
		private static var NUM_HEIGHT:int = 60; // The hight of the number sprites
		private static var COLON_WIDTH:int = 20; // The width of the colon sprite
		private static var DIST_BETWEEN_DIGITS:int = 5; // How far separated the numbers are
		
		public static var level:Number; // The level of the game's difficulty
		
		[Embed(source = "image_assets/dignum0.png")] private var imgnum0:Class;
		[Embed(source = "image_assets/dignum1.png")] private var imgnum1:Class;
		[Embed(source = "image_assets/dignum2.png")] private var imgnum2:Class;
		[Embed(source = "image_assets/dignum3.png")] private var imgnum3:Class;
		[Embed(source = "image_assets/dignum4.png")] private var imgnum4:Class;
		[Embed(source = "image_assets/dignum5.png")] private var imgnum5:Class;
		[Embed(source = "image_assets/dignum6.png")] private var imgnum6:Class;
		[Embed(source = "image_assets/dignum7.png")] private var imgnum7:Class;
		[Embed(source = "image_assets/dignum8.png")] private var imgnum8:Class;
		[Embed(source = "image_assets/dignum9.png")] private var imgnum9:Class;
		[Embed(source = "image_assets/digcolon.png")] private var imgcolon:Class;
		
		[Embed(source = "sound_assets/tick.mp3")] private var tickSound:Class;
		
		private var hrs:int;
		private var mins:int;
		private var secs:int;
		private var ticks:int = 0;
		
		private var stopped:Boolean = false; // If the button to stop has been clicked
		private var mod:int;
		
		private var hrsall:FlxSprite;
		private var minones:FlxSprite;
		private var mintens:FlxSprite;
		private var secones:FlxSprite;
		private var sectens:FlxSprite;
		
		private var colon1:FlxSprite;
		private var colon2:FlxSprite;
		
		private var stopButton:FlxButtonPlus; // The button to stop the clock
		
		override public function create():void {
			level = Registry.difficultyLevel;
			
			secs = 0;
			hrs = 7;
			mins = 53;
			
			if (level == 0) { // The timer moves faster after level 0
				mod = 100;
			} else {
				mod = 60;
			}
			
			// Place all the sprites
			
			var x:int = (FlxG.width / 2) - ((5 * NUM_WIDTH + 5 * DIST_BETWEEN_DIGITS) / 2) - (COLON_WIDTH);
			var y:int = (FlxG.height / 2) - (NUM_HEIGHT / 2) - 50;
			
			hrsall = new FlxSprite();
			hrsall.x = x;
			hrsall.y = y;
			add(hrsall);
			x += NUM_WIDTH + DIST_BETWEEN_DIGITS;
			
			colon1 = new FlxSprite();
			colon1.x = x;
			colon1.y = y;
			colon1.loadGraphic(imgcolon);
			add(colon1);
			x += COLON_WIDTH + DIST_BETWEEN_DIGITS;
			
			mintens = new FlxSprite();
			mintens.x = x;
			mintens.y = y;
			add(mintens);
			x += NUM_WIDTH + DIST_BETWEEN_DIGITS;
			
			minones = new FlxSprite();
			minones.x = x;
			minones.y = y;
			add(minones);
			x += NUM_WIDTH + DIST_BETWEEN_DIGITS;
			
			colon2 = new FlxSprite();
			colon2.x = x;
			colon2.y = y;
			colon2.loadGraphic(imgcolon);
			add(colon2);
			x += COLON_WIDTH + DIST_BETWEEN_DIGITS;
			
			sectens = new FlxSprite();
			sectens.x = x;
			sectens.y = y;
			add(sectens);
			x += NUM_WIDTH + DIST_BETWEEN_DIGITS;
			
			secones = new FlxSprite();
			secones.x = x;
			secones.y = y;
			add(secones);
			
			changeImages();
			
			stopButton = new FlxButtonPlus(50, (FlxG.height / 2), stopClock, null, "STOP!", 200, 40);
			stopButton.updateInactiveButtonColors([ 0xffFF0080, 0xffFF80C0 ]);
			stopButton.updateActiveButtonColors([ 0xffFFFF00, 0xffFF8000 ]);
			stopButton.screenCenter();
			stopButton.textNormal.size = 30;
			stopButton.textHighlight.size = 30;
			add(stopButton);
			
			super.create();
			super.setCommandText("Clock in at 8:00!");
			super.setTimer(11000);
			super.timerText.visible = false; // Don't show the timer!
		}
		
		override public function update():void {
			super.update();
			
			if (ticks % mod >= 0 && !stopped && !FlxG.paused) {
				secs++;
				
				if (secs >= 60) {
					secs = 0;
					mins++;
					
					if (level != 3 || mins < 58) { // Level 3 has the tick sound stop
						FlxG.play(tickSound);
					}
				}
				
				if (mins >= 60) {
					mins = 0;
					hrs++;
				}
				
				changeImages();
			}
			
			// Have the numbers fade away above level 0
			if (level >= 1 && mins >= 57 || level >= 2 && mins >= 56) {
				var sub:Number = 0.01;
				
				secones.alpha -= sub;
				sectens.alpha -= sub;
				minones.alpha -= sub;
				mintens.alpha -= sub;
				hrsall.alpha -= sub;
				colon1.alpha -= sub;
				colon2.alpha -= sub;
			}
		}
		
		// Update all of the sprites
		public function changeImages():void {
			loadImage(secones, secs % 10);
			loadImage(sectens, secs / 10);
			
			loadImage(minones, mins % 10);
			loadImage(mintens, mins / 10);
			
			loadImage(hrsall, hrs);
		}
		
		// Load the correct image into sprite obj, according to n
		public function loadImage(obj:FlxSprite, n:int):void {
			switch (n) {
				case 0:
					obj.loadGraphic(imgnum0);
					break;
				case 1:
					obj.loadGraphic(imgnum1);
					break;
				case 2:
					obj.loadGraphic(imgnum2);
					break;
				case 3:
					obj.loadGraphic(imgnum3);
					break;
				case 4:
					obj.loadGraphic(imgnum4);
					break;
				case 5:
					obj.loadGraphic(imgnum5);
					break;
				case 6:
					obj.loadGraphic(imgnum6);
					break;
				case 7:
					obj.loadGraphic(imgnum7);
					break;
				case 8:
					obj.loadGraphic(imgnum8);
					break;
				case 9:
					obj.loadGraphic(imgnum9);
					break;
				default:
					break;
			}
		}
		
		// Called after the "STOP!" button is pressed
		public function stopClock():void {
			stopped = true;
			this.remove(stopButton); // Make sure it can't be pressed again
			
			// Make the numbers visible again
			secones.alpha = 1;
			sectens.alpha = 1;
			minones.alpha = 1;
			mintens.alpha = 1;
			hrsall.alpha = 1;
			colon1.alpha = 1;
			colon2.alpha = 1;
			
			super.timerText.visible = true; // Bring back the timer!
			
			// Timer must read 8:00:XX
			if (hrs == 8 && mins == 0) { // Success!
				super.success = true;
			} else { // Failure!
				super.timer.abort();
			}
		}
		
	}

}