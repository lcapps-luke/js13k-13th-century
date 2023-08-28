package map;

import resource.ResourceBuilder;

class Map {
	public static inline var PX_TO_MILES = 2.5;
	public static inline var TRAVEL_SPEED = 5;
	public static inline var TRAVEL_HOURS_PER_DAY = 14;
	public static inline var TYPE_VILLAGE = 0;
	public static inline var TYPE_TOWN = 1;

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

		currentLocation = locations[ResourceBuilder.buildLocationIndex("Launceston")];
		reveal(currentLocation, []);
	}

	private static inline function loadLocations(s:Array<String>) {
		for (l in s) {
			var p = l.split(",");
			var d = p.slice(4).map(Std.parseFloat);
			var q = d.map(d -> calcQty(Std.parseInt(p[1]), d));
			var t = Std.parseInt(p[1]);

			locations.push({
				name: p[0],
				type: t,
				x: Std.parseFloat(p[2]),
				y: Std.parseFloat(p[3]),
				known: t == TYPE_TOWN,
				demand: d,
				qty: q,
				high: -1,
				low: -1,
				info: false
			});
		}
	}

	public static inline function calcQty(type:Int, demand:Float):Int {
		return Math.round((-demand * 49 + 99) * (type == TYPE_TOWN ? 1 : 0.5));
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

	@:native("rn")
	public static function revealNeighbors():Array<String> {
		var res:Array<String> = [];
		for (r in routes) {
			if (r.a == currentLocation || r.b == currentLocation) {
				reveal(r.a, res);
				reveal(r.b, res);
			}
		}
		return res;
	}

	@:native("re")
	public static function reveal(l:Location, r:Array<String>) {
		if (!l.known) {
			r.push('Learnt about the neighbouring village of ${l.name}');
		}

		l.known = true;

		if (l.high == -1) {
			var highVal:Float = -10;
			var lowVal:Float = 10;

			for (i in 0...l.demand.length) {
				var d = l.demand[i];
				if (d > highVal) {
					highVal = d;
					l.high = i;
				}
				if (d < lowVal) {
					lowVal = d;
					l.low = i;
				}
			}

			r.push('Learnt about the market demand in ${l.name}');
		}
	}
}

typedef Location = {
	var name:String;
	var x:Float;
	var y:Float;
	var type:Int;
	var known:Bool;
	var demand:Array<Float>;
	var qty:Array<Int>;
	var high:Int;
	var low:Int;
	var info:Bool;
};

typedef Route = {
	var a:Location;
	var b:Location;
	var danger:Float;
};
