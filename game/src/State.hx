package;

abstract class State {
	private var bg:String = "#FFFFFF";

	public function new() {}

	@:native("u")
	public function update(s:Float) {
		Main.context.fillStyle = bg;
		Main.context.fillRect(0, 0, Main.canvas.width, Main.canvas.height);
	}
}
