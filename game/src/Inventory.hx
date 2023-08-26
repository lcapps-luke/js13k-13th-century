package;

class Inventory {
	@:native("p")
	public static var pence:Int;
	@:native("s")
	public static var store(default, null):Array<Int>;

	@:native("t")
	public static function init() {
		pence = 24;
		store = [for (i in 0...map.Map.resources.length) 0];
	}
}
