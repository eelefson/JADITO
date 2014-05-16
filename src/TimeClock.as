package {
	import mx.core.FlexSprite;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	
	public class TimeClock extends MinigameState {
	
		private static var NUM_WIDTH:int = 40; // The width of the number sprites
		private static var NUM_HEIGHT:int = 60; // The hight of the number sprites
		private static var COLON_WIDTH:int = 20; // The width of the colon sprite
		private static var DIST_BETWEEN_DIGITS:int = 0; // How far separated the numbers are
		
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
		[Embed(source = "image_assets/TimePunchLarge.png")] private var imgclock:Class;
		[Embed(source = "image_assets/officewall.png")] private var wall:Class;
		
		[Embed(source = "sound_assets/tick.mp3")] private var tickSound:Class;
		
		private var hrs:int;
		private var mins:int;
		private var secs:Number;
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
			
			//FlxG.bgColor = 0xFFFFFFFF;
			var wallpaper:FlxSprite = new FlxSprite(0, 0);
			wallpaper.loadGraphic(wall);
			add(wallpaper);
			
			var clock:FlxSprite = new FlxSprite(FlxG.width - 480, FlxG.height - 450);
			clock.loadGraphic(imgclock);
			add(clock);
			
			gameOver = false;
			
			secs = 0;
			hrs = 7;
			mins = 53;
			
			if (level == 3) {
				mins = 45;
			}
			
			if (level == 0) { // The timer moves faster after level 0
				mod = 1;
			} else if (level == 1){
				mod = 1;
			} else if (level == 2) {
				mod = 1;
			} else {
				mod = 1;
			}
			
			// Place all the sprites
			
			var x:int = (FlxG.width / 2) - ((5 * NUM_WIDTH + 5 * DIST_BETWEEN_DIGITS) / 2) - (COLON_WIDTH);
			var y:int = (FlxG.height / 2) - (NUM_HEIGHT / 2) - 50 + 100;
			
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
			
			/*stopButton = new FlxButtonPlus(50, FlxG.height - 100, stopClock, null, "STOP!", 200, 40);
			stopButton.updateInactiveButtonColors([ 0xffFF0080, 0xffFF80C0 ]);
			stopButton.updateActiveButtonColors([ 0xffFFFF00, 0xffFF8000 ]);
			stopButton.screenCenter();
			stopButton.textNormal.size = 30;
			stopButton.textHighlight.size = 30;
			add(stopButton);*/
			
			super.create();
			super.setCommandText("Clock in at 8:00!");
			super.setTimer(11000);
			super.timerText.visible = false; // Don't show the timer!
			var data5:Object = { "difficulty":level };
			Registry.loggingControl.logLevelStart(13, data5);
		}
		
		override public function update():void {
			super.update();
			if (FlxG.mouse.justReleased()) {
				stopClock();
			}
			if (ticks % mod == 0 && !stopped && !FlxG.paused) {
				
				if (level == 0 || level == 1) {
					secs++;
				} else if (level == 2) {
					secs += 1.5;
				} else {
					secs += 2;
				}
				
				if (secs >= 60) {
					secs = 0;
					mins++;
					
					if (level < 2 || level == 2 && mins < 58 || level == 3 && mins < 55) { // Levels 2 & 3 have the tick sound stop
						FlxG.play(tickSound);
					}
				}
				
				if (mins >= 60) {
					mins = 0;
					hrs++;
				}
				
				changeImages();
			}
			
			ticks++;
			
			// Have the numbers fade away above level 0
			if (!stopped && level >= 1 && mins >= 55 || !stopped && level == 3 && mins >= 53) {
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
			if (!FlxG.paused) {
				//this.remove(stopButton); // Make sure it can't be pressed again
				
				// Make the numbers visible again
				secones.alpha = 1;
				sectens.alpha = 1;
				minones.alpha = 1;
				mintens.alpha = 1;
				hrsall.alpha = 1;
				colon1.alpha = 1;
				colon2.alpha = 1;
				
				//super.timerText.visible = true; // Bring back the timer!
				
				// Timer must read 8:00:XX
				if (hrs == 8 && mins == 0 || hrs == 7 && mins == 59) { // Success!
					if(!gameOver){
						var data1:Object = { "completed":"success" };
						Registry.loggingControl.logLevelEnd(data1);
					}
					gameOver = true;
					super.success = true;
				} else { // Failure!
					if(!gameOver){
						var data2:Object = { "completed":"failure" };
						Registry.loggingControl.logLevelEnd(data2);
					}
					gameOver = true;
					super.timer.abort();
				}
			}
		}
		
	}

}