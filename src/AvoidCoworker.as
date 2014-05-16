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
		[Embed(source = "image_assets/coworker.png")] private var coworkerImg:Class;
		[Embed(source = "image_assets/you.png")] private var youImg:Class;
		[Embed(source = "image_assets/cubicleSimple.png")] private var cubicle:Class;
		[Embed(source = "image_assets/coworkerArrow.png")] private var rightArrow:Class;
		[Embed(source = "image_assets/curveArrow.png")] private var curveArrow:Class;
		[Embed(source = "image_assets/curveArrowFlip.png")] private var curveArrowFlip:Class;
		[Embed(source = "image_assets/work_station.png")] private var workStationImage:Class;
		[Embed(source = "image_assets/skull2.png")] private var skullImage:Class;
		
		private var difficulty:int;
		private var speed:int;
		private var x:Number = FlxG.width / 2;
		private var y:Number = FlxG.height / 2;
		private var routes:Array = new Array(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11);
		private var route:Number;
		private var justStarted:Boolean = true;
		private var nowRunning:Boolean = false;
		private var gameHeight:int = FlxG.height;
		private var gameWidth:int = FlxG.width;
		
		private var Xcoords:Array = new Array(0, 0, FlxG.width - 250, FlxG.width - 250);
		private var Ycoords:Array = new Array(0, FlxG.height - 170, 0, FlxG.height - 170);
		private var runTimer:FlxDelay;
		
		private var cubicles:FlxGroup;
		private var workstations:FlxGroup;
		
		private var you:FlxExtendedSprite;
		private var coworker:FlxExtendedSprite;
		private var enemies:FlxGroup;
		private var preview:FlxExtendedSprite;
		private var skull:FlxSprite;
		
		override public function create():void {
			FlxG.mouse.hide();
			FlxG.bgColor = 0xffffffff;
			
			difficulty = Registry.difficultyLevel;
			
			if (difficulty < 2) {
				route = routes[Math.floor(Math.random() * 4)];
			} else {
				route = routes[Math.floor(Math.random() * 12)];
			}
			
			if (difficulty == 0) {
				speed = 100;
			} else if (difficulty == 4) {
				speed = 300; 
			} else {
				speed = 200;
			}
			
			preview = new FlxExtendedSprite(0, 0);
			
			if (route < 4) {
				preview.loadGraphic(rightArrow);
			} else if (route == 4 || route == 6 || route == 8 || route == 10) {
				preview.loadGraphic(curveArrow);
			} else {
				preview.loadGraphic(curveArrowFlip);
			}
			
			preview.x = x - (preview.width / 2);
			preview.y = y - (preview.height / 2);
			
			/*if (route < 4) {
				preview = new FlxExtendedSprite(x - 100, y - 40);
			} else {
				preview = new FlxExtendedSprite(x-100, y-119);
			}*/
			
			//2, 8, 11 do not need to be rotated
			
			if (route == 0 || route == 4 || route == 7) {
				preview.angle = 90;
			} else if (route == 1 || route == 6 || route == 5) {
				preview.angle = 270;
			} else if (route == 3 || route == 9 || route == 10) {
				preview.angle = 180;
			}

			preview.visible = false;
			add(preview);
			
			skull = new FlxSprite(FlxG.width / 2 - 15, FlxG.height / 2 - 12);
			skull.loadGraphic(skullImage);
			skull.visible = false;
			add(skull);
			
			enemies = new FlxGroup();
			coworker = new FlxExtendedSprite(0, 0);
			coworker.loadGraphic(coworkerImg, true, true, 60, 98);
			coworker.addAnimation("Walking Right", new Array(0, 1), 10);
			coworker.addAnimation("Walking Left", new Array(2, 3), 10);
			coworker.play("Walking Right");
			coworker.visible = false;
			enemies.add(coworker);
			add(enemies);
			
			you = new FlxExtendedSprite(x, y);
			you.loadGraphic(youImg);
			you.elasticity = 0;
			you.solid = true;
			add(you);			
			
			cubicles = new FlxGroup();
			workstations = new FlxGroup();
			
			for (var i:int = 0; i < 4; i++) {
				var work_station_graphic:FlxSprite;
				if (i == 0 || i == 2) {
					work_station_graphic = new FlxSprite(Xcoords[i], Ycoords[i] - 25);
					work_station_graphic.loadGraphic(workStationImage);
					workstations.add(work_station_graphic);
				} else {
					work_station_graphic = new FlxSprite(Xcoords[i], Ycoords[i] - 40);
					work_station_graphic.loadGraphic(workStationImage);
					workstations.add(work_station_graphic);
				}
				/*var work_station_graphic:FlxSprite = new FlxSprite(Xcoords[i], Ycoords[i] - 25);
				work_station_graphic.loadGraphic(workStationImage);
				workstations.add(work_station_graphic);*/
				
				var testRect:FlxExtendedSprite = new FlxExtendedSprite(Xcoords[i], Ycoords[i]);
				testRect.loadGraphic(cubicle);
				testRect.immovable = true;
				testRect.elasticity = 0;
				testRect.solid = true;
				cubicles.add(testRect);
			}
			
			add(cubicles);
			add(workstations);
			super.create();
			super.setCommandText("Avoid Coworker!");
			super.setTimer(6 * 1000);
			super.timer.callback = timeout;
			//Registry.loggingControl.logLevelStart(1,null);
		}
		
		override public function update():void {
			
			super.update();
			
			if (!FlxG.paused) {
				if (justStarted) {
					runTimer = new FlxDelay(1000);
					runTimer.start();
					justStarted = false;
					preview.visible = true;
					skull.visible = true;
				}
				
				if (runTimer.hasExpired) {
					preview.visible = false;
					skull.visible = false;
					if (nowRunning == false) {
						if (route == 0 || route == 4 || route == 5) {
							//coworker = new FlxExtendedSprite(FlxG.width / 2, -100);
							coworker.x = (FlxG.width / 2) - 20;
							coworker.y = -100;
							coworker.visible = true;
							coworker.velocity.y = 200;
						} else if (route == 1 || route == 6 || route == 7) {
							//coworker = new FlxExtendedSprite(FlxG.width / 2, FlxG.height + 100);
							coworker.x = (FlxG.width / 2) - 20;
							coworker.y = FlxG.height + 100;
							coworker.visible = true;
							coworker.velocity.y = -200;
						} else if (route == 2 || route == 8 || route == 9) {
							//coworker = new FlxExtendedSprite(0, FlxG.height / 2);
							coworker.x = 0;
							coworker.y = (FlxG.height / 2) - 49;
							coworker.visible = true;
							coworker.velocity.x = 200;
						} else if (route == 3 || route == 10 || route == 11) {
							//coworker = new FlxExtendedSprite(FlxG.width + 100, FlxG.height / 2);
							coworker.x = FlxG.width + 100;
							coworker.y = (FlxG.height / 2) - 49;
							coworker.visible = true;
							coworker.velocity.x = -200;
							coworker.play("Walking Left");
						}

						nowRunning = true;
					}
				}
				
				if ((coworker.x >= (gameWidth / 2) - 20) && nowRunning) {
					if (route == 8 || route == 9) {
						if (route == 8) {
							coworker.velocity.y = - 200;
						} else {
							coworker.velocity.y = 200;
						}
						coworker.velocity.x = 0;
					}
				} 
				if ((coworker.x <= (gameWidth / 2) - 20) && nowRunning) {
					if (route == 10 || route == 11) {
						if (route == 10) {
							coworker.velocity.y = 200;
						} else {
							coworker.velocity.y = -200;
						}
						coworker.velocity.x = 0;
					}
				} 
				if ((coworker.y >= (gameHeight / 2) - 49) && nowRunning) {
					if (route == 4 || route == 5) {
						if (route == 4) {
							coworker.velocity.x = 200;
						} else {
							coworker.velocity.x = -200;
						}
						coworker.velocity.y = 0;
					}
				} 
				if ((coworker.y <= (gameHeight / 2) - 49) && nowRunning) {
					if (route == 6 || route == 7) {
						if (route == 6) {
							coworker.velocity.x = - 200;
						} else {
							coworker.velocity.x = 200;
						}
						coworker.velocity.y = 0;
					}
				}
				
				you.x = FlxG.mouse.screenX - 20;
				you.y = FlxG.mouse.screenY - 30;
				
				FlxG.collide(cubicles, you);
				FlxG.collide(super.walls, you);
				FlxG.overlap(you, enemies, failure);
			}
			

		}
		
		public function failure(me:FlxObject, them:FlxObject):void {
			//var data1:Object = { "completed":"failure" };
			//Registry.loggingControl.logLevelEnd(data1);
			super.success = false;
			super.timer.abort();
			you.visible = false;
			FlxG.mouse.show();
		}
		
		public function timeout():void {
			//var data1:Object = { "completed":"success" };
			//Registry.loggingControl.logLevelEnd(data1);
			super.success = true;
			super.timer.abort();
			you.visible = false;
			FlxG.mouse.show();
		}
		
	}

}