package map;

import resource.ResourceBuilder;

class Map {
	public static inline var PX_TO_MILES = 2.5;
	public static inline var TRAVEL_SPEED = 5;
	public static inline var TRAVEL_HOURS_PER_DAY = 14;

	@:native("l")
	public static var locations(default, null):Array<Location> = [];

	@:native("r")
	public static var routes(default, null):Array<Route> = [];

	@:native("e")
	public static var resources(default, null) = ["🌾", "🐟", "🧀", "🧂", "🧶", "🧱"];

	@:native("b")
	public static var resourceBasePrices(default, null) = [10, 15, 20, 15, 20, 25];

	@:native("c")
	public static var currentLocation:Location;

	public static function load() {
		if (locations.length > 0) {
			return;
		}

		var str = ResourceBuilder.buildMap();
		var lr = str.split("+");

		loadLocations(lr[0].split("|"));
		loadRoutes(lr[1].split("|"));

		currentLocation = locations.filter(l -> l.name == "Launceston")[0];
	}

	private static inline function loadLocations(s:Array<String>) {
		for (l in s) {
			var p = l.split(",");
			var d = p.slice(4).map(Std.parseFloat);
			var q = d.map(d -> calcQty(Std.parseInt(p[1]), d));

			locations.push({
				name: p[0],
				type: Std.parseInt(p[1]),
				x: Std.parseFloat(p[2]),
				y: Std.parseFloat(p[3]),
				visited: false,
				known: true,
				baseDemand: d,
				demand: d.copy(),
				qty: q,
				high: -1,
				low: -1
			});
		}
	}

	@:native("cq")
	public static inline function calcQty(type:Int, demand:Float):Int {
		return Math.round((-demand * 49 + 99) * (type == 1 ? 1 : 0.5));
	}

	private static inline function loadRoutes(s:Array<String>) {
		for (r in s) {
			var p = r.split(",");
			routes.push({
				a: locations[Std.parseInt(p[0])],
				b: locations[Std.parseInt(p[1])],
				danger: Std.parseFloat(p[2])
			});
		}
	}

	@:native("grt")
	public static function getRouteTo(dest:Location):Null<Route> {
		for (r in routes) {
			if ((r.a == currentLocation && r.b == dest) || (r.a == dest && r.b == currentLocation)) {
				return r;
			}
		}

		return null;
	}
}

typedef Location = {
	var name:String;
	var x:Float;
	var y:Float;
	var type:Int;
	var visited:Bool;
	var known:Bool;
	var baseDemand:Array<Float>;
	var demand:Array<Float>;
	var qty:Array<Int>;
	var high:Int;
	var low:Int;
};

typedef Route = {
	var a:Location;
	var b:Location;
	var danger:Float;
};
