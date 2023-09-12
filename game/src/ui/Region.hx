package ui;

class Region {
	public static inline var CLICK_TYPE_RELEASE = 0;
	public static inline var CLICK_TYPE_HOLD = 1;

	public static inline var STATE_DISABLED:Int = 0;
	public static inline var STATE_NORMAL:Int = 1;
	public static inline var STATE_OVER:Int = 2;
	public static inline var STATE_DOWN:Int = 3;

	public static inline var HOLD_BREAK_TIME:Float = .5;
	public static inline var HOLD_CLICK_TIME:Float = .05;

	public var x:Float = 0;
	public var y:Float = 0;
	public var w:Float = 0;
	public var h:Float = 0;

	@:native("st")
	public var state:Int = STATE_NORMAL;

	@:native("o")
	public var onClick:Void->Void = null;

	@:native("ct")
	public var clickType = CLICK_TYPE_RELEASE;

	private var holdTimer:Float = HOLD_BREAK_TIME;

	@:native("u")
	public function update(s:Float) {
		if (state == STATE_DISABLED) {
			return;
		}

		if (Mouse.X < x || Mouse.Y < y || Mouse.X > x + w || Mouse.Y > y + h) {
			state = STATE_NORMAL;
			return;
		}

		if (clickType == CLICK_TYPE_RELEASE) {
			if (Mouse.CLICK && onClick != null) {
				onClick();
			}
		}
		else {
			if (state != STATE_DOWN && Mouse.DOWN) {
				onClick();
			}

			if (state == STATE_DOWN) {
				holdTimer -= s;
				if (holdTimer < 0) {
					onClick();
					holdTimer = HOLD_CLICK_TIME;
				}
			}
			else {
				holdTimer = HOLD_BREAK_TIME;
			}
		}

		state = Mouse.DOWN ? STATE_DOWN : STATE_OVER;
	}

	@:native("e")
	public function enable(e:Bool) {
		if (e && state == STATE_DISABLED || !e && state != STATE_DISABLED) {
			state = e ? STATE_NORMAL : STATE_DISABLED;
		}
	}
}
