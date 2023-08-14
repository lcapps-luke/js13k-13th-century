package;

import haxe.Json;
import js.Browser;
import js.html.Blob;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.FileSystem;
import js.html.ImageElement;
import js.html.InputElement;
import js.html.InputEvent;
import js.html.MouseEvent;
import js.html.SelectElement;
import js.html.URL;
import js.html.Window;

class EditorMain {
	public static var canvas(default, null):CanvasElement;
	public static var context(default, null):CanvasRenderingContext2D;
	public static var map(default, null):ImageElement;
	public static var mode(default, null):SelectElement;

	private static var locations = new Array<Location>();
	private static var routes = new Array<Route>();

	private static var start:Location = null;
	private static var mouseX:Float = 0;
	private static var mouseY:Float = 0;

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

		Browser.window.document.getElementById("btn-save").onclick = onSave;
		Browser.window.document.getElementById("file-load").onchange = onLoad;
	}

	private static function update(s:Float) {
		Browser.window.requestAnimationFrame(update);

		context.clearRect(0, 0, canvas.width, canvas.height);
		context.drawImage(map, 0, 0, 555, 1080);

		for (l in locations) {
			context.fillStyle = l.highlight ? "#FFFF00" : "#FF0000";

			context.beginPath();
			context.ellipse(l.x, l.y, 5, 5, 0, 0, Math.PI * 2);
			context.fill();
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
			locations.push({
				x: e.pageX,
				y: e.pageY,
				name: "newtown",
				type: true,
				highlight: false
			});
		}
		if (mode.value == "add-village") {
			locations.push({
				x: e.pageX,
				y: e.pageY,
				name: "newville",
				type: false,
				highlight: false
			});
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

	private static function onSave() {
		var resolvedRoutes = new Array<Dynamic>();
		for (r in routes) {
			resolvedRoutes.push({
				a: locations.indexOf(r.a),
				b: locations.indexOf(r.b),
				danger: r.danger
			});
		}

		var mapData = {
			locations: locations,
			routes: resolvedRoutes
		};

		var mapDataJson = Json.stringify(mapData);
		var blob = new Blob([mapDataJson], {type: 'application/json'});
		Browser.window.open(URL.createObjectURL(blob), "_blank");
	}

	private static function onLoad(e:InputEvent) {
		var ele:InputElement = cast e.target;
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
