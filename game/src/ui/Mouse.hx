package ui;

import js.html.MouseEvent;

class Mouse {
	public static var X(default, null):Float = 0;
	public static var Y(default, null):Float = 0;
	public static var CLICK:Bool = false;
	public static var DOWN:Bool = false;

	public static function init() {
		Main.canvas.onmousemove = onMouseMove;
		Main.canvas.onclick = onMouseClick;
		Main.canvas.onmousedown = onMouseDown;
		Main.canvas.onmouseup = onMouseUp;
	}

	private static function onMouseMove(e:MouseEvent) {
		var rect = Main.canvas.getBoundingClientRect();
		var sx = Main.canvas.width / rect.width;
		var sy = Main.canvas.width / rect.width;

		X = (e.clientX - rect.left) * sx;
		Y = (e.clientY - rect.top) * sy;
	}

	private static inline function onMouseClick(e:MouseEvent) {
		onMouseMove(e);
		CLICK = true;
	}

	private static inline function onMouseDown(e:MouseEvent) {
		onMouseMove(e);
		DOWN = true;
	}

	private static inline function onMouseUp(e:MouseEvent) {
		onMouseMove(e);
		DOWN = false;
	}

	public static function update() {
		CLICK = false;
	}
}
