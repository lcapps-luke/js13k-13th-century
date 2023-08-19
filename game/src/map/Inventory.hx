package map;

class Inventory {
	public static var pence:Int;
	public static var store(default, null):Array<Int>;

	public static function init() {
		pence = 24;
		store = [for (i in 0...map.Map.resources.length) 0];
	}
}
