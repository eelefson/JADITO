package  
{
	import org.flixel.*;	
	import org.flixel.plugin.photonstorm.*;
	import org.flixel.plugin.photonstorm.FlxExtendedSprite;
	/**
	 * ...
	 * @author Thomas Eberlein
	 */
	public class AvoidCoworker extends MinigameState 
	{
		
		[Embed(source = "image_assets/stickfigure.png")] private var person:Class;
		[Embed(source = "image_assets/cubicleSimple.png")] private var cubicle:Class;
		
		private var difficulty:int;
		private var speed:int = 100;
		private var x:Number = FlxG.width / 2;
		private var y:Number = FlxG.height / 2;
		private var routes:Array;
		private var justStarted:Boolean = true;
		private var nowRunning:Boolean = false;
		private var testBool:Boolean = true;
		
		private var Xcoords:Array;
		private var Ycoords:Array;
		private var runTimer:FlxDelay;
		
		private var cubicles:FlxGroup;
		
		private var you:FlxExtendedSprite;
		private var coworker:FlxExtendedSprite;
		private var enemies:FlxGroup;
		
		override public function create():void {
			FlxG.mouse.hide();
			FlxG.bgColor = 0xffffffff;
			
			difficulty = Registry.difficultyLevel;
			
			Xcoords = new Array(0, 0, FlxG.width - 250, FlxG.width - 250);
			Ycoords = new Array(0, FlxG.height - 170, 0, FlxG.height - 170);
			routes = new Array(0, 1, 2, 3, 4, 5 ,6 ,7, 8, 9, 10, 11);
			
			enemies = new FlxGroup();
			add(enemies);
			
			you = new FlxExtendedSprite(x, y);
			you.loadGraphic(person);
			you.elasticity = 0;
			you.solid = true;
			add(you);
			
			cubicles = new FlxGroup();
			
			for (var i:int = 0; i < 4; i++) {
				var testRect:FlxExtendedSprite = new FlxExtendedSprite(Xcoords[i], Ycoords[i]);
				testRect.loadGraphic(cubicle);
				testRect.immovable = true;
				testRect.elasticity = 0;
				testRect.solid = true;
				cubicles.add(testRect);
			}
			
			add(cubicles);
			
			super.create();
			super.setCommandText("Avoid Him!");
			super.setTimer(20 * 1000);
			super.timer.callback = timeout;
		}
		
		override public function update():void {
			/*if (x != FlxG.mouse.screenX && y != FlxG.mouse.screenY) {
				var yDistance:Number = FlxG.mouse.screenY - y;
				var xDistance:Number = FlxG.mouse.screenX - x;
	 
				var radian:Number = Math.atan2(yDistance, xDistance);
				you.velocity.x = Math.cos(radian) * speed;
				you.velocity.y = Math.sin(radian) * speed;
			}*/
			
			if (justStarted) {
				runTimer = new FlxDelay(5000);
				runTimer.start();
				justStarted = false;
			}
			//trace(runTimer.secondsRemaining.toString());
			
			if (runTimer.hasExpired && testBool) {
				if (nowRunning == false) {
					var route:Number = routes[Math.floor(Math.random() * 12)];
					trace(route);
					if (route == 0 || route == 4 || route == 5) {
						coworker = new FlxExtendedSprite(FlxG.width / 2, -100);
						coworker.loadGraphic(person);
						coworker.velocity.y = 200;
					} else if (route == 1 || route == 6 || route == 7) {
						coworker = new FlxExtendedSprite(FlxG.width / 2, FlxG.height + 100);
						coworker.loadGraphic(person);
						coworker.velocity.y = -200;
					} else if (route == 2 || route == 8 || route == 9) {
						coworker = new FlxExtendedSprite(0, FlxG.height / 2);
						coworker.loadGraphic(person);
						coworker.velocity.x = 200;
					} else if (route == 3 || route == 10 || route == 11) {
						coworker = new FlxExtendedSprite(FlxG.width + 100, FlxG.height / 2);
						coworker.loadGraphic(person);
						coworker.velocity.x = -200;
					}
					//trace(coworker.velocity.x);
					//trace(coworker.velocity.y);
					enemies.add(coworker);
					nowRunning = true;
					//trace(nowRunning);
					trace("Called oncE?");
					testBool = false;
				}
			}
			
			if (runTimer.hasExpired) {
				if (route == 4 || route == 5) {
					trace("in here 4");
					if (coworker.y >= FlxG.height / 2) {
						if (route == 4) {
							coworker.velocity.x = 200;
						} else {
							coworker.velocity.x = -200;
						}
						coworker.velocity.y = 0;
					}
				} else if (route == 6 || route == 7) {
					trace("in here 6");
					if (coworker.y <= FlxG.height / 2) {
						if (route == 6) {
							coworker.velocity.x = - 200;
						} else {
							coworker.velocity.x = 200;
						}
							coworker.velocity.y = 0;
					}
				} else if (route == 8 || route == 9) {
					trace("in here 8");
					if (coworker.x >= FlxG.width / 2) {
						if (route == 8) {
							coworker.velocity.y = - 200;
						} else {
							coworker.velocity.y = 200;
						}
						coworker.velocity.x = 0;
					}
				} else if (route == 10 || route == 11) {
					trace("in here 10");
					if (coworker.x <= FlxG.width / 2 ) {
						if (route == 10) {
							coworker.velocity.y = 200;
						} else {
							coworker.velocity.y = -200;
						}
						coworker.velocity.x = 0;
					}
				}
			}
			
			you.x = FlxG.mouse.screenX;
			you.y = FlxG.mouse.screenY;
			
			FlxG.collide(cubicles, you);
			//FlxG.overlap(you, enemies, failure);
			
			super.update();
		}
		
		public function failure(me:FlxObject, them:FlxObject):void {
			super.success = false;
			super.timer.abort();
		}
		
		public function timeout():void {
			super.success = true;
			super.timer.abort();
		}
		
	}

}