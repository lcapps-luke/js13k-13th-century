package ui;

class Region {
	public static inline var STATE_DISABLED:Int = 0;
	public static inline var STATE_NORMAL:Int = 1;
	public static inline var STATE_OVER:Int = 2;
	public static inline var STATE_DOWN:Int = 3;

	public var x:Float = 0;
	public var y:Float = 0;
	public var w:Float = 0;
	public var h:Float = 0;

	@:native("s")
	public var state:Int = STATE_NORMAL;

	@:native("o")
	public var onClick:Void->Void = null;

	@:native("u")
	public function update() {
		if (state == STATE_DISABLED) {
			return;
		}

		if (Mouse.X < x || Mouse.Y < y || Mouse.X > x + w || Mouse.Y > y + h) {
			state = STATE_NORMAL;
			return;
		}

		state = Mouse.DOWN ? STATE_DOWN : STATE_OVER;

		if (Mouse.CLICK && onClick != null) {
			onClick();
		}
	}

	@:native("e")
	public function enable(e:Bool) {
		state = e ? STATE_NORMAL : STATE_DISABLED;
	}
}
