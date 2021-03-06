package  
{
	import org.flixel.*;	
	import org.flixel.plugin.photonstorm.*;
	import org.flixel.plugin.photonstorm.FlxExtendedSprite;
	import org.flixel.plugin.photonstorm.API.FlxKongregate;

	/**
	 * ...
	 * @author Thomas Eberlein
	 */
	public class AvoidCoworker extends MinigameState 
	{
		[Embed(source = "image_assets/coworker.png")] private var coworkerImg:Class;
		[Embed(source = "image_assets/you.png")] private var youImg:Class;
		[Embed(source = "image_assets/cubicleSimple.png")] private var cubicle:Class;
		[Embed(source = "image_assets/coworkerArrow.png")] private var rightArrow:Class;
		[Embed(source = "image_assets/curveArrow2.png")] private var curveArrow:Class;
		[Embed(source = "image_assets/curveArrowFlip2.png")] private var curveArrowFlip:Class;
		[Embed(source = "image_assets/work_station2.png")] private var workStationImage:Class;
		[Embed(source = "image_assets/skull2.png")] private var skullImage:Class;
		//[Embed(source = "image_assets/officewall.png")] private var wall:Class;
		
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
			if (FlxG.getPlugin(FlxMouseControl) == null) {
				FlxG.addPlugin(new FlxMouseControl);
			}
			
			FlxG.mouse.hide();
			FlxG.bgColor = 0xffffffff;
			
			/*var wallpaper:FlxSprite = new FlxSprite(0, 0);
			wallpaper.loadGraphic(wall);
			add(wallpaper);*/
			
			super.gameOver = false;
			
			//Registry.loggingControl = new Logger("jadito", 103, "4453dcb14ff92850b75600e5193f7247", 1, 1);
			
			difficulty = Registry.difficultyLevel;
			
			if (difficulty < 2) {
				route = routes[Math.floor(Math.random() * 4)];
			} else {
				route = routes[Math.floor(Math.random() * 8) + 4];
			}
			
			if (difficulty == 0) {
				speed = 200;
			} else if (difficulty == 3) {
				speed = 600; 
			} else {
				speed = 400;
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
			
			
			
			if (route == 0 || route == 4 || route == 5) {
				preview.angle = 90;
				preview.y = 90;
			} else if (route == 1 || route == 6 || route == 7) {
				preview.angle = 270;
				preview.y = FlxG.height - (preview.height + 90);
			} else if (route == 3 || route == 10 || route == 11) {
				preview.angle = 180;
				preview.x = FlxG.width - (preview.width + 10);
			} else {
				preview.x = 10;
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
			if (difficulty < 2) {
				super.setTimer(5 * 1000);
			} else if (difficulty == 2) {
				super.setTimer(4 * 1000);
			} else {
				super.setTimer(3 * 1000);
			}
			super.timer.callback = timeout;
			var data3:Object = { "difficulty":difficulty, 
								"playthrough":Registry.playthrough, 
								"sequence number":Registry.playthroughSeqNum };
			Registry.playthroughSeqNum++;
			Registry.loggingControl.logLevelStart(1, data3);
		}
		
		override public function update():void {
			
			super.update();
			
			if (!FlxG.paused) {
				if (justStarted) {
					runTimer = new FlxDelay(500);
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
							coworker.velocity.y = speed;
						} else if (route == 1 || route == 6 || route == 7) {
							//coworker = new FlxExtendedSprite(FlxG.width / 2, FlxG.height + 100);
							coworker.x = (FlxG.width / 2) - 20;
							coworker.y = FlxG.height + 100;
							coworker.visible = true;
							coworker.velocity.y = -speed;
						} else if (route == 2 || route == 8 || route == 9) {
							//coworker = new FlxExtendedSprite(0, FlxG.height / 2);
							coworker.x = 0;
							coworker.y = (FlxG.height / 2) - 49;
							coworker.visible = true;
							coworker.velocity.x = speed;
						} else if (route == 3 || route == 10 || route == 11) {
							//coworker = new FlxExtendedSprite(FlxG.width + 100, FlxG.height / 2);
							coworker.x = FlxG.width + 100;
							coworker.y = (FlxG.height / 2) - 49;
							coworker.visible = true;
							coworker.velocity.x = -speed;
							coworker.play("Walking Left");
						}

						nowRunning = true;
					}
				}
				
				if ((coworker.x >= (gameWidth / 2) - 20) && nowRunning) {
					if (route == 8 || route == 9) {
						if (route == 8) {
							coworker.velocity.y = - speed;
						} else {
							coworker.velocity.y = speed;
						}
						coworker.velocity.x = 0;
					}
				} 
				if ((coworker.x <= (gameWidth / 2) - 20) && nowRunning) {
					if (route == 10 || route == 11) {
						if (route == 10) {
							coworker.velocity.y = speed;
						} else {
							coworker.velocity.y = -speed;
						}
						coworker.velocity.x = 0;
					}
				} 
				if ((coworker.y >= (gameHeight / 2) - 49) && nowRunning) {
					if (route == 4 || route == 5) {
						if (route == 4) {
							coworker.velocity.x = speed;
						} else {
							coworker.velocity.x = -speed;
						}
						coworker.velocity.y = 0;
					}
				} 
				if ((coworker.y <= (gameHeight / 2) - 49) && nowRunning) {
					if (route == 6 || route == 7) {
						if (route == 6) {
							coworker.velocity.x = - speed;
						} else {
							coworker.velocity.x = speed;
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
			if (!gameOver) {
				var data1:Object = { "completed":"failure","type":"collision" };
				Registry.loggingControl.logLevelEnd(data1);
			}
			gameOver = true;
			super.success = false;
			super.timer.abort();
			you.visible = false;
			FlxG.mouse.show();
		}
		
		public function timeout():void {
			if(!gameOver) {
				var data1:Object = { "completed":"success" };
				Registry.loggingControl.logLevelEnd(data1);
			}
			if(Registry.kongregate) {
				if (difficulty == 0) {
					FlxKongregate.submitStats("AvoidTheCoworkerBeginner", 1);
					FlxKongregate.submitStats("AvoidTheCoworkerProgress", 1);
				}else if (difficulty == 1) {
					FlxKongregate.submitStats("AvoidTheCoworkerEasy", 1);
					FlxKongregate.submitStats("AvoidTheCoworkerProgress", 2);
				}else if (difficulty == 2) {
					FlxKongregate.submitStats("AvoidTheCoworkerMedium", 1);
					FlxKongregate.submitStats("AvoidTheCoworkerProgress", 3);
				}else {
					FlxKongregate.submitStats("AvoidTheCoworkerHard", 1);
					FlxKongregate.submitStats("AvoidTheCoworkerProgress", 4);
				}
			}
			
			gameOver = true;
			super.success = true;
			super.timer.abort();
			you.visible = false;
			FlxG.mouse.show();
		}
		
		override public function destroy():void {
			//	Important! Clear out the plugin otherwise resources will get messed right up after a while
			FlxMouseControl.clear();

			super.destroy();
		}
		
	}

}