package;

import Types.Guard;
import Types.Stats;
import map.Map;

class Inventory {
	@:native("p")
	public static var pence:Int;
	@:native("s")
	public static var store(default, null):Array<Int>;

	@:native("ps")
	public static var stats(default, null):Stats = {
		guard: 2,
		speed: 2,
		health: 2,
		attack: 2
	};

	@:native("g")
	public static var guard:Guard = null;

	@:native("t")
	public static function init() {
		pence = 24;
		store = [for (i in 0...Map.resources.length) 0];
	}

	@:native("v")
	public static function getStoreValue():Int {
		var res = 0;

		for (i in 0...store.length) {
			res += Math.floor((Map.resourceBasePrices[i] * 0.8) * store[i]);
		}

		return res;
	}
}
