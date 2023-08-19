package map;

import resource.ResourceBuilder;

class Map {
	public static var locations(default, null):Array<Location> = [];
	public static var routes(default, null):Array<Route> = [];
	public static var resources(default, null) = ["🌾", "🐟", "🧀", "🧂", "🧶", "🧱"];

	public static function load() {
		if (locations.length > 0) {
			return;
		}

		var str = ResourceBuilder.buildMap();
		var lr = str.split("+");

		loadLocations(lr[0].split("|"));
		loadRoutes(lr[1].split("|"));
	}

	private static inline function loadLocations(s:Array<String>) {
		for (l in s) {
			var p = l.split(",");
			var d = p.slice(4).map(Std.parseFloat);

			locations.push({
				name: p[0],
				type: Std.parseInt(p[1]),
				x: Std.parseFloat(p[2]),
				y: Std.parseFloat(p[3]),
				visited: false,
				known: true,
				baseDemand: d,
				demand: d.copy()
			});
		}
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
};

typedef Route = {
	var a:Location;
	var b:Location;
	var danger:Float;
};
