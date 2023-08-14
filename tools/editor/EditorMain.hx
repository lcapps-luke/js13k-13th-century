package;

import haxe.Json;
import js.Browser;
import js.html.Blob;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.DivElement;
import js.html.ImageElement;
import js.html.InputElement;
import js.html.InputEvent;
import js.html.MouseEvent;
import js.html.SelectElement;
import js.html.URL;

class EditorMain {
	private static inline var SCALE = 3.6;

	public static var canvas(default, null):CanvasElement;
	public static var context(default, null):CanvasRenderingContext2D;
	public static var map(default, null):ImageElement;
	public static var mode(default, null):SelectElement;
	public static var locationOptions(default, null):DivElement;
	public static var routeOptions(default, null):DivElement;
	public static var inputName(default, null):InputElement;
	public static var inputDanger(default, null):InputElement;

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

		Browser.window.document.getElementById("btn-save").onclick = onSave;
		Browser.window.document.getElementById("file-load").onchange = onLoad;
	}

	private static function update(s:Float) {
		Browser.window.requestAnimationFrame(update);

		context.clearRect(0, 0, canvas.width, canvas.height);
		context.drawImage(map, 0, 0, map.naturalWidth * SCALE, map.naturalHeight * SCALE);

		for (l in locations) {
			context.fillStyle = l.highlight ? "#FFFF00" : "#FF0000";

			context.beginPath();
			context.ellipse(l.x, l.y, 5, 5, 0, 0, Math.PI * 2);
			context.fill();

			context.fillStyle = "#000";
			var w = context.measureText(l.name).width;
			context.fillText(l.name, Math.round(l.x - w / 2), Math.round(l.y - 10));
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

	private static function onMouseDown(e:MouseEvent) {
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
				highlight: false
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
				highlight: false
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
			scaledLocations.push({
				name: l.name,
				type: l.type,
				x: roundTo1(l.x / SCALE),
				y: roundTo1(l.y / SCALE),
				highlight: false
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
	}

	private static function showOptions(location:Bool, route:Bool) {
		if (location) {
			locationOptions.classList.remove("hide");
			inputName.value = selectedLocation.name;
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
}

typedef Location = {
	var name:String;
	var x:Float;
	var y:Float;
	var type:Bool;
	var highlight:Bool;
};

typedef Route = {
	var a:Location;
	var b:Location;
	var danger:Float;
};
