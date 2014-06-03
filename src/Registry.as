package  {
	/**
	 * ...
	 * @author Elijah Elefson
	 */
	public class Registry {
		public static var day:int;
		public static var pool:Array;
		public static var taskStatuses:Array;
		public static var difficultyLevel:int;
		public static var minigames:Array;
		public static var playCurrentDay:Boolean;
		public static var titles:Array;
		public static var usingWhatDidTheBossSay:Boolean;
		public static var loggingControl:Logger;
		public static var failures:int;
		public static var failedMostRecentMinigame:Boolean;
		public static var score:int;
		public static var BobScores:Array = new Array(200, 700, 1500, 2900, 4400, 8000);
		public static var playthrough:int = 0;
		public static var playthroughSeqNum:int;
		public static var nextWeek:Boolean;
		public static var skip:Boolean = false;
		
		static public function beginGame():void {
			// RESET ALL REGISTRY VALUES TO MAKE SURE NOTHING WEIRD HAPPENS
			Registry.day = 0;
			Registry.pool = null;
			Registry.taskStatuses = null;
			Registry.difficultyLevel = 0;
			Registry.minigames = null;
			Registry.playCurrentDay = false;
			Registry.titles = null;
			Registry.usingWhatDidTheBossSay = false;
			Registry.failures = 0;
			Registry.failedMostRecentMinigame = false;
			Registry.score = 0;
			Registry.BobScores = new Array(200, 700, 1500, 2900, 4400, 8000);
			Registry.playthroughSeqNum = 0;
			Registry.nextWeek = false;
			
			Registry.titles = new Array("Lead Pencil Pusher",
										"King of the Cubicles",
										"Director of Menial Tasks",
										"Senior Productivity Engineer",
										"Water Cooler Warrior",
										"Assistant to the Regional Manager",
										"Assistant Regional Manager",
										"Employee of the Week",
										"Lord of the Lunch Break",
										"Good at Something",
										"Duke of the Office Drones",
										"Master of Meetings");
			shuffle(Registry.titles);
			
			// Array storing all the possible minigames available to play
			var a:Array = new Array(MinigameEnums.DICTATOR_DICTION, MinigameEnums.COFFEE_RUN, MinigameEnums.COLD_CALLER,
				MinigameEnums.MY_DAUGTHERS_ART_PROJECT, MinigameEnums.SIGN_PAPER, MinigameEnums.IN_OUT,
				MinigameEnums.BRAINSTORMER, MinigameEnums.SPEEDY_STAPLER, MinigameEnums.SPELL_CHECKER,
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
			
			// CHANGES NUMBER OF FAILURES ALLOWED
			Registry.failures = 6;
			Registry.failedMostRecentMinigame = false;
			
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
		}
		
		static public function newWeek():void {
			// RESET ALL REGISTRY VALUES TO MAKE SURE NOTHING WEIRD HAPPENS
			Registry.day = 0;
			Registry.pool = null;
			Registry.taskStatuses = null;
			Registry.difficultyLevel = 0;
			Registry.minigames = null;
			Registry.playCurrentDay = true;
			Registry.titles = null;
			Registry.usingWhatDidTheBossSay = false;
			Registry.failures = 0;
			Registry.failedMostRecentMinigame = false;
			Registry.score = Registry.score;
			for (var j:int = 0; j < Registry.BobScores.length; j++) {
				Registry.BobScores[j] = Registry.BobScores[j] + Registry.score;
			}
			Registry.playthroughSeqNum += 1;
			Registry.nextWeek = false;
			
			Registry.titles = new Array("Lead Pencil Pusher",
										"King of the Cubicles",
										"Director of Menial Tasks",
										"Senior Productivity Engineer",
										"Water Cooler Warrior",
										"Assistant to the Regional Manager",
										"Assistant Regional Manager",
										"Employee of the Week",
										"Lord of the Lunch Break",
										"Good at Something",
										"Duke of the Office Drones",
										"Master of Meetings");
			shuffle(Registry.titles);
			
			// Array storing all the possible minigames available to play
			var a:Array = new Array(MinigameEnums.DICTATOR_DICTION, MinigameEnums.COFFEE_RUN, MinigameEnums.COLD_CALLER,
				MinigameEnums.MY_DAUGTHERS_ART_PROJECT, MinigameEnums.SIGN_PAPER, MinigameEnums.IN_OUT,
				MinigameEnums.BRAINSTORMER, MinigameEnums.SPEEDY_STAPLER, MinigameEnums.SPELL_CHECKER,
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
			
			// CHANGES NUMBER OF FAILURES ALLOWED
			Registry.failures = 6;
			Registry.failedMostRecentMinigame = false;
			
			// Array containing arrays of the minigames at each difficulty level(0-3)
			var minigames:Array = new Array(levelZeroMinigames, new Array(), new Array(), new Array());
			Registry.day = DaysOfTheWeek.MONDAY;
			Registry.pool = new Array();
			Registry.taskStatuses = new Array();
			for (i = 0; i < 6; i++) {
				Registry.taskStatuses[i] = TaskStatuses.EMPTY;
			}
			Registry.minigames = minigames;
		}
		
		static private function shuffle(a:Array):void {
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