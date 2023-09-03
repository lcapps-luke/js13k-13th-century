package;

class Inventory {
	@:native("p")
	public static var pence:Int;
	@:native("s")
	public static var store(default, null):Array<Int>;

	@:native("pg")
	public static var playerGuard:Float = 100;

	@:native("h")
	public static var health:Int = 2;

	@:native("sp")
	public static var speed:Float = 10;

	@:native("t")
	public static function init() {
		pence = 24;
		store = [for (i in 0...map.Map.resources.length) 0];
	}
}
