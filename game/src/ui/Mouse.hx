package ui;

import js.html.MouseEvent;

class Mouse {
	public static var X(default, null):Float = 0;
	public static var Y(default, null):Float = 0;

	@:native("C")
	public static var CLICK:Bool = false;

	@:native("D")
	public static var DOWN:Bool = false;

	@:native("i")
	public static function init() {
		Main.canvas.onmousemove = onMouseMove;
		Main.canvas.onclick = onMouseClick;
		Main.canvas.onmousedown = onMouseDown;
		Main.canvas.onmouseup = onMouseUp;
	}

	@:native("m")
	private static function onMouseMove(e:MouseEvent) {
		var rect = Main.canvas.getBoundingClientRect();
		var sx = Main.canvas.width / rect.width;
		var sy = Main.canvas.width / rect.width;

		X = (e.clientX - rect.left) * sx;
		Y = (e.clientY - rect.top) * sy;
	}

	@:native("l")
	private static inline function onMouseClick(e:MouseEvent) {
		onMouseMove(e);
		CLICK = true;
	}

	@:native("o")
	private static inline function onMouseDown(e:MouseEvent) {
		onMouseMove(e);
		DOWN = true;
	}

	@:native("p")
	private static inline function onMouseUp(e:MouseEvent) {
		onMouseMove(e);
		DOWN = false;
	}

	@:native("u")
	public static function update() {
		CLICK = false;
	}
}
