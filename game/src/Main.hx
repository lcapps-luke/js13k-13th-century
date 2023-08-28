package;

import js.Browser;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import map.Map;
import map.MapState;
import resource.Images;
import ui.Mouse;

class Main {
	@:native("e")
	public static var canvas(default, null):CanvasElement;

	@:native("c")
	public static var context(default, null):CanvasRenderingContext2D;

	@:native("l")
	public static var lastFrame:Float = 0;

	@:native("t")
	private static var state:State = null;

	public static function main() {
		canvas = cast Browser.window.document.getElementById("c");
		context = canvas.getContext2d();

		Browser.window.document.body.onresize = onResize;
		onResize();

		Map.load();
		Images.load(() -> {
			setState(new MapState());
		});
		Mouse.init();
		Inventory.init();

		Browser.window.requestAnimationFrame(update);
	}

	@:native("r")
	private static function onResize() {
		var l = Math.floor((Browser.window.document.body.clientWidth - canvas.clientWidth) / 2);
		var t = Math.floor((Browser.window.document.body.clientHeight - canvas.clientHeight) / 2);
		canvas.style.left = '${l}px';
		canvas.style.top = '${t}px';
	}

	@:native("u")
	private static function update(s:Float) {
		var d = s - lastFrame;

		if (state != null) {
			state.update(d / 1000);
		}

		lastFrame = s;
		Mouse.update();
		Browser.window.requestAnimationFrame(update);
	}

	@:native("s")
	public static function setState(s:State) {
		state = s;
	}

	@:native("fot")
	public static function fillAndOutlineText(str:String, x:Float, y:Float) {
		Main.context.strokeText(str, x, y);
		Main.context.fillText(str, x, y);
	}
}
