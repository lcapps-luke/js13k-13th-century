package ui;

class Number {
	@:native("ts")
	private var textSize:Float = 60;
	private var pad:Float = 0;

	public var val:Int;
	public var min:Int;
	public var max:Int;

	public var x:Float = 0;
	public var y:Float = 0;

	@:native("sb")
	private var subBtn:Button;
	@:native("ab")
	private var addBtn:Button;

	public function new(val:Int = 0, min:Int = 0, max:Int = 999) {
		this.val = val;
		this.min = min;
		this.max = max;

		subBtn = new Button("-", textSize);
		subBtn.onClick = () -> this.val -= 1;
		subBtn.clickType = Region.CLICK_TYPE_HOLD;

		addBtn = new Button("+", textSize);
		addBtn.onClick = () -> this.val += 1;
		addBtn.clickType = Region.CLICK_TYPE_HOLD;

		pad = textSize * 0.3;
	}

	public function update(s:Float) {
		var acc = x;
		subBtn.x = acc;
		subBtn.y = y;
		subBtn.enable(val > min);
		subBtn.update(s);
		acc += subBtn.w + pad;

		var w = Math.max(Main.context.measureText(Std.string(min)).width, Main.context.measureText(Std.string(max)).width);
		Main.context.fillText(Std.string(val), acc, y + textSize * 0.9);
		acc += w + pad;

		addBtn.x = acc;
		addBtn.y = y;
		addBtn.enable(val < max);
		addBtn.update(s);
	}
}
