package;

import haxe.DynamicAccess;
import haxe.Json;
import js.Browser;
import js.Syntax;
import js.html.Blob;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.DivElement;
import js.html.Event;
import js.html.FileReader;
import js.html.ImageElement;
import js.html.InputElement;
import js.html.InputEvent;
import js.html.MouseEvent;
import js.html.SelectElement;
import js.html.URL;

class EditorMain {
	private static inline var SCALE = 3.6;
	private static var RESOURCE(default, null) = ["🌾", "🐟", "🧀", "🧂", "🧶", "🧱"];
	private static var RESOURCE_RANDOM(default, null) = [
		"🌾" => {
			min: function(loc:Float) {
				return Math.max(0.1, (0.1 + (-loc + 1) * 0.9) - 0.1);
			},
			max: function(loc:Float) {
				return Math.min(2, (0.1 + (-loc + 1) * 0.9) + 0.1);
			}
		},
		"🐟" => {
			min: function(loc:Float) {
				return Math.max(0.1, (0.1 + (loc + 1) * 0.9) - 0.1);
			},
			max: function(loc:Float) {
				return Math.min(2, (0.1 + (loc + 1) * 0.9) + 0.1);
			}
		},
		"🧀" => {
			min: function(loc:Float) {
				return Math.max(0.1, (0.1 + (-loc + 1) * 0.9) - 0.1);
			},
			max: function(loc:Float) {
				return Math.min(2, (0.1 + (-loc + 1) * 0.9) + 0.1);
			}
		},
		"🧂" => {
			min: function(loc:Float) {
				return Math.max(0.1, (0.1 + (-loc + 1) * 0.9) - 0.1);
			},
			max: function(loc:Float) {
				return Math.min(2, (0.1 + (-loc + 1) * 0.9) + 0.1);
			}
		},
		"🧶" => {
			min: function(loc:Float) {
				return Math.max(0.1, (0.1 + (-loc + 1) * 0.9) - 0.1);
			},
			max: function(loc:Float) {
				return Math.min(2, (0.1 + (-loc + 1) * 0.9) + 0.1);
			}
		},
		"🧱" => {
			min: function(loc:Float) {
				return Math.max(0.1, (0.1 + (-loc + 1) * 0.9) - 0.1);
			},
			max: function(loc:Float) {
				return Math.min(2, (0.1 + (-loc + 1) * 0.9) + 0.1);
			}
		},
	];

	public static var canvas(default, null):CanvasElement;
	public static var context(default, null):CanvasRenderingContext2D;
	public static var map(default, null):ImageElement;
	public static var mode(default, null):SelectElement;
	public static var locationOptions(default, null):DivElement;
	public static var routeOptions(default, null):DivElement;
	public static var inputName(default, null):InputElement;
	public static var inputDanger(default, null):InputElement;
	public static var inputDemand(default, null):Map<String, InputElement>;
	public static var randomLocationType(default, null):InputElement;

	private static var locations = new Array<Location>();
	private static var routes = new Array<Route>();

	private static var start:Location = null;
	private static var mouseX:Float = 0;
	private static var mouseY:Float = 0;

	private static var selectedLocation:Location = null;
	private static var selectedRoute:Route = null;

	public static function main() {
		canvas = cast Browser.window.document.getElementById("c");
		canvas.onmousedown = onMouseDown;
		canvas.onmouseup = onMouseUp;
		canvas.onmousemove = onMouseMove;
		context = canvas.getContext2d();

		map = cast Browser.window.document.createElement("img");
		map.src = "image/map.svg";
		map.onload = function() {
			Browser.window.requestAnimationFrame(update);
		};

		mode = cast Browser.window.document.getElementById("sel-mode");

		locationOptions = cast Browser.window.document.getElementById("div-location");
		routeOptions = cast Browser.window.document.getElementById("div-route");

		inputName = cast Browser.window.document.getElementById("txt-name");
		inputName.onchange = () -> {
			selectedLocation.name = inputName.value;
		}
		inputDanger = cast Browser.window.document.getElementById("num-danger");
		inputDanger.onchange = () -> {
			selectedRoute.danger = inputDanger.valueAsNumber;
		}

		inputDemand = new Map<String, InputElement>();
		var demandInputs = Browser.window.document.getElementsByClassName("num-demand");
		for (di in demandInputs) {
			var input:InputElement = cast di;
			inputDemand.set(input.name, input);
			input.onchange = (e:InputEvent) -> {
				var ele:InputElement = cast e.target;
				selectedLocation.demand.set(ele.name, ele.valueAsNumber);
			}
		}

		Browser.window.document.getElementById("btn-save").onclick = onSave;
		Browser.window.document.getElementById("file-load").onchange = onLoad;

		randomLocationType = cast Browser.window.document.getElementById("num-loctype");
		Browser.window.document.getElementById("btn-random").onclick = onRandomApply;
	}

	private static function update(s:Float) {
		Browser.window.requestAnimationFrame(update);

		context.clearRect(0, 0, canvas.width, canvas.height);
		context.drawImage(map, 0, 0, map.naturalWidth * SCALE, map.naturalHeight * SCALE);

		for (l in locations) {
			var c = l.type ? "#FF0000" : "#FF00FF";
			context.fillStyle = l.highlight ? "#FFFF00" : c;

			context.beginPath();
			context.ellipse(l.x, l.y, 5, 5, 0, 0, Math.PI * 2);
			context.fill();

			context.fillStyle = "#000";
			var txt = l.name;
			if (defaultDemand(l.demand)) {
				txt += "⚠";
			}
			var w = context.measureText(txt).width;
			context.fillText(txt, Math.round(l.x - w / 2), Math.round(l.y - 10));
		}

		context.strokeStyle = "2px solid #FF0000";
		for (r in routes) {
			context.beginPath();
			context.moveTo(r.a.x, r.a.y);
			context.lineTo(r.b.x, r.b.y);
			context.stroke();
		}

		if (start != null) {
			context.strokeStyle = "2px solid #FFFF00";
			context.beginPath();
			context.moveTo(start.x, start.y);
			context.lineTo(mouseX, mouseY);
			context.stroke();
		}
	}

	private static function defaultDemand(d:DynamicAccess<Float>) {
		for (di in RESOURCE) {
			if (d.get(di) != 1.0) {
				return false;
			}
		}
		return true;
	}

	static function onMouseDown(e:MouseEvent) {
		start = null;

		if (mode.value == "add-route") {
			for (l in locations) {
				if (l.highlight) {
					start = l;
				}
			}
		}
	}

	private static function onMouseUp(e:MouseEvent) {
		if (mode.value == "add-town") {
			selectedLocation = {
				x: e.pageX,
				y: e.pageY,
				name: "newtown",
				type: true,
				highlight: false,
				demand: makeDemandMap()
			};

			locations.push(selectedLocation);
			showOptions(true, false);
		}
		if (mode.value == "add-village") {
			selectedLocation = {
				x: e.pageX,
				y: e.pageY,
				name: "newville",
				type: false,
				highlight: false,
				demand: makeDemandMap()
			};

			locations.push(selectedLocation);
			showOptions(true, false);
		}
		if (mode.value == "add-route" && start != null) {
			for (l in locations) {
				if (l.highlight) {
					addRoute(start, l);
					break;
				}
			}
			start = null;
		}
		if (mode.value == "select-location") {
			for (l in locations) {
				if (l.highlight) {
					selectedLocation = l;
					showOptions(true, false);
					break;
				}
			}
		}
	}

	private static function makeDemandMap():DynamicAccess<Float> {
		var demand = new DynamicAccess<Float>();
		for (r in RESOURCE) {
			demand.set(r, 1);
		}

		return demand;
	}

	private static function onMouseMove(e:MouseEvent) {
		mouseX = e.pageX;
		mouseY = e.pageY;

		for (l in locations) {
			l.highlight = Math.sqrt(Math.pow(mouseX - l.x, 2) + Math.pow(mouseY - l.y, 2)) < 10;
		}
	}

	private static function addRoute(a:Location, b:Location) {
		routes.push({
			a: a,
			b: b,
			danger: 0
		});
	}

	private static inline function roundTo1(v:Float) {
		return Math.round(v * 10) / 10;
	}

	private static function onSave() {
		var scaledLocations = new Array<Location>();
		for (l in locations) {
			var demand = new DynamicAccess<Float>();
			for (k in l.demand.keys()) {
				demand.set(k, roundTo1(l.demand.get(k)));
			}

			scaledLocations.push({
				name: l.name,
				type: l.type,
				x: roundTo1(l.x / SCALE),
				y: roundTo1(l.y / SCALE),
				highlight: false,
				demand: demand
			});
		}

		var resolvedRoutes = new Array<Dynamic>();
		for (r in routes) {
			resolvedRoutes.push({
				a: locations.indexOf(r.a),
				b: locations.indexOf(r.b),
				danger: r.danger
			});
		}

		var mapData = {
			locations: scaledLocations,
			routes: resolvedRoutes
		};

		var mapDataJson = Json.stringify(mapData);
		var blob = new Blob([mapDataJson], {type: 'application/json'});
		Browser.window.open(URL.createObjectURL(blob), "_blank");
	}

	private static function onLoad(e:InputEvent) {
		var ele:InputElement = cast e.target;
		if (ele.files.length == 0) {
			return;
		}

		var reader = new FileReader();
		reader.onload = function(e:Event) {
			var data:String = reader.result;
			loadData(Json.parse(data));
		}
		reader.readAsText(ele.files[0]);
	}

	private static function loadData(data:Dynamic) {
		// locations
		locations = new Array<Location>();
		var dataLocations:Array<Dynamic> = cast data.locations;
		for (l in dataLocations) {
			var demand = l.demand == null ? makeDemandMap() : l.demand;

			locations.push({
				name: l.name,
				type: l.type,
				x: l.x * SCALE,
				y: l.y * SCALE,
				highlight: false,
				demand: demand
			});
		}

		// routes
		routes = new Array<Route>();
		var dataRoutes:Array<Dynamic> = cast data.routes;
		for (r in dataRoutes) {
			routes.push({
				a: locations[r.a],
				b: locations[r.b],
				danger: r.danger
			});
		}
	}

	private static function showOptions(location:Bool, route:Bool) {
		if (location) {
			locationOptions.classList.remove("hide");
			inputName.value = selectedLocation.name;

			for (d in selectedLocation.demand.keys()) {
				inputDemand.get(d).valueAsNumber = selectedLocation.demand.get(d);
			}
		}
		else {
			locationOptions.classList.add("hide");
		}
		if (route) {
			routeOptions.classList.remove("hide");
			inputDanger.valueAsNumber = selectedRoute.danger;
		}
		else {
			routeOptions.classList.add("hide");
		}
	}

	private static function onRandomApply() {
		var locationType:Float = randomLocationType.valueAsNumber; // -1 coastal - 1 inland
		var locJit = Math.random() * 0.4 - 0.2;
		locationType = Math.min(Math.max(locationType + locJit, -1), 1);

		for (r in RESOURCE) {
			var min = RESOURCE_RANDOM[r].min(locationType);
			var max = RESOURCE_RANDOM[r].max(locationType);
			var res = min + Math.random() * (max - min);
			trace('$r: min $min, max $max | $res');

			selectedLocation.demand[r] = res;
		}

		showOptions(true, false);
	}
}

typedef Location = {
	var name:String;
	var x:Float;
	var y:Float;
	var type:Bool;
	var highlight:Bool;
	var demand:DynamicAccess<Float>;
};

typedef Route = {
	var a:Location;
	var b:Location;
	var danger:Float;
};
