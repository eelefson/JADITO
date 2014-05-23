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
	}
}